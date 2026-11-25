#!/usr/bin/env bash
# KatWork fork check: the ArtCraft marks are gone (see KATWORK.md).
#
#   scripts/check-no-marks.sh              check the tracked files of this repository
#   scripts/check-no-marks.sh --self-test  plant each defect in a scratch repository and
#                                          exit 1 unless every one is refused
#
# Data, committed beside this script in scripts/katwork-marks/:
#   app       one line "<App> <repo>", for example "GridCraft gridcraft"
#   hashes    SHA-256 of every file the fork base held in its brand directory
#   allow     lines that may still name ArtCraft (copyright, install paths, ...):
#             "<path><TAB><the whole line, exactly>"
#
# Exit 1 when:
#   1. a tracked file's SHA-256 is in `hashes`;
#   2. the plan's pattern finds a line (README.md and NOTICE are left out here, step 4 checks them);
#   3. a line names ArtCraft, the "Crafting Apps" tagline or the mark's path data, and is not in `allow`;
#   4. README.md or NOTICE does not hold the "Based on" line exactly once, or names a mark file;
#   5. a tracked image is not listed in KATWORK.md.
set -u

PLAN_PATTERN='artcraft-(logo|mark)|docs/brand|getartcraft\.com'
EXTRA_PATTERN='artcraft|crafting apps|M104\.28,49\.49'
IMAGE_EXT='\.(png|jpe?g|gif|svg|ico|icns|webp|bmp|tiff?|avif)$'
# The eight brand images are byte-identical in every Craft app; the self-test makes sure
# the committed hash list still holds them.
BRAND_IMAGE_HASHES='
08fc6d9d3717e8f13417bac6f9025b50e11d1e0b32e9e000883d2fe0c4a0c67b 3188971e1affdf4f6be4fa65f715376a7a305e6aa741ec78b0296c8f934eff08
8b86aeb06a12a90ba77a60e0d90329272310e244ee5c1f9b161b391280ca79d8 a3e03dc49f9ad4225b8517d5424309c8d1c864d3996d862190d9cc797d5af427
9d372157a949c147318561e629b11561c28b7cbc14c84b516a3fe6e84d8fbbad f87af81b6fa411da8820eed2bfdcc54c0ee9cd453b4e868c64f56c69db142d0e
5954cc0306e1b9d7beb47097e2e842157113a39d9aba078b57304902687936a9 570adcb4f7ba8ca0647f97074476bab81d3272988f1cdee52efa21bf026036a4
'

check() {
  local data=scripts/katwork-marks fail=0 app repo line hits
  if [ ! -r "$data/app" ] || [ ! -r "$data/hashes" ] || [ ! -r "$data/allow" ]; then
    echo "check-no-marks: missing $data/app, hashes or allow" >&2
    return 1
  fi
  read -r app repo < "$data/app"
  line="Based on $app by the ArtCraft team (https://github.com/storytold/$repo). This build is not an ArtCraft product."

  # 1. Exact copies of a mark, wherever they are.
  hits=$(git ls-files -z | while IFS= read -r -d '' f; do
           [ -f "$f" ] && [ ! -L "$f" ] && printf '%s\0' "$f"
         done | xargs -0 -r sha256sum | awk 'NR==FNR { if ($1 ~ /^[0-9a-f]{64}$/) h[$1]=1; next }
                                             ($1 in h) { sub(/^[0-9a-f]+  /, ""); print }' "$data/hashes" -)
  if [ -n "$hits" ]; then
    echo "check-no-marks: a file is a copy of an ArtCraft mark:"; echo "$hits"; fail=1
  fi

  # 2. The plan's pattern, in file paths and in file contents.
  hits=$(git ls-files | grep -i -E "$PLAN_PATTERN|$EXTRA_PATTERN")
  if [ -n "$hits" ]; then
    echo "check-no-marks: a tracked path names the marks:"; echo "$hits"; fail=1
  fi
  hits=$(git grep -n -I -i -E "$PLAN_PATTERN" -- . ':!KATWORK.md' ':!README.md' ':!NOTICE' \
           ':!scripts/check-no-marks.sh' ':!.github/workflows/katwork.yml')
  if [ -n "$hits" ]; then
    echo "check-no-marks: a reference to the marks or the ArtCraft website:"; echo "$hits"; fail=1
  fi

  # 3. ArtCraft named anywhere else, unless the exact line is allowed.
  hits=$(git grep -I -i -E -n --null "$EXTRA_PATTERN" -- . ':!KATWORK.md' ':!scripts/check-no-marks.sh' \
           ':!scripts/katwork-marks' ':!.github/workflows/katwork.yml' \
         | awk -F'\0' -v allow="$data/allow" -v based="$line" '
             BEGIN { while ((getline l < allow) > 0) { if (l !~ /^#/ && l != "") ok[l] = 1 } }
             { text = $3; for (i = 4; i <= NF; i++) text = text "\0" $i
               if (text != based && !(($1 "\t" text) in ok)) print $1 ":" $2 ": " text }')
  if [ -n "$hits" ]; then
    echo "check-no-marks: ArtCraft is named outside the allowed lines ($data/allow):"; echo "$hits"; fail=1
  fi

  # 4. README.md and NOTICE: the required line once, and no mark.
  for f in README.md NOTICE; do
    if [ ! -f "$f" ]; then echo "check-no-marks: $f is missing"; fail=1; continue; fi
    if [ "$(grep -c -x -F -- "$line" "$f")" != 1 ]; then
      echo "check-no-marks: $f must hold this line exactly once: $line"; fail=1
    fi
    if grep -n -i -E 'artcraft-(logo|mark)|docs/brand|getartcraft\.com' "$f"; then
      echo "check-no-marks: $f names a mark or the ArtCraft website"; fail=1
    fi
  done

  # 5. Every tracked image is accounted for in KATWORK.md.
  if [ ! -f KATWORK.md ]; then
    echo "check-no-marks: KATWORK.md is missing"; fail=1
  else
    hits=$(git ls-files | grep -i -E "$IMAGE_EXT" | while IFS= read -r f; do
             grep -q -F -- "\`$f\`" KATWORK.md || echo "$f"
           done)
    if [ -n "$hits" ]; then
      echo "check-no-marks: images missing from the list in KATWORK.md:"; echo "$hits"; fail=1
    fi
  fi

  [ "$fail" = 0 ] && echo "check-no-marks: ok ($app)"
  return "$fail"
}

self_test() {
  local self tmp n=0 bad=0 h
  self=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
  # The committed list must still hold the eight brand images.
  for h in $BRAND_IMAGE_HASHES; do
    if ! grep -q "^$h" "$(dirname "$self")/katwork-marks/hashes"; then
      echo "self-test: scripts/katwork-marks/hashes lacks brand image $h"; bad=1
    fi
  done
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/no-marks.XXXXXX") || return 1
  trap 'rm -rf "$tmp"' RETURN

  # A clean repository; each case starts from it, plants one thing, and expects $want.
  fresh() {
    rm -rf "$tmp/r" && mkdir -p "$tmp/r/scripts/katwork-marks" "$tmp/r/assets" && cd "$tmp/r" || return 1
    git init -q . && cp "$self" scripts/check-no-marks.sh
    echo "Demo demo" > scripts/katwork-marks/app
    printf 'fake icon bytes\n' > assets/icon.png
    printf 'planted mark bytes\n' > "$tmp/mark"
    sha256sum "$tmp/mark" | cut -d' ' -f1 > scripts/katwork-marks/hashes
    printf '# allowed\nsrc/a.rs\tCopyright (c) 2026 ArtCraft Team and the Demo contributors\nNOTICE\tCopyright (c) 2026 ArtCraft Team and the Demo contributors\n' > scripts/katwork-marks/allow
    printf 'Copyright (c) 2026 ArtCraft Team and the Demo contributors\n' > NOTICE
    printf '# Demo\n' > README.md
    local based='Based on Demo by the ArtCraft team (https://github.com/storytold/demo). This build is not an ArtCraft product.'
    echo "$based" >> NOTICE; echo "$based" >> README.md
    printf '# KatWork\n- `assets/icon.png`: kept\n' > KATWORK.md
    mkdir -p src && printf 'Copyright (c) 2026 ArtCraft Team and the Demo contributors\nfn main() {}\n' > src/a.rs
  }
  expect() {  # expect <want> <name>
    git add -A >/dev/null 2>&1
    bash scripts/check-no-marks.sh > "$tmp/out" 2>&1; local got=$?
    n=$((n + 1))
    if [ "$got" != "$1" ]; then echo "self-test FAIL: $2 (want $1, got $got)"; sed 's/^/  /' "$tmp/out"; bad=1; fi
  }
  ( fresh ) || return 1
  fresh; expect 0 "a clean repository passes"
  fresh; cp "$tmp/mark" assets/x.bin; expect 1 "a copy of a mark under another path"
  fresh; echo 'en	Visit getartcraft.com' > src/i18n.tsv; expect 1 "the website in a .tsv"
  fresh; echo '<url>https://getartcraft.com/apps/demo</url>' > src/a.xml.in; expect 1 "the website in a .xml.in"
  fresh; mkdir -p docs/brand && echo x > docs/brand/LICENSE-brand.txt; expect 1 "a file under docs/brand"
  fresh; echo 'let u = "https://discord.gg/artcraft";' >> src/a.rs; expect 1 "the Discord invite"
  fresh; echo 'ui.label("Part of the Crafting Apps from the team");' >> src/a.rs; expect 1 "the Crafting Apps tagline"
  fresh; echo 'const MARK_PATH: &str = "M104.28,49.49L81.55,0h-31.23";' >> src/a.rs; expect 1 "the mark path data"
  fresh; echo 'const ARTCRAFT_MARK: &[u8] = &[];' >> src/a.rs; expect 1 "a mark identifier"
  fresh; printf 'Copyright (c) 2026 ArtCraft Team and the Demo contributors\n' > src/b.rs; expect 1 "an allowed line in another file"
  fresh; echo '<img src="docs/brand/artcraft-logo.svg">' >> README.md; expect 1 "the logo in README.md"
  fresh; sed -i '/^Based on/d' NOTICE; expect 1 "NOTICE without the Based on line"
  fresh; tail -1 README.md >> README.md; expect 1 "the Based on line twice"
  fresh; printf 'x\n' > assets/new.svg; expect 1 "an image missing from KATWORK.md"
  fresh; : > scripts/katwork-marks/hashes; cp "$tmp/mark" assets/x.bin; expect 0 "an empty hash list finds nothing (control)"
  cd / || return 1
  if [ "$bad" = 0 ]; then echo "check-no-marks self-test: ok ($n cases)"; fi
  return "$bad"
}

case "${1:-}" in
  --self-test) self_test ;;
  "") cd "$(git rev-parse --show-toplevel)" && check ;;
  *) echo "usage: $0 [--self-test]" >&2; exit 2 ;;
esac

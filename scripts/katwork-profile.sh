#!/usr/bin/env bash
# KatWork fork check: the KatWork build profile leaves the gated crates out of the build graph.
#
#   scripts/katwork-profile.sh   reads scripts/katwork-profile.tsv and exits 1 on any failed row
#
# Each row: <package> <native|wasm32> <katwork-features|-> <crate> <present|absent>
#   The KatWork build is `--no-default-features [--features <katwork-features>]`; with it, <crate> must not be in the
#   normal-dependency graph of <package>. The last column is the control: with the default features (the upstream
#   build) <crate> must be `present`, which proves the gate defaults on and that <crate> is spelt right; `absent`
#   marks a row whose crate is not in that graph even upstream (the assertion is then vacuous, and is printed so).
#   An `absent` control proves <crate> is spelt right another way: it must be a package of Cargo.lock (cargo tree
#   resolves only <package>'s own graph, so a crate the workspace has elsewhere also gives "did not match").
#   Every row's <package> must be a workspace member: `-p` with a misspelt package gives the same "did not match".
#
# A row whose <crate> is `<dep>/<feature>` checks a feature, for a gate that removes no crate (a command that runs
# a system program, say): with the KatWork features <dep> must be built without <feature>; `present` means the
# default build has it.
#
# `cargo tree -i X` has two "not in the graph" outputs: exit 101 with "did not match any packages" (X is not in
# the resolved graph) and exit 0 with "nothing to print" (X is only in other targets or edge kinds). A typo gives
# the first, which is why every row with `present` checks the default build too.
set -u
cd "$(git rev-parse --show-toplevel)" || exit 1
table=scripts/katwork-profile.tsv
fail=0 n=0

tree() {  # tree <package> <target> <crate> [cargo args...]; sets rc and out
  local pkg=$1 target=$2 crate=$3; shift 3
  local args=(tree --locked -p "$pkg" -e normal -i "$crate" "$@")
  [ "$target" = wasm32 ] && args+=(--target wasm32-unknown-unknown)
  out=$(cargo "${args[@]}" 2>&1); rc=$?
}
has_feature() {  # has_feature [cargo args...]: 0 if $dep is built with $feat, 1 without, 3 not in the graph, 2 error
  local args=(tree --locked -p "$pkg" -e normal -f '{p} {f}' --prefix none "$@")
  [ "$target" = wasm32 ] && args+=(--target wasm32-unknown-unknown)
  out=$(cargo "${args[@]}" 2>&1) || return 2
  grep -q "^$dep v" <<<"$out" || return 3
  grep "^$dep v" <<<"$out" | grep -qE "(^| |,)$feat(,|\$)" || return 1
}
absent() {
  { [ "$rc" = 101 ] && grep -q 'did not match any packages' <<<"$out"; } ||
    { [ "$rc" = 0 ] && grep -q 'nothing to print' <<<"$out"; }
}

members=$(cargo metadata --locked --no-deps --format-version 1 2>/dev/null |
  python3 -c 'import json,sys; print("\n".join(p["name"] for p in json.load(sys.stdin)["packages"]))')
[ -n "$members" ] || { echo "FAIL: cargo metadata listed no workspace package"; exit 1; }
locked() { grep -qx "name = \"$1\"" Cargo.lock; }

# `|| [ -n "$pkg" ]` keeps a last row that has no final newline.
while read -r pkg target feats crate control || [ -n "$pkg" ]; do
  case "$pkg" in ''|'#'*) continue ;; esac
  n=$((n + 1))
  case "$target" in
    native|wasm32) ;;
    *) echo "FAIL: row $n: target must be native or wasm32, not '$target'"; fail=1; continue ;;
  esac
  if ! grep -qx -- "$pkg" <<<"$members"; then echo "FAIL: row $n: $pkg is not a package of this workspace"; fail=1; continue; fi
  if [ "$feats" = - ]; then extra=(); else extra=(--features "$feats"); fi
  if [[ "$crate" == */* ]]; then
    dep=${crate%%/*} feat=${crate#*/}
    has_feature --no-default-features "${extra[@]}"; r=$?
    case $r in
      1|3) echo "ok: $dep is built without $feat in $pkg ($target, KatWork features: $feats)$([ $r = 3 ] && echo ": $dep is not in the graph")" ;;
      0) echo "FAIL: $dep is built with $feat in $pkg ($target, KatWork features: $feats)"; fail=1 ;;
      *) echo "FAIL: cargo tree failed for $pkg ($target):"; sed 's/^/  /' <<<"$out" | head -10; fail=1 ;;
    esac
    has_feature; r=$?
    case "$control:$r" in
      present:0) echo "ok: control: $dep is built with $feat in $pkg with the default features" ;;
      absent:1|absent:3) echo "note: $dep is not built with $feat in $pkg ($target) upstream either; this row is vacuous" ;;
      *) echo "FAIL: control ($control): $dep with $feat in $pkg ($target) upstream: got $r (0 with, 1 without, 3 no $dep)"; fail=1 ;;
    esac
    continue
  fi
  tree "$pkg" "$target" "$crate" --no-default-features "${extra[@]}"
  if absent; then
    why=$([ "$rc" = 101 ] && echo "not in the resolved graph" || echo "nothing to print")
    echo "ok: $crate is not in $pkg ($target, KatWork features: $feats): $why"
  else
    echo "FAIL: $crate is in $pkg ($target, KatWork features: $feats):"; sed 's/^/  /' <<<"$out" | head -20; fail=1
  fi
  tree "$pkg" "$target" "$crate"
  case "$control" in
    present)
      if [ "$rc" = 0 ] && grep -q "^$crate v" <<<"$out"; then
        echo "ok: control: $crate is in $pkg with the default features"
      else
        echo "FAIL: control: $crate is not in $pkg ($target) with the default features (gate not on by default, or a typo):"
        sed 's/^/  /' <<<"$out" | head -10; fail=1
      fi ;;
    absent)
      if absent && locked "$crate"; then echo "note: $crate is not in $pkg ($target) upstream either; this row is vacuous"
      else echo "FAIL: control: $crate is in $pkg ($target) upstream, or is not in the workspace at all (a typo?), but the row says absent:"; sed 's/^/  /' <<<"$out" | head -10; fail=1; fi ;;
    *) echo "FAIL: row $n: control must be present or absent, not '$control'"; fail=1 ;;
  esac
done < "$table"

[ "$n" -gt 0 ] || { echo "FAIL: $table has no rows"; fail=1; }
[ "$fail" = 0 ] && echo "katwork-profile: ok ($n rows)"
exit "$fail"

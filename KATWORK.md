# KatWork fork of WordCraft

This repository is the KatWork fork of WordCraft (https://github.com/storytold/wordcraft). KatWork builds the app's CLI and web
build from this fork. It carries the patches listed below; everything else is upstream code.

Based on WordCraft by the ArtCraft team (https://github.com/storytold/wordcraft). This build is not an ArtCraft product.

## Fork base

- Fork base (this fork's `main` when the KatWork work started): `c179a31619632d96728653f00c56246ba374e928`
- Upstream `storytold/wordcraft` head at that time: `c179a31619632d96728653f00c56246ba374e928`

## KatWork patches

| Patch | Upstream PR |
|---|---|
| `chore(katwork): remove the ArtCraft marks` | not proposed upstream (the brand terms let a fork that proposes changes keep the marks; this one is a distributed modified version) |
| `feat(katwork): font-download feature, on by default` | draft, not opened (in the fork PR body) |
| `feat(katwork): ssip feature, on by default` | draft, not opened (in the fork PR body) |

## The KatWork build

Two Cargo features, each on by default so an upstream build is unchanged, are off in the KatWork build:

- `font-download` (wordcraft-engine; forwarded by wordcraft-mcp, wordcraft-zotero, wordcraft-ui-egui, the CLI and the
  web crate; the desktop app turns it on): the font store's language-pack downloader (craft-font-store, ureq with
  rustls and webpki-roots). With it off there is no font store: `proof.installPack` and `proof.removePack` are unknown
  commands, `proof.packs` lists no packs and refuses `refresh`, and Options › Language shows no Add a language… button
  and no line about the store. The web build keeps craft's font manager for its font picker, which holds the store's
  built-in index but no downloader.
- `ssip` (wordcraft-engine; forwarded likewise): Read Aloud's Speech Dispatcher client (`speech/ssip.rs`, craft-ssip),
  which connects to the address in `SPEECHD_ADDRESS` (any TCP host) and can start `speech-dispatcher`. With it off Read
  Aloud uses only the speech programs (`espeak-ng`/`espeak` on Linux and the BSDs, `say` on macOS, PowerShell on
  Windows).

The CLI: `cargo build --locked --release -p wordcraft-cli --no-default-features`. The web build: trunk with
`data-cargo-no-default-features` on `apps/wordcraft-web` (no extra features). `scripts/katwork-profile.sh` (CI job `katwork-profile`) checks that the gated crates are not
in either build graph, and `crates/engine/tests/katwork_profile.rs` that the pack-store commands are unknown and that
Read Aloud never connects to `SPEECHD_ADDRESS` or starts `speech-dispatcher` (the SSIP client is std::net code, which
cargo tree cannot see). `language_packs::tests::without_the_font_store_nothing_offers_a_download` (wordcraft-ui-egui,
run with its features off) checks the hidden button.

## The marks

The ArtCraft name, wordmark and logos are trademarks of the ArtCraft Team and are not covered by the app's licence. This fork
removes them, as the brand terms require of a distributed modified version: `docs/brand/` is deleted; links to the ArtCraft
website and its community (Discord), and taglines that present the build as an ArtCraft product, are removed; help links and
`app.links`-style results point to the upstream repository (https://github.com/storytold/wordcraft); README.md, NOTICE and the
About window carry the "Based on" line above as plain text. No new logo is drawn: where a mark was shown, the app's name is shown
as plain text.

`scripts/check-no-marks.sh` (CI job `no-marks` in `.github/workflows/katwork.yml`) fails when a tracked file is a copy of a
fork-base brand file (`scripts/katwork-marks/hashes`), when a line names the marks or the ArtCraft website, when a line names
ArtCraft and is not in `scripts/katwork-marks/allow`, or when an image below is missing from this file.

### What still names ArtCraft, and why (`scripts/katwork-marks/allow`)

- Copyright notices (`LICENSE-MIT`, `NOTICE`, README): required by the licences.
- Application ids `ai.storyteller.wordcraft` and installer paths and folders (`Programs\ArtCraft\...`): kept unchanged; they are
  identifiers, not marks, and changing them would break upgrades of existing installs.
- The nightly channel's messages, comments and tests that name ArtCraft Launcher (`build_flavor.rs`, `main.rs`, `profile_root.rs`,
  `updates_ui.rs`, `docs/releasing.md`, the Linux nightly scripts) and the Flatpak permission for the launcher's version folder
  (`xdg-data/ArtCraft/versions`): they name a separate program and its folders, the upstream nightly builds' updater; KatWork
  builds no nightly.
- The upstream release workflow's secret name (`release.yml`): upstream CI configuration, unchanged; KatWork does not run it.
- The "Based on" line inside code (`crates/ui-egui/src/credits.rs`: the About text and its test).

## Image assets of the fork base

Removed (the brand files, deleted with `docs/brand/`, and the images named below):

- `docs/brand/LICENSE-brand.txt`: removed
- `docs/brand/artcraft-logo-white.png`: removed
- `docs/brand/artcraft-logo-white.svg`: removed
- `docs/brand/artcraft-logo.png`: removed
- `docs/brand/artcraft-logo.svg`: removed
- `docs/brand/artcraft-mark-black.png`: removed
- `docs/brand/artcraft-mark-black.svg`: removed
- `docs/brand/artcraft-mark.png`: removed
- `docs/brand/artcraft-mark.svg`: removed
- `crates/ui-egui/icons/discord.svg`: removed (the Discord icon of the removed community buttons)
- `crates/ui-egui/icons/discordPill.svg`: removed (the Discord icon of the removed title bar button)

Every other image of the fork base, each kept:

- `assets/app-icon/hicolor/128x128/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/16x16/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/24x24/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/256x256/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/32x32/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/48x48/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/512x512/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/64x64/apps/ai.storyteller.wordcraft.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/hicolor/scalable/apps/ai.storyteller.wordcraft.svg`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-1024.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-macos-512.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-nightly-1024.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-nightly.icns`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-nightly.ico`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft-nightly.png`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft.icns`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft.ico`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `assets/app-icon/wordcraft.svg`: kept: placeholder per `ATTRIBUTION.md` (original artwork by the WordCraft contributors, MIT OR Apache-2.0; no licence file in `assets/app-icon/`)
- `crates/ui-egui/icons/accept.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/accessibility.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addNote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addPen.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addShape.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addins.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/addressBlock.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/align.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/alignCenter.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/alignLeft.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/alignRight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/alignText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/altText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/arrangeAll.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/autofit.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/bibliography.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/blankPage.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/blockAuthors.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/bold.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/bookmark.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/borderPainter.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/borders.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/breaks.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/bringForward.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/bullets.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/canvas.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/caption.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/case.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccCheckBox.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccComboBox.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccDate.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccDropDown.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccGallery.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccPicture.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccPlainText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccRepeat.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ccRichText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/cellAlign.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/cellMargins.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/changeChartType.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/charborder.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chart.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chartData.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chartTitle.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/check.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/checkErrors.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chevronDoubleRight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chevronDown.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chevronLeft.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chevronRight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/chevronUp.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/citation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/clear.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/close.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/closeOutline.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/colWidth.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/colors.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/columns.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/combine.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/comment.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/compare.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/copy.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/coverPage.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/crop.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/crossRef.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/cut.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/darkMode.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/dataLabels.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/dateTime.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/deleteComment.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/deleteTable.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/demote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/designMode.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/dictate.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/distributeCols.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/distributeRows.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/docPrefs.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/documentTemplate.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/draft.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/draw.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/drawTable.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/dropCap.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/dropdown.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/editRecipients.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/editor.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/effects.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/effectsDesign.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/enclose.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/endnote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/envelope.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/equation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/eraser.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/export.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/file.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/find.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/finish.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/first.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fitOnePage.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/focus.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/folder.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fontMissing.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fontcolor.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fontdialog.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fonts.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/footer.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/footnote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/formula.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/fullScreen.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/greetingLine.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/gridlines.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/group.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/grow.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/header.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/help.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/hideInk.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/highlight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/highlightFields.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/highlightNoColor.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/homeFolder.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/hyphenation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/icons.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/immersive.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/indent.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/indentLeft.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/indentRight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/index.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/info.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/inkToMath.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/inkToShape.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/insertAbove.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/insertBelow.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/insertLeft.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/insertRight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/interfaceTheme.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/italic.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/justify.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/labels.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/language.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/lasso.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/last.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/launcher.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/legend.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/lineNumbers.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/lineSpacing.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/link.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/macros.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/mailMerge.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/margins.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/markCitation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/markEntry.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/markdownSource.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/markup.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/matchFields.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/merge.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/mergeField.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/minus.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/models3d.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/more.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/multilevel.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/multiplePages.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/navPane.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/newComment.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/newWindow.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/next.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/nextChange.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/nextComment.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/nextFootnote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/numbering.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/object.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/onePage.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/onlinePicture.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/open.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/options.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/orientation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outdent.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outline.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineBody.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineCollapse.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineDemote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineDown.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineExpand.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlinePromote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineTop.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/outlineUp.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pageBorders.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pageBreak.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pageColor.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pageNumber.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pageWidth.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/painter.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/paraSpacing.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pastCitation.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/paste.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pen.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pencil.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/phonetic.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/picture.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pilcrow.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/pin.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/plus.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/position.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/prevChange.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/prevComment.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/preview.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/previous.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/print.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/printLayout.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/promote.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/properties.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/protect.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/quickParts.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/readAloud.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/readMode.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/recipients.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/recover.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/redo.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/reject.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/repeatHeader.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replace.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replay.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replayForward.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replayPause.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replayPlay.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/replayRewind.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/researcher.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/resetGraphic.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/resolve.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/restrict.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/reviewingPane.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/rotate.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/rowHeight.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/ruler.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/rules.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/save.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/saveAs.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/screenshot.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/search.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/select.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/selectTable.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/selectionPane.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/sendBackward.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/setDefault.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shading.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shadingNoBar.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.arrow.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.curvedArrowConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.curvedConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.diamond.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.elbowArrowConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.elbowConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.ellipse.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.heart.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.line.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.rectangle.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.roundedRectangle.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.star.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.straightArrowConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.straightConnector.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shape.triangle.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shapeEffects.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shapes.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/share.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/showComments.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/showNotes.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/shrink.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/sideBySide.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/sideToSide.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/signature.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/size.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/smartArt.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/smartArtColors.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/sort.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/sources.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/spaceAfter.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/spaceBefore.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/spelling.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/split.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/splitCells.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/splitTable.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/strike.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/styles.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/stylesPane.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/subscript.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/superscript.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/switchWindows.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/symbol.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/syncScroll.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/table.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/tableOfAuthorities.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/tableOfFigures.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textBox.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textBoxLink.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textBoxUnlink.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textDirection.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textFill.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textLtr.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textOutline.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textPane.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/textRtl.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/themes.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/thesaurus.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/thickness.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/toText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/toc.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/trackChanges.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/transform.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/translate.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/underline.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/undo.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/unlinkCitations.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/update.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/updateTable.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/user.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/vertical.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/video.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/watermark.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/webLayout.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/wordArt.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/wordCount.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/wrapText.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/zoom.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/zoom100.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/zoomIn.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `crates/ui-egui/icons/zoomOut.svg`: kept: UI icon, original artwork per `ATTRIBUTION.md` (no ArtCraft mark)
- `docs/images/backstage.png`: kept, edited: screenshot of the upstream build; its File page showed a "Discord community" link, painted over with the menu's colour (viewed: no ArtCraft mark)
- `docs/images/dark.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `docs/images/design.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `docs/images/hero.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `docs/images/layout.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `docs/images/references.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `docs/images/review.png`: kept, edited: screenshot of the upstream build; its title bar showed the Discord button, painted over with the bar's background (viewed: no ArtCraft mark)
- `packaging/macos/dmg/background.svg`: kept: macOS disk-image background, original artwork (the app name and icon; viewed: no ArtCraft mark)
- `packaging/macos/dmg/background.tiff`: kept: macOS disk-image background, original artwork (the app name and icon; viewed: no ArtCraft mark)

## Other notes

- The LaTeX export's header comment comes from the shared `craft-latex` library (a git dependency), which writes the ArtCraft
  website into the user's `.tex` file; `crates/formats/src/latex.rs` replaces that first line with the upstream repository.
- Interface translations come from the pinned shared catalog (`craft-i18n.rev`), which this fork does not change: the shortened
  About text and the "Based on" line show in English until that catalog has them, and the catalog's entries for the removed
  strings are unused.

# Changelog

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## 1.5.0 - 2026-08-22

### Added

- Individual true-colour profiles for the named Johto story cast, all Johto
  Gym Leaders, all returning Kanto Gym Leaders, the Elite Four and Champion
  Lance.
- Anime-era palettes for Silver, Professors Oak and Elm, Mom, Bill, Kurt,
  Team Rocket and the Kimono Girls.
- Nurse Joy's pink hair, white cap and apron across Pokémon Centers.
- Green-and-cream Poké Mart clerks with a gold badge and navy trousers.

### Changed

- INDIGO//97 is now presented and packaged as a fully independent character
  recolour; its previous optional character-mod dependency and recommendations
  have been removed.

### Preserved

- The 1.2.1 player, bicycle and fishing transforms remain unchanged.
- Every output retains the ROM-imported silhouette, frame count and animation
  timing. Trainer-card and battle portraits remain unchanged.

## 1.2.1 - 2026-08-21

### Fixed

- Gold and Silver now recolour the shared `gen2_fish_*` pose strips emitted by
  their ROM importer. Crystal keeps using its per-character Chris and Kris
  pose strips.
- Crystal now recolours the actual `krisbike.png` bicycle sheet emitted by its
  ROM importer.
- Kris's front-facing red suspenders begin on her torso instead of touching
  her cheeks like red tears in the enlarged voxel view.

### Verified

- Full imports of canonical personal Pokemon Gold, Silver and Crystal ROMs
  through Gen2Recomped's in-app importer, followed by mod-transform and live
  renderer checks for each game's real asset paths.

## 1.2.0 - 2026-08-21

### Added

- Matching true-colour fishing poses for the boy player in Gold, Silver and
  Crystal.
- Matching true-colour fishing poses for the Crystal heroine.

### Preserved

- Boy and Crystal heroine walking and bicycle output from earlier releases.
- Trainer-card portraits and battle portraits remain unchanged.

## 1.1.0 - 2026-08-20

### Added

- Cerulean-era anime-inspired true-colour treatment for the Crystal heroine.
- Crystal heroine walking and bicycle support, including orange hair, a yellow
  top, red accents, denim-blue shorts and a teal backpack.

### Preserved

- The 1.0.0 boy-player transform is pixel-identical in 1.1.0.
- Fishing poses, trainer-card portraits and battle portraits remain unchanged.

## 1.0.0 - 2026-08-20

### Added

- Late-1990s anime-inspired true-colour treatment for the Gen 2 boy player.
- Walking and bicycle support across Gold, Silver and the boy route in Crystal.
- ROM-safe first-load transform; no extracted game artwork is distributed.
- Independent true-colour character rendering with no required character mod.
- GitHub update metadata and automated installable release packaging.


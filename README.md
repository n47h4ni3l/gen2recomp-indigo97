# INDIGO//97

INDIGO//97 brings late-1990s anime-inspired true colour to Gen2Recomped while
preserving the cartridge's chunky 16-pixel silhouettes and original animation
timing.

The player designs now sit inside a much broader Johto cast pass. Professors,
the rival, Gym Leaders, the Elite Four, Champion Lance, Team Rocket, Kanto's
returning leaders and other named story characters receive individually chosen
period-appropriate palettes. Version 1.5 also includes the two people every
trainer sees constantly: Nurse Joy and Poké Mart clerks.

## Install

1. Download the `.zip` from the latest GitHub release. Keep it zipped.
2. Open Gen2Recomped and choose **MODS > Import mod .zip**.
3. Enable **INDIGO//97** and restart when prompted.

That is all. Once installed, Gen2Recomped can check this repository for future
versions from the mod manager.

## What 1.5 changes

- Boy-player walking, bicycle and fishing frames in Gold, Silver and Crystal.
- Crystal heroine walking, bicycle and fishing frames.
- Silver, Professors Oak and Elm, Mom, Bill, Kurt and Mr. Pokémon's elder
  overworld design.
- All Johto Gym Leaders, all returning Kanto Gym Leaders, the Elite Four and
  Champion Lance.
- Team Rocket's male and female overworld designs and the Kimono Girls.
- Nurse Joy, including the white cap/apron and pink-haired anime silhouette.
- Poké Mart clerks in a period GSC green-and-cream uniform with navy trousers.
- Colour only: movement, collision, scripts, saves and game data are untouched.

Trainer-card portraits and battle portraits are not changed in 1.5.0.

## Visual pairing

INDIGO//97 works as a complete flat true-colour mod by itself. It has also been
tested with Dramatic Shape, which changes the world presentation rather than
INDIGO//97's character colours. Neither mod is required by the other.

## ROM-safe by design

No ROM, extracted sprite sheet or cartridge-derived image is included. On first
load, `transforms.lua` reads the sprites already created from your own imported
ROM, applies INDIGO//97's colour designs, and writes private derived copies
inside your Gen2Recomped save directory.

Disable the mod to restore the cartridge appearance. Delete
`save/mod-derived/indigo_97` if you ever want to force the colour transform to
run again.

## Compatibility

- Gen2Recomped `0.7.6` through the last `0.x` release.
- Mod API 2.
- Gold, Silver and Crystal imports; game-specific sheets are detected and
  transformed only when present.
- No other character mod is required or affiliated.

## Credits

- **n47h4ni3l**: concept, art direction and testing.
- **OpenAI Codex**: implementation and packaging assistance.
- **Gen2Recomped contributors**: mod API, asset-transform system and tooling.

INDIGO//97 is an independent, unofficial fan-made mod. Pokémon and the
underlying game artwork belong to their respective owners. A legally obtained
compatible ROM and Gen2Recomped are required; neither is distributed here.


-- INDIGO//97 asset transform
--
-- Runs once inside Gen2Recomped's restricted transform sandbox. It reads the
-- player sheets from the player's private ROM cache and writes only the
-- recoloured result to save/mod-derived/indigo_97. No cartridge pixels ship in
-- this repository or its release ZIP.

local SHEETS = {
  { path = "sprites/chris.png", bike = false, style = "indigo" },
  { path = "sprites/chrisbike.png", bike = true, style = "indigo" },
  { path = "sprites/kris.png", bike = false, style = "cerulean" },
  { path = "sprites/krisbike.png", bike = true, style = "cerulean" },
}

local FISHING_POSES = {
  -- Gold and Silver expose the shared Chris strips through the original
  -- field-effect paths. Crystal additionally exposes the per-character paths
  -- below so its boy/girl selection can swap fishing art with the player form.
  { path = "fx/gen2_fish_down.png", direction = "down", style = "indigo" },
  { path = "fx/gen2_fish_up.png", direction = "up", style = "indigo" },
  { path = "fx/gen2_fish_side.png", direction = "side", style = "indigo" },
  { path = "fx/chris_fish_down.png", direction = "down", style = "indigo" },
  { path = "fx/chris_fish_up.png", direction = "up", style = "indigo" },
  { path = "fx/chris_fish_side.png", direction = "side", style = "indigo" },
  { path = "fx/kris_fish_down.png", direction = "down", style = "cerulean" },
  { path = "fx/kris_fish_up.png", direction = "up", style = "cerulean" },
  { path = "fx/kris_fish_side.png", direction = "side", style = "cerulean" },
}

-- Named story characters and the two recurring service roles. Paths are the
-- importer's own lower-case *SpriteGFX labels; a missing path is normal (for
-- example Crystal-only or post-game sheets) and is skipped without warning.
local STORY_SHEETS = {
  { path = "sprites/rival.png", profile = "silver" },
  { path = "sprites/oak.png", profile = "oak" },
  { path = "sprites/red.png", profile = "red" },
  { path = "sprites/blue.png", profile = "blue" },
  { path = "sprites/bill.png", profile = "bill" },
  { path = "sprites/elder.png", profile = "elder" },
  { path = "sprites/kurt.png", profile = "kurt" },
  { path = "sprites/mom.png", profile = "mom" },
  { path = "sprites/elm.png", profile = "elm" },
  { path = "sprites/will.png", profile = "will" },
  { path = "sprites/falkner.png", profile = "falkner" },
  { path = "sprites/whitney.png", profile = "whitney" },
  { path = "sprites/bugsy.png", profile = "bugsy" },
  { path = "sprites/morty.png", profile = "morty" },
  { path = "sprites/chuck.png", profile = "chuck" },
  { path = "sprites/jasmine.png", profile = "jasmine" },
  { path = "sprites/pryce.png", profile = "pryce" },
  { path = "sprites/clair.png", profile = "clair" },
  { path = "sprites/brock.png", profile = "brock" },
  { path = "sprites/karen.png", profile = "karen" },
  { path = "sprites/bruno.png", profile = "bruno" },
  { path = "sprites/misty.png", profile = "misty" },
  { path = "sprites/lance.png", profile = "lance" },
  { path = "sprites/surge.png", profile = "surge" },
  { path = "sprites/erika.png", profile = "erika" },
  { path = "sprites/koga.png", profile = "koga" },
  { path = "sprites/sabrina.png", profile = "sabrina" },
  { path = "sprites/janine.png", profile = "janine" },
  { path = "sprites/blaine.png", profile = "blaine" },
  { path = "sprites/rocket.png", profile = "rocket" },
  { path = "sprites/rocketgirl.png", profile = "rocket_girl" },
  { path = "sprites/kimonogirl.png", profile = "kimono" },
  { path = "sprites/nurse.png", profile = "nurse" },
  { path = "sprites/clerk.png", profile = "clerk" },
}

local C = {
  ink = { 20, 23, 31 },
  hair = { 38, 34, 42 },
  hair_hi = { 78, 65, 68 },
  hair_dark = { 25, 24, 31 },
  auburn = { 126, 51, 31 },
  orange = { 230, 96, 35 },
  orange_hi = { 255, 151, 55 },
  red = { 211, 43, 47 },
  red_hi = { 246, 78, 65 },
  red_dark = { 131, 30, 39 },
  white = { 246, 239, 213 },
  white_shadow = { 191, 198, 194 },
  white_dark = { 125, 132, 132 },
  skin = { 232, 164, 101 },
  skin_shadow = { 181, 101, 64 },
  blue = { 38, 105, 177 },
  blue_hi = { 71, 143, 211 },
  navy = { 24, 53, 102 },
  denim = { 118, 172, 202 },
  denim_hi = { 165, 207, 222 },
  denim_dark = { 61, 105, 137 },
  yellow = { 239, 185, 40 },
  yellow_hi = { 255, 224, 92 },
  yellow_dark = { 157, 105, 27 },
  teal = { 34, 139, 129 },
  teal_hi = { 77, 184, 168 },
  teal_dark = { 18, 76, 75 },
  green = { 52, 132, 65 },
  green_hi = { 88, 171, 83 },
  green_dark = { 28, 79, 45 },
  steel = { 105, 119, 128 },
  steel_hi = { 180, 190, 188 },
}

-- Compact late-1990s TV-animation palettes.  Every profile has three tones
-- per material because the source art is four-shade 2bpp: transparent plus
-- three visible values.  The transform never changes a sprite's silhouette.
local PROFILES = {
  silver = {
    hair = {{255,101,72},{206,52,52},{105,28,42}},
    skin = {{255,211,164},{232,158,112},{151,87,77}},
    top = {{88,94,126},{45,48,73},{23,24,38}},
    bottom = {{235,231,212},{170,174,174},{80,84,92}},
    accent = {{246,83,73},{188,45,53},{103,27,39}}, style = "jacket",
  },
  oak = {
    hair = {{238,238,224},{183,188,181},{91,96,99}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{247,246,229},{210,216,211},{117,126,129}},
    bottom = {{222,190,117},{172,132,71},{91,67,48}},
    accent = {{236,92,72},{170,47,48},{91,28,37}}, style = "coat",
  },
  red = {
    hair = {{83,76,73},{38,36,43},{21,22,29}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{241,77,66},{199,43,48},{111,27,38}},
    bottom = {{83,143,195},{42,91,152},{26,48,90}},
    accent = {{255,226,92},{226,167,34},{123,91,28}}, style = "cap",
  },
  blue = {
    hair = {{163,111,75},{104,67,52},{54,40,39}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{113,128,203},{63,73,154},{37,38,87}},
    bottom = {{224,222,208},{160,166,170},{77,82,94}},
    accent = {{160,99,179},{104,57,131},{59,35,81}}, style = "jacket",
  },
  bill = {
    hair = {{240,157,74},{188,93,45},{99,49,40}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{242,229,187},{203,186,131},{111,95,71}},
    bottom = {{127,94,159},{78,55,119},{45,34,74}},
    accent = {{109,174,205},{61,126,172},{35,72,113}}, style = "jacket",
  },
  elder = {
    hair = {{236,233,210},{181,178,164},{93,91,92}},
    skin = {{250,204,153},{222,147,101},{137,79,65}},
    top = {{211,184,121},{157,122,72},{84,62,45}},
    bottom = {{105,141,112},{62,101,78},{34,60,51}},
    accent = {{229,103,67},{176,59,51},{95,33,40}}, style = "robe",
  },
  kurt = {
    hair = {{232,227,204},{172,169,157},{86,87,92}},
    skin = {{250,204,153},{222,147,101},{137,79,65}},
    top = {{126,157,103},{77,112,73},{43,67,51}},
    bottom = {{180,137,83},{126,88,58},{70,53,45}},
    accent = {{228,185,78},{178,129,39},{97,73,32}}, style = "apron",
  },
  mom = {
    hair = {{157,101,69},{101,62,50},{55,40,39}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{247,143,142},{220,82,101},{126,43,66}},
    bottom = {{247,234,205},{205,191,164},{110,104,95}},
    accent = {{104,174,190},{55,125,153},{33,72,100}}, style = "apron",
  },
  elm = {
    hair = {{154,105,70},{98,66,51},{52,42,39}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{247,246,229},{210,216,211},{117,126,129}},
    bottom = {{152,127,93},{102,79,62},{57,50,47}},
    accent = {{79,173,159},{37,121,118},{24,68,76}}, style = "coat",
  },
  will = {
    hair = {{212,159,225},{156,96,180},{78,48,106}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{200,81,113},{137,42,82},{73,27,53}},
    bottom = {{71,68,88},{38,38,57},{22,23,33}},
    accent = {{242,232,211},{192,188,179},{103,104,108}}, style = "mask",
  },
  falkner = {
    hair = {{100,110,169},{54,62,126},{31,34,76}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{130,180,218},{68,122,184},{36,68,126}},
    bottom = {{238,235,215},{185,191,188},{93,101,108}},
    accent = {{242,193,67},{198,134,34},{110,76,28}}, style = "robe",
  },
  whitney = {
    hair = {{255,142,181},{232,78,133},{140,40,84}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{247,240,218},{217,215,199},{122,125,127}},
    bottom = {{240,91,132},{202,48,93},{112,30,64}},
    accent = {{100,104,158},{55,59,118},{32,34,72}}, style = "dress",
  },
  bugsy = {
    hair = {{196,173,215},{139,110,169},{74,55,105}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{193,176,114},{137,119,67},{75,68,47}},
    bottom = {{120,156,90},{73,111,62},{40,66,47}},
    accent = {{235,154,65},{190,95,42},{100,51,35}}, style = "scout",
  },
  morty = {
    hair = {{255,225,106},{230,174,53},{135,92,31}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{166,120,197},{107,70,157},{57,42,96}},
    bottom = {{230,218,185},{185,169,129},{96,85,68}},
    accent = {{213,69,101},{161,36,70},{89,26,49}}, style = "headband",
  },
  chuck = {
    hair = {{85,70,64},{43,40,43},{22,24,31}},
    skin = {{255,204,145},{222,139,86},{134,74,61}},
    top = {{246,237,211},{209,207,190},{111,116,120}},
    bottom = {{230,88,65},{184,48,49},{99,29,37}},
    accent = {{89,126,174},{48,78,134},{30,45,83}}, style = "gi",
  },
  jasmine = {
    hair = {{148,105,75},{94,61,49},{49,40,39}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{247,243,222},{216,218,208},{119,129,132}},
    bottom = {{235,235,219},{190,195,193},{98,106,113}},
    accent = {{99,157,203},{52,106,165},{31,60,105}}, style = "dress",
  },
  pryce = {
    hair = {{239,239,225},{183,190,189},{91,99,104}},
    skin = {{250,204,153},{222,147,101},{137,79,65}},
    top = {{117,164,198},{61,113,166},{35,65,109}},
    bottom = {{123,70,77},{76,43,56},{43,30,41}},
    accent = {{236,232,206},{193,192,178},{104,107,109}}, style = "coat",
  },
  clair = {
    hair = {{120,159,221},{61,104,183},{35,58,119}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{71,80,115},{38,43,75},{23,25,42}},
    bottom = {{117,150,207},{63,99,170},{36,58,108}},
    accent = {{226,67,75},{180,37,52},{98,25,38}}, style = "cape",
  },
  brock = {
    hair = {{111,82,61},{70,51,44},{40,35,36}},
    skin = {{220,163,111},{180,112,76},{108,66,58}},
    top = {{213,144,73},{162,91,47},{89,51,39}},
    bottom = {{118,147,86},{74,104,61},{42,63,46}},
    accent = {{236,224,190},{193,182,149},{101,97,84}}, style = "vest",
  },
  karen = {
    hair = {{111,104,156},{61,58,112},{34,33,68}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{75,76,91},{39,40,56},{22,23,33}},
    bottom = {{229,199,90},{182,141,48},{100,80,36}},
    accent = {{230,88,107},{176,44,72},{96,29,50}}, style = "jacket",
  },
  bruno = {
    hair = {{100,76,62},{57,48,44},{31,31,34}},
    skin = {{225,164,110},{187,110,74},{112,65,56}},
    top = {{205,109,69},{153,66,51},{85,40,40}},
    bottom = {{235,225,196},{188,180,157},{97,96,89}},
    accent = {{91,122,153},{48,75,113},{30,45,73}}, style = "gi",
  },
  misty = {
    hair = {{255,151,58},{229,88,34},{133,47,32}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{255,224,92},{234,176,38},{133,94,29}},
    bottom = {{102,174,207},{51,119,172},{30,68,111}},
    accent = {{227,78,76},{180,40,49},{99,27,38}}, style = "suspenders",
  },
  lance = {
    hair = {{245,106,78},{202,53,52},{109,29,41}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{80,84,109},{42,45,72},{24,25,42}},
    bottom = {{69,72,96},{36,39,64},{22,23,37}},
    accent = {{237,76,68},{193,38,49},{105,25,37}}, style = "cape",
  },
  surge = {
    hair = {{255,226,98},{232,179,47},{135,96,28}},
    skin = {{242,188,128},{207,124,82},{126,71,58}},
    top = {{130,163,82},{78,117,58},{45,70,44}},
    bottom = {{116,137,88},{68,94,61},{40,57,43}},
    accent = {{237,231,200},{193,190,169},{102,104,99}}, style = "military",
  },
  erika = {
    hair = {{91,82,77},{45,43,47},{23,25,31}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{240,103,99},{203,54,67},{113,32,49}},
    bottom = {{244,202,85},{203,148,40},{111,83,31}},
    accent = {{127,168,104},{75,121,73},{42,70,50}}, style = "kimono",
  },
  koga = {
    hair = {{83,71,75},{42,39,47},{22,23,31}},
    skin = {{225,168,117},{190,115,80},{113,66,59}},
    top = {{116,83,151},{69,50,112},{40,33,73}},
    bottom = {{81,72,116},{46,42,83},{29,29,55}},
    accent = {{210,70,90},{159,37,64},{87,27,47}}, style = "ninja",
  },
  sabrina = {
    hair = {{111,89,123},{62,51,86},{34,32,57}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{203,79,111},{147,42,81},{79,28,54}},
    bottom = {{180,97,154},{116,57,119},{65,38,77}},
    accent = {{238,224,190},{192,181,157},{101,96,87}}, style = "dress",
  },
  janine = {
    hair = {{198,120,202},{138,67,158},{74,42,96}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{209,72,127},{156,38,91},{85,27,61}},
    bottom = {{95,74,135},{54,45,98},{33,31,63}},
    accent = {{224,214,190},{183,176,159},{98,94,89}}, style = "ninja",
  },
  blaine = {
    hair = {{245,242,222},{193,195,188},{101,105,108}},
    skin = {{250,204,153},{222,147,101},{137,79,65}},
    top = {{247,246,229},{210,216,211},{117,126,129}},
    bottom = {{126,105,95},{83,66,61},{48,44,44}},
    accent = {{229,76,64},{183,40,47},{100,27,37}}, style = "coat",
  },
  rocket = {
    hair = {{76,72,72},{38,37,43},{20,22,28}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{83,84,92},{43,44,56},{23,24,33}},
    bottom = {{78,79,88},{40,41,53},{23,24,33}},
    accent = {{236,71,68},{193,36,47},{106,25,37}}, style = "rocket",
  },
  rocket_girl = {
    hair = {{132,103,138},{75,57,96},{39,35,61}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{83,84,92},{43,44,56},{23,24,33}},
    bottom = {{78,79,88},{40,41,53},{23,24,33}},
    accent = {{236,71,68},{193,36,47},{106,25,37}}, style = "rocket",
  },
  kimono = {
    hair = {{80,71,69},{39,38,43},{20,22,28}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{228,80,76},{184,42,51},{100,28,39}},
    bottom = {{214,69,73},{168,36,49},{91,26,38}},
    accent = {{111,163,92},{65,113,65},{38,67,48}}, style = "kimono",
  },
  nurse = {
    hair = {{255,173,202},{239,103,158},{151,53,102}},
    skin = {{255,219,176},{235,169,121},{151,93,76}},
    top = {{255,178,203},{238,105,154},{151,53,98}},
    bottom = {{250,243,222},{216,218,207},{120,127,130}},
    accent = {{229,70,73},{183,37,50},{101,26,39}}, style = "nurse",
  },
  clerk = {
    hair = {{105,84,67},{59,48,43},{31,31,34}},
    skin = {{255,211,163},{231,157,108},{143,83,69}},
    top = {{126,174,99},{74,124,69},{42,73,50}},
    bottom = {{79,91,119},{42,49,80},{25,28,48}},
    accent = {{244,211,88},{205,154,40},{112,86,30}}, style = "clerk",
  },
}

local DIRECTIONS = { "down", "up", "side", "down", "up", "side" }

local function shadeIndex(r, a)
  if a == 0 or r > 0.83 then return 0 end -- OBJ colour 0 is transparent
  if r > 0.5 then return 1 end
  if r > 0.17 then return 2 end
  return 3
end

local function put(image, x, y, colour)
  image:setPixel(x, y,
    colour[1] / 255, colour[2] / 255, colour[3] / 255, 1)
end

local function toned(shade, highlight, base)
  if shade == 3 then return C.ink end
  return shade == 1 and highlight or base
end

local function region(shade, boundary, highlight, base, shadow)
  if boundary then return C.ink end
  if shade == 1 then return highlight end
  if shade == 2 then return base end
  return shadow
end

local function sourceShade(source, x, y, frameY)
  if x < 0 or x >= 16 or y < frameY or y >= frameY + 16 then return 0 end
  local r, _, _, a = source:getPixel(x, y)
  return shadeIndex(r, a)
end

local function poseShade(source, x, y)
  if x < 0 or x >= 16 or y < 0 or y >= 8 then return 0 end
  local r, _, _, a = source:getPixel(x, y)
  return shadeIndex(r, a)
end

-- The pose is only the lower eight pixels of the 16x16 standing frame. Its
-- top edge meets the ordinary walking sheet, so absence above row zero is not
-- an outline; all other exposed edges are.
local function isPoseBoundary(source, x, y)
  return poseShade(source, x - 1, y) == 0
    or poseShade(source, x + 1, y) == 0
    or (y > 0 and poseShade(source, x, y - 1) == 0)
    or poseShade(source, x, y + 1) == 0
end

local function isBoundary(source, x, y, frameY)
  return sourceShade(source, x - 1, y, frameY) == 0
    or sourceShade(source, x + 1, y, frameY) == 0
    or sourceShade(source, x, y - 1, frameY) == 0
    or sourceShade(source, x, y + 1, frameY) == 0
end

local function capColour(direction, x, localY, shade, boundary)
  local whitePanel = (direction == "down" and x >= 6 and x <= 9
      and localY >= 1 and localY <= 3)
    or (direction == "side" and x >= 8 and x <= 12
      and localY >= 2 and localY <= 4)

  if whitePanel then
    if not boundary and shade == 3 and x >= 7 and x <= 9 then
      return C.green_dark
    end
    return region(shade, boundary, C.white, C.white_shadow, C.white_dark)
  end
  return region(shade, boundary, C.red_hi, C.red, C.red_dark)
end

-- This is the 1.0.0 boy transform. Keep its logic unchanged: existing users
-- must get exactly the same generated pixels after upgrading.
local function colourBoySheet(ctx, source, bike)
  local width, height = source:getDimensions()
  if width ~= 16 or height < 96 then return nil end
  local out = ctx.blank(width, height)

  for y = 0, 95 do
    local frame = math.floor(y / 16)
    local frameY = frame * 16
    local top = (not bike and frame >= 3) and 1 or 0
    local direction = DIRECTIONS[frame + 1]
    local localY = (y - frameY) - top

    for x = 0, 15 do
      local r, _, _, a = source:getPixel(x, y)
      local shade = shadeIndex(r, a)
      if shade ~= 0 then
        local boundary = isBoundary(source, x, y, frameY)
        local colour

        if localY <= 4 then
          colour = capColour(direction, x, localY, shade, boundary)
        elseif localY <= 9 then
          if direction == "up" then
            colour = region(shade, boundary, C.hair_hi, C.hair, C.hair_dark)
          else
            colour = toned(shade, C.skin, C.skin_shadow)
            if direction == "side" and x >= 9 then
              colour = region(shade, boundary, C.hair_hi, C.hair, C.hair_dark)
            end
          end
        else
          colour = C.ink
        end

        if bike and localY >= 10 then
          if direction == "up" then
            colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
          else
            colour = region(shade, boundary, C.blue_hi, C.blue, C.navy)
          end
          if localY <= 11 and (x <= 3 or x >= 12) then
            colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
          end
          if localY >= 12 then
            local sideWheel = direction == "side" and (x <= 4 or x >= 11)
            if shade == 3 then
              colour = C.ink
            elseif sideWheel then
              colour = shade == 1 and C.steel_hi or C.steel
            elseif shade == 1 then
              colour = C.steel_hi
            else
              colour = C.red
            end
          end
        elseif not bike and localY >= 10 then
          if direction == "up" then
            colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
          else
            colour = region(shade, boundary, C.blue_hi, C.blue, C.navy)
          end
          if localY <= 12 and (x <= 3 or x >= 12) then
            colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
          end
          if y - frameY >= 13 then
            colour = region(shade, boundary, C.denim_hi, C.denim, C.denim_dark)
          end
          if y - frameY >= 14 then
            colour = region(shade, boundary, C.white, C.red, C.red_dark)
          end
        end

        if direction == "down" and not bike
            and (localY == 10 or localY == 11) and x >= 7 and x <= 8 then
          colour = shade == 3 and C.ink or C.navy
        end

        put(out, x, y, colour)
      end
    end
  end

  return out
end

local function accent(shade, highlight, base, dark)
  if shade == 1 then return highlight end
  if shade == 2 then return base end
  return dark
end

local function girlHairColour(shade, boundary)
  if boundary or shade == 3 then return C.auburn end
  return shade == 1 and C.orange_hi or C.orange
end

local function girlHeadColour(direction, x, localY, shade, boundary)
  if direction == "up" then
    return girlHairColour(shade, boundary)
  end

  local face = direction == "down"
      and localY >= 3 and localY <= 6 and x >= 5 and x <= 10
    or direction == "side"
      and localY >= 3 and localY <= 8 and x >= 5 and x <= 8

  if face then return toned(shade, C.skin, C.skin_shadow) end
  return girlHairColour(shade, boundary)
end

local function girlBodyColour(direction, x, localY, shade, boundary)
  if direction == "up" then
    if localY <= 9 and (x <= 3 or x >= 12) then
      return toned(shade, C.skin, C.skin_shadow)
    end
    return region(shade, boundary, C.teal_hi, C.teal, C.teal_dark)
  end

  if direction == "side" then
    if localY <= 10 and x <= 5 then
      return toned(shade, C.skin, C.skin_shadow)
    end
    if x >= 10 then
      return region(shade, boundary, C.teal_hi, C.teal, C.teal_dark)
    end
    if x == 7 then
      return accent(shade, C.red_hi, C.red, C.red_dark)
    end
    return region(shade, boundary, C.yellow_hi, C.yellow, C.yellow_dark)
  end

  if localY <= 9 and (x <= 3 or x >= 12) then
    return toned(shade, C.skin, C.skin_shadow)
  end
  -- The red suspenders start on the torso.  Beginning them at localY 7 put
  -- two red pixels directly against the bottom of Kris's face, which read as
  -- tears in the enlarged voxel view.
  if (x == 5 or x == 10) and localY >= 9 and localY <= 12 then
    return accent(shade, C.red_hi, C.red, C.red_dark)
  end
  return region(shade, boundary, C.yellow_hi, C.yellow, C.yellow_dark)
end

local function girlBikeColour(direction, x, localY, shade, boundary)
  if localY <= 11 then
    return girlBodyColour(direction, x, localY, shade, boundary)
  end

  local sideWheel = direction == "side" and (x <= 4 or x >= 11)
  if shade == 3 then return C.ink end
  if sideWheel then return shade == 1 and C.steel_hi or C.steel end
  if shade == 1 then return C.steel_hi end
  return C.red
end

local function colourGirlSheet(ctx, source, bike)
  local width, height = source:getDimensions()
  if width ~= 16 or height < 96 then return nil end
  local out = ctx.blank(width, height)

  for y = 0, 95 do
    local frame = math.floor(y / 16)
    local frameY = frame * 16
    local top = (not bike and frame >= 3) and 1 or 0
    local direction = DIRECTIONS[frame + 1]
    local localY = (y - frameY) - top
    local headEnd = direction == "side" and 9 or 6

    for x = 0, 15 do
      local r, _, _, a = source:getPixel(x, y)
      local shade = shadeIndex(r, a)
      if shade ~= 0 then
        local boundary = isBoundary(source, x, y, frameY)
        local colour

        if localY <= headEnd then
          colour = girlHeadColour(direction, x, localY, shade, boundary)
        elseif bike then
          colour = girlBikeColour(direction, x, localY, shade, boundary)
        elseif localY >= 14 then
          colour = accent(shade, C.red_hi, C.red, C.red_dark)
        elseif localY >= 12 then
          colour = region(shade, boundary,
            C.denim_hi, C.denim, C.denim_dark)
        else
          colour = girlBodyColour(direction, x, localY, shade, boundary)
        end

        put(out, x, y, colour)
      end
    end
  end

  return out
end

local function profileTone(tones, shade, boundary)
  if boundary or shade == 3 then return tones[3] end
  return shade == 1 and tones[1] or tones[2]
end

local function characterColour(profile, direction, x, localY, shade, boundary)
  local style = profile.style

  -- The recurring service roles get deliberately stronger iconography than
  -- the general cast: Joy's white cap/apron and the mart clerk's green cap,
  -- gold badge and navy trousers remain readable in a 16-pixel figure.
  if style == "nurse" then
    if localY <= 2 then
      local cap = profileTone(profile.bottom, shade, boundary)
      if direction == "down" and x >= 7 and x <= 8 and not boundary then
        cap = profileTone(profile.accent, shade, false)
      end
      return cap
    elseif localY <= 4 then
      return profileTone(profile.hair, shade, boundary)
    elseif localY <= 8 then
      if direction == "up" or (direction == "side" and x >= 9) then
        return profileTone(profile.hair, shade, boundary)
      end
      return profileTone(profile.skin, shade, boundary)
    elseif localY <= 12 then
      if direction ~= "up" and x >= 6 and x <= 9 then
        return profileTone(profile.bottom, shade, boundary)
      end
      return profileTone(profile.top, shade, boundary)
    end
    return profileTone(profile.bottom, shade, boundary)
  end

  if style == "clerk" then
    if localY <= 2 then
      return profileTone(profile.top, shade, boundary)
    elseif localY <= 4 then
      return profileTone(profile.hair, shade, boundary)
    elseif localY <= 8 then
      if direction == "up" or (direction == "side" and x >= 9) then
        return profileTone(profile.hair, shade, boundary)
      end
      return profileTone(profile.skin, shade, boundary)
    elseif localY <= 12 then
      if direction == "down" and x >= 7 and x <= 8 and localY <= 10 then
        return profileTone(profile.accent, shade, boundary)
      end
      return profileTone(profile.top, shade, boundary)
    end
    return profileTone(profile.bottom, shade, boundary)
  end

  -- Hair/headwear and face. A rear view is all hair; front and side views
  -- expose a compact face without inventing pixels outside the source mask.
  if localY <= 3 then
    if style == "cap" then
      if direction == "down" and x >= 6 and x <= 9 and localY >= 1
          and not boundary then
        return region(shade, false, C.white, C.white_shadow, C.white_dark)
      end
      return profileTone(profile.top, shade, boundary)
    end
    if (style == "headband" or style == "mask") and localY >= 2 then
      return profileTone(profile.accent, shade, boundary)
    end
    return profileTone(profile.hair, shade, boundary)
  elseif localY <= 8 then
    if style == "mask" and direction ~= "up" and localY <= 6 then
      return profileTone(profile.accent, shade, boundary)
    end
    if direction == "up" or (direction == "side" and x >= 9) then
      return profileTone(profile.hair, shade, boundary)
    end
    return profileTone(profile.skin, shade, boundary)
  end

  if style == "coat" and localY <= 12 then
    if direction ~= "up" and x >= 6 and x <= 9 then
      return profileTone(profile.accent, shade, boundary)
    end
    return profileTone(profile.top, shade, boundary)
  end

  if style == "rocket" then
    if direction == "down" and localY >= 10 and localY <= 11
        and x >= 6 and x <= 9 then
      return profileTone(profile.accent, shade, boundary)
    end
    if (localY <= 11 and (x <= 3 or x >= 12)) or localY >= 14 then
      return region(shade, boundary, C.white, C.white_shadow, C.white_dark)
    end
  end

  if (style == "kimono" or style == "robe" or style == "dress")
      and localY >= 11 and localY <= 12 then
    return profileTone(profile.accent, shade, boundary)
  end

  if style == "cape" and (direction == "up" or x <= 3 or x >= 12)
      and localY <= 13 then
    return profileTone(profile.accent, shade, boundary)
  end

  if (style == "apron" or style == "suspenders") and direction ~= "up"
      and localY >= 10 and localY <= 13 and x >= 6 and x <= 9 then
    return profileTone(profile.accent, shade, boundary)
  end

  if (style == "jacket" or style == "vest" or style == "scout"
      or style == "military" or style == "gi" or style == "ninja")
      and direction ~= "up" and localY >= 10 and localY <= 11
      and x >= 7 and x <= 8 then
    return profileTone(profile.accent, shade, boundary)
  end

  if localY <= 12 then return profileTone(profile.top, shade, boundary) end
  return profileTone(profile.bottom, shade, boundary)
end

local function colourCharacterSheet(ctx, source, profile)
  local width, height = source:getDimensions()
  if width ~= 16 or height < 16 or height % 16 ~= 0 then return nil end
  local out = ctx.blank(width, height)
  local frames = math.floor(height / 16)

  for frame = 0, frames - 1 do
    local frameY = frame * 16
    local direction = DIRECTIONS[(frame % 3) + 1]
    for localY = 0, 15 do
      local y = frameY + localY
      for x = 0, 15 do
        local r, _, _, a = source:getPixel(x, y)
        local shade = shadeIndex(r, a)
        if shade ~= 0 then
          local colour = characterColour(profile, direction, x, localY,
            shade, isBoundary(source, x, y, frameY))
          put(out, x, y, colour)
        end
      end
    end
  end
  return out
end

local function boyFishingColour(direction, x, localY, shade, boundary)
  local colour

  if localY <= 9 then
    if direction == "up" then
      colour = region(shade, boundary, C.hair_hi, C.hair, C.hair_dark)
    else
      colour = toned(shade, C.skin, C.skin_shadow)
      if direction == "side" and x >= 9 then
        colour = region(shade, boundary, C.hair_hi, C.hair, C.hair_dark)
      end
    end
  else
    if direction == "up" then
      colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
    else
      colour = region(shade, boundary, C.blue_hi, C.blue, C.navy)
    end
    if localY <= 12 and (x <= 3 or x >= 12) then
      colour = region(shade, boundary, C.green_hi, C.green, C.green_dark)
    end
    if localY >= 13 then
      colour = region(shade, boundary, C.denim_hi, C.denim, C.denim_dark)
    end
    if localY >= 14 then
      colour = region(shade, boundary, C.white, C.red, C.red_dark)
    end
  end

  if direction == "down" and (localY == 10 or localY == 11)
      and x >= 7 and x <= 8 then
    colour = shade == 3 and C.ink or C.navy
  end

  return colour
end

local function girlFishingColour(direction, x, localY, shade, boundary)
  local headEnd = direction == "side" and 9 or 6
  if localY <= headEnd then
    return girlHeadColour(direction, x, localY, shade, boundary)
  end
  if localY >= 14 then
    return accent(shade, C.red_hi, C.red, C.red_dark)
  end
  if localY >= 12 then
    return region(shade, boundary, C.denim_hi, C.denim, C.denim_dark)
  end
  return girlBodyColour(direction, x, localY, shade, boundary)
end

local function colourFishingPose(ctx, source, style, direction)
  local width, height = source:getDimensions()
  if width ~= 16 or height ~= 8 then return nil end
  local out = ctx.blank(width, height)

  for y = 0, 7 do
    local localY = y + 8
    for x = 0, 15 do
      local r, _, _, a = source:getPixel(x, y)
      local shade = shadeIndex(r, a)
      if shade ~= 0 then
        local boundary = isPoseBoundary(source, x, y)
        local colour = style == "cerulean"
          and girlFishingColour(direction, x, localY, shade, boundary)
          or boyFishingColour(direction, x, localY, shade, boundary)
        put(out, x, y, colour)
      end
    end
  end

  return out
end

return function(ctx)
  for _, sheet in ipairs(SHEETS) do
    if ctx.exists(sheet.path) then
      local colour = sheet.style == "cerulean"
        and colourGirlSheet or colourBoySheet
      local result = colour(ctx, ctx.readImage(sheet.path), sheet.bike)
      if result then ctx.writeImage(result, sheet.path) end
    end
  end

  for _, sheet in ipairs(STORY_SHEETS) do
    if ctx.exists(sheet.path) then
      local profile = PROFILES[sheet.profile]
      local result = profile and colourCharacterSheet(ctx,
        ctx.readImage(sheet.path), profile)
      if result then ctx.writeImage(result, sheet.path) end
    end
  end

  for _, pose in ipairs(FISHING_POSES) do
    if ctx.exists(pose.path) then
      local result = colourFishingPose(ctx, ctx.readImage(pose.path),
        pose.style, pose.direction)
      if result then ctx.writeImage(result, pose.path) end
    end
  end
end


-- INDIGO//97
--
-- transforms.lua writes full-colour versions of the player's own imported
-- sheets under save/mod-derived/indigo_97. Keeping the original image paths
-- lets the asset resolver select those derived copies automatically.
return function(mod)
  local sprites = {
    { id = "SPRITE_RED", required = true },
    { id = "SPRITE_RED_BIKE", required = true },
    { id = "SPRITE_KRIS", required = false },
    { id = "SPRITE_KRIS_BIKE", required = false },
    -- Named story cast. Each entry keeps the ROM-provided image and geometry;
    -- transforms.lua only supplies a true-colour derived copy when that sheet
    -- exists in the imported game.
    { id = "SPRITE_SILVER", required = false },
    { id = "SPRITE_OAK", required = false },
    { id = "SPRITE_RED_KANTO", required = false },
    { id = "SPRITE_BLUE", required = false },
    { id = "SPRITE_BILL", required = false },
    { id = "SPRITE_ELDER", required = false },
    { id = "SPRITE_KURT", required = false },
    { id = "SPRITE_MOM", required = false },
    { id = "SPRITE_ELM", required = false },
    { id = "SPRITE_WILL", required = false },
    { id = "SPRITE_FALKNER", required = false },
    { id = "SPRITE_WHITNEY", required = false },
    { id = "SPRITE_BUGSY", required = false },
    { id = "SPRITE_MORTY", required = false },
    { id = "SPRITE_CHUCK", required = false },
    { id = "SPRITE_JASMINE", required = false },
    { id = "SPRITE_PRYCE", required = false },
    { id = "SPRITE_CLAIR", required = false },
    { id = "SPRITE_BROCK", required = false },
    { id = "SPRITE_KAREN", required = false },
    { id = "SPRITE_BRUNO", required = false },
    { id = "SPRITE_MISTY", required = false },
    { id = "SPRITE_LANCE", required = false },
    { id = "SPRITE_SURGE", required = false },
    { id = "SPRITE_ERIKA", required = false },
    { id = "SPRITE_KOGA", required = false },
    { id = "SPRITE_SABRINA", required = false },
    { id = "SPRITE_JANINE", required = false },
    { id = "SPRITE_BLAINE", required = false },
    { id = "SPRITE_ROCKET", required = false },
    { id = "SPRITE_ROCKET_GIRL", required = false },
    { id = "SPRITE_KIMONO_GIRL", required = false },
    -- Recurring service characters belong in the story pass because players
    -- see them constantly throughout a normal playthrough.
    { id = "SPRITE_NURSE", required = false },
    { id = "SPRITE_CLERK", required = false },
  }

  for _, sprite in ipairs(sprites) do
    if mod.content.sprites:get(sprite.id) then
      -- Patch only the colour contract. Image, frame count, walker metadata
      -- and ROM-hack-specific fields remain whatever the merged game supplied.
      mod.content.sprites:patch(sprite.id, { trueColor = true })
    elseif sprite.required then
      mod.log:warn("%s is unavailable; import a supported Gen 2 ROM and reload",
        sprite.id)
    end
  end
end



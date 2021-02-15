-- Preloads all image assets

preloader = {}
preloader.has_preloaded = false

local function preload_image(image_path)
    UiPush()
    UiAlign("top left")
    UiImage(image_path)
    UiPop()
end

-- must be called from draw()
preloader.preload_images = function()
    for weapon_key, weapon_definition in pairs(sprite_weapons.registry.registered_weapons) do
        preload_image(weapon_definition.ammo_image_path)
        for state_key, state_definition in pairs(weapon_definition.states) do
            for frame_number, frame_path in pairs(state_definition.frames) do
                preload_image(frame_path)
            end
        end
    end
    preloader.has_preloaded = true
end

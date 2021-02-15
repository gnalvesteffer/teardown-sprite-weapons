#include "weapons/table.lua"
#include "weapons/registry.lua"
#include "weapons/register_weapons.lua"
#include "weapons/preload.lua"
#include "weapons/state.lua"
#include "weapons/model.lua"
#include "weapons/view.lua"
#include "weapons/controller.lua"

sprite_weapons.init = function()
end

sprite_weapons.tick = function(deltaTime)
    sprite_weapons.controller.tick(deltaTime)
    sprite_weapons.model.tick(deltaTime)
    sprite_weapons.view.tick(deltaTime)
end

sprite_weapons.draw = function()
    if not preloader.has_preloaded then
        preloader.preload_images() -- preloading reduces slowdown ingame, but results in longer load times at the start
    end
    sprite_weapons.view.draw()
end

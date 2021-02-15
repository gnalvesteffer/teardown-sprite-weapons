#include "npcs/table.lua"
#include "npcs/registry.lua"
#include "npcs/register_npcs.lua"
#include "npcs/npc.lua"

sprite_npcs.init = function()
    for npc_key, npc_definition in pairs(sprite_npcs.registry.registered_npcs) do
        local spawn_locations = FindLocations("npc_spawn_" .. npc_key, true)
        for spawn_location_iterator = 1, #spawn_locations do
            local spawn_location = spawn_locations[spawn_location_iterator]
            local npc = sprite_npcs.npc.spawn(npc_key, GetLocationTransform(spawn_location))
        end
    end
end

sprite_npcs.tick = function(deltaTime)
    sprite_npcs.npc.sort_spawned_npcs_by_distance()
    for npc_iterator, npc in ipairs(sprite_npcs.npc.spawned_npcs) do
        npc:tick(deltaTime)
    end
end

sprite_npcs.draw = function()
    for npc_iterator, npc in ipairs(sprite_npcs.npc.spawned_npcs) do
        local screen_bounds = npc:get_screen_bounding_box()

        UiPush()
        UiTranslate(screen_bounds.top_left.x, screen_bounds.top_left.y)
        UiColor(1, 0, 0)
        UiRect(5, 5)
        UiFont("bold.ttf", 18)
        UiText(tostring(math.floor(screen_bounds.top_left.x)) .. "," .. tostring(math.floor(screen_bounds.top_left.y)))
        UiPop()

        UiPush()
        UiTranslate(screen_bounds.top_right.x, screen_bounds.top_right.y)
        UiColor(0, 1, 0)
        UiRect(5, 5)
        UiFont("bold.ttf", 18)
        UiText(tostring(math.floor(screen_bounds.top_right.x)) .. "," .. tostring(math.floor(screen_bounds.top_right.y)))
        UiPop()

        UiPush()
        UiTranslate(screen_bounds.bottom_left.x, screen_bounds.bottom_left.y)
        UiColor(1, 0, 1)
        UiRect(5, 5)
        UiFont("bold.ttf", 18)
        UiText(tostring(math.floor(screen_bounds.bottom_left.x)) .. "," .. tostring(math.floor(screen_bounds.bottom_left.y)))
        UiPop()

        UiPush()
        UiTranslate(screen_bounds.bottom_right.x, screen_bounds.bottom_right.y)
        UiColor(0, 1, 1)
        UiRect(5, 5)
        UiFont("bold.ttf", 18)
        UiText(tostring(math.floor(screen_bounds.bottom_right.x)) .. "," .. tostring(math.floor(screen_bounds.bottom_right.y)))
        UiPop()
    end
end

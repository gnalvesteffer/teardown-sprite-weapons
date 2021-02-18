#include "npcs/table.lua"
#include "npcs/ai_registry.lua"
#include "npcs/register_ai.lua"
#include "npcs/npc_registry.lua"
#include "npcs/register_npcs.lua"
#include "npcs/npc.lua"

local function spawn_npcs_from_locations()
    for npc_key, npc_definition in pairs(sprite_npcs.npc_registry.registered_npcs) do
        local spawn_locations = FindLocations("npc_spawn_" .. npc_key, true)
        for spawn_location_iterator = 1, #spawn_locations do
            local spawn_location = spawn_locations[spawn_location_iterator]
            local location_transform = GetLocationTransform(spawn_location)
            local npc = sprite_npcs.npc.spawn(npc_key, location_transform.pos, QuatToEuler(location_transform.rot)[2] * math.rad_to_deg)
        end
    end
end

sprite_npcs.init = function()
    spawn_npcs_from_locations()
end

sprite_npcs.tick = function(delta_time)
    sprite_npcs.npc.sort_spawned_npcs_by_distance()
    for npc_iterator, npc in ipairs(sprite_npcs.npc.spawned_npcs) do
        npc:tick(delta_time)
    end
end

sprite_npcs.draw = function()
end

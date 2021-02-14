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
    for npc_iterator = 1, #sprite_npcs.npc.spawned_npcs do
        sprite_npcs.npc.spawned_npcs[npc_iterator]:tick(deltaTime)
    end    
end

sprite_npcs.draw = function()

end

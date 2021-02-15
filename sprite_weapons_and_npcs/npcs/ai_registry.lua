sprite_npcs.ai_registry = {}
sprite_npcs.ai_registry.registered_ai = {}

sprite_npcs.ai_registry.register_ai = function(definition)
    sprite_npcs.ai_registry.registered_ai[definition.key] = {
        key = definition.key,
        init = function(npc)
            definition.init(npc)
        end,
        tick = function(npc, delta_time)
            definition.tick(npc, delta_time)
        end,
    }
end

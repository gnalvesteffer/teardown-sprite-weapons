sprite_npcs.registry = {}
sprite_npcs.registry.registered_npcs = {}

local function build_frames(npc_key, animation_name, total_frames, is_reversed)
    local frames = {}
    if is_reversed then
        for frame_number = total_frames, 1, -1 do
            table.insert(frames, LoadSprite("npcs/content/" .. npc_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png"))
        end
    else
        for frame_number = 1, total_frames do
            table.insert(frames, LoadSprite("npcs/content/" .. npc_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png"))
        end
    end
    return frames
end

local function load_sounds(npc_key, sound_name, total_sounds)
    local sounds = {}
    for sound_number = 1, total_sounds do
        table.insert(sounds, LoadSound("npcs/content/" .. npc_key .. "/sounds/" .. sound_name .. "." .. sound_number .. ".ogg"))
    end
    return sounds
end

sprite_npcs.registry.register_npc = function(definition)
    sprite_npcs.registry.registered_npcs[definition.key] = {
        key = definition.key,
        name = definition.name,
        health = definition.health,
        states = {
            idle = {
                frames = build_frames(definition.key, "idle", definition.states.idle.total_frames, false),
                total_frames = definition.states.idle.total_frames,
                frame_rate = definition.states.idle.frame_rate,
                image_size = definition.states.idle.image_size,
                aspect_ratio = definition.states.idle.image_size.width / definition.states.idle.image_size.height, -- width:height
                npc_width = definition.states.idle.npc_height * definition.states.idle.image_size.width / definition.states.idle.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.idle.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.idle.total_frames / definition.states.idle.frame_rate,
                animation_mode = "loop"
            },
            dead = {
                frames = build_frames(definition.key, "dead", definition.states.dead.total_frames, false),
                total_frames = definition.states.dead.total_frames,
                frame_rate = definition.states.dead.frame_rate,
                image_size = definition.states.dead.image_size,
                aspect_ratio = definition.states.dead.image_size.width / definition.states.dead.image_size.height, -- width:height
                npc_width = definition.states.dead.npc_height * definition.states.dead.image_size.width / definition.states.dead.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.dead.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.dead.total_frames / definition.states.dead.frame_rate,
                animation_mode = "oneshot"
            },
        }
    }
end

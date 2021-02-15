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
                draw_height_offset = definition.states.idle.draw_height_offset,
                npc_width = definition.states.idle.npc_height * definition.states.idle.image_size.width / definition.states.idle.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.idle.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.idle.total_frames / definition.states.idle.frame_rate,
                animation_mode = "loop"
            },
            aim = {
                frames = build_frames(definition.key, "aim", definition.states.aim.total_frames, false),
                total_frames = definition.states.aim.total_frames,
                frame_rate = definition.states.aim.frame_rate,
                image_size = definition.states.aim.image_size,
                aspect_ratio = definition.states.aim.image_size.width / definition.states.aim.image_size.height, -- width:height
                draw_height_offset = definition.states.aim.draw_height_offset,
                npc_width = definition.states.aim.npc_height * definition.states.aim.image_size.width / definition.states.aim.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.aim.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.aim.total_frames / definition.states.aim.frame_rate,
                animation_mode = "oneshot"
            },
            hurt = {
                frames = build_frames(definition.key, "hurt", definition.states.hurt.total_frames, false),
                total_frames = definition.states.hurt.total_frames,
                frame_rate = definition.states.hurt.frame_rate,
                image_size = definition.states.hurt.image_size,
                aspect_ratio = definition.states.hurt.image_size.width / definition.states.hurt.image_size.height, -- width:height
                draw_height_offset = definition.states.hurt.draw_height_offset,
                npc_width = definition.states.hurt.npc_height * definition.states.hurt.image_size.width / definition.states.hurt.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.hurt.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.hurt.total_frames / definition.states.hurt.frame_rate,
                animation_mode = "oneshot",
                sounds = load_sounds(definition.key, "hurt", definition.states.hurt.total_sounds)
            },
            dead = {
                frames = build_frames(definition.key, "dead", definition.states.dead.total_frames, false),
                total_frames = definition.states.dead.total_frames,
                frame_rate = definition.states.dead.frame_rate,
                image_size = definition.states.dead.image_size,
                aspect_ratio = definition.states.dead.image_size.width / definition.states.dead.image_size.height, -- width:height
                draw_height_offset = definition.states.dead.draw_height_offset,
                npc_width = definition.states.dead.npc_height * definition.states.dead.image_size.width / definition.states.dead.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.dead.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.dead.total_frames / definition.states.dead.frame_rate,
                animation_mode = "oneshot",
                sounds = load_sounds(definition.key, "dead", definition.states.dead.total_sounds)
            },
        }
    }
end

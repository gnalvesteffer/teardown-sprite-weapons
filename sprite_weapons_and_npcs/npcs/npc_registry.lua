sprite_npcs.npc_registry = {}
sprite_npcs.npc_registry.registered_npcs = {}

local function build_frames(npc_key, animation_name, total_frames, is_reversed)
    local frames = {}
    if is_reversed then
        for frame_number = total_frames, 1, -1 do
            table.insert(frames, LoadSprite("npcs/content/npcs/" .. npc_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png"))
        end
    else
        for frame_number = 1, total_frames do
            table.insert(frames, LoadSprite("npcs/content/npcs/" .. npc_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png"))
        end
    end
    return frames
end

local function load_sounds(npc_key, sound_name, total_sounds)
    local sounds = {}
    for sound_number = 1, total_sounds do
        table.insert(sounds, LoadSound("npcs/content/npcs/" .. npc_key .. "/sounds/" .. sound_name .. "." .. sound_number .. ".ogg"))
    end
    return sounds
end

sprite_npcs.npc_registry.register_npc = function(definition)
    sprite_npcs.npc_registry.registered_npcs[definition.key] = {
        key = definition.key,
        name = definition.name,
        health = definition.health,
        ai_key = definition.ai_key,
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
                animation_mode = "loop",
                sounds = load_sounds(definition.key, "idle", definition.states.hurt.total_sounds)
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
                animation_mode = "oneshot",
                sounds = load_sounds(definition.key, "aim", definition.states.hurt.total_sounds)
            },
            aim_idle = {
                frames = build_frames(definition.key, "aim_idle", definition.states.aim_idle.total_frames, false),
                total_frames = definition.states.aim_idle.total_frames,
                frame_rate = definition.states.aim_idle.frame_rate,
                image_size = definition.states.aim_idle.image_size,
                aspect_ratio = definition.states.aim_idle.image_size.width / definition.states.aim_idle.image_size.height, -- width:height
                draw_height_offset = definition.states.aim_idle.draw_height_offset,
                npc_width = definition.states.aim_idle.npc_height * definition.states.aim_idle.image_size.width / definition.states.aim_idle.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.aim_idle.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.aim_idle.total_frames / definition.states.aim_idle.frame_rate,
                animation_mode = "loop",
                sounds = load_sounds(definition.key, "aim_idle", definition.states.hurt.total_sounds)
            },
            fire = {
                frames = build_frames(definition.key, "fire", definition.states.fire.total_frames, false),
                total_frames = definition.states.fire.total_frames,
                frame_rate = definition.states.fire.frame_rate,
                image_size = definition.states.fire.image_size,
                aspect_ratio = definition.states.fire.image_size.width / definition.states.fire.image_size.height, -- width:height
                draw_height_offset = definition.states.fire.draw_height_offset,
                npc_width = definition.states.fire.npc_height * definition.states.fire.image_size.width / definition.states.fire.image_size.height, -- width of NPC in meters during this animation state
                npc_height = definition.states.fire.npc_height, -- height of NPC in meters during this animation state
                duration = definition.states.fire.total_frames / definition.states.fire.frame_rate,
                animation_mode = "oneshot",
                sounds = load_sounds(definition.key, "fire", definition.states.hurt.total_sounds)
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

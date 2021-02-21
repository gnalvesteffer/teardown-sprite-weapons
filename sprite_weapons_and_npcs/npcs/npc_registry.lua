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

local function build_state_definition(definition, state_key, animation_mode)
    local state_definition = {
        sounds = load_sounds(definition.key, state_key, definition.states.aim.total_sounds),
        headings = {}
    }

    for heading, heading_definition in pairs(definition.states[state_key].headings) do
        state_definition.headings[heading] = {
            frames = build_frames(definition.key, state_key .. "-" .. tostring(heading), definition.states[state_key].headings[heading].total_frames, false),
            total_frames = definition.states[state_key].headings[heading].total_frames,
            frame_rate = definition.states[state_key].headings[heading].frame_rate,
            image_size = definition.states[state_key].headings[heading].image_size,
            aspect_ratio = definition.states[state_key].headings[heading].image_size.width / definition.states[state_key].headings[heading].image_size.height, -- width:height
            draw_height_offset = definition.states[state_key].headings[heading].draw_height_offset,
            npc_width = definition.states[state_key].headings[heading].npc_height * definition.states[state_key].headings[heading].image_size.width / definition.states[state_key].headings[heading].image_size.height, -- width of NPC in meters during this animation state
            npc_height = definition.states[state_key].headings[heading].npc_height, -- height of NPC in meters during this animation state
            duration = definition.states[state_key].headings[heading].total_frames / definition.states[state_key].headings[heading].frame_rate,
            animation_mode = animation_mode,
        }
    end

    return state_definition
end

sprite_npcs.npc_registry.register_npc = function(definition)
    sprite_npcs.npc_registry.registered_npcs[definition.key] = {
        key = definition.key,
        name = definition.name,
        health = definition.health,
        ai_key = definition.ai_key,
        states = {
            idle = build_state_definition(definition, "idle", "pingpong"),
            aim = build_state_definition(definition, "aim", "oneshot"),
            aim_idle = build_state_definition(definition, "aim_idle", "pingpong"),
            fire = build_state_definition(definition, "fire", "oneshot"),
            hurt = build_state_definition(definition, "hurt", "oneshot"),
            dead = build_state_definition(definition, "dead", "oneshot"),
        }
    }
end

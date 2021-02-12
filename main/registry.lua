registered_weapons = {}

local function build_frames(weapon_key, animation_name, total_frames, is_reversed)
    local frames = {}
    if is_reversed then
        for frame_number = total_frames, 1, -1 do
            table.insert(frames, "weapons/" .. weapon_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png")
        end
    else
        for frame_number = 1, total_frames do
            table.insert(frames, "weapons/" .. weapon_key .. "/images/" .. animation_name .. "." .. frame_number .. ".png")
        end
    end
    return frames
end

local function load_sounds(weapon_key, sound_name, total_sounds)
    local sounds = {}
    for sound_number = 1, total_sounds do
        table.insert(sounds, LoadSound("weapons/" .. weapon_key .. "/sounds/" .. sound_name .. "." .. sound_number .. ".ogg"))
    end
    return sounds
end

function register_weapon(definition)
    registered_weapons[definition.key] = { -- `key` must match the weapon's folder name
        key = definition.key,
        name = definition.name,
        states = {
            idle = {
                frames = build_frames(definition.key, "idle", definition.states.idle.total_frames, false),
                total_frames = definition.states.idle.total_frames,
                frame_rate = definition.states.idle.frame_rate,
                duration = definition.states.idle.total_frames / definition.states.idle.frame_rate,
                animation_mode = "loop",
                total_sounds = definition.states.idle.total_sounds,
                sounds = load_sounds(definition.key, "idle", definition.states.idle.total_sounds)
            },
            fire = {
                frames = build_frames(definition.key, "fire", definition.states.fire.total_frames, false),
                total_frames = definition.states.fire.total_frames,
                frame_rate = definition.states.fire.frame_rate,
                duration = definition.states.fire.total_frames / definition.states.fire.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.fire.total_sounds,
                sounds = load_sounds(definition.key, "fire", definition.states.fire.total_sounds)
            },
            aim = {
                frames = build_frames(definition.key, "aim", definition.states.aim.total_frames, false),
                total_frames = definition.states.aim.total_frames,
                frame_rate = definition.states.aim.frame_rate,
                duration = definition.states.aim.total_frames / definition.states.aim.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.aim.total_sounds,
                sounds = load_sounds(definition.key, "aim", definition.states.aim.total_sounds)
            },
            aim_reverse = {
                frames = build_frames(definition.key, "aim", definition.states.aim.total_frames, true),
                total_frames = definition.states.aim.total_frames,
                frame_rate = definition.states.aim.frame_rate,
                duration = definition.states.aim.total_frames / definition.states.aim.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.aim.total_sounds,
                sounds = load_sounds(definition.key, "aim", definition.states.aim.total_sounds)
            },
            aimidle = {
                frames = build_frames(definition.key, "aimidle", definition.states.aimidle.total_frames, false),
                total_frames = definition.states.aimidle.total_frames,
                frame_rate = definition.states.aimidle.frame_rate,
                duration = definition.states.aimidle.total_frames / definition.states.aimidle.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.aim.total_sounds,
                sounds = load_sounds(definition.key, "aimidle", definition.states.aimidle.total_sounds)
            },
            aimfire = {
                frames = build_frames(definition.key, "aimfire", definition.states.aimfire.total_frames, false),
                total_frames = definition.states.aimfire.total_frames,
                frame_rate = definition.states.aimfire.frame_rate,
                duration = definition.states.aimfire.total_frames / definition.states.aimfire.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.fire.total_sounds,
                sounds = load_sounds(definition.key, "fire", definition.states.fire.total_sounds)
            },
            reload = {
                frames = build_frames(definition.key, "reload", definition.states.reload.total_frames, false),
                total_frames = definition.states.reload.total_frames,
                frame_rate = definition.states.reload.frame_rate,
                duration = definition.states.reload.total_frames / definition.states.reload.frame_rate,
                animation_mode = "oneshot",
                total_sounds = definition.states.reload.total_sounds,
                sounds = load_sounds(definition.key, "reload", definition.states.reload.total_sounds)
            },
        },
        fire_rate = definition.fire_rate, -- duration in seconds between each shot
        reach = definition.reach, -- distance in meters that the weapon can reach/hit/shoot
        impact_force = definition.impact_force, -- influences the size of holes made when shooting stuff
        magazine_size = definition.magazine_size
    }
end

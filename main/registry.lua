registered_weapons = {}

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
                total_frames = definition.states.idle.total_frames,
                frame_rate = definition.states.idle.frame_rate,
                duration = definition.states.idle.total_frames / definition.states.idle.frame_rate,
                total_sounds = definition.states.idle.total_sounds,
                sounds = load_sounds(definition.key, "idle", definition.states.idle.total_sounds)
            },
            fire = {
                total_frames = definition.states.fire.total_frames,
                frame_rate = definition.states.fire.frame_rate,
                duration = definition.states.fire.total_frames / definition.states.fire.frame_rate,
                total_sounds = definition.states.fire.total_sounds,
                sounds = load_sounds(definition.key, "fire", definition.states.fire.total_sounds)
            }
        },
        fire_rate = definition.fire_rate, -- duration in seconds between each shot
        reach = definition.reach -- distance in meters that the weapon can reach/hit/shoot
    }
end

state = {
    weapons = {
        ["m16a2"] = {
        }
    },
    equipped_weapon_key = "m16a2",
    weapon_state = "idle",
    weapon_state_time = 0,
    last_fire_time = -1,
    is_trigger_pulled = false,
    is_aiming = false
}

state.set_weapon_state = function(weapon_state)
    state.weapon_state = weapon_state
    state.weapon_state_time = 0
end

state.get_current_weapon = function()
    return state.weapons[state.equipped_weapon_key]
end

function get_current_weapon_definition()
    return registered_weapons[state.equipped_weapon_key]
end

function get_random_weapon_sound()
    local weapon_definition = get_current_weapon_definition()
    local total_sounds = weapon_definition.states[state.weapon_state].total_sounds
    if total_sounds == 0 then
        return nil
    end
    return math.random(1, total_sounds)
end

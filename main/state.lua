state = {
    weapons = {
        ["m16a2"] = {
            ammo = 30,
            reserve_ammo = 30 * 5
        }
    },
    equipped_weapon_key = "m16a2",
    weapon_state = "idle",
    weapon_state_time = 0,
    last_fire_time = -1,
    is_trigger_pulled = false,
    is_aiming = false,
    is_attempting_reload = false
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

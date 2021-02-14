state = {
    weapons = {
        ["m16a2"] = {
            ammo = 30,
            reserve_ammo = 30 * 5
        },
        ["hk53"] = {
            ammo = 25,
            reserve_ammo = 25 * 5
        }
    },
    equipped_weapon_key = "m16a2",
    weapon_state = "idle",
    weapon_state_time = 0,
    last_fire_time = -1,
    is_trigger_pulled = false,
    is_aiming = false,
    is_attempting_reload = false,
    next_weapon_index_delta = 0,
    movement_time = 0,
    is_enabled = true
}

state.get_equipped_weapon_index = function()
    local i = 1
    for k, v in pairs(state.weapons) do
        if k == state.equipped_weapon_key then
            break
        end
        i = i + 1
    end
    return i
end

state.set_equipped_weapon_index = function(index)
    local i = 1
    for k, v in pairs(state.weapons) do
        if i == index then
            state.equipped_weapon_key = k
            return
        end
        i = i + 1
    end
end

state.set_weapon_state = function(weapon_state)
    state.weapon_state = weapon_state
    state.weapon_state_time = 0
end

state.get_current_weapon = function()
    return state.weapons[state.equipped_weapon_key]
end

state.get_reserve_magazine_count = function()
    local magazine_size =  get_current_weapon_definition().magazine_size
    return math.ceil(state.get_current_weapon().reserve_ammo / magazine_size)
end

function get_current_weapon_definition()
    return registered_weapons[state.equipped_weapon_key]
end

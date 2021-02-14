sprite_weapons.state = {
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

sprite_weapons.state.get_equipped_weapon_index = function()
    local i = 1
    for k, v in pairs(sprite_weapons.state.weapons) do
        if k == sprite_weapons.state.equipped_weapon_key then
            break
        end
        i = i + 1
    end
    return i
end

sprite_weapons.state.set_equipped_weapon_index = function(index)
    local i = 1
    for k, v in pairs(sprite_weapons.state.weapons) do
        if i == index then
            sprite_weapons.state.equipped_weapon_key = k
            return
        end
        i = i + 1
    end
end

sprite_weapons.state.set_weapon_state = function(weapon_state)
    sprite_weapons.state.weapon_state = weapon_state
    sprite_weapons.state.weapon_state_time = 0
end

sprite_weapons.state.get_current_weapon = function()
    return sprite_weapons.state.weapons[sprite_weapons.state.equipped_weapon_key]
end

sprite_weapons.state.get_reserve_magazine_count = function()
    local magazine_size =  sprite_weapons.state.get_current_weapon_definition().magazine_size
    return math.ceil(sprite_weapons.state.get_current_weapon().reserve_ammo / magazine_size)
end

sprite_weapons.state.get_current_weapon_definition = function()
    return sprite_weapons.registry.registered_weapons[sprite_weapons.state.equipped_weapon_key]
end

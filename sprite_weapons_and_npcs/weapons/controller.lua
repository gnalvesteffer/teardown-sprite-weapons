sprite_weapons.controller = {}

sprite_weapons.controller.tick = function(delta_time)
    sprite_weapons.state.is_trigger_pulled = InputDown("lmb")
    sprite_weapons.state.is_aiming = InputDown("rmb")
    sprite_weapons.state.is_attempting_reload = InputPressed("r")

    -- handle weapon switching
    local scroll_wheel_delta = InputValue("mousewheel")
    if scroll_wheel_delta ~= 0 then
        sprite_weapons.state.next_weapon_index_delta = sprite_weapons.state.get_equipped_weapon_index() + scroll_wheel_delta
    end
end

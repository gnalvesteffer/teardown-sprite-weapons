controller = {}

controller.tick = function(deltaTime)
    state.is_trigger_pulled = InputDown("lmb")
    state.is_aiming = InputDown("rmb")
    state.is_attempting_reload = InputPressed("r")

    -- handle weapon switching
    local scroll_wheel_delta = InputValue("mousewheel")
    if scroll_wheel_delta ~= 0 then
        state.next_weapon_index_delta = state.get_equipped_weapon_index() + scroll_wheel_delta
    end
end

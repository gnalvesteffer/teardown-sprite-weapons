controller = {}

controller.tick = function(deltaTime)
    state.is_trigger_pulled = InputDown("lmb")
    state.is_aiming = InputDown("rmb")
    state.is_attempting_reload = InputPressed("r")
end

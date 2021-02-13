viewmodel = {}

local function calculate_current_weapon_frame()
    local weapon_definition = get_current_weapon_definition()
    local weapon_state_definition = weapon_definition.states[state.weapon_state]

    if weapon_state_definition.animation_mode == "loop" then
        return math.floor((state.weapon_state_time * weapon_state_definition.frame_rate % weapon_state_definition.total_frames) + 1)
    else
        if weapon_state_definition.animation_mode == "oneshot" then
            return math.min(math.floor(state.weapon_state_time * weapon_state_definition.frame_rate) + 1, weapon_state_definition.total_frames)
        end
    end
end

local function get_current_weapon_frame_image_path()
    local weapon_definition = get_current_weapon_definition()
    local weapon_state_definition = weapon_definition.states[state.weapon_state]
    local frame_number = calculate_current_weapon_frame()
    return weapon_state_definition.frames[frame_number]
end

local function get_weapon_sway_amount()
    local player_speed = VecLength(GetPlayerVelocity())
    local movement_amount = math.clamp(player_speed * math.clamp(state.movement_time, 0, 1), 0, 10)
    local breathing_amount = 3 -- todo: tie this to some sort of stamina variable?
    return {
        x = (breathing_amount + math.sin(GetTime() * 1.3) * breathing_amount) + (movement_amount + math.sin(state.movement_time * 10) * movement_amount),
        y = (breathing_amount + math.cos(GetTime() * 2) * breathing_amount) + (movement_amount + math.sin(state.movement_time * 20) * movement_amount)
    }
end

local function draw_weapon()
    local weapon_sway_amount = get_weapon_sway_amount()
    UiPush()
    UiAlign("top left")
    UiTranslate(weapon_sway_amount.x, weapon_sway_amount.y)
    UiImage(get_current_weapon_frame_image_path())
    UiPop()
end

viewmodel.tick = function(deltaTime)

end

viewmodel.draw = function()
    draw_weapon()
end

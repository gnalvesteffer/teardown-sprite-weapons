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

local function draw_weapon()
    UiPush()
    UiAlign("top left")
    UiImage(get_current_weapon_frame_image_path())
    UiPop()
end

viewmodel.tick = function(deltaTime)
end

viewmodel.draw = function()
    draw_weapon()
end

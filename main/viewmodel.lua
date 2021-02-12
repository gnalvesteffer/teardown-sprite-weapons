local function calculate_current_weapon_frame()
    local weapon_definition = get_current_weapon_definition()
    local weapon_state_definition = weapon_definition.states[state.weapon_state]
    return math.floor((state.weapon_state_time * weapon_state_definition.frame_rate % weapon_state_definition.total_frames) + 1)
end

local function get_current_weapon_frame_image_path()
    local weapon_definition = get_current_weapon_definition()
    local frame = calculate_current_weapon_frame()
    return "weapons/" .. weapon_definition.key .. "/images/" .. state.weapon_state .. "." .. frame .. ".png"
end

local function draw_weapon()
    UiPush()
    UiAlign("top left")
    UiImage(get_current_weapon_frame_image_path())
    UiPop()
end

viewmodel = {
    tick = function()

    end,
    draw = function()
        draw_weapon()
    end
}

sprite_weapons.viewmodel = {}

local function calculate_current_weapon_frame()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local weapon_state_definition = weapon_definition.states[sprite_weapons.state.weapon_state]

    if weapon_state_definition.animation_mode == "loop" then
        return math.floor((sprite_weapons.state.weapon_state_time * weapon_state_definition.frame_rate % weapon_state_definition.total_frames) + 1)
    else
        if weapon_state_definition.animation_mode == "oneshot" then
            return math.min(math.floor(sprite_weapons.state.weapon_state_time * weapon_state_definition.frame_rate) + 1, weapon_state_definition.total_frames)
        end
    end
end

local function get_current_weapon_frame_image_path()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local weapon_state_definition = weapon_definition.states[sprite_weapons.state.weapon_state]
    local frame_number = calculate_current_weapon_frame()
    return weapon_state_definition.frames[frame_number]
end

local function get_weapon_sway_amount()
    local player_speed = VecLength(GetPlayerVelocity())
    local movement_amount = math.clamp(player_speed * math.clamp(sprite_weapons.state.movement_time, 0, 1), 0, 10)
    local breathing_amount = 3 -- todo: tie this to some sort of stamina variable?
    return {
        x = (breathing_amount + math.sin(GetTime() * 1.3) * breathing_amount) + (movement_amount + math.sin(sprite_weapons.state.movement_time * 10) * movement_amount),
        y = (breathing_amount + math.cos(GetTime() * 2) * breathing_amount) + (movement_amount + math.sin(sprite_weapons.state.movement_time * 20) * movement_amount)
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

local function draw_ammo()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local ammo = sprite_weapons.state.get_current_weapon().ammo
    for ammo_iterator = 0, ammo - 1 do
        UiPush()
        UiAlign("bottom right")
        UiTranslate((UiWidth() - 10) - (weapon_definition.ammo_image_size.width * ammo_iterator), UiHeight() - 10)
        UiImage(weapon_definition.ammo_image_path)
        UiPop()
    end
end

local function draw_magazines()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    for magazine_iterator = 0, sprite_weapons.state.get_reserve_magazine_count() - 1 do
        UiPush()
        UiAlign("bottom right")
        UiTranslate((UiWidth() - 10) - (weapon_definition.magazine_image_size.width * magazine_iterator), (UiHeight() - 10) - weapon_definition.ammo_image_size.height - 10)
        UiImage(weapon_definition.magazine_image_path)
        UiPop()
    end
end

local function draw_weapon_name()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    UiPush()
    UiAlign("bottom right")
    UiTranslate(UiWidth() - 10, (UiHeight() - 10) - (weapon_definition.magazine_image_size.height + 10 + weapon_definition.ammo_image_size.height + 10))
    UiFont("bold.ttf", 32)
    local text_width, text_height = UiGetTextSize(weapon_definition.name)
    UiColor(0, 0, 0)
    UiRect(text_width, text_height)
    UiColor(1, 1, 1)
    UiText(weapon_definition.name)
    UiPop()
end

sprite_weapons.viewmodel.tick = function(deltaTime)
end

sprite_weapons.viewmodel.draw = function()
    if not sprite_weapons.state.is_enabled then
        return
    end

    draw_weapon()
    draw_ammo()
    draw_magazines()
    draw_weapon_name()
end

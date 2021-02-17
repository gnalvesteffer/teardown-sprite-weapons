sprite_weapons.hud = {}

local function draw_ammo()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local ammo = sprite_weapons.state.get_current_weapon().ammo
    for ammo_iterator = 0, ammo - 1 do
        UiPush()
        UiAlign("bottom right")
        UiTranslate((UiWidth() - 25) - (weapon_definition.ammo_image_size.width * ammo_iterator), UiHeight() - 10)
        UiImage(weapon_definition.ammo_image_path)
        UiPop()
    end
end

local function draw_magazines()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    for magazine_iterator = 0, sprite_weapons.state.get_reserve_magazine_count() - 1 do
        UiPush()
        UiAlign("bottom right")
        UiTranslate((UiWidth() - 25) - (weapon_definition.magazine_image_size.width * magazine_iterator), (UiHeight() - 10) - weapon_definition.ammo_image_size.height - 10)
        UiImage(weapon_definition.magazine_image_path)
        UiPop()
    end
end

local function draw_weapon_name()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    UiPush()
    UiAlign("bottom right")
    UiTranslate(UiWidth() - 25, (UiHeight() - 10) - (weapon_definition.magazine_image_size.height + 10 + weapon_definition.ammo_image_size.height + 10))
    UiFont("bold.ttf", 32)
    local text_width, text_height = UiGetTextSize(weapon_definition.name)
    UiColor(0, 0, 0)
    UiRect(text_width, text_height)
    UiColor(1, 1, 1)
    UiText(weapon_definition.name)
    UiPop()
end

local function draw_health()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local health = GetPlayerHealth()
    UiPush()
    UiFont("bold.ttf", 32)
    local weapon_name_width, weapon_name_height = UiGetTextSize(weapon_definition.name)
    UiAlign("bottom right")
    UiTranslate(UiWidth() - 5, UiHeight() - 10)
    UiColor(0.4, 0.1, 0.1, 0.75)
    UiRect(10, (weapon_definition.magazine_image_size.height + 10 + weapon_definition.ammo_image_size.height + 10 + weapon_name_height))
    UiColor(0.8, 0.15, 0.15)
    UiRect(10, (weapon_definition.magazine_image_size.height + 10 + weapon_definition.ammo_image_size.height + 10 + weapon_name_height) * health)
    UiPop()

    -- draw screen indicator
    local damage = 1 - health
    UiPush()
    UiAlign("top left")
    UiColor(0.5 - (damage * 0.5), 0.1 - (damage * 0.1), 0.1 - (damage * 0.1), damage)
    UiRect(UiWidth(), UiHeight())
    UiPop()

    -- draw death text
    if damage == 1 then
        local kia_text = "K.I.A."
        UiPush()
        UiAlign("top left")
        UiFont("bold.ttf", 128)
        UiColor(1, 1, 1)
        local kia_text_width, kia_text_height = UiGetTextSize(kia_text)
        UiTranslate(10, UiHeight() / 2 - kia_text_height / 2)
        UiText(kia_text)
        UiPop()

        UiPush()
        UiAlign("top left")
        UiFont("regular.ttf", 24)
        UiColor(1, 1, 1)
        UiTranslate(10, UiHeight() / 2 + kia_text_height)
        UiText("Press Esc")
        UiPop()
    end
end

sprite_weapons.hud.tick = function(delta_time)

end

sprite_weapons.hud.draw = function()
    draw_ammo()
    draw_magazines()
    draw_weapon_name()
    draw_health()
end

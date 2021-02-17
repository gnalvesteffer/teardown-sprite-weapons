escape_menu_options = {
    [1] = {
        text = "RESTART",
        handler = function()
            Restart()
        end
    },
    [2] = {
        text = "ABORT",
        handler = function()
            Menu()
        end
    }
}

function init()
end

function tick(delta_time)
end

function draw_escape_menu()
    local font_size = 36
    for index, option in ipairs(escape_menu_options) do
        UiPush()
        UiFont("bold.ttf", font_size)
        UiAlign("center middle")
        UiTranslate(UiWidth() / 2, ((UiHeight() / 2) - (#escape_menu_options * font_size / 2)) + ((index - 1) * (font_size + 10)))
        local text_width, text_height = UiGetTextSize(option.text)
        UiColor(0, 0, 0)
        UiRect(text_width + 5, text_height + 5)
        UiColor(1, 1, 1)
        if UiTextButton(option.text) then
            UiSound("common/click.ogg")
            option.handler()
        end
        UiPop()
    end
end

function draw()
    if GetBool("game.paused") then
        draw_escape_menu()
    end
end

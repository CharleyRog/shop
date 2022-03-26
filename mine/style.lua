local style = {}
local com   = require("component")
local unicode = require("unicode")
local gpu   = com.gpu
local func  = require('func')

local display = {
    x = 85,
    y = 33,
}

color = {
    black = 0x000000,
    white = 0xFFFFFF,
    gray  = 0x909090,
    green = 0x00a550,
    red   = 0xB22222
}

function style.draw_hello()
    str = "Нажми по монитору что бы авторизоваться"
    gpu.set(func.center(str), display.y/2 - 1, str)
    style.button(display.x/2, display.y/2 + 3, 35, 5, "Авторизоваться")
end

function style.display_main(w, h, group)
    gpu.fill(1, 1, display.x, display.y, " ")

    gpu.fill(13, 1, w - 13, 1, "─")
    gpu.fill(14, h-3, w - 2, 1, "─")
    gpu.fill(w, 1, 1, 1, "┐")
    gpu.fill(13, h-3, 1, 1, "└")
    gpu.fill(w, h-3, 1, 1, "┘")
    gpu.fill(w, 2, 1, h-5, "│")
    gpu.fill(13, 2, 1, 28, "│")

    -- НАЗАД

    gpu.set(1, h - 2, "┌")
    gpu.set(1, h, "└")
    gpu.set(10, h - 2, "┐")
    gpu.set(10, h, "┘")

    gpu.fill(2, h, 8, 1, "─")
    gpu.fill(2, h-2, 8, 1, "─")

    gpu.set(1, h - 1, "│")
    gpu.set(10, h - 1, "│")

    gpu.set(8 + func.center("Добро пожаловать!"), 3,"ДОБРО ПОЖАЛОВАТЬ!")

    gpu.set(8 + func.center("Для пополнения баланса необходимо поместить в левый сундук"), 10,"Для пополнения баланса необходимо поместить в левый сундук")

    gpu.set(8 + func.center("ресурс, который имеется в обменнике."), 11,"ресурс, который имеется в обменнике.")

    gpu.set(8 + func.center("Купленные ресурсы помещаются в правый сундук."), 13,"Купленные ресурсы помещаются в правый сундук.")

    gpu.set(8 + func.center("ВНИМАНИЕ"), h-7,"ВНИМАНИЕ")
    gpu.set(8 + func.center("ДОСТУП К ОБМЕННИКУ МОЖЕТ БЫТЬ ЗАКРЫТ"), h-6,"ДОСТУП К ОБМЕННИКУ МОЖЕТ БЫТЬ ЗАКРЫТ")
    gpu.set(8 + func.center("В ЛЮБОЙ МОМЕНТ БЕЗ ОБЪЯСНЕНИЯ ПРИЧИНЫ"), h-5,"В ЛЮБОЙ МОМЕНТ БЕЗ ОБЪЯСНЕНИЯ ПРИЧИНЫ")
    gpu.set(2, display.y - 1, "< НАЗАД")
    gpu.set(13, display.y - 1, "Логин: ")
    gpu.set(13, display.y, "Баланс:")
end

function style.display_mod(w, h)
    gpu.set(w - 1, 2, "┐")
    gpu.fill(w - 1, 3, 1, h-7, "│")
    gpu.set(w - 1, h-4, "┘")

    gpu.fill(27, 5, 1, 25, "│") --
    gpu.set(27, h-4, "└")

    gpu.fill(28, 2, 56, 1, "─")
    gpu.fill(28, h-4, 56, 1, "─")
end

function style.table_auth(w, h)
    gpu.fill(1, 2 ,1, h-1, "│")
    gpu.fill(w, 2, 1, h-1, "│")

    gpu.fill(2, 1, w-2, 1, "─")
    gpu.fill(2, h, w-2, 1, "─")

    gpu.fill(1, 1, 1, 1, "┌")
    gpu.fill(1, h, 1, 1, "└")

    gpu.fill(w, 1, 1, 1, "┐")
    gpu.fill(w, h, 1, 1, "┘")
end

function style.display_buy(name, price, count)
    start_x = 38
    w_x = 35
    start_y = 9
    w_y = 14

    gpu.fill(start_x, start_y, w_x + 1, w_y + 1, " ")

    gpu.set(start_x, start_y, "┌")
    gpu.set(start_x + w_x, start_y, "┐")
    gpu.set(start_x, start_y + w_y, "└")
    gpu.set(start_x + w_x, start_y + w_y, "┘")

    gpu.fill(start_x + 1, start_y, w_x - 1, 1, "─")
    gpu.fill(start_x + 1, start_y + w_y, w_x - 1, 1, "─")

    gpu.fill(start_x, start_y + 1, 1, w_y - 1, "│")
    gpu.fill(start_x + w_x, start_y + 1, 1, w_y - 1, "│")

    gpu.set(start_x + w_x / 2 - unicode.len("ВЫ СОБИРАЕТЕСЬ КУПИТЬ") / 2, start_y + 1, "ВЫ СОБИРАЕТЕСЬ КУПИТЬ")
    gpu.set(start_x + w_x / 2 - unicode.len(name) / 2, start_y + 2, name)
    local str = "ПО ЦЕНЕ " .. tostring(price) .. "$ / ШТ"
    gpu.set(start_x + w_x / 2 - unicode.len(str) / 2, start_y + 4, str)
    gpu.set(start_x + w_x / 2 - unicode.len("УКАЖИТЕ КОЛИЧЕСТВО") / 2, start_y + 6, "УКАЖИТЕ КОЛИЧЕСТВО")

    local sum = "В СУММЕ: "..tostring(price * count).."$"
    gpu.set(start_x + w_x / 2 - unicode.len(sum) / 2, start_y + 11, sum)

    gpu.setForeground(color.black)
    gpu.setBackground(color.white)

    gpu.set(start_x + w_x / 2 - 11, start_y + 7, "  1 ")
    gpu.set(start_x + w_x / 2 - 5, start_y + 7, " 32 ")
    gpu.set(start_x + w_x / 2 + 6 - unicode.len(" 256"), start_y + 7, " 64 ")
    gpu.set(start_x + w_x / 2 + 12 - unicode.len(" 256"), start_y + 7, " 128")

    gpu.set(start_x + w_x / 2 - 11, start_y + 9, " 256")
    gpu.set(start_x + w_x / 2 - 5, start_y + 9, " 512")
    gpu.set(start_x + w_x / 2 + 6 - unicode.len("1024"), start_y + 9, "1024")
    gpu.set(start_x + w_x / 2 + 12 - unicode.len("6912"), start_y + 9, "6912")

    gpu.set(start_x + w_x / 2 - unicode.len(" КУПИТЬ ") - 1, start_y + 13, " КУПИТЬ ")
    gpu.set(start_x + w_x / 2 + 2, start_y + 13, " ОТМЕНА ")

    gpu.setForeground(color.white)
    gpu.setBackground(color.black)
end

function style.button(x, y, w, h, str)
    gpu.setBackground(color.gray)
    gpu.setForeground(color.black)
    gpu.fill(x-w/2, y-h/2, w, h, " ")
    gpu.set(x - unicode.len(str)/2, y, str)

    gpu.setBackground(color.black)
    gpu.setForeground(color.white)
end

function style.updateGroup(Groups)
    gpu.fill(2, 1, 11, 1, "─")
    gpu.set(1, 1, "┌")
    gpu.set(13, 1, "┬")
    gpu.set(13, 3 + (#Groups-1)*2, "┤")
    gpu.set(1, 3 + (#Groups-1)*2, "└")
    for i = 1, #Groups do
        gpu.set(3, 2 + (i-1)*2, Groups[i].name)
        gpu.set(1, 2 + (i-1)*2, "│")
        gpu.set(13, 2 + (i-1)*2, "│")
        if i < #Groups then
            gpu.set(1, 3 + (i-1)*2, "├")
            gpu.set(13, 3 + (i-1)*2, "┤")
        end
        gpu.fill(2, 3 + (i-1)*2, 11, 1, "─")
    end
end

function style.updateMods(Mods)
    gpu.fill(16, 2, 11, 1, "─")
    gpu.fill(15, 2, 1, 1, "┌")
    gpu.fill(27, 2, 1, 1, "┬")
    gpu.fill(15, 4 + (#Mods-1)*2, 1, 1, "└")
    gpu.fill(27, 4 + (#Mods-1)*2, 1, 1, "┤")
    for i = 1, #Mods do
        gpu.set(17, 3 + (i-1)*2, Mods[i].name)
        gpu.set(15, 3 + (i-1)*2, "│")
        gpu.set(27, 3 + (i-1)*2, "│")
        if i < #Mods then
            gpu.set(15, 4 + (i-1)*2, "├")
            gpu.set(27, 4 + (i-1)*2, "┤")
        end
        gpu.fill(16, 4 + (i-1)*2, 11, 1, "─")
    end
end

return style
local com           = require("component")
local event         = require("event")
local term          = require("term")
local unicode       = require("unicode")
local gpu           = com.gpu
local internet      = require("internet")
local serialization = require("serialization")
local comp          = require("computer")

local fs            = require("filesystem")
local shell         = require("shell")
local style         = require('style')
local func          = require('func')

local sell          = com.proxy("a367e4e8-2546-4406-bdcd-8f940cca00f3")
local me_sell       = com.proxy("6a6086a0-d375-4e4f-852a-f66dd4c07248")
local buy           = com.proxy("c50cb86d-8e16-430c-8c91-1057ddd4ecde")
local me_buy        = com.proxy("6d99968c-20df-42b2-b96d-fe845a7d21a4")

event.shouldInterrupt = function () return false end

local display = {
    x = 85,
    y = 33,
}

local Groups = {}
local Mods = {}
local Items = {}
local Select_Items = {}
local num_item = 1
local count_items = 0

local AUTOEXIT = 25
local user = {}
local auth = false
local num_group = 0
local num_mod = 1
local inStr = 13
local status_buy = false
local buy_count = 1

function start()
    func.userdel()
    gpu.setResolution(display.x, display.y)
    hello()
end

function hello()
    term.clear()
    style.table_auth(display.x, display.y)
    style.draw_hello()
end

function autoExit()
    if timer <= 1 then
        internet.request("http://shop.kudrin.su/func/save2.php?name="..user.name.."&money="..tostring(user.money))
        hello()
        auth = false
        func.userdel()
    else
        timer = timer - 1
        gpu.fill(display.x - 2, display.y, 2 , 1, " ")
        gpu.set(display.x - 2, display.y, tostring(timer))
    end
end

function Login()
    local e,_,w,h,_,nick = event.pull("touch")
    if nick then
        if not func.checkserver() then return end
        local res = internet.request("http://shop.kudrin.su/func/load2.php?name="..nick)
        for line in res do
            if line ~= "wait" then
                user = serialization.unserialize(line)
                Groups = func.get_groups()
                Mods = func.get_mods()
                Items = func.get_items()
                timer = AUTOEXIT
                comp.addUser(user.name)
                num_group = 0
                num_mod = 1
                status_buy = false
                auth = true
                main()
            end
        end
    else auth = false
    end
end

function swap_group(num)
    style.updateGroup(Groups)
    if num ~= 1 then
        gpu.set(13, 1 + (num-1)*2, "┘")
    end
    if num == 1 then
        gpu.set(13, 1, "─")
    end
    gpu.set(13, 2 + (num-1)*2, " ")
    gpu.set(13, 2 + (num-1)*2 + 1, "┐")
end

function swap_mod(num2)
    style.updateMods(Mods)
    if num2 ~= 1 then
        gpu.set(27, 2 + (num2-1)*2, "┘")
    end
    if num2 == 1 then
        gpu.set(27, 2 + (num2-1)*2, "─")
    end
    gpu.set(27, 3 + (num2-1)*2, " ")
    gpu.set(27, 4 + (num2-1)*2, "┐")
    draw_items()
end

function draw_items()
    gpu.fill(28, 3, 56, inStr * 2, " ")
    count_items = 0
    Select_Items = {}
    for i = 1, #Items do
        if Items[i].groups == num_group and Items[i].mods == num_mod then
            Select_Items[count_items + 1] = Items[i]
            Items[i].count = tostring(func.getme(Items[i].id, Items[i].dmg))
            gpu.set(30, 3 + count_items * 2, "[      ]")
            gpu.set(31, 3 + count_items * 2, Items[i].count)
            gpu.set(39, 3 + count_items * 2, Items[i].title)
            gpu.set(69, 3 + count_items * 2, tostring(Items[i].price).."$")
            gpu.setForeground(color.black)
            gpu.setBackground(color.white)
            gpu.set(75, 3 + count_items * 2, " КУПИТЬ ")
            gpu.setForeground(color.white)
            gpu.setBackground(color.black)
            if count_items > 0 and count_items < 13 then
                gpu.fill(29, 2 + count_items * 2, 54, 1, "─")
            end
            count_items = count_items + 1
        end
        if count_items == 13 then
            break
        end
    end
end

function redriw_buy(i)
    style.display_buy(Select_Items[i].title, Select_Items[i].price, buy_count)
end

function touch(w, h)
    if w >= 1 and w <= 10 and h >= 31 and h <= 33 then timer = 0
    elseif status_buy then
        if w >= 44 and w<=47 and h == 16 then buy_count = 1 redriw_buy(num_item)
        elseif w >= 50 and w<=53 and h == 16 then buy_count = 32 redriw_buy(num_item)
        elseif w >= 57 and w<=60 and h == 16 then buy_count = 64 redriw_buy(num_item)
        elseif w >= 63 and w<=66 and h == 16 then buy_count = 128 redriw_buy(num_item)
        elseif w >= 44 and w<=47 and h == 18 then buy_count = 256 redriw_buy(num_item)
        elseif w >= 50 and w<=53 and h == 18 then buy_count = 512 redriw_buy(num_item)
        elseif w >= 57 and w<=60 and h == 18 then buy_count = 1024 redriw_buy(num_item)
        elseif w >= 63 and w<=66 and h == 18 then buy_count = 6912 redriw_buy(num_item)
        elseif w >= 57 and w <= 64 and h == 22 then
            status_buy = false
            buy_count = 1
            draw_items()
        elseif w >= 46 and w <= 53 and h == 22 then
            buy(num_item)
            status_buy = false
            buy_count = 1
            draw_items()
        end
    else
        if w >= 1 and w <= 10 then
            for i = 1, #Groups do
                if h == i * 2 then
                    if num_group == 0 then
                        style.display_mod(display.x, display.y)
                    end
                    num_group = i
                    swap_group(num_group)
                    num_mod = 1
                    swap_mod(num_mod)
                    break
                end
            end
        elseif w >= 16 and w <= 26 and num_group > 0 then
            for i = 1, #Mods do
                if h == i * 2 + 1 then
                    num_mod = i
                    swap_mod(num_mod)
                    break
                end
            end
        elseif w >= 75 and w <= 82 and num_group > 0 then
            for i = 1, count_items do -- БАГ
                if h == 3 + (i-1) * 2 then
                    status_buy = true
                    num_item = i
                    redriw_buy(num_item)
                    break
                end
            end
        end
    end
end

function main()
    style.display_main(display.x, display.y, Groups)
    gpu.set(22, display.y - 1, user.name) --
    gpu.set(22, display.y, tostring(user.money).."$")
    gpu.set(display.x - unicode.len("Авто выход через:") - 3, display.y, "Авто выход через: "..AUTOEXIT)
    style.updateGroup(Groups)
end

function updateMoney(add)
    user.money = func.round(user.money + add, 2)
    gpu.fill(22, display.y, 40, 1, " ")
    gpu.set(22, display.y, tostring(user.money).."$")
end

function checksrystal()
    sell.condenseItems()
    local result = 0
    for slot = 1, sell.getInventorySize() do
        local item = sell.getStackInSlot(slot)
        if item then
            for i = 1, #Items do
                if item.id == Items[i].id and item.dmg == Items[i].dmg then
                    me_sell.pullItem(2, slot)
                    updateMoney(item.qty*Items[i].price)
                    if num_group > 0 then draw_items() end
                end
            end
        end
    end
end

function buy(i)
    local count = func.buy(user.name, user.money, Select_Items[i].price, Select_Items[i].id, Select_Items[i].dmg, buy_count)
    if count ~= nil then
        updateMoney(-1 * count * Select_Items[i].price)
    end
end

start()
while true do
    if not auth then
        local result, err = pcall(Login)
        os.sleep(0.1)
    else
        checksrystal()
        term.setCursor(1,1)
        local e,_,w,h,_,nick = event.pull(1, "touch")
        if e == "touch" then
            timer = AUTOEXIT
            local result, err = pcall(touch, w, h)
        end
        autoExit()
    end
end
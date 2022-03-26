local func      = {}
local com       = require("component")
local unicode   = require("unicode")
local internet  = require("internet")
local ser       = require("serialization")
local comp      = require("computer")
local fs        = require("filesystem")

local sell          = com.proxy("a367e4e8-2546-4406-bdcd-8f940cca00f3")
local me_sell       = com.proxy("6a6086a0-d375-4e4f-852a-f66dd4c07248")
local buy           = com.proxy("c50cb86d-8e16-430c-8c91-1057ddd4ecde")
local me_buy        = com.proxy("6d99968c-20df-42b2-b96d-fe845a7d21a4")

local display = {
    x = 85,
    y = 33,
}

function func.buy(user, money, price, id, dmg, count)
    me_count, max_size = func.getme(id, dmg)
    if money < price * count then
        count = math.floor(money / price)
    end
    if count == 0 then return end
    if count > me_count then count = me_count end
    local fingerprint = {id = id, dmg = dmg}
    local result = 0
    for i = 1, math.ceil(count/max_size) do
        size = me_buy.exportItem(fingerprint, 2, count).size
        count = count - size
        result = result + size
    end
    return result
end

function func.checkserver()
    local con = internet.open("shop.kudrin.su", 443)
    if(con) then
        return true
    else
        return false
    end
end

function func.userdel()
    local comp_users={comp.users()}
    for i=1, #comp_users do
        comp.removeUser(comp_users[i])
    end
end

function func.center(str)
    return display.x/2 - unicode.len(str)/2
end

function func.round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function func.get_groups()
    local string = ""
    local res = internet.request("http://shop.kudrin.su/lib/groups.php")
    for line in res do
        string = string..line
    end
    local groups = ser.unserialize(string)
    return groups
end

function func.get_mods()
    local string = ""
    local res = internet.request("http://shop.kudrin.su/lib/mods.php")
    for line in res do
        string = string..line
    end
    local mods = ser.unserialize(string)
    return mods
end

function func.get_items()
    local string = ""
    local res = internet.request("http://shop.kudrin.su/lib/items2.php")
    for line in res do
        string = string..line
    end
    local Items = ser.unserialize(string)
    return Items
end

function func.getme(id, dmg)
    local fingerprint = {id = id, dmg = dmg}
    local item = me_sell.getItemDetail(fingerprint)
    if item then
        item = item.basic()
        return item.qty, item.max_size
    end
    return 0, 0
end

return func
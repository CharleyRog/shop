local component = require("component")
local term = require('term')
local text = require("text")
local components = {}
local methods = {}
local offset = 0
term.clear()
for address, name in component.list() do
    if name:len() > offset then
        offset = name:len()
    end
    components[address] = name
end

offset = offset + 2
print(' -------- Найденные компоненты --------')
for address, name in pairs(components) do
    io.write(text.padRight(name, offset) .. address .. '\n')
end
print(' --------------------------------------')
io.write('Введите имя компонента, методы которого нужно узнать: \n>> ')
local name = io.read()
if component.isAvailable(name) then
    t = component.getPrimary(name)
    local filename = name..'_doc.tmp'
    local file = io.open(filename, 'w')
    for k,v in pairs(t) do
        table.insert(methods,'>> Метод: '..k..'\nДокументация: '..tostring(v))
        file:write('>> Метод: '..k..'\nДокументация: '..tostring(v)..'\n')
    end
    file:close()
    if component.isAvailable('internet') then
        print('Перейдите по ссылке на сайт для ознакомления!')
        require('shell').execute('pastebin put '..filename)
    else
        term.clear()
        print('Нажимайте ENTER для продолжения')
        for k,v in pairs(methods) do
            print('['..k..'] '..v)
            io.read()
        end
    end
else
    print('Ошибка. Компонента '..name..' не существует!')
end
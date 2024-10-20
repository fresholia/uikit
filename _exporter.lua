Exporter = {}
Exporter.resourceName = getResourceName(getThisResource())
Exporter.injection = {
    'RESOURCE_NAME = "' .. Exporter.resourceName .. '"',
    'IS_EXTERNAL = true',
}
Exporter.replicationStr = [[
for type in pairs(ElementType) do
    _G[type] = {}

    _G[type].new = function(self)
        outputChatBox(type .. ' is not imported. Please add this to the top line: import(\'' .. type .. '\')')
        error(type .. ' is not imported. Please add this to the top line: import(\'' .. type .. '\')')
    end
end
]]

Exporter.replicationDependency = [[
function import(...)
    loadstring(exports.]] .. Exporter.resourceName .. [[:import(...))()
end
]]

Exporter.checkOOPStr = [[
if not isOOPEnabled() then
    outputChatBox('OOP is not enabled. To use UIKit, you need to enable OOP. Please add this to the top line of meta.xml: <oop>true</oop>')
    error('OOP is not enabled. To use UIKit, you need to enable OOP. Please add this to the top line of meta.xml: <oop>true</oop>')
    return
end
]]

Exporter.modules = {}

createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, function()
    local xml = XML.load('meta.xml')
    local nodes = xml:getChildren()

    table.insert(Exporter.injection, Exporter.checkOOPStr)

    for i, node in ipairs(nodes) do
        if node:getName() == 'script' then
            local src = node:getAttribute('src')
            local isSkip = node:getAttribute('skip')
            local isIgnore = node:getAttribute('ignore')
            local module = node:getAttribute('module')
            if isSkip and not isIgnore then
                if not File.exists(src) then
                    outputConsole('[UIKit] Failed to load module, file not found: ' .. src)
                    break
                end

                local file = File.open(src)
                local content = file:read(file:getSize())
                file:close()

                if not module then
                    table.insert(Exporter.injection, content)
                else
                    if not Exporter.modules[module] then
                        Exporter.modules[module] = ''
                    end

                    Exporter.modules[module] = Exporter.modules[module] .. '\n' .. content
                end
            end
        end
    end

    table.insert(Exporter.injection, Exporter.replicationStr)
    table.insert(Exporter.injection, 'screenSize = Vector2(guiGetScreenSize())')
    table.insert(Exporter.injection, 'Core = Core:new()')
    table.insert(Exporter.injection, Exporter.replicationDependency)
end)

function getModule()
    local str = table.concat(Exporter.injection, '\n')

    if File.exists('temp.lua') then
        File.delete('temp.lua')
    end

    local tempFile = File.new('temp.lua')
    tempFile:write(str)
    tempFile:close()

    return str
end

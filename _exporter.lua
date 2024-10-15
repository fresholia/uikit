local Exporter = {}
Exporter.resourceName = getResourceName(getThisResource())
Exporter.injection = {
    'RESOURCE_NAME = "' .. Exporter.resourceName .. '"',
    'IS_EXTERNAL = true'
}

createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, function()
    local xml = XML.load('meta.xml')
    local nodes = xml:getChildren()

    for i, node in ipairs(nodes) do
        if node:getName() == 'script' then
            local src = node:getAttribute('src')
            local isSkip = node:getAttribute('skip')
            local isIgnore = node:getAttribute('ignore')
            if isSkip and not isIgnore then
                if not File.exists(src) then
                    outputConsole('[UIKit] Failed to load module, file not found: ' .. src)
                    break
                end

                local file = File.open(src)
                local content = file:read(file:getSize())
                file:close()

                table.insert(Exporter.injection, content)
            end
        end
    end

    table.insert(Exporter.injection, 'screenSize = Vector2(guiGetScreenSize())')
    table.insert(Exporter.injection, 'Core = Core:new()')
    table.insert(Exporter.injection, 'outputConsole("[UIKit] Exported modules loaded.")')
end)

function getModule()
    return table.concat(Exporter.injection, '\n')
end

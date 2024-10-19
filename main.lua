screenSize = Vector2(guiGetScreenSize())
RESOURCE_NAME = getResourceName(getThisResource())

local function bootstrap()
    -- # Create a new core instance
    Core = Core:new()

    addCommandHandler('workshop', function()
        -- # Display the workshop
        Workshop:show()
    end)

    local button = Button:new(
            Vector2(250, 250),
            nil,
            'Open DatePicker',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )
    DatePicker:new(button)
end
createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, bootstrap)

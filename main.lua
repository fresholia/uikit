screenSize = Vector2(guiGetScreenSize())

local function bootstrap()
    -- # Create a new core instance
    Core = Core:new()

    -- # Display the workshop
    Workshop:show()
end
createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, bootstrap)

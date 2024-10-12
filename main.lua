screenSize = Vector2(guiGetScreenSize())

local function bootstrap()
    -- # Create a new core instance
    Core = Core:new()

    addCommandHandler('workshop', function()
        -- # Display the workshop
        Workshop:show()
    end)
end
createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, bootstrap)

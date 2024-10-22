screenSize = Vector2(guiGetScreenSize())
RESOURCE_NAME = getResourceName(getThisResource())

local function bootstrap()
    -- # Create a new core instance
    Core = Core:new()

    addCommandHandler('workshop', function()
        -- # Display the workshop
        Workshop:show()
    end)

    local listItems = {
        { key = 'apple', value = 'Apple' },
        { key = 'banana', value = 'Banana' },
        { key = 'cherry', value = 'Cherry' },
        { key = 'date', value = 'Date' },
        { key = 'elderberry', value = 'Elderberry' },
        { key = 'fig', value = 'Fig' },
        { key = 'grape', value = 'Grape' },
        { key = 'honeydew', value = 'Honeydew' },
        { key = 'kiwi', value = 'Kiwi' },
        { key = 'lemon', value = 'Lemon' },
        { key = 'mango', value = 'Mango' },
        { key = 'nectarine', value = 'Nectarine' },
        { key = 'orange', value = 'Orange' },
        { key = 'pear', value = 'Pear' },
        { key = 'quince', value = 'Quince' },
        { key = 'raspberry', value = 'Raspberry' },
        { key = 'strawberry', value = 'Strawberry' },
        { key = 'tangerine', value = 'Tangerine' },
        { key = 'ugli', value = 'Ugli' },
    }

    local scrollableList = ScrollableList:new(Vector2(200, 200), Vector2(300, 600), listItems)
    scrollableList:setSelectMode(ScrollableList.selectMode.Multiple)

end
createNativeEvent(ClientEventNames.onClientResourceStart, resourceRoot, bootstrap)

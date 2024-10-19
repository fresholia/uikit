Workshop:registerElement(ElementType.IconButton, function(tabs, tab)
    local variantsMap = {
        [1] = Button.variants.Solid,
        [2] = Button.variants.Bordered,
        [3] = Button.variants.Light,
    }

    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size & Variants',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local buttonX = tabs.content.position.x
    for i = 1, #sizesMap do
        local button = IconButton:new(
                Vector2(buttonX, tabs.content.position.y + 30),
                nil,
                Icon:new(Vector2(0, 0), Vector2(30, 30), 'user', Icon.style.Solid),
                variantsMap[i],
                Element.color.Danger,
                sizesMap[i]
        )
        button:setParent(tab)

        buttonX = buttonX + 40
    end
end)

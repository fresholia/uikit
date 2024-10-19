Workshop:registerElement(ElementType.Switch, function(tabs, tab)
    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local checkboxY = tabs.content.position.y

    for i = 1, #sizesMap do
        local checkbox = Switch:new(
                Vector2(tabs.content.position.x, checkboxY + 30),
                nil,
                sizesMap[i],
                Element.color.Dark,
                sizesMap[i]
        )
        checkbox:setParent(tab)

        checkboxY = checkboxY + checkbox.size.y + 10
    end

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 150),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    for i = 1, #colorsMap do
        local checkbox = Switch:new(
                Vector2(tabs.content.position.x, tabs.content.position.y + 180 + (i - 1) * 40),
                nil,
                Element.size.Medium,
                colorsMap[i],
                colorsMap[i]
        )
        checkbox:setParent(tab)
        checkbox:setSelected(true)
    end
end)
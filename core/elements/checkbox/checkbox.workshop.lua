Workshop:registerElement(ElementType.Checkbox, function(tabs, tab)
    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local checkboxX = tabs.content.position.x

    for i = 1, #sizesMap do
        local checkbox = Checkbox:new(
                Vector2(checkboxX, tabs.content.position.y + 30),
                sizesMap[i],
                sizesMap[i],
                Element.color.Dark,
                false
        )
        checkbox:setParent(tab)

        checkboxX = checkboxX + checkbox.size.x + 10
    end

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 100),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    checkboxX = tabs.content.position.x

    for i = 1, #colorsMap do
        local checkbox = Checkbox:new(
                Vector2(checkboxX, tabs.content.position.y + 130),
                Element.size.Medium,
                colorsMap[i],
                colorsMap[i],
                false
        )
        checkbox:setParent(tab)

        checkboxX = checkboxX + checkbox.size.x + 10
    end

    local withTooltipHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 200),
            Vector2(tabs.content.size.x, 30),
            'With Tooltip',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    withTooltipHeader:setParent(tab)

    local checkbox = Checkbox:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 230),
            Element.size.Medium,
            'With Tooltip',
            Element.color.Dark,
            false
    )

    checkbox:setParent(tab)

    Tooltip:new(checkbox, 'This is a tooltip!', Element.size.Medium, Tooltip.placement.Top)
end)
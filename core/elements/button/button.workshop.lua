Workshop:registerElement(ElementType.Button, function(tabs, tab)
    local variantsMap = {
        [1] = Button.variants.Solid,
        [2] = Button.variants.Bordered,
        [3] = Button.variants.Light,
    }

    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local buttonX = tabs.content.position.x
    for i = 1, #sizesMap do
        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 30),
                nil,
                sizesMap[i],
                Button.variants.Solid,
                Element.color.Primary,
                sizesMap[i]
        )
        button:setParent(tab)

        buttonX = buttonX + button.size.x + 10
    end

    local variantHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 100),
            Vector2(tabs.content.size.x, 30),
            'Variant',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    variantHeader:setParent(tab)

    buttonX = tabs.content.position.x

    for i = 1, #variantsMap do
        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 130),
                nil,
                variantsMap[i],
                variantsMap[i],
                Element.color.Primary,
                Element.size.Medium
        )
        button:setParent(tab)
        buttonX = buttonX + button.size.x + 10
    end

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 200),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    buttonX = tabs.content.position.x

    for i = 1, #colorsMap do
        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 230),
                nil,
                colorsMap[i],
                Button.variants.Solid,
                colorsMap[i],
                Element.size.Medium
        )
        button:setParent(tab)

        buttonX = buttonX + button.size.x + 10
    end

    buttonX = tabs.content.position.x

    local startContentHeader = Text:new(
            Vector2(buttonX, tabs.content.position.y + 300),
            Vector2(tabs.content.size.x, 30),
            'Start Content',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    startContentHeader:setParent(tab)

    local button = Button:new(
            Vector2(tabs.content.position.x + 30, tabs.content.position.y + 330),
            nil,
            'Button',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )
    button:setParent(tab)
    button:setStartContent(Icon:new(Vector2(0, 0), Vector2(32, 32), 'user', Icon.style.Solid))

    local endContentHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 400),
            Vector2(tabs.content.size.x, 30),
            'End Content',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    endContentHeader:setParent(tab)

    button = Button:new(
            Vector2(tabs.content.position.x + 30, tabs.content.position.y + 430),
            nil,
            'Button',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )

    button:setParent(tab)
    button:setEndContent(Icon:new(Vector2(0, 0), Vector2(20, 20), 'user', Icon.style.Light))

    local fixedWidthHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 500),
            Vector2(tabs.content.size.x, 30),
            'Fixed Width',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    fixedWidthHeader:setParent(tab)

    button = Button:new(
            Vector2(tabs.content.position.x + 30, tabs.content.position.y + 530),
            nil,
            'Button',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )

    button:setFixedWidth(200)
    button:setParent(tab)

    local loadingHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 600),
            Vector2(tabs.content.size.x, 30),
            'Loading',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    loadingHeader:setParent(tab)

    button = Button:new(
            Vector2(tabs.content.position.x + 30, tabs.content.position.y + 630),
            nil,
            'Button',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )

    button:setParent(tab)
    button:setIsLoading(true)

    local withTooltipHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 700),
            Vector2(tabs.content.size.x, 30),
            'With Tooltip',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    withTooltipHeader:setParent(tab)

    button = Button:new(
            Vector2(tabs.content.position.x + 30, tabs.content.position.y + 730),
            nil,
            'Button',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )

    button:setParent(tab)
    Tooltip:new(button, 'This is a tooltip!', Element.size.Medium, Tooltip.placement.Top)
end)

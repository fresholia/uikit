Workshop:registerElement(ElementType.Window, function(tabs, tab)
    local windowHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Window',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    windowHeader:setParent(tab)

    local window = Window:new(Vector2(tabs.content.position.x, tabs.content.position.y + 30), Vector2(400, 200), 'Hello, World!')
    window:setParent(tab)
end)

Workshop:registerElement(ElementType.Chart, function(tabs, tab)
    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Chart',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local curvedChart = Chart:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 60),
            Vector2(400, 200),
            Element.color.Primary,
            Chart.variants.Solid,
            Chart.fill.Gradient,
            Chart.stroke.Curve,
            {
                { name = 'Series 1', data = { 25, 15, 2, 20, 86, 19, 89, 1 } },
            }
    )
    curvedChart:setParent(tab)

    curvedChart = Chart:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 280),
            Vector2(400, 200),
            Element.color.Danger,
            Chart.variants.Solid,
            Chart.fill.Gradient,
            Chart.stroke.Curve,
            {
                { name = 'Series 1', data = { 360, 120, 185, 353, 992, 293, 444 } },
            }
    )
    curvedChart:setParent(tab)
end)
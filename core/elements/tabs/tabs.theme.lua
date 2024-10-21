TabsTheme = inherit(Theme)

function TabsTheme:constructor()
    self:setProperty('padding', Core.globalPadding)
    self:setProperty('gap', {
        [Element.size.Small] = 2,
        [Element.size.Medium] = 4,
        [Element.size.Large] = 8
    })
    self:setProperty('innerPadding', { x = Padding.Large, y = Padding.Medium })
    self:setProperty('borderRadius', BorderRadii.Medium)
    self:setProperty('font', Core.fonts.Regular.element)

    self:setColor(Element.color.Primary, {
        Background = self:combine('PRIMARY', 800, 0.8),
        BackgroundHover = self:combine('PRIMARY', 700, 1),
        BackgroundActive = self:combine('PRIMARY', 800, 1),
        BackgroundDisabled = self:combine('PRIMARY', 200, 1),
        Foreground = self:combine('PRIMARY', 50, 1),
    })

    self:setColor(Element.color.Dark, {
        Background = self:combine('GRAY', 100, 0.7),
        BackgroundHover = self:combine('GRAY', 200, 1),
        BackgroundActive = self:combine('GRAY', 300, 1),
        BackgroundDisabled = self:combine('GRAY', 200, 1),
        Foreground = self:combine('GRAY', 900, 1),
    })
end

TabsTheme = inherit(Theme)

function TabsTheme:constructor()
    self:setProperty('padding', Core.globalPadding)
    self:setProperty('gap', {
        [Element.size.Small] = 4,
        [Element.size.Medium] = 8,
        [Element.size.Large] = 12
    })
    self:setProperty('innerPadding', { x = 6, y = 6 })
    self:setProperty('borderRadius', 8)
    self:setProperty('font', Core.fonts.Regular.element)

    self:setColor(Element.color.Primary, {
        Background = self:combine('PRIMARY', 800, 0.8),
        BackgroundHover = self:combine('PRIMARY', 700, 1),
        BackgroundActive = self:combine('PRIMARY', 800, 1),
        BackgroundDisabled = self:combine('PRIMARY', 200, 1),
        Foreground = self:combine('PRIMARY', 50, 1),
    })

    self:setColor(Element.color.Dark, {
        Background = self:combine('DARK', 900, 0.7),
        BackgroundHover = self:combine('DARK', 700, 1),
        BackgroundActive = self:combine('DARK', 800, 1),
        BackgroundDisabled = self:combine('DARK', 200, 1),
        Foreground = self:combine('DARK', 50, 1),
    })

end

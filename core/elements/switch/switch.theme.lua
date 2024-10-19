SwitchTheme = inherit(Theme)

function SwitchTheme:constructor()
    self:setProperty('borderRadius', 10)

    self:setColor(Element.color.Primary, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('PRIMARY', 700, 1),
        BackgroundActive = self:combine('PRIMARY', 800, 1),
        BackgroundDisabled = self:combine('PRIMARY', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Secondary, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('SECONDARY', 700, 1),
        BackgroundActive = self:combine('SECONDARY', 800, 1),
        BackgroundDisabled = self:combine('SECONDARY', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Success, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('GREEN', 700, 1),
        BackgroundActive = self:combine('GREEN', 800, 1),
        BackgroundDisabled = self:combine('GREEN', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Danger, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('RED', 700, 1),
        BackgroundActive = self:combine('RED', 800, 1),
        BackgroundDisabled = self:combine('RED', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Warning, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('ORANGE', 700, 1),
        BackgroundActive = self:combine('ORANGE', 800, 1),
        BackgroundDisabled = self:combine('ORANGE', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Info, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('BLUE', 700, 1),
        BackgroundActive = self:combine('BLUE', 800, 1),
        BackgroundDisabled = self:combine('BLUE', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Light, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('LIGHT', 700, 1),
        BackgroundActive = self:combine('LIGHT', 800, 1),
        BackgroundDisabled = self:combine('LIGHT', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.Dark, {
        Background = self:combine('DARK', 800, 1),
        BackgroundHover = self:combine('DARK', 700, 1),
        BackgroundActive = self:combine('DARK', 800, 1),
        BackgroundDisabled = self:combine('DARK', 200, 1),
        Foreground = self:combine('DARK', 300, 1),
    })

    self:setColor(Element.color.White, {
        Background = self:combine('WHITE', 500, 1),
        BackgroundHover = self:combine('WHITE', 700, 1),
        BackgroundActive = self:combine('WHITE', 800, 1),
        BackgroundDisabled = self:combine('WHITE', 200, 1),
        Foreground = self:combine('WHITE', 50, 1),
    })

    self:setProperty('baseSize', {
        [Element.size.Small] = { x = 24, y = 10 },
        [Element.size.Medium] = { x = 36, y = 16 },
        [Element.size.Large] = { x = 60, y = 24 },
    })
    self:setProperty('padding', {
        [Element.size.Small] = { x = 4, y = 4, fontSize = 0.4 },
        [Element.size.Medium] = { x = 4, y = 4, fontSize = 0.5 },
        [Element.size.Large] = { x = 4, y = 4, fontSize = 0.6 },
    })
    self:setProperty('font', Core.fonts.Regular.element)
end
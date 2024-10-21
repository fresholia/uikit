ButtonTheme = inherit(Theme)

function ButtonTheme:constructor()
    self:setProperty('padding', Core.globalPadding)

    self:setColor(Element.color.Primary, {
        Background = self:combine('PRIMARY', 500, 1),
        BackgroundHover = self:combine('PRIMARY', 700, 1),
        BackgroundActive = self:combine('PRIMARY', 800, 1),
        BackgroundDisabled = self:combine('PRIMARY', 200, 1),
        Foreground = self:combine('PRIMARY', 50, 1),
    })

    self:setColor(Element.color.Secondary, {
        Background = self:combine('SECONDARY', 500, 1),
        BackgroundHover = self:combine('SECONDARY', 600, 1),
        BackgroundActive = self:combine('SECONDARY', 700, 1),
        BackgroundDisabled = self:combine('SECONDARY', 200, 1),
        Foreground = self:combine('SECONDARY', 50, 1),
    })

    self:setColor(Element.color.Success, {
        Background = self:combine('GREEN', 500, 1),
        BackgroundHover = self:combine('GREEN', 700, 1),
        BackgroundActive = self:combine('GREEN', 800, 1),
        BackgroundDisabled = self:combine('GREEN', 200, 1),
        Foreground = self:combine('GREEN', 50, 1),
    })

    self:setColor(Element.color.Danger, {
        Background = self:combine('RED', 500, 1),
        BackgroundHover = self:combine('RED', 700, 1),
        BackgroundActive = self:combine('RED', 800, 1),
        BackgroundDisabled = self:combine('RED', 200, 1),
        Foreground = self:combine('RED', 50, 1),
    })

    self:setColor(Element.color.Warning, {
        Background = self:combine('ORANGE', 500, 1),
        BackgroundHover = self:combine('ORANGE', 700, 1),
        BackgroundActive = self:combine('ORANGE', 800, 1),
        BackgroundDisabled = self:combine('ORANGE', 200, 1),
        Foreground = self:combine('ORANGE', 50, 1),
    })

    self:setColor(Element.color.Info, {
        Background = self:combine('BLUE', 500, 1),
        BackgroundHover = self:combine('BLUE', 700, 1),
        BackgroundActive = self:combine('BLUE', 800, 1),
        BackgroundDisabled = self:combine('BLUE', 200, 1),
        Foreground = self:combine('BLUE', 50, 1),
    })

    self:setColor(Element.color.Light, {
        Background = self:combine('LIGHT', 500, 1),
        BackgroundHover = self:combine('LIGHT', 700, 1),
        BackgroundActive = self:combine('LIGHT', 800, 1),
        BackgroundDisabled = self:combine('LIGHT', 200, 1),
        Foreground = self:combine('LIGHT', 50, 1),
    })

    self:setColor(Element.color.Dark, {
        Background = self:combine('DARK', 500, 1),
        BackgroundHover = self:combine('DARK', 700, 1),
        BackgroundActive = self:combine('DARK', 800, 1),
        BackgroundDisabled = self:combine('DARK', 200, 1),
        Foreground = self:combine('DARK', 50, 1),
    })

    self:setColor(Element.color.White, {
        Background = self:combine('WHITE', 500, 1),
        BackgroundHover = self:combine('WHITE', 700, 1),
        BackgroundActive = self:combine('WHITE', 800, 1),
        BackgroundDisabled = self:combine('WHITE', 200, 1),
        Foreground = self:combine('WHITE', 50, 1),
    })

    self:setProperty('font', Core.fonts.Regular.element)
    self:setProperty('hoverDuration', AnimationDuration.Fast)
end

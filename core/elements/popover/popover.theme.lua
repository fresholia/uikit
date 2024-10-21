PopoverTheme = inherit(Theme)

function PopoverTheme:constructor()

    self:setColor(Element.color.Primary, {
        Background = self:combine('PRIMARY', 500, 1),
        Foreground = self:combine('PRIMARY', 50, 1),
    })

    self:setColor(Element.color.Secondary, {
        Background = self:combine('SECONDARY', 500, 1),
        Foreground = self:combine('SECONDARY', 50, 1),
    })

    self:setColor(Element.color.Success, {
        Background = self:combine('GREEN', 500, 1),
        Foreground = self:combine('GREEN', 50, 1),
    })

    self:setColor(Element.color.Danger, {
        Background = self:combine('RED', 500, 1),
        Foreground = self:combine('RED', 50, 1),
    })

    self:setColor(Element.color.Warning, {
        Background = self:combine('ORANGE', 500, 1),
        Foreground = self:combine('ORANGE', 50, 1),
    })

    self:setColor(Element.color.Info, {
        Background = self:combine('BLUE', 500, 1),
        Foreground = self:combine('BLUE', 50, 1),
    })

    self:setColor(Element.color.Light, {
        Background = self:combine('LIGHT', 500, 1),
        Foreground = self:combine('LIGHT', 50, 1),
    })

    self:setColor(Element.color.Dark, {
        Background = self:combine('CONTENT', 2, 1),
        Foreground = self:combine('CONTENT', 3, 1),
    })

    self:setColor(Element.color.White, {
        Background = self:combine('WHITE', 500, 1),
        Foreground = self:combine('WHITE', 50, 1),
    })
end
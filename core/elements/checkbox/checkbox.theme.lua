CheckboxTheme = inherit(Theme)

function CheckboxTheme:constructor()
    self:setProperty('radius', 4)

    self:setProperty('padding', {
        [Element.size.Small] = { x = Padding.Small, y = Padding.Small, fontSize = 0.4 },
        [Element.size.Medium] = { x = Padding.Medium, y = Padding.Medium, fontSize = 0.5 },
        [Element.size.Large] = { x = Padding.Large, y = Padding.Large, fontSize = 0.6 },
    })
    self:setProperty('font', Core.fonts.Regular.element)
end

CheckboxTheme = inherit(Theme)

function CheckboxTheme:constructor()
    self:setProperty('radius', 4)

    self:setProperty('padding', {
        [Element.size.Small] = { x = 8, y = 8, fontSize = 0.4 },
        [Element.size.Medium] = { x = 10, y = 10, fontSize = 0.5 },
        [Element.size.Large] = { x = 12, y = 12, fontSize = 0.6 },
    })
    self:setProperty('font', Core.fonts.Regular.element)
end

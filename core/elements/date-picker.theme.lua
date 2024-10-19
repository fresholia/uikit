DatePickerTheme = inherit(Theme)

function DatePickerTheme:constructor()
    self:setProperty('borderRadius', 12)
    self:setProperty('gap', 12)
    self:setProperty('padding', { x = 12, y = 12 })

    self:setColor('background', self:combine('LAYOUT', 'Background', 1))
    self:setColor('backgroundHeader', self:combine('CONTENT', 1, 1))
    self:setColor('foreground', self:combine('LIGHT', 900, 1))
    self:setColor('foregroundActive', self:combine('LIGHT', 400, 1))
    self:setColor('foregroundHeader', self:combine('LIGHT', 600, 1))
    self:setColor('primaryColor', self:combine('PRIMARY', 300, 1))

end
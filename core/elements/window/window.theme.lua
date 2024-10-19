WindowTheme = inherit(Theme)

function WindowTheme:constructor()
    self:setColor('background', self:c('CONTENT', 1, 1))
    self:setColor('foreground', self:combine('GRAY', 900, 1))
    self:setColor('hover', self:combine('GRAY', 400, 1))
    self:setColor('line', self:c('CONTENT', 4, 0.05))

    self:setProperty('titlebarHeight', 40)
    self:setProperty('padding', 12)
    self:setProperty('borderRadius', 6)

    self:setProperty('hoverDuration', 150)
end

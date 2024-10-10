WindowTheme = inherit(Theme)

function WindowTheme:constructor()
    self:setColor('background', self:c('GRAY', 900, 0.9))
    self:setColor('foreground', self:c('GRAY', 100, 1))
    self:setColor('line', self:c('GRAY', 700, 0.9))

    self:setProperty('titlebarHeight', 30)
    self:setProperty('padding', 12)
end

TableTheme = inherit(Theme)

function TableTheme:constructor()
    self:setColor('backgroundColor', self:combine('CONTENT', 1, 1))
    self:setColor('headerColor', self:combine('CONTENT', 2, 1))
    self:setColor('headerForegroundColor', self:combine('LIGHT', 400, 1))
    self:setColor('headerForegroundIconColor', self:combine('LIGHT', 800, 1))

    self:setProperty('innerPadding', { x = Padding.Medium, y = Padding.Medium })
    self:setProperty('headerHeight', 35)
    self:setProperty('rowHeight', 30)
    self:setProperty('selectableWidth', 24)

    self:setProperty('borderRadius', BorderRadii.Medium)
end

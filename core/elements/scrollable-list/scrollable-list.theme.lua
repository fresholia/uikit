ScrollableListTheme = inherit(Theme)

function ScrollableListTheme:constructor()
    self:setProperty('rowHeight', Padding.Large * 2)
    self:setProperty('rowPadding', Padding.XSmall)
    self:setProperty('rowBorderRadius', BorderRadii.XSmall)

    self:setProperty('borderRadius', BorderRadii.Small)
    self:setProperty('innerPadding', { x = Padding.Medium, y = Padding.Medium })

    self:setColor('background', self:combine('CONTENT', 1, 1))
    self:setColor('rowBackground', self:combine('CONTENT', 1, 1))
    self:setColor('rowBackgroundHover', self:combine('CONTENT', 2, 1))

    self:setColor('scrollbarBackground', self:combine('CONTENT', 2, 0.25))
    self:setColor('scrollbarForeground', self:combine('CONTENT', 3, 0.25))

    self:setColor('foreground', self:combine('LIGHT', 800, 1))

    self:setProperty('hoverDuration', AnimationDuration.Fast)
end
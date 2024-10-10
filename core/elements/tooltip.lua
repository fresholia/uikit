Tooltip = inherit(Element)
Tooltip.placement = {
    Top = 'top',
    Bottom = 'bottom',
    Right = 'right',
    Left = 'left',
    TopStart = 'top-start',
    TopEnd = 'top-end',
    BottomStart = 'bottom-start',
    BottomEnd = 'bottom-end',
    LeftStart = 'left-start',
    LeftEnd = 'left-end',
    RightStart = 'right-start',
    RightEnd = 'right-end',
}

function Tooltip:constructor(parent, content, tooltipSize, placement, color)
    assert(parent, 'Parent is required.')

    self.type = ElementType.Tooltip

    self.content = content

    self.theme = TooltipTheme:new()
    self.color = color or Element.color.Dark
    self.placement = placement or Tooltip.placement.Top
    self.tooltipSize = tooltipSize

    self:setParent(parent)
    self:calculateSize()

    parent:createEvent(Element.events.OnCursorEnter, bind(self.doPulse, self))
    parent:createEvent(Element.events.OnCursorLeave, bind(self.removeChildren, self))
end

function Tooltip:calculateSize()
    local padding = self.theme:getProperty('padding')[self.tooltipSize or Element.size.Medium]
    local fontSize = padding.fontSize
    local textWidth = dxGetTextWidth(self.content, fontSize, self.theme:getProperty('font'))
    local textHeight = dxGetFontHeight(fontSize, self.theme:getProperty('font'))

    local size = Vector2(textWidth + padding.x * 2, textHeight + padding.y * 2)

    self.size = size
end

function Tooltip:getPosition()
    local gap = self.theme:getProperty('gap')

    local parentElement = Core:hasElement(self.parent)
    if not parentElement then
        return false
    end

    if self.placement == Tooltip.placement.Top then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Tooltip.placement.Bottom then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Tooltip.placement.Right then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == Tooltip.placement.Left then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == Tooltip.placement.TopStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Tooltip.placement.TopEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Tooltip.placement.BottomStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Tooltip.placement.BottomEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Tooltip.placement.LeftStart then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y
        )
    elseif self.placement == Tooltip.placement.LeftEnd then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    elseif self.placement == Tooltip.placement.RightStart then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y
        )
    elseif self.placement == Tooltip.placement.RightEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    end
end

function Tooltip:setText(text)
    self.content = text
    self:calculateSize()
end

function Tooltip:doPulse()
    local palette = self.theme:getColor(self.color)
    local padding = self.theme:getProperty('padding')[self.tooltipSize]

    local position = self:getPosition()
    if not position then
        return
    end

    local rect = Rectangle:new(position, self.size, self.theme:getProperty('borderRadius'))
    rect:setParent(self)
    rect:setColor(palette.Background.element)

    local text = Text:new(rect.position, rect.size, self.content, self.theme:getProperty('font'), padding.fontSize, nil, Text.alignment.Center)
    text:setParent(rect)
    text:setColor(palette.Foreground.element)
end

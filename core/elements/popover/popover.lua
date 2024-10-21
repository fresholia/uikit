Popover = inherit(Element)
Popover.placement = {
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

function Popover:constructor(size, parent, placement, color)
    self.placement = placement or Popover.placement.Top
    self.color = color or Element.color.Dark

    self.size = size

    self.theme = PopoverTheme:new()

    self:setParent(parent)
    self:setRenderIndex(999)

    self.position = self:getPosition()

    self.content = {
        size = Vector2(self.size.x - Padding.Medium, self.size.y - Padding.Medium * 2),
        position = Vector2(self.position.x + Padding.Medium / 2, self.position.y + Padding.Medium / 2)
    }

    parent:createEvent(Element.events.OnClick, bind(self.onOpen, self))
    parent:createEvent(Element.events.OnClickOutside, bind(self.onClose, self))

    self:createEvent(Element.events.OnChildAdd, bind(self.onChildAdd, self))
end

function Popover:doPulse()
    local palette = self.theme:getColor(self.color)

    local bgRect = Rectangle:new(self.position, self.size, BorderRadii.Small, palette.Background.element)
    bgRect:setParent(self)
    bgRect:setRenderIndex(-1)
end

function Popover:onChildAdd(child)
    child:setVisible(false, true)
end

function Popover:onOpen()
    if self:isVisible() then
        self:onClose()
        return
    end

    self:setVisible(true, true)
    self.position = self:getPosition()
    self:doPulse()
end

function Popover:onClose()
    if self.isHovered then
        return
    end

    self:setVisible(false, true)
end

function Popover:getPosition()
    local gap = Padding.Medium

    local parentElement = Core:hasElement(self.parent)
    if not parentElement then
        return false
    end

    if self.placement == Popover.placement.Top then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Popover.placement.Bottom then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Popover.placement.Right then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == Popover.placement.Left then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == Popover.placement.TopStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Popover.placement.TopEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == Popover.placement.BottomStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Popover.placement.BottomEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == Popover.placement.LeftStart then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y
        )
    elseif self.placement == Popover.placement.LeftEnd then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    elseif self.placement == Popover.placement.RightStart then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y
        )
    elseif self.placement == Popover.placement.RightEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    end
end

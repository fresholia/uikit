IconButton = inherit(Button)

function IconButton:constructor(_, _, iconElement, variant, color, buttonSize)
    self.type = ElementType.IconButton
    self.iconElement = iconElement

    self.label = ''
    self.childrenMap = {}
    self.theme = IconButtonTheme:new()

    self.variant = variant or Button.variants.Solid
    self.color = color or Element.color.Primary
    self.buttonSize = buttonSize or Element.size.Medium

    self:doPulse()

    self:createEvent(Element.events.OnClick, bind(self.onClick, self))
    self:createEvent(Element.events.OnCursorEnter, bind(self.onCursorEnter, self))
    self:createEvent(Element.events.OnCursorLeave, bind(self.onCursorLeave, self))

    local buttonSizes = self.theme:getProperty('buttonSizes')[self.buttonSize]
    self:setFixedWidth(buttonSizes.x)
    self:setFixedHeight(buttonSizes.y)
    self.iconElement:setParent(self)

    self.iconElement:setSize(Vector2(buttonSizes.iconSize, buttonSizes.iconSize))
    self.iconElement:setPosition(Vector2(self.position.x + (buttonSizes.x / 2) - (buttonSizes.iconSize / 2),
            self.position.y + (buttonSizes.y / 2) - (buttonSizes.iconSize / 2)))
end

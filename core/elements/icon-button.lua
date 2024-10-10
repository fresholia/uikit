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

Workshop:registerElement(ElementType.IconButton, function(tabs, tab)
    local variantsMap = {
        [1] = Button.variants.Solid,
        [2] = Button.variants.Bordered,
        [3] = Button.variants.Light,
    }

    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size & Variants',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local buttonX = tabs.content.position.x
    for i = 1, #sizesMap do
        local button = IconButton:new(
                Vector2(buttonX, tabs.content.position.y + 30),
                nil,
                Icon:new(Vector2(0, 0), Vector2(30, 30), 'user', Icon.style.Solid),
                variantsMap[i],
                Element.color.Danger,
                sizesMap[i]
        )
        button:setParent(tab)

        buttonX = buttonX + 40
    end
end)

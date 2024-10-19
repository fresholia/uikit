ButtonGroup = inherit(Element)

function ButtonGroup:new(...)
    return new(self, ...)
end

function ButtonGroup:constructor(position, size, buttons, variant, color, buttonSize)
    self.type = ElementType.ButtonGroup

    self.buttons = buttons or {}
    self.variant = variant or Button.variants.Solid
    self.color = color or Element.color.Primary
    self.buttonSize = buttonSize or Element.size.Medium

    self.activeIndex = 1

    self.localButtons = {}

    self:doPulse()
end

function ButtonGroup:setActiveIndex(index)
    self.activeIndex = index

    for i = 1, #self.localButtons do
        self.localButtons[i]:setColor(i == index and self.color or Element.color.Dark)
    end
end

function ButtonGroup:onSwitch(index)
    if self.activeIndex == index then
        return
    end

    self:setActiveIndex(index)
    self:virtual_callEvent(Element.events.OnChange, index)
end

function ButtonGroup:doPulse()
    self:removeChildren()

    local buttonWidth = self.size.x / #self.buttons

    for i = 1, #self.buttons do
        local button = Button:new(
                Vector2(self.position.x + (buttonWidth * (i - 1)), self.position.y),
                Vector2(buttonWidth, self.size.y),
                self.buttons[i].label,
                self.variant,
                self.activeIndex == i and self.color or Element.color.Dark,
                self.buttonSize
        )
        button:createEvent(Element.events.OnClick, bind(self.onSwitch, self, i))
        if i == 1 then
            button.theme:setProperty('borderRadius', { tl = 4, tr = 0, br = 0, bl = 4 })
        elseif i == #self.buttons then
            button.theme:setProperty('borderRadius', { tl = 0, tr = 4, br = 4, bl = 0 })
        else
            button.theme:setProperty('borderRadius', 0)
        end

        self.localButtons[i] = button

        button:setParent(self)
        button:setFixedWidth(buttonWidth)
    end
end
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

    self.totalWidth = 0

    self:doPulse()
end

function ButtonGroup:setActiveIndex(index)
    self.activeIndex = index

    for i = 1, #self.localButtons do
        self.localButtons[i]:setColor(i == index and self.color or Element.color.Dark)
    end
end

function ButtonGroup:onSwitch(index, label, value)
    if self.activeIndex == index then
        return
    end

    self:setActiveIndex(index)
    self:virtual_callEvent(Element.events.OnChange, index, label, value)
end

function ButtonGroup:doPulse()
    self:removeChildren()

    local buttonWidth = self.size.x / #self.buttons

    self.totalWidth = buttonWidth * #self.buttons
    for i = 1, #self.buttons do
        local label = self.buttons[i].label
        local value = self.buttons[i].value

        local button = Button:new(
                Vector2(self.position.x + (buttonWidth * (i - 1)), self.position.y),
                Vector2(buttonWidth, self.size.y),
                label,
                self.variant,
                (self.activeIndex == i or self.activeIndex == label) and self.color or Element.color.Dark,
                self.buttonSize
        )
        button:createEvent(Element.events.OnClick, bind(self.onSwitch, self, i, label, value))
        if i == 1 then
            button.theme:setProperty('borderRadius', { tl = BorderRadii.XSmall, tr = 0, br = 0, bl = BorderRadii.XSmall })
        elseif i == #self.buttons then
            button.theme:setProperty('borderRadius', { tl = 0, tr = BorderRadii.XSmall, br = BorderRadii.XSmall, bl = 0 })
        else
            button.theme:setProperty('borderRadius', BorderRadii.None)
        end

        self.localButtons[i] = button

        button:setParent(self)
        button:setFixedWidth(buttonWidth)
    end
end
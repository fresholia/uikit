Checkbox = inherit(Element)

function Checkbox:constructor(_, _, label, color, isSelected)
    self.type = ElementType.Checkbox

    self.label = label
    self.color = color or Element.color.Dark
    self.isSelected = isSelected or false
    self.isIndeterminate = false

    self.theme = CheckboxTheme:new()

    local btn = Button:new(
            self.position,
            nil,
            '', Button.variants.Solid, Element.color.Dark, self.size)

    local currentTheme = self.theme:getProperty('padding')[self.size or Element.size.Medium]
    btn.theme:setProperty('padding', self.theme:getProperty('padding'))

    btn:doPulse()
    btn:setParent(self)

    self.btn = btn

    local indeterminateIcon = Icon:new(Vector2(btn.position.x + btn.size.x / 2 - 8, btn.position.y + btn.size.y / 2 - 8), Vector2(16, 16), 'minus', Icon.style.Solid)
    indeterminateIcon:setParent(self)
    indeterminateIcon:setRenderMode(Element.renderMode.Hidden)

    self.indeterminateIcon = indeterminateIcon

    local icon = Icon:new(Vector2(btn.position.x + btn.size.x / 2 - 8, btn.position.y + btn.size.y / 2 - 8), Vector2(16, 16), 'check', Icon.style.Solid)
    icon:setRenderMode(self.isSelected and Element.renderMode.Normal or Element.renderMode.Hidden)
    icon:setParent(self)

    self.icon = icon

    local text = Text:new(
            Vector2(btn.position.x + btn.size.x + 5, btn.position.y),
            btn.size,
            self.label,
            self.theme:getProperty('font'),
            currentTheme.fontSize, nil, Text.alignment.LeftCenter)
    text:setParent(self)

    self.size = {
        x = btn.size.x + text.textWidth + currentTheme.x,
        y = btn.size.y
    }

    self:createEvent(Element.events.OnClick, bind(self.onSelectionChange, self))
    self.btn:setColor(self.isSelected and self.color or Element.color.Dark)
end

function Checkbox:setSelected(isSelected)
    self.isSelected = isSelected

    self.icon:setRenderMode(self.isSelected and Element.renderMode.Normal or Element.renderMode.Hidden)
    self.indeterminateIcon:setRenderMode(Element.renderMode.Hidden)

    self.btn:setColor(self.isSelected and self.color or Element.color.Dark)
end

function Checkbox:setIndeterminate(isIndeterminate)
    self.isIndeterminate = isIndeterminate

    self.indeterminateIcon:setRenderMode(self.isIndeterminate and Element.renderMode.Normal or Element.renderMode.Hidden)

    if self.isIndeterminate then
        self.icon:setRenderMode(Element.renderMode.Hidden)
    end

    self.btn:setColor(self.isSelected and self.color or Element.color.Dark)
end

function Checkbox:onSelectionChange()
    self.isSelected = not self.isSelected

    self.icon:setRenderMode(self.isSelected and Element.renderMode.Normal or Element.renderMode.Hidden)

    self:virtual_callEvent(Element.events.OnChange, self.isSelected)
end

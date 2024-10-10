Checkbox = inherit(Element)

function Checkbox:constructor(position, size, label, color, isSelected)
    self.type = ElementType.Checkbox

    self.label = label
    self.color = color or Element.color.Dark
    self.isSelected = isSelected or false

    self.theme = CheckboxTheme:new()

    local btn = Button:new(
            self.position,
            nil,
            '', Button.variants.Solid, self.color, self.size)

    local currentTheme = self.theme:getProperty('padding')[self.size or Element.size.Medium]
    btn.theme:setProperty('padding', self.theme:getProperty('padding'))

    btn:doPulse()
    btn:setParent(self)

    local icon = Icon:new(Vector2(btn.position.x + btn.size.x / 2 - 8, btn.position.y + btn.size.y / 2 - 8), Vector2(16, 16), 'check', Icon.style.Solid)
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
end

function Checkbox:setSelected(isSelected)
    self.isSelected = isSelected

    self.icon:setVisible(self.isSelected)
end

function Checkbox:onSelectionChange()
    self.isSelected = not self.isSelected

    self.icon:setVisible(self.isSelected)
end

Workshop:registerElement(ElementType.Checkbox, function(tabs, tab)
    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local checkboxX = tabs.content.position.x

    for i = 1, #sizesMap do
        local checkbox = Checkbox:new(
                Vector2(checkboxX, tabs.content.position.y + 30),
                sizesMap[i],
                sizesMap[i],
                Element.color.Dark,
                false
        )
        checkbox:setParent(tab)

        checkboxX = checkboxX + checkbox.size.x + 10
    end

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 100),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    checkboxX = tabs.content.position.x

    for i = 1, #colorsMap do
        local checkbox = Checkbox:new(
                Vector2(checkboxX, tabs.content.position.y + 130),
                Element.size.Medium,
                colorsMap[i],
                colorsMap[i],
                false
        )
        checkbox:setParent(tab)

        checkboxX = checkboxX + checkbox.size.x + 10
    end

    local withTooltipHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 200),
            Vector2(tabs.content.size.x, 30),
            'With Tooltip',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    withTooltipHeader:setParent(tab)

    local checkbox = Checkbox:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 230),
            Element.size.Medium,
            'With Tooltip',
            Element.color.Dark,
            false
    )

    checkbox:setParent(tab)

    Tooltip:new(checkbox, 'This is a tooltip!', Element.size.Medium, Tooltip.placement.Top)
end)
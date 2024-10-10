Switch = inherit(Element)

function Switch:constructor(position, _, switchSize, color, label)
    self.type = ElementType.Switch
    self.switchSize = switchSize or Element.size.Medium
    self.color = color or Element.color.Dark
    self.label = label or ''

    self.theme = SwitchTheme:new()

    self.isSelected = false
    self.elements = {}

    self:calculateSize()
    self:doPulse()
end

function Switch:calculateSize()
    local borderRadius = self.theme:getProperty('borderRadius')
    local padding = self.theme:getProperty('padding')[self.switchSize]
    local font = self.theme:getProperty('font')
    local baseSize = self.theme:getProperty('baseSize')[self.switchSize]

    self.size = Vector2(
            padding.x * 2 + baseSize.x,
            padding.y * 2 + baseSize.y
    )
end

function Switch:setSelected(isSelected, withAnimation)
    if self.isSelected == isSelected then
        return
    end

    if self:isDisabled() then
        return
    end

    self.isSelected = isSelected
    if withAnimation then
        self:animatePulse(isSelected)
    else
        self:doPulse()
    end
end

function Switch:toggle()
    self:setSelected(not self.isSelected, true)
end

function Switch:setDisabled(disabled)
    self.disabled = disabled
    self:doPulse()
end

function Switch:animatePulse()
    local newDotPosition = self.dotPositions[self.isSelected]
    local palette = self.theme:getColor(self.color)

    Core.animate:doPulse(self.elements.dot.id,
            { self.elements.dot.position.x, self.elements.dot.position.y, 0 },
            { newDotPosition.x, newDotPosition.y, 0 },
            150, 'Linear', function(x, y)
                self.elements.dot:setPosition(Vector2(x, y))
            end)

    Core.animate:doPulse(self.elements.dot.id .. 'size',
            { self.dotSize, 0, 0 },
            { self.dotSize * 1.5, 0, 0 },
            150, 'SineCurve', function(x)
                self.elements.dot:setSize(Vector2(x, self.elements.dot.size.y), true)
            end)

    local normalColor = { palette.Background.original.r, palette.Background.original.g, palette.Background.original.b }
    local activeColor = { palette.BackgroundActive.original.r, palette.BackgroundActive.original.g, palette.BackgroundActive.original.b }

    Core.animate:doPulse(self.elements.bg.id,
            self.isSelected and normalColor or activeColor,
            self.isSelected and activeColor or normalColor,
            150, 'Linear', function(r, g, b)
                self.elements.bg:setColor(tocolor(r, g, b))
            end)
end

function Switch:doPulse()
    self:removeChildren()

    local borderRadius = self.theme:getProperty('borderRadius')
    local palette = self.theme:getColor(self.color)
    local padding = self.theme:getProperty('padding')[self.switchSize]
    local font = self.theme:getProperty('font')
    local baseSize = self.theme:getProperty('baseSize')[self.switchSize]

    local bgRectColor = self.isSelected and palette.BackgroundActive.element or palette.Background.element

    if self:isDisabled() then
        bgRectColor = palette.BackgroundDisabled.element
    end

    local bgRect = Rectangle:new(self.position, self.size, borderRadius)
    bgRect:setColor(bgRectColor)
    bgRect:setParent(self)
    bgRect:createEvent(Element.events.OnClick, bind(self.toggle, self))
    self.elements.bg = bgRect

    local dotSize = bgRect.size.y - padding.y * 2
    self.dotSize = dotSize

    local dotPositions = {
        [true] = Vector2(bgRect.position.x + bgRect.size.x - dotSize - padding.x, self.position.y + padding.y),
        [false] = Vector2(self.position.x + padding.x, self.position.y + padding.y)
    }
    self.dotPositions = dotPositions

    local dotRect = Rectangle:new(
            dotPositions[self.isSelected],
            Vector2(dotSize, dotSize),
            dotSize / 2
    )
    dotRect:setColor(palette.Foreground.element)
    dotRect:setParent(self)
    dotRect:setRenderIndex(1)
    self.elements.dot = dotRect

    if self.label ~= '' then
        local text = Text:new(
                Vector2(
                        bgRect.position.x + bgRect.size.x + padding.x * 2,
                        bgRect.position.y
                ),
                bgRect.size,
                self.label,
                self.theme:getProperty('font'),
                padding.fontSize, nil, Text.alignment.LeftCenter)
        text:setParent(self)
    end
end

Workshop:registerElement(ElementType.Switch, function(tabs, tab)
    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local checkboxY = tabs.content.position.y

    for i = 1, #sizesMap do
        local checkbox = Switch:new(
                Vector2(tabs.content.position.x, checkboxY + 30),
                nil,
                sizesMap[i],
                Element.color.Dark,
                sizesMap[i]
        )
        checkbox:setParent(tab)

        checkboxY = checkboxY + checkbox.size.y + 10
    end

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 150),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    for i = 1, #colorsMap do
        local checkbox = Switch:new(
                Vector2(tabs.content.position.x, tabs.content.position.y + 180 + (i - 1) * 40),
                nil,
                Element.size.Medium,
                colorsMap[i],
                colorsMap[i]
        )
        checkbox:setParent(tab)
        checkbox:setSelected(true)
    end
end)
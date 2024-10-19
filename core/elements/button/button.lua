Button = inherit(Element)
Button.variants = {
    Solid = 'solid',
    Bordered = 'bordered',
    Light = 'light',
}

function Button:constructor(_, _, label, variant, color, buttonSize)
    self.type = ElementType.Button
    self.label = label
    self.variant = variant
    self.color = color
    self.buttonSize = buttonSize

    self.theme = ButtonTheme:new()

    self.isLoading = false

    self.startContent = nil
    self.endContent = nil

    self.childrenMap = {}

    self:doPulse()

    self:createEvent(Element.events.OnClick, bind(self.onClick, self))
    self:createEvent(Element.events.OnCursorEnter, bind(self.onCursorEnter, self))
    self:createEvent(Element.events.OnCursorLeave, bind(self.onCursorLeave, self))
end

function Button:setLabel(label)
    self.label = label
    self.childrenMap.text:setText(label)
end

function Button:setStartContent(content)
    self.startContent = content
    self:doPulse()
end

function Button:setEndContent(content)
    self.endContent = content
    self:doPulse()
end

function Button:setColor(color)
    self.color = color
    self:doPulse()
end

function Button:doPulse()
    self:removeChildrenExcept({ ElementType.DatePicker, ElementType.Icon })

    local padding = self.theme:getProperty('padding')[self.buttonSize or Element.size.Medium]

    local colorPalette = self.theme:getColor(self.color)

    self.colorPalette = colorPalette

    if not colorPalette then
        error('Invalid color or variant.')
        return false
    end

    if not padding then
        error('Invalid button size.')
        return false
    end

    local textWidth = dxGetTextWidth(self.label, padding.fontSize, self.theme:getProperty('font'))
    local textHeight = dxGetFontHeight(padding.fontSize, self.theme:getProperty('font'))

    local size = Vector2(textWidth + padding.x * 2, textHeight + padding.y * 2)

    if self.label == '' then
        size.x = padding.x * 2
        size.y = padding.y * 2
    end

    local contentSize = Vector2(size.y - padding.y, size.y - padding.y)

    if self.startContent then
        size.x = size.x + contentSize.x + padding.x / 2
    end

    if self.endContent then
        size.x = size.x + contentSize.x + padding.x / 2
    end

    if self.fixedWidth then
        size.x = self.fixedWidth
    end

    if self.fixedHeight then
        size.y = self.fixedHeight
    end

    self.size = size

    local borderRadius = self.theme:getProperty('borderRadius') or self.size.y * 0.2

    local bg = Rectangle:new(self.position, self.size, borderRadius)
    bg:setColor((self.disabled or self.startContent) and colorPalette.BackgroundDisabled.element or colorPalette.Background.element)
    bg:setParent(self)
    bg:setRenderMode(self.variant == Button.variants.Light and Element.renderMode.Hidden or Element.renderMode.Normal)
    bg:setRenderIndex(-1)

    self.childrenMap.bg = bg

    local textX = self.position.x + padding.x
    if self.startContent then
        self.startContent:setSize(contentSize)
        self.startContent:setPosition(Vector2(self.position.x + padding.x / 2, self.position.y + padding.y / 2))
        self.startContent:setColor(colorPalette.Foreground.element)
        self.startContent:setRenderIndex(10)
        self.startContent:setParent(self)
        self.startContent:setPostGUI(true)

        textX = self.startContent.position.x + self.startContent.size.x + padding.x / 2
    end

    if self.endContent then
        self.endContent:setSize(contentSize)
        self.endContent:setPosition(Vector2(self.position.x + self.size.x - contentSize.x - padding.x / 2, self.position.y + padding.y / 2))

        self.endContent:setParent(self)
        self.endContent:setRenderIndex(1)
        self.endContent:setColor(colorPalette.Foreground.element)
    end

    if self.label ~= '' then
        local text = Text:new(Vector2(textX, self.position.y),
                self.size,
                self.label,
                self.theme:getProperty('font'),
                padding.fontSize,
                nil, Text.alignment.LeftCenter)
        text:setParent(self)
        text:setRenderIndex(100)
        text:setColor(colorPalette.Foreground.element)

        self.childrenMap.text = text
    end
end

function Button:setFixedWidth(width)
    self.fixedWidth = width
    self:doPulse()
end

function Button:setFixedHeight(height)
    self.fixedHeight = height
    self:doPulse()
end

function Button:setIsLoading(isLoading)
    self.isLoading = isLoading

    if isLoading then
        self:setDisabled(true)
        self.startContent = Icon:new(
                Vector2(self.position.x + 5, self.position.y + 5),
                Vector2(20, 20),
                'spinner-third', Icon.style.Solid
        )
        self.startContent:rotate(true)
    else
        self:setDisabled(false)
        self.startContent = nil
    end

    self:doPulse()
end

function Button:onCursorEnter()
    if self:isDisabled() then
        return
    end

    local bgColor = self.colorPalette.Background.original
    local hoverColor = self.colorPalette.BackgroundHover.original

    Core.animate:doPulse(self.id,
            { bgColor.r, bgColor.g, bgColor.b },
            { hoverColor.r, hoverColor.g, hoverColor.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                self.childrenMap.bg:setColor(tocolor(r, g, b, self.alpha * 255))
            end)
end

function Button:onCursorLeave()
    if self:isDisabled() then
        return
    end

    local bgColor = self.colorPalette.Background.original
    local hoverColor = self.colorPalette.BackgroundHover.original

    Core.animate:doPulse(self.id,
            { hoverColor.r, hoverColor.g, hoverColor.b },
            { bgColor.r, bgColor.g, bgColor.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                self.childrenMap.bg:setColor(tocolor(r, g, b, self.alpha * 255))
            end)
end

function Button:setDisabled(disabled)
    self.disabled = disabled
    self:doPulse()
end

function Button:onClick()
    if self:isDisabled() then
        return
    end

    if not self.childrenMap.bg then
        return
    end

    self.childrenMap.bg:setColor(self.colorPalette.BackgroundActive.element)
    Timer(function()
        self.childrenMap.bg:setColor(self.colorPalette.BackgroundHover.element)
    end, 150, 1)
end

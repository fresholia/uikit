Input = inherit(BaseInput)

function Input:constructor()
    self.type = ElementType.Input
 
    self:handle()
    self:doPulse()

    self.startContent = nil
    self.endContent = nil

    self:setMaxLength(self.innerSize.x / 8)
end

function Input:setStartContent(content)
    self.startContent = content
    self:calculateSize()
    self:doPulse()
end

function Input:setEndContent(content)
    self.endContent = content
    self:calculateSize()
    self:doPulse()
end

function Input:doPulse()
    self:virtual_doPulse()

    local borderRadius = self.theme:getProperty('borderRadius')
    local palette = self.theme:getColor(self.color)

    local baseRect = Rectangle:new(self.position, self.size, borderRadius)
    baseRect:setParent(self)
    baseRect:setColor(palette.Background.element)
    baseRect:setRenderIndex(-1)
    baseRect:setRenderMode(self.variant == BaseInput.variants.Light and Element.renderMode.Hidden or Element.renderMode.Normal)
end

Workshop:registerElement(ElementType.Input, function(tabs, tab)
    local variantsMap = {
        [1] = BaseInput.variants.Solid,
        [2] = BaseInput.variants.Bordered,
        [3] = BaseInput.variants.Light,
        [4] = BaseInput.variants.Underlined,
    }

    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local inputX = tabs.content.position.x
    for i = 1, #sizesMap do
        local input = Input:new(
                Vector2(inputX, tabs.content.position.y + 30),
                Vector2(220, 20),
                nil,
                nil,
                sizesMap[i]
        )
        input:setLabel(sizesMap[i])
        input:setParent(tab)

        inputX = inputX + input.size.x + 10
    end

    inputX = tabs.content.position.x

    local variantHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 100),
            Vector2(tabs.content.size.x, 30),
            'Variant',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    variantHeader:setParent(tab)

    for i = 1, #variantsMap do
        local input = Input:new(
                Vector2(inputX, tabs.content.position.y + 130),
                Vector2(220, 20),
                variantsMap[i],
                nil,
                Element.size.Medium
        )
        input:setLabel(variantsMap[i])
        input:setParent(tab)

        inputX = inputX + input.size.x + 10
    end

    inputX = tabs.content.position.x

    local colorHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 200),
            Vector2(tabs.content.size.x, 30),
            'Color',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    colorHeader:setParent(tab)

    for i = 1, #colorsMap do
        local input = Input:new(
                Vector2(inputX, tabs.content.position.y + 230),
                Vector2(100, 20),
                nil,
                colorsMap[i],
                Element.size.Medium
        )
        input:setLabel(colorsMap[i])
        input:setParent(tab)

        inputX = inputX + input.size.x + 10
    end

    inputX = tabs.content.position.x

    local iconHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 300),
            Vector2(tabs.content.size.x, 30),
            'With Start/End Content',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    iconHeader:setParent(tab)

    local withStartContentInput = Input:new(
            Vector2(inputX, tabs.content.position.y + 330),
            Vector2(220, 20),
            nil,
            nil,
            Element.size.Medium
    )

    withStartContentInput:setLabel('With Start Content')
    withStartContentInput:setParent(tab)
    withStartContentInput:setStartContent(
            Icon:new(
                    Vector2(0, 0),
                    Vector2(32, 32),
                    'user',
                    Icon.style.Light
            )
    )

    local withEndContentInput = Input:new(
            Vector2(inputX + 240, tabs.content.position.y + 330),
            Vector2(220, 20),
            nil,
            nil,
            Element.size.Medium
    )

    withEndContentInput:setLabel('With End Content')
    withEndContentInput:setParent(tab)
    withEndContentInput:setEndContent(
            Icon:new(
                    Vector2(0, 0),
                    Vector2(32, 32),
                    'user',
                    Icon.style.Light
            )
    )

    local withIsClearableInput = Input:new(
            Vector2(inputX + 480, tabs.content.position.y + 330),
            Vector2(220, 20),
            nil,
            nil,
            Element.size.Medium
    )

    withIsClearableInput:setLabel('With Clearable')
    withIsClearableInput:setParent(tab)
    withIsClearableInput:setIsClearable(true)
end)
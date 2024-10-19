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

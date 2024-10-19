Text = inherit(Element)
Text.alignment = {
    LeftTop = 'left-top',
    LeftCenter = 'left-center',
    LeftBottom = 'left-bottom',
    CenterTop = 'center-top',
    Center = 'center',
    CenterBottom = 'center-bottom',
    RightTop = 'right-top',
    RightCenter = 'right-center',
    RightBottom = 'right-bottom',
}

function Text:constructor(position, size, text, font, textSize, color, alignment)
    assert(type(text) == 'string', 'Text must be a string.')
    self.type = ElementType.Text

    self.text = text
    self.font = font or 'default'
    self.textSize = textSize or 1
    self.color = color or tocolor(255, 255, 255, 255)
    self.alignment = alignment or Text.alignment.LeftTop

    self.colorCoded = false

    if self.alignment == Text.alignment.LeftTop then
        self.alignX = 'left'
        self.alignY = 'top'
    elseif self.alignment == Text.alignment.LeftCenter then
        self.alignX = 'left'
        self.alignY = 'center'
    elseif self.alignment == Text.alignment.LeftBottom then
        self.alignX = 'left'
        self.alignY = 'bottom'
    elseif self.alignment == Text.alignment.CenterTop then
        self.alignX = 'center'
        self.alignY = 'top'
    elseif self.alignment == Text.alignment.Center then
        self.alignX = 'center'
        self.alignY = 'center'
    elseif self.alignment == Text.alignment.CenterBottom then
        self.alignX = 'center'
        self.alignY = 'bottom'
    elseif self.alignment == Text.alignment.RightTop then
        self.alignX = 'right'
        self.alignY = 'top'
    elseif self.alignment == Text.alignment.RightCenter then
        self.alignX = 'right'
        self.alignY = 'center'
    elseif self.alignment == Text.alignment.RightBottom then
        self.alignX = 'right'
        self.alignY = 'bottom'
    end

    self.textWidth = dxGetTextWidth(self.text, self.textSize, self.font)
end

function Text:setText(text)
    self.text = text
end

function Text:setTextSize(textSize)
    self.textSize = textSize
end

function Text:setFont(font)
    self.font = font
end

function Text:setColor(color)
    self.color = color
end

function Text:setColorCoded(colorCoded)
    self.colorCoded = colorCoded
end

function Text:render()
    dxDrawText(self.text,
            self.position.x,
            self.position.y,
            self.position.x + self.size.x,
            self.position.y + self.size.y,
            self.color,
            self.textSize,
            self.font,
            self.alignX,
            self.alignY,
            false, false, self.postGUI, self.colorCoded)
end

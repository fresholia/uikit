BaseInput = inherit(Element)
BaseInput.variants = {
    Solid = 'solid',
    Bordered = 'bordered',
    Light = 'light',
    Underlined = 'underlined'
}

function BaseInput:virtual_constructor(position, width, variant, color, inputSize)
    self.type = ElementType.BaseInput

    self.value = {}
    self.cursorPosition = Vector2(0, 1)

    self.selectionStart = Vector2(0, 0)
    self.selectionEnd = Vector2(0, 0)

    self.scroll = {
        current = 1,
        visibleMax = 1
    }

    self.theme = BaseInputTheme:new()
    self.isEditing = false

    self.pressingKeys = {}

    -- # Set constructor values
    self.variant = variant or BaseInput.variants.Solid
    self.color = color or Element.color.Dark
    self.inputSize = inputSize or Element.size.Medium

    -- # Input Opts
    self.masked = false
    self.regex = nil
    self.maxLength = nil
    self.multiline = false
    self.label = nil
    self.isClearable = false
end

function BaseInput:handle()
    self:createEvent(Element.events.OnCharacter, bind(self.onCharacter, self))
    self:createEvent(Element.events.OnKey, bind(self.onKey, self))
    self:createEvent(Element.events.OnClickOutside, bind(self.onClickOutside, self))
    self:createEvent(Element.events.OnVisibleChange, bind(self.setIsEditing, self, false))
    self:createEvent(Element.events.OnCursorMoveInside, bind(self.onCursorMoveInside, self))
    self:createEvent(Element.events.OnVisibleChange, bind(self.setIsEditing, self, false))

    self:createEvent(Element.events.OnPressDown, bind(self.onPressDown, self))
    self:createEvent(Element.events.OnPressUp, bind(self.onPressUp, self))
    self:calculateSize()
end

function BaseInput:destructor()
    self:setIsEditing(false)
end

function BaseInput:clearValue()
    self.value = {}
    self.cursorPosition = Vector2(0, 1)
    self.selectionStart = Vector2(0, 0)
    self.selectionEnd = Vector2(0, 0)
    self:reRender()
end

function BaseInput:setIsClearable(state)
    assert(type(state) == 'boolean', 'State must be a boolean.')
    self.isClearable = state

    if self.endContent then
        self.endContent:destroy()
        self.endContent = nil
    end

    if state then
        self.endContent = Icon:new(Vector2(0, 0), Vector2(32, 32), 'times', Icon.style.Solid)
        self.endContent:createEvent(Element.events.OnClick, bind(self.clearValue, self))

        self.endContent:setRenderMode(self:isValueEmpty() and Element.renderMode.Hidden or Element.renderMode.Normal)
    end

    self:calculateSize()
    self:doPulse()
end

function BaseInput:setLabel(label)
    assert(type(label) == 'string', 'Label must be a string.')
    self.label = label
    self:calculateSize()
    self:doPulse()
end

function BaseInput:setMasked(state)
    assert(type(state) == 'boolean', 'State must be a boolean.')

    self.masked = state
    self:reRender()
end

function BaseInput:setMaxLength(length)
    assert(type(length) == 'number', 'Length must be a number.')
    self.maxLength = math.floor(length)
end

function BaseInput:isValueEmpty()
    return #self.value == 0 or utf8.len(table.concat(self.value)) == 0
end

function BaseInput:hasSelection()
    if self.multiline then
        return self.selectionStart.x ~= self.selectionEnd.x or self.selectionStart.y ~= self.selectionEnd.y
    end

    return self.selectionStart.x ~= self.selectionEnd.x or self.selectionStart.y ~= self.selectionEnd.y
end

function BaseInput:animateLabelToTop()
    local padding = self.theme:getProperty('padding')[self.inputSize]

    if self.labelElement.position.y == self.labelElement.basePosition.y - 8 then
        return
    end

    Core.animate:doPulse(self.labelElement.id,
            { padding.fontSize, self.labelElement.basePosition.y, 0 },
            { padding.fontSize - 0.07, self.labelElement.basePosition.y - 8, 0 },
            self.theme:getProperty('hoverDuration'), 'Linear', function(fontSize, y)
                self.labelElement:setTextSize(fontSize)
                self.labelElement:setPosition(Vector2(self.labelElement.position.x, y))
            end)
end

function BaseInput:animateLabelToCenter()
    local padding = self.theme:getProperty('padding')[self.inputSize]

    if self.labelElement.position.y == self.labelElement.basePosition.y then
        return
    end

    Core.animate:doPulse(self.labelElement.id,
            { padding.fontSize - 0.07, self.labelElement.basePosition.y - 8, 0 },
            { padding.fontSize, self.labelElement.basePosition.y, 0 },
            self.theme:getProperty('hoverDuration'), 'Linear', function(fontSize, y)
                self.labelElement:setTextSize(fontSize)
                self.labelElement:setPosition(Vector2(self.labelElement.position.x, y))
            end)
end

function BaseInput:setIsEditing(state)
    self.isEditing = state
    guiSetInputEnabled(state)

    if self.labelElement then
        if state then
            self:animateLabelToTop()
        elseif self:isValueEmpty() then
            self:animateLabelToCenter()
        end
    end

    if not state then
        self.hoveringCursorPosition = nil
        self.selectionPressing = nil
        self.selectionStart = Vector2(0, 0)
        self.selectionEnd = Vector2(0, 0)
    else
        self:reRender()
    end

    self.caretElement:setRenderMode(state and Element.renderMode.Normal or Element.renderMode.Hidden)
end

function BaseInput:calculateSize()
    local padding = self.theme:getProperty('padding')[self.inputSize]
    local font = self.theme:getProperty('font')

    local textHeight = dxGetFontHeight(padding.fontSize, font)

    self.size = Vector2(self.size.x, textHeight + padding.y * 2)

    self.innerSize = Vector2(self.size.x - padding.x * 2, self.size.y - padding.y * 2)
    self.innerPosition = Vector2(self.position.x + padding.x, self.position.y + padding.y)

    local contentSize = Vector2(self.size.y - padding.y * 1.5, self.size.y - padding.y * 1.5)

    if self.label then
        textHeight = textHeight / 2
        self.innerSize.y = self.innerSize.y + textHeight / 2
        self.innerPosition.y = self.innerPosition.y + textHeight

        self.size.y = self.size.y + textHeight
    end

    if self.startContent then
        self.innerSize.x = self.innerSize.x - contentSize.x
        self.innerPosition.x = self.innerPosition.x + contentSize.x

        self.startContent:setSize(contentSize)
        self.startContent:setPosition(Vector2(
                self.position.x + padding.x / 2,
                self.position.y + self.size.y / 2 - contentSize.y / 2
        ))
        self.startContent:setRenderIndex(15)
        self.startContent:setColor(tocolor(255, 255, 255))

        self.startContent:setParent(self)
    end

    if self.endContent then
        self.innerSize.x = self.innerSize.x - contentSize.x

        self.endContent:setSize(contentSize)
        self.endContent:setPosition(Vector2(
                self.position.x + self.size.x - contentSize.x - padding.x / 2,
                self.position.y + self.size.y / 2 - contentSize.y / 2
        ))
        self.endContent:setRenderIndex(15)
        self.endContent:setColor(tocolor(255, 255, 255))

        self.endContent:setParent(self)
    end
end

function BaseInput:onCursorMoveInside(x, y)
    if x < self.innerPosition.x or x > self.innerPosition.x + self.innerSize.x then
        return
    end

    if y < self.innerPosition.y or y > self.innerPosition.y + self.innerSize.y then
        return
    end

    local font = self.theme:getProperty('font')
    local padding = self.theme:getProperty('padding')[self.inputSize]

    local cursorY = math.floor((y - self.innerPosition.y) / dxGetFontHeight(padding.fontSize, font)) + self.scroll.current
    local cursorX = 0

    local currentLine = self.value[cursorY] or ''

    local totalTextWidth = dxGetTextWidth(currentLine, padding.fontSize, font)

    for i = 1, utf8.len(currentLine) do
        local text = utf8.sub(currentLine, 1, i)
        local textWidth = dxGetTextWidth(text, padding.fontSize, font)

        if textWidth > x - self.innerPosition.x then
            cursorX = i - 1
            break
        end
    end

    if x >= self.innerPosition.x + totalTextWidth then
        cursorX = utf8.len(currentLine) + 1
    end

    if not self.multiline then
        cursorY = 1
    end

    self.hoveringCursorPosition = Vector2(cursorX, cursorY)

    if self.selectionPressing then
        if self.hoveringCursorPosition.x ~= self.selectionPressing.x or self.hoveringCursorPosition.y ~= self.selectionPressing.y then
            if self.selectionPressing.x > self.hoveringCursorPosition.x then
                self.selectionStart = Vector2(
                        self.hoveringCursorPosition.x,
                        self.hoveringCursorPosition.y
                )
                self.selectionEnd = Vector2(
                        self.selectionPressing.x,
                        self.selectionPressing.y
                )
            else
                self.selectionStart = Vector2(
                        self.selectionPressing.x,
                        self.selectionPressing.y
                )
                self.selectionEnd = Vector2(
                        self.hoveringCursorPosition.x,
                        self.hoveringCursorPosition.y
                )
            end

            self.cursorPosition = Vector2(self.hoveringCursorPosition.x, self.hoveringCursorPosition.y)
            self:reRender()
        end
    end
end

function BaseInput:onKey(button, pressOrRelease, callCount)
    if not self.isEditing then
        return
    end

    if not pressOrRelease then
        return
    end

    if not callCount then
        callCount = 0
    end

    local passThrough = false

    local ctrl = getKeyState('lctrl') or getKeyState('rctrl')

    if button == 'esc' then
        passThrough = true
    elseif button == 'arrow_l' then
        if self:hasSelection() then
            self.cursorPosition.x = self.selectionStart.x
            self.cursorPosition.y = math.min(self.selectionStart.y, self.selectionEnd.y)

            self.selectionStart = Vector2(0, 0)
            self.selectionEnd = Vector2(0, 0)

            passThrough = true
        else
            self.cursorPosition.x = self.cursorPosition.x - 1
            if self.cursorPosition.x < 0 then
                self.cursorPosition.x = 0

                if self.cursorPosition.y > 0 then
                    self.cursorPosition.y = math.max(1, self.cursorPosition.y - 1)
                    self.cursorPosition.x = utf8.len(self.value[self.cursorPosition.y])
                end
            end
        end

        self:reRender()
    elseif button == 'arrow_r' then
        if self:hasSelection() then
            self.cursorPosition.x = self.selectionEnd.x
            self.cursorPosition.y = math.max(self.selectionStart.y, self.selectionEnd.y)

            self.selectionStart = Vector2(0, 0)
            self.selectionEnd = Vector2(0, 0)

            passThrough = true
        else
            self.cursorPosition.x = self.cursorPosition.x + 1
            if self.cursorPosition.x > utf8.len(self.value[self.cursorPosition.y]) then
                self.cursorPosition.x = utf8.len(self.value[self.cursorPosition.y])

                if self.cursorPosition.y < #self.value then
                    self.cursorPosition.y = self.cursorPosition.y + 1
                    self.cursorPosition.x = 0
                end
            end
        end

        self:reRender()
    elseif button == 'arrow_u' then
        if not self.multiline then
            self.cursorPosition.x = 0
            self.cursorPosition.y = 1
            self:reRender()
        elseif self.cursorPosition.y ~= 1 then

            self.cursorPosition.y = math.max(0, self.cursorPosition.y - 1)
            self.cursorPosition.x = math.min(utf8.len(self.value[self.cursorPosition.y]), self.cursorPosition.x)

            if self.cursorPosition.y < self.scroll.current then
                self.scroll.current = self.scroll.current - 1
            end
        end

        self:reRender()
    elseif button == 'arrow_d' then
        if not self.multiline then
            self.cursorPosition.x = #self.value[1]
            self.cursorPosition.y = 1
            self:updateCaretPosition()
        else
            self.cursorPosition.y = math.min(#self.value, self.cursorPosition.y + 1)
            self.cursorPosition.x = math.min(utf8.len(self.value[self.cursorPosition.y]), self.cursorPosition.x)

            if self.cursorPosition.y > self.scroll.current + self.scroll.visibleMax then
                self.scroll.current = self.scroll.current + 1
            end
        end

        self:reRender()
    elseif button == 'backspace' then
        if self:hasSelection() then
            self.cursorPosition.x = self.selectionStart.x
            self.cursorPosition.y = math.min(self.selectionStart.y, self.selectionEnd.y)

            for i = self.selectionStart.y, self.selectionEnd.y do
                local line = self.value[i]
                if i == self.selectionEnd.y and line then
                    self.value[i] = utf8.sub(line, 1, self.selectionStart.x) .. utf8.sub(line, self.selectionEnd.x + 1)
                else
                    table.remove(self.value, i)
                end
            end

            if self.cursorPosition.y < self.scroll.current then
                self.scroll.current = self.cursorPosition.y
            end

            self.selectionStart = Vector2(0, 0)
            self.selectionEnd = Vector2(0, 0)

            passThrough = true
        else
            if self.cursorPosition.x == 0 then
                if self.cursorPosition.y == 1 then
                    return
                end

                local currentLine = self.value[self.cursorPosition.y]
                local previousLine = self.value[self.cursorPosition.y - 1]

                self.cursorPosition.x = utf8.len(previousLine)
                self.cursorPosition.y = self.cursorPosition.y - 1

                self.value[self.cursorPosition.y] = previousLine .. currentLine
                table.remove(self.value, self.cursorPosition.y + 1)
            else
                local currentLine = self.value[self.cursorPosition.y]
                self.value[self.cursorPosition.y] = utf8.sub(currentLine, 1, self.cursorPosition.x - 1) .. utf8.sub(currentLine, self.cursorPosition.x + 1)
                self.cursorPosition.x = self.cursorPosition.x - 1
            end
        end

        self:reRender()
    elseif ctrl and button == 'a' then
        self.selectionStart = Vector2(0, 1)
        self.selectionEnd = Vector2(utf8.len(self.value[#self.value]), #self.value)

        passThrough = true
        self:reRender()
    elseif ctrl and button == 'c' then
        local clipboard = ''

        if self:hasSelection() then
            for i = self.selectionStart.y, self.selectionEnd.y do
                local line = self.value[i]
                if i == self.selectionEnd.y then
                    clipboard = clipboard .. utf8.sub(line, self.selectionStart.x, self.selectionEnd.x)
                else
                    clipboard = clipboard .. line .. '\n'
                end
            end
        else
            clipboard = self.value[self.cursorPosition.y]
        end

        setClipboard(clipboard)

        passThrough = true
    elseif button == 'enter' or button == 'num_enter' then
        if not self.multiline then
            return
        end

        local currentLineText = self.value[self.cursorPosition.y]

        if self.cursorPosition.x < utf8.len(currentLineText) then
            local newLine = utf8.sub(currentLineText, self.cursorPosition.x + 1)
            self.value[self.cursorPosition.y] = utf8.sub(currentLineText, 1, self.cursorPosition.x)

            self.cursorPosition.y = self.cursorPosition.y + 1

            table.insert(self.value, self.cursorPosition.y, newLine)

            if self.cursorPosition.y > self.scroll.current + self.scroll.visibleMax then
                self.scroll.current = self.scroll.current + 1
            end

            self.cursorPosition.x = #self.value[self.cursorPosition.y]
        else
            self.cursorPosition.y = self.cursorPosition.y + 1
            self.cursorPosition.x = 0

            if not self.value[self.cursorPosition.y] then
                self.value[self.cursorPosition.y] = ''
            end

            if self.cursorPosition.y > self.scroll.current + self.scroll.visibleMax then
                self.scroll.current = self.scroll.current + 1
            end
        end

        passThrough = true
        self:reRender()
    end

    if not passThrough then
        local stickyMs = math.max(30, 150 - callCount * 20)

        Timer(function()
            local isPressing = getKeyState(button)
            if isPressing then
                callCount = callCount + 1
            end
            self:onKey(button, isPressing, callCount)
        end, stickyMs, 1)
    end
end

function BaseInput:onCharacter(character)
    if not self.isEditing then
        return
    end

    if character == '\127' then
        return
    end

    if self.regex then
        if not utf8.match(character, self.regex) then
            return
        end
    end

    if self.maxLength then
        if utf8.len(table.concat(self.value)) >= self.maxLength then
            return
        end
    end

    local font = self.theme:getProperty('font')
    local padding = self.theme:getProperty('padding')[self.inputSize]

    local currentLine = self.value[self.cursorPosition.y] or ''
    local currentLineTextWidth = dxGetTextWidth(currentLine, padding.fontSize, font)

    if self:hasSelection() then
        self.cursorPosition.x = self.selectionStart.x
        self.cursorPosition.y = math.min(self.selectionStart.y, self.selectionEnd.y)

        for i = self.selectionStart.y, self.selectionEnd.y do
            local line = self.value[i]
            if i == self.selectionEnd.y and line then
                self.value[i] = utf8.sub(line, 1, self.selectionStart.x) .. utf8.sub(line, self.selectionEnd.x + 1)
            else
                table.remove(self.value, i)
            end
        end

        currentLine = self.value[self.cursorPosition.y] or ''

        self.selectionStart = Vector2(0, 0)
        self.selectionEnd = Vector2(0, 0)

        self.value[self.cursorPosition.y] = utf8.sub(currentLine, 1, self.cursorPosition.x) .. character .. utf8.sub(currentLine, self.cursorPosition.x + 1)
        self.cursorPosition.x = self.cursorPosition.x + 1
    else
        self.value[self.cursorPosition.y] = utf8.sub(currentLine, 1, self.cursorPosition.x) .. character .. utf8.sub(currentLine, self.cursorPosition.x + 1)
        self.cursorPosition.x = self.cursorPosition.x + 1
    end

    if self.multiline then
        if currentLineTextWidth > self.innerSize.x - padding.x * 2 then
            self.cursorPosition.x = 0
            self.cursorPosition.y = self.cursorPosition.y + 1

            if self.cursorPosition.y > self.scroll.current + self.scroll.visibleMax then
                self.scroll.current = self.scroll.current + 1
            end
        end
    end

    self:reRender()
end

function BaseInput:onPressDown()
    self:setIsEditing(true)
    if not self.hoveringCursorPosition then
        return
    end

    self.selectionPressing = Vector2(
            self.hoveringCursorPosition.x,
            self.hoveringCursorPosition.y
    )
end

function BaseInput:onPressUp()
    if not self.isEditing then
        return
    end

    if not self.hoveringCursorPosition then
        self.selectionPressing = nil
        return
    end

    if self.hoveringCursorPosition.x == self.selectionPressing.x and self.hoveringCursorPosition.y == self.selectionPressing.y then
        self.selectionStart = Vector2(0, 0)
        self.selectionEnd = Vector2(0, 0)

        self.cursorPosition = Vector2(self.hoveringCursorPosition.x, self.hoveringCursorPosition.y)
        self:reRender()
    end

    self.selectionPressing = nil
end

function BaseInput:onClickOutside()
    if not self.isEditing then
        return
    end

    if self.selectionPressing then
        return
    end

    self:setIsEditing(false)
end

function BaseInput:setValue(value)
    self.value = value
end

function BaseInput:getCaretPosition()
    local font = self.theme:getProperty('font')
    local padding = self.theme:getProperty('padding')[self.inputSize]

    local value = self.value[self.cursorPosition.y] or ''
    if self.masked then
        value = string.rep('●', utf8.len(value))
    end

    local caretPosition = Vector2(
            self.innerPosition.x + dxGetTextWidth(utf8.sub(value, 1, self.cursorPosition.x), padding.fontSize, font),
            self.innerPosition.y + (self.cursorPosition.y - self.scroll.current) * dxGetFontHeight(padding.fontSize, font)
    )

    local caretSize = Vector2(1, dxGetFontHeight(padding.fontSize, font))

    return caretPosition, caretSize
end

function BaseInput:updateCaretPosition()
    local caretPosition, caretSize = self:getCaretPosition()

    self.caretElement:setPosition(caretPosition)
    self.caretElement:setSize(caretSize)
end

function BaseInput:createInputCaret()
    local caretPosition, caretSize = self:getCaretPosition()

    local caret = Rectangle:new(caretPosition, caretSize, 0)
    caret:setParent(self)
    caret:setColor(tocolor(255, 255, 255))
    caret:setRenderIndex(9)
    caret:setRenderMode(Element.renderMode.Hidden)

    self.caretElement = caret
end

function BaseInput:virtual_doPulse()
    self:removeChildrenExcept(ElementType.Icon)

    local font = self.theme:getProperty('font')
    local padding = self.theme:getProperty('padding')[self.inputSize]
    local palette = self.theme:getColor(self.color)

    local text = Text:new(
            self.innerPosition,
            self.innerSize,
            table.concat(self.value, '\n'),
            font,
            padding.fontSize,
            palette.Foreground.element,
            Text.alignment.LeftTop
    )
    text:setParent(self)
    text:setRenderIndex(10)

    if self.label then
        local label = Text:new(
                Vector2(
                        self.innerPosition.x,
                        self.position.y + self.size.y / 2 - dxGetFontHeight(padding.fontSize, font) / 2
                ),
                self.innerSize,
                self.label,
                font,
                padding.fontSize,
                palette.Foreground.element,
                Text.alignment.LeftTop
        )
        label:setParent(self)
        label:setRenderIndex(10)

        self.labelElement = label
        self.labelElement.basePosition = self.labelElement.position
    end

    if self.startContent then
        self.startContent:setColor(palette.Foreground.element)
    end

    if self.endContent then
        self.endContent:setColor(palette.Foreground.element)
    end

    self:createInputCaret(text)

    self.textElement = text
end

function BaseInput:reRender()
    local palette = self.theme:getColor(self.color)
    local values = {}

    for y, lineText in pairs(self.value) do
        values[#values + 1] = ''
        for x = 1, utf8.len(lineText) do
            local character = utf8.sub(lineText, x, x)
            if self.masked then
                character = '●'
            end

            if x == self.selectionStart.x + 1 and y == self.selectionStart.y then
                character = palette.BackgroundHover.original.hex .. character
            elseif x == self.selectionEnd.x + 1 and y == self.selectionEnd.y then
                character = palette.Foreground.original.hex .. character
            end

            values[#values] = values[#values] .. character
        end
    end

    local value = table.concat(values, '\n')

    self.textElement:setColorCoded(true)
    self.textElement:setText(value)
    self:updateCaretPosition()

    self:virtual_callEvent(Element.events.OnChange, value:gsub('#%x%x%x%x%x%x', ''))

    if self.isClearable and self.endContent then
        self.endContent:setRenderMode(self:isValueEmpty() and Element.renderMode.Hidden or Element.renderMode.Normal)
    end
end

function BaseInput:render()
    if not self.isEditing then
        return
    end

    if not self.caretElement then
        return
    end

    local progress = Core.animate.nowTick % 1000 / 1000 * 2
    if 1 < progress then
        progress = 2 - progress
    end

    self.caretAlpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, 'InOutQuad')
    self.caretElement:setColor(tocolor(255, 255, 255, self.caretAlpha))
end

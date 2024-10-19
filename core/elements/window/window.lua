Window = inherit(Element)

function Window:constructor(_, _, titlebarTitle)
    self.type = ElementType.Window
    self.theme = WindowTheme:new()

    self.titlebar = {
        title = titlebarTitle or '',
        visible = true,
        height = self.theme:getProperty('titlebarHeight')
    }

    self.localElements = {}

    self:doPulse()
end

function Window:doPulse()
    if #self.localElements > 0 then
        for i = 1, #self.localElements do
            self.localElements[i]:destroy()
        end
        self.localElements = {}
    end

    local position, size = self.position, self.size
    local padding = self.theme:getProperty('padding')

    if self.titlebar.visible then
        position, size = Vector2(self.position.x + padding, self.position.y + self.titlebar.height + padding),
        Vector2(self.size.x - (padding * 2), self.size.y - self.titlebar.height - (padding * 2))
    end

    self.content = {
        position = position,
        size = size
    }

    local borderRadius = self.theme:getProperty('borderRadius')

    local bg = Rectangle:new(self.position, self.size, borderRadius)
    bg:setColor(self.theme:getColor('background'))
    bg:setParent(self)
    table.insert(self.localElements, bg)

    if self.titlebar.visible then
        local line = Rectangle:new(Vector2(self.position.x, self.position.y + self.titlebar.height), Vector2(self.size.x, 1), 0)
        line:setColor(self.theme:getColor('line'))
        line:setParent(bg)
        table.insert(self.localElements, line)

        local titlebarText = Text:new(Vector2(self.position.x + padding, self.position.y),
                Vector2(self.size.x, self.titlebar.height),
                self.titlebar.title,
                Core.fonts.Regular.element,
                0.5,
                nil, Text.alignment.LeftCenter)
        titlebarText:setParent(bg)
        titlebarText:setColor(self.theme:getColor('foreground').element)
        table.insert(self.localElements, titlebarText)

        local iconSize = Vector2(self.titlebar.height / 1.4, self.titlebar.height / 1.4)

        local closeIcon = IconButton:new(
                Vector2(self.position.x + self.size.x - iconSize.x - padding, self.position.y + self.titlebar.height / 2 - iconSize.y / 2),
                nil,
                Icon:new(Vector2(0, 0), Vector2(30, 30), 'times', Icon.style.Light),
                Button.variants.Light,
                Element.color.Light,
                Element.size.Medium
        )
        closeIcon:setParent(bg)
        closeIcon:createEvent(Element.events.OnClick, bind(self.destroy, self))
        closeIcon:createEvent(Element.events.OnCursorEnter, bind(self.onCursorEnterCloseIcon, self))
        closeIcon:createEvent(Element.events.OnCursorLeave, bind(self.onCursorLeaveCloseIcon, self))

        table.insert(self.localElements, closeIcon)
    end
end

function Window:onCursorEnterCloseIcon()
    if not self.localElements[#self.localElements].iconElement then
        return
    end

    local textColor = self.theme:getColor('foreground')
    local hoverColor = self.theme:getColor('hover')

    Core.animate:doPulse(self.id,
            { textColor.original.r, textColor.original.g, textColor.original.b },
            { hoverColor.original.r, hoverColor.original.g, hoverColor.original.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                self.localElements[#self.localElements].iconElement:setColor(tocolor(r, g, b))
            end)
end

function Window:onCursorLeaveCloseIcon()
    if not self.localElements[#self.localElements].iconElement then
        return
    end

    local textColor = self.theme:getColor('foreground')
    local hoverColor = self.theme:getColor('hover')

    Core.animate:doPulse(self.id,
            { hoverColor.original.r, hoverColor.original.g, hoverColor.original.b },
            { textColor.original.r, textColor.original.g, textColor.original.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                self.localElements[#self.localElements].iconElement:setColor(tocolor(r, g, b))
            end)
end

function Window:setTitle(title)
    self.titlebar.title = title
end

function Window:setTitlebarVisible(visible)
    self.titlebar.visible = visible
    self:doPulse()
end

function Window:toCenter()
    self.position = Vector2(screenSize.x / 2 - self.size.x / 2, screenSize.y / 2 - self.size.y / 2)
    self:doPulse()
end

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

    local bg = Rectangle:new(self.position, self.size, 2)
    bg:setColor(self.theme:getColor('background'))
    bg:setParent(self)
    table.insert(self.localElements, bg)

    if self.titlebar.visible then
        local line = Rectangle:new(Vector2(self.position.x, self.position.y + self.titlebar.height), Vector2(self.size.x, 1), 0)
        line:setColor(self.theme:getColor('line'))
        line:setParent(bg)
        table.insert(self.localElements, line)

        local titlebarText = Text:new(Vector2(self.position.x + 10, self.position.y),
                Vector2(self.size.x, self.titlebar.height),
                self.titlebar.title,
                Core.fonts.Regular.element,
                0.48,
                nil, Text.alignment.LeftCenter)
        titlebarText:setParent(bg)
        titlebarText:setColor(self.theme:getColor('foreground'))
        table.insert(self.localElements, titlebarText)

        local iconSize = Vector2(self.titlebar.height / 1.4, self.titlebar.height / 1.4)
        local closeIcon = Icon:new(
                Vector2(self.position.x + self.size.x - iconSize.x - (self.titlebar.height - iconSize.y) / 2, self.position.y + self.titlebar.height / 2 - iconSize.y / 2),
                iconSize,
                'times', Icon.style.Solid)
        closeIcon:setColor(self.theme:getColor('foreground'))
        closeIcon:setParent(bg)
        closeIcon:createEvent(Element.events.OnClick, bind(self.destroy, self))
        table.insert(self.localElements, closeIcon)
    end
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

Workshop:registerElement(ElementType.Window, function(tabs, tab)
    local windowHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Window',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    windowHeader:setParent(tab)

    local window = Window:new(Vector2(tabs.content.position.x, tabs.content.position.y + 30), Vector2(400, 200), 'Hello, World!')
    window:setParent(tab)
end)

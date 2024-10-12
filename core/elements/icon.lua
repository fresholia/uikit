Icon = inherit(Element)
Icon.style = {
    Solid = 'solid',
    Brands = 'brands',
    Regular = 'regular',
    Light = 'light',
}

function Icon:constructor(_, size, name, style, force, borderColor, color)
    self.type = ElementType.Icon
    self.color = color or tocolor(255, 255, 255, 255)

    self.texture = Core.iconGen:getIcon(name, size.x, style, force, borderColor, color)
    self.isRotating = false
end

function Icon:setColor(color)
    self.color = color
end

function Icon:rotate(state)
    self.isRotating = state
end

function Icon:render()
    if not Core.iconGen.ticks[self.texture] then
        dxDrawRectangle(self.position.x, self.position.y, self.size.x, self.size.y, tocolor(0, 0, 0, 255), self.postGUI)
        return
    end

    local rotation = self.isRotating and getTickCount() % 360 or 0

    dxDrawImage(self.position.x, self.position.y, self.size.x, self.size.y,
            self.texture .. Core.iconGen.ticks[self.texture],
            rotation, 0, 0, self.color, self.postGUI)
end

Workshop:registerElement(ElementType.Icon, function(tabs, tab)
    local iconsHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Icons',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    iconsHeader:setParent(tab)

    local someIcons = {
        { name = 'home', style = Icon.style.Solid },
        { name = 'youtube', style = Icon.style.Brands },
        { name = 'home', style = Icon.style.Regular },
        { name = 'home', style = Icon.style.Light },

        { name = 'user', style = Icon.style.Solid },
        { name = 'discord', style = Icon.style.Brands },
        { name = 'user', style = Icon.style.Regular },
        { name = 'user', style = Icon.style.Light },

        { name = 'cog', style = Icon.style.Solid },
        { name = 'facebook', style = Icon.style.Brands },
        { name = 'cog', style = Icon.style.Regular },
        { name = 'cog', style = Icon.style.Light },

        { name = 'bell', style = Icon.style.Solid },
        { name = 'twitter', style = Icon.style.Brands },
        { name = 'bell', style = Icon.style.Regular },
        { name = 'bell', style = Icon.style.Light },

        { name = 'envelope', style = Icon.style.Solid },
        { name = 'instagram', style = Icon.style.Brands },
        { name = 'envelope', style = Icon.style.Regular },
        { name = 'envelope', style = Icon.style.Light },
    }

    local iconX = tabs.content.position.x

    for i = 1, #someIcons do
        local icon = Icon:new(
                Vector2(iconX, tabs.content.position.y + 30),
                Vector2(30, 30),
                someIcons[i].name,
                someIcons[i].style
        )
        icon:setParent(tab)

        iconX = iconX + icon.size.x + 10
    end
end)

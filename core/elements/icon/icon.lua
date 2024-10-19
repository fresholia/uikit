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

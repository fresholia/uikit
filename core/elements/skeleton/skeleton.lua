Skeleton = inherit(Element)

function Skeleton:new(...)
    return new(self, ...)
end

function Skeleton:constructor()
    self.type = ElementType.Skeleton
end

function Skeleton:render()
    local nowTick = Core.animate.nowTick
    local alpha = math.abs(math.sin(nowTick / 1000))

    dxDrawRectangle(self.position.x, self.position.y, self.size.x, self.size.y, tocolor(130, 130, 133, 10 + (20 * alpha)))
end

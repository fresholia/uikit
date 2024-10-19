Blur = inherit(Element)

function Blur:constructor(_, _, strength)
    self.type = ElementType.Blur
    self.strength = strength or 5
end

function Blur:render()
    exports.in_blur:dxDrawBlurSection(self.position.x, self.position.y, self.size.x, self.size.y, self.strength)
end
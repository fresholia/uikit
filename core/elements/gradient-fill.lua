GradientFill = inherit(Element)

function GradientFill:constructor(_, _, yOffset, color1, color2)
    self.yOffset = yOffset
    self.color1 = color1
    self.color2 = color2
end

function GradientFill:render()
    local x1, y1 = self.position.x, self.position.y
    local x2, y2 = self.size.x, self.size.y

    local totalHeight = self.yOffset - math.max(y1, y2)

    for py = math.max(y1, y2), self.yOffset do
        local progress = (py - math.max(y1, y2)) / totalHeight

        if not progress or progress < 0 or progress > 1 or progress ~= progress then
            break
        end

        local r, g, b = interpolateBetween(
                self.color1.r, self.color1.g, self.color1.b, self.color2.r, self.color2.g, self.color2.b, progress, 'Linear'
        )
        local alpha = interpolateBetween(130, 0, 0, 0, 0, 0, progress, 'Linear')

        dxDrawRectangle(x1, py, x2 - x1, 1, tocolor(r, g, b, alpha), self.postGUI)
    end
end

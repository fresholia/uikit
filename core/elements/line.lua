Line = inherit(Element)

function Line:constructor(_, endPosition, color, stroke, strokeDashArray)
    self.type = ElementType.Line

    self.endPosition = endPosition
    self.color = color or Element.color.Primary
    self.stroke = stroke or Line.stroke.Curve
    self.strokeDashArray = strokeDashArray or 2

end

function Line:render()
    dxDrawLine(
            self.position.x,
            self.position.y,
            self.endPosition.x,
            self.endPosition.y,
            self.color,
            self.stroke,
            self.postGUI
    )
end

Chart = inherit(Element)
Chart.variants = {
    Solid = 'solid',
    Transparent = 'transparent',
}

Chart.fill = {
    Solid = 'solid',
    Gradient = 'gradient',
}

Chart.stroke = {
    Curve = 'curve',
}

function Chart:constructor(_, _, color, variant, fill, stroke, series)
    self.type = ElementType.Chart

    self.theme = ChartTheme:new()

    self.color = color or Element.color.Primary
    self.variant = variant or Chart.variants.Solid

    self.fill = fill or Chart.fill.Solid
    self.stroke = stroke or Chart.stroke.Curve
    self.series = series or {}

    self.elements = {}
    self.elementPoints = {}
    self.curveSmoothness = 20

    self.isLoading = true

    self:doPulse()

    self:createEvent(Element.events.OnCursorEnter, bind(self.onCursorEnter, self))
    self:createEvent(Element.events.OnCursorLeave, bind(self.onCursorLeave, self))
end

function Chart:setIsLoading(isLoading)
    self.isLoading = isLoading
    self:doPulse()
end

function Chart:setSeries(series)
    self.series = series
    self.isLoading = false
    self:doPulse()
end

function Chart:getSeries()
    return self.series
end

function Chart:catMulRomSpline(t, p0, p1, p2, p3)
    local t2 = t * t
    local t3 = t2 * t

    local a = (-t3 + 2 * t2 - t) / 2
    local b = (3 * t3 - 5 * t2 + 2) / 2
    local c = (-3 * t3 + 4 * t2 + t) / 2
    local d = (t3 - t2) / 2

    return a * p0 + b * p1 + c * p2 + d * p3
end

function Chart:findPeaks(rt, normalizedData, data)
    local peaks = {}
    for i = 1, #normalizedData do
        local prevY = normalizedData[i - 1] or 0
        local currentY = normalizedData[i]

        local nextY = normalizedData[i + 1] or 0

        if prevY and currentY and nextY then
            if currentY > prevY and currentY > nextY then
                peaks[i] = {
                    x = (i - 1) * rt.size.x / #normalizedData,
                    y = currentY,
                    value = data[i]
                }
            end
        end
    end

    for i = 1, #data do
        if not peaks[i] then
            local x = (i - 1) * rt.size.x / #data
            local y = normalizedData[i]

            peaks[i] = {
                x = x,
                y = y,
                value = data[i]
            }
        end
    end

    return peaks
end

function Chart:calculateYAxisValues(data, minVal, maxVal)
    local stepValues = {}
    local step = (maxVal - minVal) / 5

    for i = 1, 6 do
        stepValues[i] = math.floor(minVal + (i - 1) * step)
    end

    return stepValues
end

function Chart:createChartTexture()
    local palette = self.theme:getColor(self.color)
    local chartPadding = self.theme:getProperty('chartPadding')
    local innerPadding = self.theme:getProperty('innerPadding')

    local rt = RenderTexture:new(
            Vector2(
                    self.position.x + chartPadding.x,
                    self.position.y + chartPadding.y
            ),
            Vector2(
                    self.size.x - chartPadding.x - innerPadding,
                    self.size.y - chartPadding.y * 2
            )
    )
    rt:setUID(self.type .. md5(toJSON(self.series) .. self.variant .. self.color))

    rt:setAsTarget()

    if self.variant == Chart.variants.Transparent then
        rt:setSize(self.size)
        rt:setPosition(self.position)
    end

    local peakPoints = {}
    local stepValues = {}

    for i = 1, #self.series do
        local serie = self.series[i]
        if serie then
            local minVal = math.min(unpack(serie.data))
            local maxVal = math.max(unpack(serie.data))
            local customPalette = serie.color and self.theme:getColor(serie.color) or palette

            local step = rt.size.x / #serie.data
            local stepY = rt.size.y / (maxVal - minVal)

            stepValues = self:calculateYAxisValues(serie.data, minVal, maxVal)

            if self.stroke == Chart.stroke.Curve then
                local normalizedData = {}
                for i = 1, #serie.data do
                    normalizedData[i] = rt.size.y - ((serie.data[i] - minVal) / (maxVal - minVal)) * rt.size.y
                end

                for i = 1, #normalizedData do
                    for t = 0, 1, 1 / self.curveSmoothness do
                        local prevX = clamp(self:catMulRomSpline(t - (1 / self.curveSmoothness),
                                (i - 2) * rt.size.x / #normalizedData,
                                (i - 1) * rt.size.x / #normalizedData,
                                i * rt.size.x / #normalizedData,
                                (i + 1) * rt.size.x / #normalizedData), 0, rt.size.x)

                        local prevY = clamp(self:catMulRomSpline(t - (1 / self.curveSmoothness),
                                normalizedData[i - 1] or 0,
                                normalizedData[i],
                                normalizedData[i + 1] or 0,
                                normalizedData[i + 2] or 0), 0, rt.size.y)

                        local nextX = clamp(self:catMulRomSpline(t,
                                (i - 2) * rt.size.x / #normalizedData,
                                (i - 1) * rt.size.x / #normalizedData,
                                i * rt.size.x / #normalizedData,
                                (i + 1) * rt.size.x / #normalizedData), 0, rt.size.x)

                        local nextY = clamp(self:catMulRomSpline(t,
                                normalizedData[i - 1] or 0,
                                normalizedData[i],
                                normalizedData[i + 1] or 0,
                                normalizedData[i + 2] or 0), 0, rt.size.y)

                        if not rt.isExists then
                            if nextX and nextY then
                                local line = Line:new(Vector2(prevX, prevY),
                                        Vector2(nextX, nextY), customPalette.Foreground.element, 2)
                                line:setParent(rt)
                            end

                            if self.fill == Chart.fill.Gradient then
                                local gradientFillRect = GradientFill:new(
                                        Vector2(prevX, prevY),
                                        Vector2(nextX, nextY),
                                        self.position.y + rt.size.y,
                                        customPalette.GradientStart.original,
                                        customPalette.GradientEnd.original
                                )
                                gradientFillRect:setParent(rt)
                            end
                        end
                    end
                end

                peakPoints = self:findPeaks(rt, normalizedData, serie.data)
            else
                for j = 1, #serie.data - 1 do
                    local x = (j - 1) * step
                    local y = rt.size.y - (serie.data[j] - minVal) * stepY

                    local nextX = j * step
                    local nextY = rt.size.y - (serie.data[j + 1] - minVal) * stepY

                    if nextX and nextY and not rt.isExists then
                        local line = Line:new(Vector2(x, y), Vector2(nextX, nextY), customPalette.Foreground.element, 2)
                        line:setParent(rt)
                    end
                end
            end
        end
    end

    rt:resetAsTarget()
    rt:createTexture()

    return rt, peakPoints, stepValues
end

function Chart:onCursorEnter()
    if self.isLoading then
        return
    end

    createNativeEvent(ClientEventNames.onClientCursorMove, root, bind(self.onCursorMove, self))
end

function Chart:onCursorLeave()
    if self.isLoading then
        return
    end

    removeNativeEvent(ClientEventNames.onClientCursorMove, root, bind(self.onCursorMove, self))

    self.elements.line:setRenderMode(Element.renderMode.Hidden)
    self.elements.point:setRenderMode(Element.renderMode.Hidden)
end

function Chart:animateToChartLine(index)
    local point = self.elementPoints[index]
    if not point then
        return
    end

    local lineRect = self.elements.line
    local pointRect = self.elements.point

    self.elements.tooltip:setText(tostring(point.value))

    if not lineRect.renderMode ~= Element.renderMode.Normal then
        lineRect:setRenderMode(Element.renderMode.Normal)
    end

    if not pointRect.renderMode ~= Element.renderMode.Normal then
        pointRect:setRenderMode(Element.renderMode.Normal)
    end

    if lineRect.position.x == 0 then
        lineRect:setPosition(Vector2(point.linePosition.x, point.linePosition.y))
    else
        Core.animate:doPulse(lineRect.id,
                { lineRect.position.x, lineRect.position.y, 0 },
                { point.linePosition.x, point.linePosition.y, 0 },
                150, 'Linear', function(x, y)
                    lineRect:setPosition(Vector2(x, y))
                end)
    end

    if pointRect.position.x == 0 then
        pointRect:setPosition(Vector2(point.pointPosition.x, point.pointPosition.y))
    else
        Core.animate:doPulse(pointRect.id,
                { pointRect.position.x, pointRect.position.y, 0 },
                { point.pointPosition.x - (pointRect.size.x / 2), point.pointPosition.y - (pointRect.size.y / 2), 0 },
                150, 'Linear', function(x, y)
                    pointRect:setPosition(Vector2(x, y))
                end)
    end
end

function Chart:onCursorMove(_, _, cursorX, cursorY)
    if not self.isHovered then
        return
    end

    for i = 1, #self.elementPoints do
        local element = self.elementPoints[i]
        local futureElement = self.elementPoints[i + 1]

        local withinArea

        if futureElement then
            withinArea = cursorX >= element.pointPosition.x - (self.elements.point.size.x * 2) and cursorX < futureElement.pointPosition.x
        else
            withinArea = cursorX >= element.pointPosition.x - (self.elements.point.size.x * 2) and cursorX <= self.position.x + self.size.x
        end

        if withinArea and not visibleAny then
            self:animateToChartLine(i)
        end
    end
end

function Chart:doPulse()
    self:removeChildren()

    local palette = self.theme:getColor(self.color)
    local borderRadius = self.theme:getProperty('borderRadius')
    local innerPadding = self.theme:getProperty('innerPadding')
    local font = self.theme:getProperty('font')
    local fontScale = self.theme:getProperty('fontScale')

    local bgRect = Rectangle:new(self.position, self.size, borderRadius)
    bgRect:setParent(self)
    bgRect:setColor(palette.Background.element)

    if self.isLoading then
        local spinnerIcon = Icon:new(Vector2(bgRect.position.x + bgRect.size.x / 2 - 50, bgRect.position.y + bgRect.size.y / 2 - 50),
                Vector2(100, 100), 'spinner-third', Icon.style.Solid)
        spinnerIcon:setParent(bgRect)
        spinnerIcon:setColor(palette.Foreground.element)
        spinnerIcon:rotate(true)
        return
    end

    local chart, peakPoints, stepValues = self:createChartTexture()
    chart:setParent(bgRect)

    self.elementPoints = {}

    local verticalRect = Rectangle:new(
            Vector2(0, 0),
            Vector2(1, chart.size.y),
            0
    )

    verticalRect:setColor(palette.GradientEnd.element)
    verticalRect:setParent(bgRect)
    verticalRect:setRenderIndex(100)
    verticalRect:setPostGUI(true)
    verticalRect:setRenderMode(Element.renderMode.Hidden)

    self.elements.line = verticalRect

    local pointRect = Rectangle:new(
            Vector2(0, 0),
            Vector2(8, 8),
            3
    )
    pointRect:setColor(palette.GradientEnd.element)
    pointRect:setParent(bgRect)
    pointRect:setRenderIndex(100)
    pointRect:setPostGUI(true)
    pointRect:setRenderMode(Element.renderMode.Hidden)

    local tooltip = Tooltip:new(pointRect, 'This is a tooltip!', Element.size.Medium, Tooltip.placement.Right)

    self.elements.tooltip = tooltip
    self.elements.point = pointRect

    for i = 1, #peakPoints do
        local point = peakPoints[i]
        if point then
            self.elementPoints[i] = {
                pointPosition = Vector2(chart.position.x + point.x, chart.position.y + point.y),
                linePosition = Vector2(chart.position.x + point.x, chart.position.y),

                value = point.value
            }

            self.elementPoints[i].pointPosition.y = math.min(self.elementPoints[i].pointPosition.y, chart.position.y + chart.size.y)
            self.elementPoints[i].pointPosition.y = math.max(self.elementPoints[i].pointPosition.y, chart.position.y)
        end
    end

    for i = 1, #stepValues do
        local step = stepValues[i]
        if step then
            local stepY = chart.position.y + chart.size.y - (i - 1) * chart.size.y / 5

            if i == 1 then
                stepY = chart.position.y + chart.size.y - 10
            end

            local text = Text:new(
                    Vector2(self.position.x + innerPadding,
                            stepY),
                    Vector2(10, 0),
                    tostring(step),
                    font,
                    fontScale,
                    palette.LineText.element,
                    Text.alignment.RightTop
            )
            text:setParent(bgRect)

            local line = Line:new(
                    Vector2(chart.position.x, stepY),
                    Vector2(chart.position.x + chart.size.x, stepY),
                    palette.Line.element,
                    1
            )
            line:setParent(bgRect)
        end
    end
end

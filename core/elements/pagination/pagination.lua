Pagination = inherit(Element)

function Pagination:constructor(_, _, color, buttonSize, total, current, boundaries, siblings, withArrows)
    self.type = ElementType.Pagination

    self.theme = PaginationTheme:new()

    self.color = color or Element.color.Primary
    self.buttonSize = buttonSize or Element.size.Medium
    self.total = total
    self.current = current
    self.boundaries = boundaries or 2
    self.siblings = siblings or 2
    self.withArrows = withArrows

    self.dots = { '...' }

    self:createEvent(Element.events.OnClick, bind(self.onClick, self))
    self:doPulse()
end

function Pagination:setTotal(total)
    self.total = total
    self:doPulse()
end

function Pagination:range(startNumber, endNumber)
    local length = endNumber - startNumber + 1
    local result = {}

    for i = 1, length do
        result[i] = startNumber + i - 1
    end

    return result
end

function Pagination:merge(...)
    local result = {}
    local resultIndex = 1

    for _, array in ipairs({ ... }) do
        for _, value in ipairs(array) do
            result[resultIndex] = value
            resultIndex = resultIndex + 1
        end
    end

    return result
end

function Pagination:calculatePagination()
    local total, current, boundaries, siblings = self.total, self.current, self.boundaries, self.siblings

    local totalPageNumbers = siblings * 2 + 3 + boundaries * 2
    if totalPageNumbers >= total then
        return self:range(1, total)
    end

    local leftSiblingIndex = math.max(current - siblings, boundaries)
    local rightSiblingIndex = math.min(current + siblings, total - boundaries)

    local shouldShowLeftDots = leftSiblingIndex > boundaries + 2
    local shouldShowRightDots = rightSiblingIndex < total - boundaries - 1

    if not shouldShowLeftDots and shouldShowRightDots then
        local leftItemCount = siblings * 2 + boundaries + 2

        return self:merge(
                self:range(1, leftItemCount),
                self.dots,
                self:range(total - (boundaries - 1), total)
        )
    end

    if shouldShowLeftDots and not shouldShowRightDots then
        local rightItemCount = boundaries + 1 + 2 * siblings

        return self:merge(
                self:range(1, boundaries),
                self.dots,
                self:range(total - rightItemCount, total)
        )
    end

    return self:merge(
            self:range(1, boundaries),
            self.dots,
            self:range(leftSiblingIndex, rightSiblingIndex),
            self.dots,
            self:range(total - boundaries + 1, total)
    )
end

function Pagination:onClick()
    for i = 1, #self.buttonPositions do
        local button = self.buttonPositions[i]

        if Core:inArea(button.position, button.size) then
            self:onSwitch(button.pageNumber)
            break
        end
    end
end

function Pagination:onSwitch(pageNumber)
    if not tonumber(pageNumber) then
        return
    end

    pageNumber = clamp(tonumber(pageNumber), 1, self.total)

    if pageNumber == self.current then
        return
    end

    self:virtual_callEvent(Element.events.OnChange, pageNumber)
    self.current = pageNumber
    self:doPulse()
end

function Pagination:doPulse()
    self:removeChildren()

    local paginationData = self:calculatePagination()
    local padding = self.theme:getProperty('padding')[self.buttonSize]
    local borderRadius = self.theme:getProperty('borderRadius')
    local font = self.theme:getProperty('font')
    local color = self.theme:getColor(self.color)

    local buttonSize = Vector2(padding.x * 2, padding.x * 2)
    local buttonPosition = Vector2(self.position.x + self.size.x / 2 - (#paginationData * buttonSize.x) / 2 - (#paginationData * padding.x / 2),
            self.position.y)

    self.buttonPositions = {}

    for i = 1, #paginationData do
        local pageNumber = paginationData[i]

        local bgRect = Rectangle:new(buttonPosition, buttonSize, borderRadius, color.Background.element)
        bgRect:setParent(self)
        bgRect:setColor(self.current == pageNumber and color.Background.element or color.BackgroundActive.element)

        local text = Text:new(buttonPosition, buttonSize, tostring(pageNumber), font, padding.fontSize, color.Foreground.element, Text.alignment.Center)
        text:setParent(bgRect)

        self.buttonPositions[i] = {
            position = buttonPosition,
            size = buttonSize,
            pageNumber = pageNumber
        }

        buttonPosition = Vector2(buttonPosition.x + buttonSize.x + padding.x / 2, buttonPosition.y)
    end
end

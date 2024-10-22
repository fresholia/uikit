ScrollableList = inherit(Element)
ScrollableList.selectMode = {
    Single = 'Single',
    Multiple = 'Multiple',
}

function ScrollableList:constructor(_, _, items)
    self.type = ElementType.ScrollableList

    self.theme = ScrollableListTheme:new()

    self.rowHeight = self.theme:getProperty('rowHeight')
    self.items = items

    self.isSelectable = true
    self.selectMode = ScrollableList.selectMode.Single

    self.selections = {}

    local innerPadding = self.theme:getProperty('innerPadding')
    self.innerSize = Vector2(self.size.x - innerPadding.x * 2, self.size.y - innerPadding.y * 2)
    self.innerPosition = Vector2(self.position.x + innerPadding.x, self.position.y + innerPadding.y)

    self:doCalculateScroll()

    self:doPulse()

    self:createEvent(Element.events.OnKey, bind(self.onKey, self))
end

function ScrollableList:setIsSelectable(isSelectable)
    assert(type(isSelectable) == 'boolean', 'Invalid isSelectable type for ScrollableList')

    self.isSelectable = isSelectable
end

function ScrollableList:setSelectMode(selectMode)
    assert(ScrollableList.selectMode[selectMode], 'Invalid select mode for ScrollableList')

    self.selectMode = selectMode
end

function ScrollableList:onKey(button, state)
    if button == 'mouse_wheel_up' then
        self.scrollCurrent = math.max(1, self.scrollCurrent - 1)
        self:doPulse()
    elseif button == 'mouse_wheel_down' then
        self.scrollCurrent = math.min(self.scrollMax, self.scrollCurrent + 1)
        self:doPulse()
    end
end

function ScrollableList:doCalculateScroll()
    local rowPadding = self.theme:getProperty('rowPadding')

    self.scrollCurrent = 1
    self.maxVisibleItems = math.floor(self.innerSize.y / (self.rowHeight + rowPadding)) - 1

    self.scrollMax = math.max(0, #self.items - self.maxVisibleItems)
end

function ScrollableList:setRowHeight(rowHeight)
    self.rowHeight = rowHeight
    self:doCalculateScroll()
    self:doPulse()
end

function ScrollableList:setItems(items)
    self.items = items
    self:doCalculateScroll()
    self:doPulse()
end

function ScrollableList:onCursorEnterRow(row)
    if self:isDisabled() then
        return
    end

    local bgColor = self.theme:getColor('rowBackground').original
    local hoverColor = self.theme:getColor('rowBackgroundHover').original

    Core.animate:doPulse(row.id,
            { bgColor.r, bgColor.g, bgColor.b },
            { hoverColor.r, hoverColor.g, hoverColor.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                row:setColor(tocolor(r, g, b))
            end)
end

function ScrollableList:onCursorLeaveRow(row)
    if self:isDisabled() then
        return
    end

    local bgColor = self.theme:getColor('rowBackground').original
    local hoverColor = self.theme:getColor('rowBackgroundHover').original

    Core.animate:doPulse(row.id,
            { hoverColor.r, hoverColor.g, hoverColor.b },
            { bgColor.r, bgColor.g, bgColor.b },
            self.theme:getProperty('hoverDuration'), 'Linear', function(r, g, b)
                row:setColor(tocolor(r, g, b))
            end)
end

function ScrollableList:onRowClick(i)
    if self:isDisabled() then
        return
    end

    local item = self.items[i]
    if not item then
        return
    end

    if self.selectMode == ScrollableList.selectMode.Single and not self.selections[item.key] then
        self.selections = {}
    end

    if self.selections[item.key] then
        self.selections[item.key] = nil
    else
        self.selections[item.key] = true
    end

    for i = self.scrollCurrent, self.scrollCurrent + self.maxVisibleItems do
        local item = self.items[i]
        if not item then
            break
        end

        item.checkIcon:setRenderMode(self.selections[item.key] and Element.renderMode.Normal or Element.renderMode.Hidden)
    end

    self:virtual_callEvent(Element.events.OnChange, self.selections)
end

function ScrollableList:doPulse()
    self:removeChildren()

    local borderRadius = self.theme:getProperty('borderRadius')
    local backgroundColor = self.theme:getColor('background')
    local rowBackgroundColor = self.theme:getColor('rowBackground')
    local rowBackgroundHoverColor = self.theme:getColor('rowBackgroundHover')
    local foregroundColor = self.theme:getColor('foreground')

    local scrollBarBackgroundColor = self.theme:getColor('scrollbarBackground')
    local scrollBarColor = self.theme:getColor('scrollbarForeground')

    local rowPadding = self.theme:getProperty('rowPadding')

    local hasScroll = #self.items > self.maxVisibleItems

    local bgRect = Rectangle:new(self.position, self.size, borderRadius)
    bgRect:setParent(self)
    bgRect:setColor(backgroundColor.element)

    local rowSize = Vector2(self.innerSize.x, self.rowHeight)

    if hasScroll then
        rowSize.x = rowSize.x - Padding.Medium
    end

    for i = self.scrollCurrent, self.scrollCurrent + self.maxVisibleItems do
        local item = self.items[i]
        if not item then
            break
        end

        local rowPosition = Vector2(self.innerPosition.x, self.innerPosition.y + (i - self.scrollCurrent) * (self.rowHeight + rowPadding))

        local row = Rectangle:new(rowPosition, rowSize, self.theme:getProperty('rowBorderRadius'))
        row:setParent(self)
        row:setColor(rowBackgroundColor.element)
        row:createEvent(Element.events.OnCursorEnter, bind(self.onCursorEnterRow, self, row))
        row:createEvent(Element.events.OnCursorLeave, bind(self.onCursorLeaveRow, self, row))
        row:createEvent(Element.events.OnClick, bind(self.onRowClick, self, i))

        local text = Text:new(Vector2(rowPosition.x + Padding.Medium, rowPosition.y), rowSize, tostring(item.value), Core.fonts.Regular.element, 0.48, foregroundColor.element, Text.alignment.LeftCenter)
        text:setParent(row)

        local checkIcon = Icon:new(Vector2(rowPosition.x + rowSize.x - (rowSize.y / 2) - Padding.Medium / 2,
                rowPosition.y + rowSize.y / 2 - (rowSize.y / 2) / 2
        ),
                Vector2(rowSize.y / 2, rowSize.y / 2), 'check', Icon.style.Light)
        checkIcon:setParent(row)
        checkIcon:setColor(foregroundColor.element)
        checkIcon:setRenderMode(self.selections[item.key] and Element.renderMode.Normal or Element.renderMode.Hidden)
        item.checkIcon = checkIcon
    end

    if not hasScroll then
        return
    end

    local scrollBarBackground = Rectangle:new(Vector2(self.innerPosition.x + self.innerSize.x - Padding.XSmall, self.innerPosition.y), Vector2(Padding.XSmall, self.innerSize.y), 0)
    scrollBarBackground:setParent(self)
    scrollBarBackground:setColor(scrollBarBackgroundColor.element)

    local scrollBarHeight = self.innerSize.y * ((self.maxVisibleItems + 1) / #self.items)
    local scrollBarPosition = Vector2(scrollBarBackground.position.x,
            (self.scrollCurrent - 1) / (#self.items - (self.maxVisibleItems + 1)) * (self.innerSize.y - scrollBarHeight) + self.innerPosition.y)

    local scrollBar = Rectangle:new(scrollBarPosition, Vector2(Padding.XSmall, scrollBarHeight), 0)
    scrollBar:setParent(self)
    scrollBar:setColor(scrollBarColor.element)
end
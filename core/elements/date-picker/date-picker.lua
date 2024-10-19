DatePicker = inherit(Element)
DatePicker.placement = {
    Top = 'top',
    Bottom = 'bottom',
    Right = 'right',
    Left = 'left',
    TopStart = 'top-start',
    TopEnd = 'top-end',
    BottomStart = 'bottom-start',
    BottomEnd = 'bottom-end',
    LeftStart = 'left-start',
    LeftEnd = 'left-end',
    RightStart = 'right-start',
    RightEnd = 'right-end',
}

function DatePicker:new(...)
    return new(self, ...)
end

function DatePicker:constructor(parent, placement)
    if not parent then
        error('Parent element is required for DatePicker.')
    end

    self.type = ElementType.DatePicker

    self.theme = DatePickerTheme:new()

    self.placement = placement or DatePicker.placement.Right
    self.size = Vector2(220, 240)
    self.position = self:getPosition()

    self.currentDate = os.date('*t')
    self.daysOfWeek = { 'Pzt', 'Sal', 'Çrş', 'Prş', 'Cum', 'Cmt', 'Paz' }
    self.monthsTranslations = {
        January = 'Ocak',
        February = 'Şubat',
        March = 'Mart',
        April = 'Nisan',
        May = 'Mayıs',
        June = 'Haziran',
        July = 'Temmuz',
        August = 'Ağustos',
        September = 'Eylül',
        October = 'Ekim',
        November = 'Kasım',
        December = 'Aralık'
    }

    self.isRendering = false

    self:setParent(parent)

    parent:createEvent(Element.events.OnClick, bind(self.onOpen, self))
    parent:createEvent(Element.events.OnClickOutside, bind(self.onHide, self))
end

function DatePicker:onOpen()
    self.position = self:getPosition()
    self.isRendering = not self.isRendering
    self:doPulse()
end

function DatePicker:onHide()
    if self.isHovered then
        return
    end

    self.isRendering = false
    self:removeChildren()
end

function DatePicker:getPosition()
    local gap = self.theme:getProperty('gap')

    local parentElement = Core:hasElement(self.parent)
    if not parentElement then
        return false
    end

    if self.placement == DatePicker.placement.Top then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == DatePicker.placement.Bottom then
        return Vector2(
                parentElement.position.x + parentElement.size.x / 2 - self.size.x / 2,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == DatePicker.placement.Right then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == DatePicker.placement.Left then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y / 2 - self.size.y / 2
        )
    elseif self.placement == DatePicker.placement.TopStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == DatePicker.placement.TopEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y - self.size.y - gap
        )
    elseif self.placement == DatePicker.placement.BottomStart then
        return Vector2(
                parentElement.position.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == DatePicker.placement.BottomEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x - self.size.x,
                parentElement.position.y + parentElement.size.y + gap
        )
    elseif self.placement == DatePicker.placement.LeftStart then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y
        )
    elseif self.placement == DatePicker.placement.LeftEnd then
        return Vector2(
                parentElement.position.x - self.size.x - gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    elseif self.placement == DatePicker.placement.RightStart then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y
        )
    elseif self.placement == DatePicker.placement.RightEnd then
        return Vector2(
                parentElement.position.x + parentElement.size.x + gap,
                parentElement.position.y + parentElement.size.y - self.size.y
        )
    end
end

function DatePicker:generateCalendar()
    local firstDay = os.time({ year = self.currentDate.year, month = self.currentDate.month, day = 1 })
    local firstDayDate = os.date("*t", firstDay)
    local totalDays = os.date("*t", os.time({ year = self.currentDate.year, month = self.currentDate.month + 1, day = 0 })).day

    local function adjustWeekday(weekday)
        return (weekday == 1) and 7 or (weekday - 1)
    end

    local beforeMonthDaysInThisWeek = adjustWeekday(firstDayDate.wday) - 1
    local lastDayWday = adjustWeekday(os.date("*t", os.time({ year = self.currentDate.year, month = self.currentDate.month, day = totalDays })).wday)
    local afterMonthDaysLastWeek = 7 - lastDayWday

    local days = {}

    for i = 1, beforeMonthDaysInThisWeek do
        local prevMonthLastDay = os.date("*t", os.time({ year = self.currentDate.year, month = self.currentDate.month, day = 0 })).day
        table.insert(days, { day = prevMonthLastDay - beforeMonthDaysInThisWeek + i, month = self.currentDate.month - 1, year = self.currentDate.year })
    end

    for i = 1, totalDays do
        table.insert(days, { day = i, month = self.currentDate.month, year = self.currentDate.year, isCurrent = true })
    end

    for i = 1, afterMonthDaysLastWeek do
        table.insert(days, { day = i, month = self.currentDate.month + 1, year = self.currentDate.year })
    end

    return days
end

function DatePicker:getCurrentMonthLabel()
    local month = string.format('%s', os.date('%B', os.time({ year = self.currentDate.year, month = self.currentDate.month, day = 1 })))

    return self.monthsTranslations[month] or month
end

function DatePicker:onDayCursorEnter()

end

function DatePicker:onDayCursorLeave()

end

function DatePicker:onDayClick(dayRect, day)
    self.selectedDate = day
    self.isRendering = false
    self:removeChildren()

    self:virtual_callEvent(Element.events.OnChange, day)
end

function DatePicker:isSelected(date)
    if not self.selectedDate then
        return false
    end

    return self.selectedDate.day == date.day and self.selectedDate.month == date.month and self.selectedDate.year == date.year
end

function DatePicker:doPulse()
    self:removeChildren()

    if not self.isRendering then
        return
    end

    local borderRadius = self.theme:getProperty('borderRadius')
    local padding = self.theme:getProperty('padding')

    local cardBackground = self.theme:getColor('background')
    local cardBackgroundHeader = self.theme:getColor('backgroundHeader')
    local foregroundColor = self.theme:getColor('foreground')
    local foregroundHeaderColor = self.theme:getColor('foregroundHeader')
    local foregroundActiveColor = self.theme:getColor('foregroundActive')
    local primaryColor = self.theme:getColor('primaryColor')

    local rect = Rectangle:new(self.position, self.size, borderRadius, cardBackground.element)
    rect:setParent(self)

    local calendar = self:generateCalendar()

    local headerPosition = Vector2(self.position.x, self.position.y)
    local headerSize = Vector2(self.size.x, 50)

    local headerRect = Rectangle:new(headerPosition, headerSize, { tl = borderRadius, tr = borderRadius, bl = 0, br = 0 }, cardBackgroundHeader.element)
    headerRect:setParent(self)

    local monthText = Text:new(Vector2(headerPosition.x, headerPosition.y + padding.y / 2), headerSize, self:getCurrentMonthLabel() .. ' ' .. self.currentDate.year, Core.fonts.Regular.element, 0.5, foregroundColor.element, Text.alignment.CenterTop)
    monthText:setParent(headerRect)
    monthText:setColor(foregroundHeaderColor.element)

    local beforeMonthButton = IconButton:new(
            Vector2(headerPosition.x + padding.x, headerPosition.y + padding.y / 3),
            Vector2(30, 30),
            Icon:new(Vector2(0, 0), Vector2(24, 24), 'chevron-left', Icon.style.Solid),
            Button.variants.Light,
            Element.color.Primary,
            Element.size.Small
    )
    beforeMonthButton:setParent(headerRect)

    beforeMonthButton:createEvent(Element.events.OnClick, function()
        self.currentDate.month = self.currentDate.month - 1

        if self.currentDate.month == 0 then
            self.currentDate.year = self.currentDate.year - 1
            self.currentDate.month = 12
        end

        self:doPulse()
    end)

    local afterMonthButton = IconButton:new(
            Vector2(headerPosition.x + headerSize.x - padding.x - 24, headerPosition.y + padding.y / 3),
            Vector2(30, 30),
            Icon:new(Vector2(0, 0), Vector2(24, 24), 'chevron-right', Icon.style.Solid),
            Button.variants.Light,
            Element.color.Primary,
            Element.size.Small
    )
    afterMonthButton:setParent(headerRect)

    afterMonthButton:createEvent(Element.events.OnClick, function()
        self.currentDate.month = self.currentDate.month + 1

        if self.currentDate.month == 13 then
            self.currentDate.year = self.currentDate.year + 1
            self.currentDate.month = 1
        end

        self:doPulse()
    end)

    local calendarSize = Vector2(
            self.size.x - padding.x * 2,
            self.size.y - headerSize.y - padding.y * 2
    )

    local calendarPosition = Vector2(self.position.x + padding.x, self.position.y + headerSize.y + padding.y)

    for i = 1, #self.daysOfWeek do
        local day = self.daysOfWeek[i]

        local dayPosition = Vector2(calendarPosition.x + ((i - 1) % 7) * (calendarSize.x / 7), headerPosition.y)
        local daySize = Vector2(calendarSize.x / 7, headerSize.y - padding.y / 2)

        local dayText = Text:new(dayPosition, daySize, day, Core.fonts.Regular.element, 0.4, foregroundColor.element, Text.alignment.CenterBottom)
        dayText:setParent(headerRect)
        dayText:setColor(foregroundActiveColor.element)
    end

    for i = 1, #calendar do
        local day = calendar[i]

        local dayPosition = Vector2(calendarPosition.x + ((i - 1) % 7) * (calendarSize.x / 7), calendarPosition.y + math.floor((i - 1) / 7) * (calendarSize.x / 7))
        local daySize = Vector2(calendarSize.x / 7, calendarSize.x / 7)

        local dayRect = Rectangle:new(dayPosition, daySize, daySize.y / 2, cardBackground.element)
        dayRect:setParent(self)
        dayRect:createEvent(Element.events.OnCursorEnter, bind(self.onDayCursorEnter, self, dayRect, day))
        dayRect:createEvent(Element.events.OnCursorLeave, bind(self.onDayCursorLeave, self, dayRect, day))
        dayRect:createEvent(Element.events.OnClick, bind(self.onDayClick, self, dayRect, day))

        local dayText = Text:new(dayPosition, daySize, string.format('%d', day.day), Core.fonts.Regular.element, 0.45, tocolor(255, 255, 255), Text.alignment.Center)
        dayText:setParent(dayRect)
        dayText:setColor(day.isCurrent and foregroundColor.element or foregroundActiveColor.element)

        if self:isSelected(day) then
            dayRect:setColor(primaryColor.element)
        end
    end
end

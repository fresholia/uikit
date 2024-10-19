Table = inherit(Element)
Table.selectMode = {
    Include = 'include',
    Exclude = 'exclude',
}

function Table:new(...)
    return new(self, ...)
end

function Table:constructor(_, _, selectionColor)
    self.type = ElementType.Table

    self.theme = TableTheme:new()

    self.columns = {}
    self.rows = {}

    self.currentPage = 1

    self.selectionColor = selectionColor or Element.color.Dark

    -- # Options
    self.isHeaderVisible = true
    self.isLoading = false
    self.isSelectable = false

    self.selections = {}
    self.selectMode = Table.selectMode.Include
end

function Table:setIsLoading(isLoading)
    self.isLoading = isLoading
    self:doPulse()
end

function Table:isRowSelected(row)
    if self.selectMode == Table.selectMode.Exclude then
        for _, selectedRow in ipairs(self.selections) do
            if selectedRow == row.uid then
                return false
            end
        end

        return true
    elseif self.selectMode == Table.selectMode.Include then
        for _, selectedRow in ipairs(self.selections) do
            if selectedRow == row.uid then
                return true
            end
        end

        return false
    end
end

function Table:setIsSelectable(isSelectable)
    self.isSelectable = isSelectable

    self:doPulse()
end

function Table:addColumn(column)
    local uid = string.random(10)
    table.insert(self.columns, { uid = uid, column = column })

    return uid
end

function Table:addRow(...)
    local cells = { ... }

    if #cells ~= #self.columns then
        error('The number of cells does not match the number of columns.')
    end

    local arrangedCells = {}
    local uid = string.random(10)

    for i, cell in ipairs(cells) do
        table.insert(arrangedCells, { column = self.columns[i].uid, cell = cell })
    end

    table.insert(self.rows, { uid = uid, cells = arrangedCells })

    return uid
end

function Table:deleteColumn(uid)
    for i, column in ipairs(self.columns) do
        if column.uid == uid then
            table.remove(self.columns, i)
            break
        end
    end

    return false
end

function Table:onSelectPage(page)
    self.currentPage = page
    self:doPulse()
end

function Table:clear()
    self.rows = {}
    self:doPulse()
end

function Table:getSelections()
    local selections = {}

    for _, row in ipairs(self.rows) do
        if self:isRowSelected(row) then
            table.insert(selections, row)
        end
    end

    return selections
end

function Table:updateAllCheckbox()
    if not self.allCheckbox then
        return
    end

    if self.selectMode == Table.selectMode.Exclude then
        if #self.selections == 0 then
            self.allCheckbox:setSelected(true)
            self.allCheckbox:setIndeterminate(false)
        elseif #self.selections == #self.rows then
            self.selectMode = Table.selectMode.Include
            self.selections = {}

            self:updateAllCheckbox()
            return
        else
            self.allCheckbox:setSelected(false)
            self.allCheckbox:setIndeterminate(true)
        end
    else
        if #self.selections == #self.rows then
            self.selectMode = Table.selectMode.Exclude
            self.selections = {}

            self:updateAllCheckbox()
            return
        elseif #self.selections > 0 then
            self.allCheckbox:setIndeterminate(true)
        else
            self.allCheckbox:setSelected(false)
            self.allCheckbox:setIndeterminate(false)
        end
    end

    for _, row in ipairs(self.rows) do
        if row.checkbox then
            row.checkbox:setSelected(self:isRowSelected(row))
        end
    end
end

function Table:onSelectionChange(row, isSelected)
    if not row.checkbox then
        return
    end

    if self.selectMode == Table.selectMode.Exclude then
        if isSelected then
            for i, selectedRow in ipairs(self.selections) do
                if selectedRow == row.uid then
                    table.remove(self.selections, i)
                    break
                end
            end
        else
            table.insert(self.selections, row.uid)
        end
    else
        if isSelected then
            table.insert(self.selections, row.uid)
        else
            for i, selectedRow in ipairs(self.selections) do
                if selectedRow == row.uid then
                    table.remove(self.selections, i)
                    break
                end
            end
        end
    end

    self:updateAllCheckbox()
end

function Table:onAllSelectionChange()
    self.selectMode = self.selectMode == Table.selectMode.Include and Table.selectMode.Exclude or Table.selectMode.Include
    self.selections = {}
    self:updateAllCheckbox()
end

function Table:doPulse()
    self:removeChildren()

    local bgColor = self.theme:getColor('backgroundColor')
    local headerColor = self.theme:getColor('headerColor')
    local headerForegroundColor = self.theme:getColor('headerForegroundColor')
    local borderRadius = self.theme:getProperty('borderRadius')
    local innerPadding = self.theme:getProperty('innerPadding')

    local headerHeight = self.theme:getProperty('headerHeight')
    local rowHeight = self.theme:getProperty('rowHeight')

    local selectableWidth = self.theme:getProperty('selectableWidth')

    local rect = Rectangle:new(self.position, self.size, borderRadius, bgColor.element)
    rect:setParent(self)

    local headerSize = Vector2(self.size.x - innerPadding.x * 2, headerHeight)
    local headerPosition = Vector2(
            self.position.x + innerPadding.x,
            self.position.y + innerPadding.y
    )

    local headerRect = Rectangle:new(headerPosition, headerSize, borderRadius / 1.6, headerColor.element)
    headerRect:setParent(self)

    local contentSize = Vector2(self.size.x - innerPadding.x * 2, self.size.y - headerSize.y - innerPadding.y * 2)
    local contentPosition = Vector2(
            self.position.x + innerPadding.x,
            headerPosition.y + headerSize.y + innerPadding.y
    )

    local maxRows = math.floor(contentSize.y / rowHeight)

    if self.isSelectable then
        headerSize = Vector2(headerSize.x - selectableWidth - innerPadding.x, headerSize.y)
        contentSize = Vector2(contentSize.x - selectableWidth - innerPadding.x, contentSize.y)

        headerPosition = Vector2(headerPosition.x + selectableWidth + innerPadding.x, headerPosition.y)
        contentPosition = Vector2(contentPosition.x + selectableWidth + innerPadding.x, contentPosition.y)

        local selectAllCheckbox = Checkbox:new(
                Vector2(self.position.x + innerPadding.x * 2, headerPosition.y + headerSize.y / 2 - 16 / 2),
                Element.size.Small,
                '',
                self.selectionColor
        )
        selectAllCheckbox:setSelected(false)
        selectAllCheckbox:setParent(headerRect)
        selectAllCheckbox:setDisabled(#self.rows == 0 or self.isLoading)
        selectAllCheckbox:createEvent(Element.events.OnChange, bind(self.onAllSelectionChange, self))

        self.allCheckbox = selectAllCheckbox
        self:updateAllCheckbox()
    end

    local columnWidth = headerSize.x / #self.columns

    for i, column in ipairs(self.columns) do
        local columnPosition = Vector2(headerPosition.x + (columnWidth * (i - 1)) + innerPadding.x, headerPosition.y)
        local columnSize = Vector2(columnWidth, headerSize.y)

        local columnLabel = Text:new(columnPosition, columnSize,
                column.column:upper(),
                Core.fonts.Regular.element,
                0.4,
                nil, Text.alignment.LeftCenter)
        columnLabel:setParent(headerRect)
        columnLabel:setColor(headerForegroundColor.element)
    end

    if self.isLoading then
        for i = 0, maxRows - 1 do
            local rowPosition = Vector2(contentPosition.x, contentPosition.y + i * rowHeight)
            local rowSize = Vector2(contentSize.x, rowHeight)

            for j = 0, #self.columns - 1 do
                local column = self.columns[j + 1]
                local columnPosition = Vector2(rowPosition.x + (columnWidth * j) + innerPadding.x, rowPosition.y + innerPadding.y)
                local columnSize = Vector2(columnWidth * math.random(4, 8) / 10, rowSize.y - innerPadding.y / 2)

                local skeletonRect = Skeleton:new(columnPosition, columnSize)
                skeletonRect:setParent(self)
            end
        end

        local spinnerIcon = Icon:new(Vector2(contentPosition.x + contentSize.x / 2 - 50, contentPosition.y + contentSize.y / 2 - 50),
                Vector2(100, 100), 'spinner-third', Icon.style.Solid)
        spinnerIcon:setParent(self)
        spinnerIcon:setColor(headerForegroundColor.element)
        spinnerIcon:rotate(true)
        return
    elseif #self.rows == 0 then
        local noDataIcon = Icon:new(Vector2(contentPosition.x + contentSize.x / 2 - 50, contentPosition.y + contentSize.y / 2 - 50),
                Vector2(100, 100), 'empty-set', Icon.style.Solid)
        noDataIcon:setParent(self)
        noDataIcon:setColor(headerForegroundColor.element)

        return
    end

    if #self.rows > maxRows then
        contentSize.y = contentSize.y - headerHeight - innerPadding.y
        maxRows = math.floor(contentSize.y / rowHeight)

        local pagination = Pagination:new(
                Vector2(self.position.x + innerPadding.x * 2, contentPosition.y + contentSize.y + innerPadding.y / 2),
                Vector2(self.size.x - innerPadding.x * 2, headerHeight),
                Element.color.Dark,
                Element.size.Medium,
                math.ceil(#self.rows / maxRows),
                self.currentPage
        )
        pagination:setParent(rect)
        pagination:createEvent(Element.events.OnChange, bind(self.onSelectPage, self))
    end

    local startRow = (self.currentPage - 1) * maxRows + 1
    local endRow = math.min(startRow + maxRows - 1, #self.rows)

    for i = startRow, endRow do
        local row = self.rows[i]
        local rowPosition = Vector2(contentPosition.x, contentPosition.y + (i - startRow) * rowHeight)
        local rowSize = Vector2(contentSize.x, rowHeight)

        local rowRect = Rectangle:new(rowPosition, rowSize, 0, bgColor.element)
        rowRect:setParent(self)

        if self.isSelectable then
            local selectCheckbox = Checkbox:new(
                    Vector2(self.position.x + innerPadding.x * 2, rowPosition.y + rowSize.y / 2 - 16 / 2),
                    Element.size.Small,
                    '',
                    self.selectionColor
            )
            selectCheckbox:setParent(rowRect)
            selectCheckbox:setSelected(self:isRowSelected(row))
            selectCheckbox:createEvent(Element.events.OnChange, bind(self.onSelectionChange, self, row))

            row.checkbox = selectCheckbox
        end

        for j, cell in ipairs(row.cells) do
            local column = self.columns[j]
            local columnPosition = Vector2(rowPosition.x + (columnWidth * (j - 1)) + innerPadding.x, rowPosition.y)
            local columnSize = Vector2(columnWidth, rowSize.y)

            local cellLabel = Text:new(columnPosition, columnSize,
                    tostring(cell.cell),
                    Core.fonts.Regular.element,
                    0.45,
                    nil, Text.alignment.LeftCenter)
            cellLabel:setParent(rowRect)
        end
    end
end

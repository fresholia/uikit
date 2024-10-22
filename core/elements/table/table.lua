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

    self.rowElements = {}

    self:createEvent(Element.events.OnClick, bind(self.onSelectRow, self))
    self:doPulse()
end

function Table:setIsLoading(isLoading)
    self.isLoading = isLoading

    self.noDataIcon:setRenderMode(Element.renderMode.Hidden)

    if self.spinnerIcon then
        self.spinnerIcon:setRenderMode(isLoading and Element.renderMode.Normal or Element.renderMode.Hidden)
    end
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
end

function Table:addColumn(column, withSearch, withSort)
    local uid = string.random(10)
    table.insert(self.columns, { uid = uid, column = column, withSearch = withSearch, withSort = withSort })

    return uid
end

function Table:updateColumns()
    self:createHeader()
    self:createContent()
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
    if page < 1 then
        page = 1
    end

    if page > math.ceil(#self.rows / self.maxRows) then
        page = math.ceil(#self.rows / self.maxRows)
    end

    self.currentPage = page

    self:updateRows()
end

function Table:clear()
    self.rows = {}
    self:updateRows()
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

    if self.isLoading then
        self.allCheckbox:setDisabled(true)
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
    elseif self.selectMode == Table.selectMode.Include then
        if #self.selections == #self.rows and #self.rows > 0 then
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

function Table:onSelectionChange(id, isSelected)
    local row = self.rows[(self.currentPage - 1) * self.maxRows + id]
    if not row then
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
    self:updateRows()
end

function Table:onSearch(i, value)
    if not value or value == '' then
        if self.originalRows then
            self.rows = self.originalRows
            self.originalRows = nil

            self:updateRows()
        end
        return
    end

    if not self.originalRows then
        self.originalRows = self.rows
    end

    self.rows = {}

    for _, row in ipairs(self.originalRows) do
        if utf8.find(tostring(row.cells[i].cell):lower(), value:lower(), 1, true) then
            table.insert(self.rows, row)
        end
    end

    self:updateRows()
end

function Table:onSort(i)
    if not self.sortActions then
        self.sortActions = {}
    end

    if not self.sortActions then
        self.sortActions[i] = 'asc'
    else
        self.sortActions[i] = self.sortActions[i] == 'asc' and 'desc' or 'asc'
    end

    local sortAction = self.sortActions[i]

    table.sort(self.rows, function(a, b)
        local cellA = a and a.cells[i].cell or ''
        local cellB = b and b.cells[i].cell or ''

        if sortAction == 'asc' then
            return cellA < cellB
        else
            return cellA > cellB
        end
    end)

    self:updateRows()
end

function Table:reCalculateVectors()
    local headerHeight = self.theme:getProperty('headerHeight')
    local innerPadding = self.theme:getProperty('innerPadding')
    local selectableWidth = self.theme:getProperty('selectableWidth')
    local rowHeight = self.theme:getProperty('rowHeight')

    local headerSize = Vector2(self.size.x - innerPadding.x * 2, headerHeight)
    local headerPosition = Vector2(
            self.position.x + innerPadding.x,
            self.position.y + innerPadding.y
    )

    local contentSize = Vector2(self.size.x - innerPadding.x * 2, self.size.y - headerSize.y - innerPadding.y * 3)
    local contentPosition = Vector2(
            self.position.x + innerPadding.x,
            headerPosition.y + headerSize.y + innerPadding.y
    )

    if self.isSelectable then
        contentSize = Vector2(contentSize.x - selectableWidth - innerPadding.x, contentSize.y)
        contentPosition = Vector2(contentPosition.x + selectableWidth + innerPadding.x, contentPosition.y)
    end

    self.maxRows = math.floor(contentSize.y / rowHeight) - 1

    if #self.rows > self.maxRows then
        contentSize.y = contentSize.y - headerHeight - innerPadding.y
        self.maxRows = math.floor(contentSize.y / rowHeight)
    end

    return {
        headerSize = headerSize,
        headerPosition = headerPosition,
        contentSize = contentSize,
        contentPosition = contentPosition
    }
end

function Table:createHeader()
    if self.headerRect then
        self.headerRect:destroy()
    end

    self.headerElements = {}
    self.vectors = self:reCalculateVectors()

    local headerPosition, headerSize = self.vectors.headerPosition, self.vectors.headerSize
    local headerColor = self.theme:getColor('headerColor')
    local borderRadius = self.theme:getProperty('borderRadius')
    local innerPadding = self.theme:getProperty('innerPadding')
    local headerForegroundColor = self.theme:getColor('headerForegroundColor')
    local headerForegroundIconColor = self.theme:getColor('headerForegroundIconColor')
    local contentPosition, contentSize = self.vectors.contentPosition, self.vectors.contentSize

    local headerRect = Rectangle:new(headerPosition, headerSize, borderRadius / 1.6, headerColor.element)
    headerRect:setParent(self.rect)
    headerRect:setRenderIndex(10)
    self.headerRect = headerRect

    if self.isSelectable then
        local selectAllCheckbox = Checkbox:new(
                Vector2(self.position.x + innerPadding.x * 2, headerPosition.y + headerSize.y / 2 - 16 / 2),
                Element.size.Small,
                '',
                self.selectionColor
        )
        selectAllCheckbox:setParent(headerRect)
        selectAllCheckbox:createEvent(Element.events.OnChange, bind(self.onAllSelectionChange, self))

        self.allCheckbox = selectAllCheckbox
        self:updateAllCheckbox()
    end

    self.columnWidth = contentSize.x / #self.columns

    for i, column in ipairs(self.columns) do
        local columnPosition = Vector2(contentPosition.x + (self.columnWidth * (i - 1)) + innerPadding.x, headerPosition.y)
        local columnSize = Vector2(self.columnWidth, headerSize.y)

        local columnLabel = Text:new(columnPosition, columnSize,
                column.column:upper(),
                Core.fonts.Regular.element,
                0.4,
                nil, Text.alignment.LeftCenter)
        columnLabel:setParent(headerRect)
        columnLabel:setColor(headerForegroundColor.element)

        if column.withSearch or column.withSort then
            local textWidth = dxGetTextWidth(column.column:upper(), 0.4, Core.fonts.Regular.element) + 5

            if column.withSearch then
                local searchIcon = IconButton:new(
                        Vector2(columnPosition.x + textWidth, columnPosition.y + columnSize.y / 2 - 24 / 2),
                        Vector2(20, 20),
                        Icon:new(Vector2(0, 0), Vector2(20, 20), 'search', Icon.style.Light, nil,
                                headerForegroundIconColor.element, headerForegroundIconColor.element),
                        Button.variants.Light,
                        Element.color.Dark,
                        Element.size.Small
                )
                searchIcon:setParent(headerRect)
                Tooltip:new(searchIcon, 'Arama', Element.size.Medium)

                local popover = Popover:new(Vector2(Padding.Large * 11, Padding.Medium * 4.6), searchIcon, Popover.placement.BottomStart, Element.color.Dark)
                popover:setParent(searchIcon)
                local searchInput = Input:new(
                        popover.content.position,
                        popover.content.size,
                        BaseInput.variants.Solid,
                        Element.color.Dark,
                        Element.size.Medium
                )
                searchInput:setParent(popover)
                searchInput:setLabel('Ara')
                searchInput:setIsClearable(true)
                searchInput:createEvent(Element.events.OnChange, bind(self.onSearch, self, i))

                textWidth = textWidth + 24
            end

            if column.withSort then
                local sortIcon = IconButton:new(
                        Vector2(columnPosition.x + textWidth, columnPosition.y + columnSize.y / 2 - 24 / 2),
                        Vector2(20, 20),
                        Icon:new(Vector2(0, 0), Vector2(24, 24), 'sort', Icon.style.Light, nil,
                                headerForegroundIconColor.element, headerForegroundIconColor.element),
                        Button.variants.Light,
                        Element.color.Dark,
                        Element.size.Small
                )
                sortIcon:setParent(headerRect)
                Tooltip:new(sortIcon, 'Sırala', Element.size.Medium)
                sortIcon:createEvent(Element.events.OnClick, bind(self.onSort, self, i))
            end
        end
    end
end

function Table:createContent()
    if self.contentRect then
        self.contentRect:destroy()
    end

    self.vectors = self:reCalculateVectors()

    local contentPosition, contentSize = self.vectors.contentPosition, self.vectors.contentSize
    local rowHeight = self.theme:getProperty('rowHeight')
    local innerPadding = self.theme:getProperty('innerPadding')
    local headerHeight = self.theme:getProperty('headerHeight')
    local headerForegroundColor = self.theme:getColor('headerForegroundColor')

    local contentRect = Rectangle:new(contentPosition, contentSize, 0, tocolor(255, 255, 255, 0))
    contentRect:setParent(self.rect)
    self.contentRect = contentRect

    -- # TODO: Skeleton loader
    local spinnerIcon = Icon:new(Vector2(contentPosition.x + contentSize.x / 2 - 50, contentPosition.y + contentSize.y / 2 - 50),
            Vector2(100, 100), 'spinner-third', Icon.style.Solid)
    spinnerIcon:setParent(contentRect)
    spinnerIcon:setColor(headerForegroundColor.element)
    spinnerIcon:rotate(true)
    spinnerIcon:setRenderMode(Element.renderMode.Hidden)
    spinnerIcon:setRenderIndex(999)
    self.spinnerIcon = spinnerIcon

    local noDataIcon = Icon:new(Vector2(contentPosition.x + contentSize.x / 2 - 50, contentPosition.y + contentSize.y / 2 - 50),
            Vector2(100, 100), 'empty-set', Icon.style.Solid)
    noDataIcon:setParent(contentRect)
    noDataIcon:setColor(headerForegroundColor.element)
    noDataIcon:setRenderMode(Element.renderMode.Normal)
    noDataIcon:setRenderIndex(999)
    self.noDataIcon = noDataIcon

    local pagination = Pagination:new(
            Vector2(self.position.x + innerPadding.x * 2, contentPosition.y + contentSize.y - innerPadding.y * 3),
            Vector2(self.size.x - innerPadding.x * 2, headerHeight),
            Element.color.Dark,
            Element.size.Medium,
            math.ceil(#self.rows / self.maxRows),
            self.currentPage
    )
    pagination:setParent(contentRect)
    pagination:createEvent(Element.events.OnChange, bind(self.onSelectPage, self))
    pagination:setRenderMode(Element.renderMode.Hidden)
    self.pagination = pagination

    for i = 1, self.maxRows do
        local rowPosition = Vector2(contentPosition.x, contentPosition.y + (i - 1) * rowHeight)
        local rowSize = Vector2(contentSize.x, rowHeight)

        if self.isSelectable then
            local selectCheckbox = Checkbox:new(
                    Vector2(self.position.x + innerPadding.x * 2, rowPosition.y + rowSize.y / 2 - 16 / 2),
                    Element.size.Small,
                    '',
                    self.selectionColor
            )
            selectCheckbox:setParent(contentRect)
            selectCheckbox:setRenderMode(Element.renderMode.Hidden)
            selectCheckbox:createEvent(Element.events.OnChange, bind(self.onSelectionChange, self, i))
        end

        self.rowElements[i] = {
            checkbox = selectCheckbox,
            cells = {},
            position = rowPosition,
            size = rowSize
        }

        for j in ipairs(self.columns) do
            local columnPosition = Vector2(rowPosition.x + (self.columnWidth * (j - 1)) + innerPadding.x, rowPosition.y)
            local columnSize = Vector2(self.columnWidth, rowSize.y)

            local cellLabel = Text:new(columnPosition, columnSize,
                    i .. ' - ' .. j,
                    Core.fonts.Regular.element,
                    0.45,
                    nil, Text.alignment.LeftCenter)
            cellLabel:setParent(contentRect)
            cellLabel:setRenderMode(Element.renderMode.Hidden)
            cellLabel:setRenderIndex(1)

            self.rowElements[i].cells[j] = cellLabel
        end
    end
end

function Table:onSelectRow()
    for i = 1, self.maxRows do
        local rowElement = self.rowElements[i]

        if not rowElement then
            break
        end

        if Core:inArea(rowElement.position, rowElement.size) then
            local data = self.rows[(self.currentPage - 1) * self.maxRows + i]

            local values = {}
            for _, cell in ipairs(data.cells) do
                table.insert(values, cell.cell)
            end

            self:virtual_callEvent(Element.events.OnChange, values)
        end
    end
end

function Table:updateRows()
    self.noDataIcon:setRenderMode(#self.rows == 0 and Element.renderMode.Normal or Element.renderMode.Hidden)

    for i = 1, self.maxRows do
        local rowElement = self.rowElements[i]

        if not rowElement then
            break
        end

        local row = self.rows[(self.currentPage - 1) * self.maxRows + i]

        if rowElement.checkbox then
            rowElement.checkbox:setRenderMode((row and self.isSelectable) and Element.renderMode.Normal or Element.renderMode.Hidden)
            rowElement.checkbox:setSelected(row and self:isRowSelected(row))
        end

        for j in ipairs(self.columns) do
            local cellElement = rowElement.cells[j]
            local cell = row and row.cells[j]

            if cell then
                cellElement:setText(cell.cell)
                cellElement:setRenderMode(Element.renderMode.Normal)
            else
                cellElement:setRenderMode(Element.renderMode.Hidden)
            end
        end
    end

    if #self.rows > self.maxRows then
        self.pagination:setRenderMode(Element.renderMode.Normal)
        self.pagination:setTotal(math.ceil(#self.rows / self.maxRows))
    else
        self.pagination:setRenderMode(Element.renderMode.Hidden)
    end
end

function Table:doPulse()
    self:removeChildren()

    local bgColor = self.theme:getColor('backgroundColor')
    local borderRadius = self.theme:getProperty('borderRadius')

    self.vectors = self:reCalculateVectors()

    local rect = Rectangle:new(self.position, self.size, borderRadius, bgColor.element)
    rect:setParent(self)
    self.rect = rect

    self:createHeader()
    self:createContent()
end

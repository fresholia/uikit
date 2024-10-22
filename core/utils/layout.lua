Layout = {}

function Layout:new(...)
    return new(self, ...)
end

function Layout:constructor()
end

function Layout:createGridLayout(position, size, columns, rows, columnsGap, rowsGap)
    local cells = {}

    if not rowsGap then
        rowsGap = columnsGap
    end

    local cellWidth = (size.x / columns)
    local cellHeight = (size.y / rows)

    cellWidth = cellWidth - columnsGap.x
    cellHeight = cellHeight - rowsGap.y

    local cellSize = Vector2(cellWidth, cellHeight)

    for i = 1, columns do
        for j = 1, rows do
            local cellPosition = Vector2(
                    position.x + (cellWidth + columnsGap.x) * (i - 1),
                    position.y + (cellHeight + rowsGap.y) * (j - 1)
            )

            table.insert(cells, { position = cellPosition, size = cellSize })
        end
    end

    return cells
end
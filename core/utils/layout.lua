Layout = {}

function Layout:new(...)
    return new(self, ...)
end

function Layout:constructor()
end

function Layout:createGridLayout(position, size, columns, rows, gap)
    local cellWidth = size.x / columns
    local cellHeight = size.y / rows

    local cells = {}

    for i = 1, columns do
        for j = 1, rows do
            local cellPosition = Vector2(position.x + (cellWidth * (i - 1)), position.y + (cellHeight * (j - 1)))
            local cellSize = Vector2(cellWidth, cellHeight)

            if gap then
                cellPosition.x = cellPosition.x + gap.x
                cellPosition.y = cellPosition.y + gap.y

                cellSize.x = cellSize.x - gap.x
                cellSize.y = cellSize.y - gap.y
            end

            table.insert(cells, { position = cellPosition, size = cellSize })
        end
    end

    return cells
end
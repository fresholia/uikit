Font = {}

function Font:new(...)
    return new(self, ...)
end

function Font:constructor(name, format, size, isBold)
    self.name = name
    self.size = size
    self.isBold = isBold

    self.element = DxFont('public/fonts/' .. name .. '.' .. format, size, isBold)

    if not self.element then
        error('Failed to create font: ' .. name)

        self.element = 'default'
    end

    return self
end

function Font:destroy()
    if self.element == 'default' then
        return
    end

    self.element:destroy()
end

Theme = {}

function Theme:new(...)
    return new(self, ...)
end

function Theme:destroy(...)
    return delete(self, ...)
end

function Theme:virtual_constructor()
    self.palette = {}
    self.properties = {}
end

function Theme:getColor(name)
    return self.palette[name]
end

function Theme:getProperty(name)
    return self.properties[name]
end

function Theme:setColor(name, color)
    self.palette[name] = color
end

function Theme:setProperty(name, value)
    self.properties[name] = value
end

function Theme:ch(name, shade, alpha)
    if alpha < 0 or alpha > 1 then
        error('Alpha must be between 0 and 1')
    end

    if not Palette[name] then
        error('Invalid color palette. ' .. name)
    end

    local r, g, b = hex2rgb(Palette[name][shade])

    return {
        r = r,
        g = g,
        b = b,
        a = alpha * 255
    }
end

function Theme:c(name, shade, alpha)
    local c = self:ch(name, shade, alpha)
    return tocolor(c.r, c.g, c.b, c.a)
end

function Theme:combine(name, shade, alpha)
    local c = self:ch(name, shade, alpha)

    return {
        element = tocolor(c.r, c.g, c.b, c.a),
        original = {
            r = c.r,
            g = c.g,
            b = c.b,
            a = c.a,
            hex = rgb2hex(c.r, c.g, c.b)
        }
    }
end

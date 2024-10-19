Rectangle = inherit(Element)

function Rectangle:constructor(_, size, radius, color)
    self.type = ElementType.Rectangle

    self.isPending = true
    self.radius = tonumber(radius) and { tl = radius, tr = radius, br = radius, bl = radius } or radius or radius
    self.color = color or tocolor(255, 255, 255, 255)
    self.uid = md5(size.x .. '_' .. size.y .. '_' .. self.radius.bl .. '_' .. self.radius.br .. '_' .. self.radius.tl .. '_' .. self.radius.tr)

    self.cachePath = '!cache/rect/' .. self.uid .. '.png'
    self:createTexture()
end

function Rectangle:destructor()
    if self.texture and isElement(self.texture) then
        self.texture:destroy()
    end
end

function Rectangle:setSize(size, ignoreTextureCreation)
    assert(size.x > 0 and size.y > 0, 'Size must be greater than 0')

    self.size = size

    if ignoreTextureCreation then
        return
    end

    self.uid = md5(size.x .. '_' .. size.y .. '_' .. self.radius.bl .. '_' .. self.radius.br .. '_' .. self.radius.tl .. '_' .. self.radius.tr)
    self.cachePath = '!cache/rect/' .. self.uid .. '.png'

    self:createTexture()
end

function Rectangle:loadTexture()
    self.texture = self.cachePath--dxCreateTexture(self.cachePath, 'argb')
    self.isPending = false
end

function Rectangle:saveTexture(svg)
    local rt = DxRenderTarget(self.size.x, self.size.y, true)
    rt:setAsTarget()
    dxDrawImage(0, 0, self.size.x, self.size.y, svg, 0, 0, 0, tocolor(255, 255, 255))
    dxSetRenderTarget()

    local pixels = rt:getPixels()
    local raw = dxConvertPixels(pixels, 'png')

    local file = File.new(self.cachePath)
    file:write(raw)
    file:close()

    self:loadTexture()
end

function Rectangle:createTexture()
    if File.exists(self.cachePath) then
        self:loadTexture()
        return
    end

    local x, y = 0, 0
    local width, height = self.size.x, self.size.y
    local tl = self.radius.tl
    local tr = self.radius.tr
    local br = self.radius.br
    local bl = self.radius.bl

    local maxRadius = math.min(self.size.x, self.size.y) / 2
    tl = math.min(tl, maxRadius)
    tr = math.min(tr, maxRadius)
    br = math.min(br, maxRadius)
    bl = math.min(bl, maxRadius)

    local path = string.format("M %d,%d", x + tl, y)
    path = path .. string.format(" H %d", x + width - tr)
    path = path .. string.format(" A %d,%d 0 0 1 %d,%d", tr, tr, x + width, y + tr)
    path = path .. string.format(" V %d", y + height - br)
    path = path .. string.format(" A %d,%d 0 0 1 %d,%d", br, br, x + width - br, y + height)
    path = path .. string.format(" H %d", x + bl)
    path = path .. string.format(" A %d,%d 0 0 1 %d,%d", bl, bl, x, y + height - bl)
    path = path .. string.format(" V %d", y + tl)
    path = path .. string.format(" A %d,%d 0 0 1 %d,%d", tl, tl, x + tl, y)
    path = path .. " Z"

    local svgTexturePath = '<svg xmlns="http://www.w3.org/2000/svg" width="' .. self.size.x .. '" height="' .. self.size.y .. '"><path d="' .. path .. '" fill="white"/></svg>'

    svgCreate(self.size.x, self.size.y, svgTexturePath, function(svg)
        self:saveTexture(svg)
    end)
end

function Rectangle:setColor(color)
    self.color = color
end

function Rectangle:render()
    if self.isPending then
        return
    end

    dxDrawImage(self.position.x, self.position.y, self.size.x, self.size.y, self.texture,
            0, 0, 0,
            self.color, self.postGUI)
end

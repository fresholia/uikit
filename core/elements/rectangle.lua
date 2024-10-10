Rectangle = inherit(Element)

function Rectangle:constructor(_, size, radius, color)
    self.type = ElementType.Rectangle

    self.isPending = true
    self.radius = radius
    self.color = color or tocolor(255, 255, 255, 255)

    self.uid = md5(size.x .. '_' .. size.y .. '_' .. radius)

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

    self.uid = md5(size.x .. '_' .. size.y .. '_' .. self.radius)
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

    svgCreate(self.size.x, self.size.y, ([[
    <svg viewBox="0 0 [width] [height]" fill="white" xmlns="http://www.w3.org/2000/svg">
      <rect width="[width]" height="[height]" rx="[radius]" />
    </svg>]]):gsub('%[width%]', self.size.x):gsub('%[height%]', self.size.y):gsub('%[radius%]', self.radius), function(svg)
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

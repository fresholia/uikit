RenderTexture = inherit(Element)

function RenderTexture:constructor()
    self.type = ElementType.RenderTexture

    self.renderTarget = DxRenderTarget(self.size.x, self.size.y, true)
    self.isReady = false

    self:createEvent(Element.events.OnChildAdd, bind(self.onChildAdd, self))

    if not self.renderTarget then
        error('Failed to create render target')
    end
end

function RenderTexture:destructor()
    if self.renderTarget and isElement(self.renderTarget) then
        self.renderTarget:destroy()
    end
end

function RenderTexture:onChildAdd(child, level)
    child:setRenderMode(Element.renderMode.RT)
end

function RenderTexture:setUID(uid)
    self.uid = uid
    self.cachePath = '!cache/rt/' .. self.uid .. '.png'

    self.isExists = File.exists(self.cachePath)
end

function RenderTexture:setAsTarget()
    if not self.renderTarget then
        error('Failed to set render target')
    end

    if not self.uid then
        error('UID is not set')
    end

    if self.isExists then
        return
    end

    self.renderTarget:setAsTarget()
end

function RenderTexture:renderChildren()
    for _, childId in pairs(self.children) do
        local child = Core:hasElement(childId)
        if child and child.render then
            child:render(child.children)
        end
    end
end

function RenderTexture:resetAsTarget()
    if self.isExists then
        return
    end

    self:renderChildren()
    dxSetRenderTarget()
end

function RenderTexture:createTexture()
    if self.isExists then
        self.isReady = true
        self:removeChildren()
        self.renderTarget:destroy()
        return
    end

    if File.exists(self.cachePath) then
        File.delete(self.cachePath)
    end

    local pixels = self.renderTarget:getPixels()
    local raw = dxConvertPixels(pixels, 'png')

    local file = File.new(self.cachePath)
    file:write(raw)
    file:close()

    self:removeChildren()
    self.renderTarget:destroy()

    self.isReady = true
end

function RenderTexture:render()
    if not self.isReady then
        return
    end

    dxDrawImage(self.position.x, self.position.y, self.size.x, self.size.y, self.cachePath, 0, 0, 0, tocolor(255, 255, 255), self.postGUI)
end

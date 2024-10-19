IconGen = {}

function IconGen:new(...)
    return new(self, ...)
end

function IconGen:constructor()
    self.iconsPath = getOriginalPath('core/elements/icon/icons.json')
    self.unicodes = {}
    self.ticks = {}

    self.fonts = {}
    self.toRestoreIcons = {}
    self.tick = 0

    self:readIcons()

    createNativeEvent(ClientEventNames.onClientRestore, root, bind(self.onClientRestore, self))
    createNativeEvent(ClientEventNames.onClientResourceStop, resourceRoot, bind(self.onClientResourceStop, self))
end

function IconGen:onClientRestore()
    for i, icon in ipairs(self.toRestoreIcons) do
        self:getIcon(unpack(icon))
    end
    self.toRestoreIcons = {}
end

function IconGen:onClientResourceStop()
    for k in pairs(self.ticks) do
        if self.ticks[k] and File.exists(k .. self.ticks[k]) then
            File.delete(k .. self.ticks[k])
        end
    end
end

function IconGen:getIcon(name, size, style, force, border, color, border2)
    if border or border2 then
        size = math.ceil(size)
    else
        size = convertSizeToP2(size)
    end

    style = style or 'solid'
    if style == 'solid' or style == 'brands' or style == 'regular' or style == 'light' then
        if not self.unicodes[name] then
            error('Icon not found: ' .. name)
            return
        end

        local fileName = 'faicons/' .. name .. '-' .. style .. '-' .. size
        if border then
            fileName = fileName .. '-b-' .. border
        end
        if border2 then
            fileName = fileName .. '-b2-' .. border2
        end
        if color then
            fileName = fileName .. '-c-' .. color
        end
        fileName = fileName .. '.png'

        if force and self.ticks[fileName] and File.exists(fileName .. self.ticks[fileName]) then
            File.delete(fileName .. self.ticks[fileName])
        end

        if not (not force and self.ticks[fileName]) or not File.exists(fileName .. self.ticks[fileName]) then
            self.tick = self.tick + 1

            self.ticks[fileName] = self.tick

            if File.exists(fileName .. self.ticks[fileName]) then
                File.delete(fileName .. self.ticks[fileName])
            end

            local rt = DxRenderTarget(size, size, true)
            if not isElement(rt) then
                table.insert(self.toRestoreIcons, {
                    name,
                    size,
                    style,
                    border,
                    color,
                    border2
                })
                return fileName
            end
            local fontSize = size
            if border or border2 then
                fontSize = size - 2
            end

            if not isElement(self.fonts[style .. fontSize]) then
                self.fonts[style .. fontSize] = DxFont(getOriginalPath('public/fonts/fa/' .. style .. '.otf'), 0.4375 * fontSize, false, 'antialiased')
            end

            local font = self.fonts[style .. fontSize]
            if not isElement(font) then
                table.insert(self.toRestoreIcons, {
                    name,
                    size,
                    style,
                    border,
                    color,
                    border2
                })
                rt:destroy()
                return fileName
            end

            dxSetRenderTarget(rt, true)
            dxSetBlendMode('modulate_add')
            if border then
                dxDrawText(utf8.char(tonumber("0x" .. self.unicodes[name])), 1, 1, size + 1, size + 1, border, 1, font, 'center', 'center')
            end
            if border2 then
                for bx = -1, 1, 2 do
                    for by = -1, 1, 2 do
                        dxDrawText(utf8.char(tonumber("0x" .. self.unicodes[name])), 0 + bx, 0 + by, size + bx, size + by, border2, 1, font, 'center', 'center')
                    end
                end
            end
            dxDrawText(utf8.char(tonumber("0x" .. self.unicodes[name])), 0, 0, size, size, color or tocolor(255, 255, 255), 1, font, 'center', 'center')
            dxSetBlendMode("blend")
            dxSetRenderTarget()

            local pixels = dxGetTexturePixels(rt)
            rt:destroy()

            if not pixels then
                table.insert(self.toRestoreIcons, {
                    name,
                    size,
                    style,
                    border,
                    color,
                    border2
                })
                return fileName
            end

            local pixelCount = 0
            for x = 0, size - 1, 4 do
                for y = 0, size - 1, 4 do
                    local r, g, b, a = dxGetPixelColor(pixels, x, y)
                    pixelCount = pixelCount + a
                    if 0 < pixelCount then
                        break
                    end
                end
            end

            if pixelCount == 0 then
                table.insert(self.toRestoreIcons, {
                    name,
                    size,
                    style,
                    border,
                    color,
                    border2
                })
                return fileName
            end

            pixels = dxConvertPixels(pixels, 'png')
            local file = File.new(fileName .. self.ticks[fileName])
            file:write(pixels)
            file:close()
            if pixelCount > 0 then
                dxDrawImage(-10000, -10000, 1000, 100, fileName .. self.ticks[fileName])
            end

            return fileName
        else
            return fileName
        end
    end
end

function IconGen:readIcons()
    if not File.exists(self.iconsPath) then
        error('Icons file not found: ' .. self.iconsPath)
        return
    end

    local file = File.open(self.iconsPath)
    local data = file:read(file.size)
    file:close()

    for key, row in pairs(fromJSON(data)) do
        self.unicodes[key] = row.unicode
    end
end
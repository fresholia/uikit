Core = {}

function Core:new(...)
    return new(self, ...)
end

function Core:constructor()
    self.elements = {}
    self.elementsArray = {}

    self.version = '1.0.0-alpha'

    self.animate = Animate:new()
    self.iconGen = IconGen:new()

    self.globalPadding = {
        [Element.size.Small] = {
            x = 10,
            y = 5,
            fontSize = 0.35
        },
        [Element.size.Medium] = {
            x = 15,
            y = 10,
            fontSize = 0.45
        },
        [Element.size.Large] = {
            x = 20,
            y = 15,
            fontSize = 0.55
        },
    }

    self.elementsTree = {}

    self.fonts = {}
    self.fonts.Regular = Font:new('MrJonesBook', 'otf', 20, false)
    self.fonts.Bold = Font:new('MrJonesBook', 'otf', 20, true)

    createNativeEvent(ClientEventNames.onClientClick, root, bind(self.onClickElement, self))
    createNativeEvent(ClientEventNames.onClientCursorMove, root, bind(self.onCursorMove, self))
    createNativeEvent(ClientEventNames.onClientCharacter, root, bind(self.onCharacter, self))
    createNativeEvent(ClientEventNames.onClientKey, root, bind(self.onKey, self))
end

function Core:inArea(position, size)
    if isCursorShowing() then
        if not position or not position.x or not position.y or not size or not size.x or not size.y then
            return false
        end

        local aX, aY = getCursorPosition()
        aX, aY = aX * screenSize.x, aY * screenSize.y
        if aX > position.x and aX < position.x + size.x and aY > position.y and aY < position.y + size.y then
            return true
        else
            return false
        end
    else
        return false
    end
end

function Core:onClickElement(button, state, absX, absY)
    if button ~= 'left' then
        return
    end

    for _, element in pairs(self.elements) do
        if element and element:isVisible() then
            if self:inArea(element.position, element.size) and not element:isDisabled() then
                if state == 'up' then
                    element:virtual_callEvent(Element.events.OnClick)
                    element:virtual_callEvent(Element.events.OnPressUp, button, state)
                else
                    element:virtual_callEvent(Element.events.OnPressDown, button, state)
                end
            else
                if state == 'up' then
                    element:virtual_callEvent(Element.events.OnClickOutside)
                end
            end
        end
    end
end

function Core:onKey(button, pressOrRelease)
    for _, element in pairs(self.elements) do
        if element and element:isVisible() then
            element:virtual_callEvent(Element.events.OnKey, button, pressOrRelease)
        end
    end
end

function Core:onCharacter(character)
    for _, element in pairs(self.elements) do
        if element and element:isVisible() then
            element:virtual_callEvent(Element.events.OnCharacter, character)
        end
    end
end

function Core:onCursorMove(_, _, cursorX, cursorY)
    if not self.hoveringElements then
        self.hoveringElements = {}
    end

    for _, element in pairs(self.elements) do
        if element:isVisible() and self:inArea(element.position, element.size) then
            if not self.hoveringElements[element.id] then
                element:virtual_callEvent(Element.events.OnCursorEnter)
                element.isHovered = true
                self.hoveringElements[element.id] = true
            else
                element:virtual_callEvent(Element.events.OnCursorMoveInside, cursorX, cursorY)
            end
        else
            if self.hoveringElements[element.id] then
                element:virtual_callEvent(Element.events.OnCursorLeave)
                element.isHovered = false
                self.hoveringElements[element.id] = false
            end
        end
    end
end

function Core:pushElement(key, element)
    self.elements[key] = element
end

function Core:hasElement(key)
    return self.elements[key]
end

function Core:removeElement(key)
    self.elements[key] = nil
end

function Core:reOrderElements()
    local tree = {}
    local baseElements = {}

    for _, element in pairs(self.elements) do
        if not element.parent then
            tree[element.id] = self:buildTree(element)
            table.insert(baseElements, element.id)
        end
    end

    table.sort(baseElements, function(a, b)
        local elementA = self:hasElement(a)
        local elementB = self:hasElement(b)

        return elementA.renderIndex < elementB.renderIndex
    end)

    self.elementsArray = baseElements
    self.elementsTree = tree
end

function Core:buildTree(element)
    local node = { __type = element.type, element = element.id, children = {} }

    table.sort(element.children, function(a, b)
        local childA = self:hasElement(a)
        local childB = self:hasElement(b)

        local aRenderIndex = childA and childA.renderIndex or 0
        local bRenderIndex = childB and childB.renderIndex or 0

        return aRenderIndex < bRenderIndex
    end)

    for _, childId in ipairs(element.children) do
        local childElement = self:hasElement(childId)
        if childElement then
            table.insert(node.children, self:buildTree(childElement))
        end
    end

    return node
end
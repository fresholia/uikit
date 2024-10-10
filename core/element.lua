Element = {}
Element.events = {
    OnClick = 'onClick',
    OnPressDown = 'onPressDown',
    OnPressUp = 'onPressUp',
    OnClickOutside = 'onClickOutside',
    OnCursorEnter = 'onCursorEnter',
    OnCursorLeave = 'onCursorLeave',
    OnCursorMoveInside = 'onCursorMoveInside',
    OnChildAdd = 'OnChildAdd',
    OnChildRemove = 'OnChildRemove',
    OnVisibleChange = 'OnVisibleChange',
    OnCharacter = 'OnCharacter',
    OnKey = 'OnKey',
}
Element.color = {
    Primary = 'primary',
    Secondary = 'secondary',
    Success = 'success',
    Danger = 'danger',
    Warning = 'warning',
    Info = 'info',
    Light = 'light',
    Dark = 'dark',
    White = 'white',
    Black = 'black',
}
Element.size = {
    Small = 'small',
    Medium = 'medium',
    Large = 'large',
}
Element.renderMode = {
    Normal = 'normal',
    Hidden = 'hidden',
    RT = 'rt',
}

sizesMap = {
    [1] = Element.size.Small,
    [2] = Element.size.Medium,
    [3] = Element.size.Large,
}

colorsMap = {
    [1] = Element.color.Primary,
    [2] = Element.color.Secondary,
    [3] = Element.color.Success,
    [4] = Element.color.Danger,
    [5] = Element.color.Warning,
    [6] = Element.color.Info,
    [7] = Element.color.Light,
    [8] = Element.color.Dark,
}

function Element:new(...)
    return new(self, ...)
end

function Element:destroy(...)
    self:removeChildren()

    if self.parent then
        local parent = Core:hasElement(self.parent)
        if parent then
            parent:removeChild(self.id)
        end
    end

    if self.theme then
        self.theme:destroy()
    end

    Core:removeElement(self.id)
    Core:reOrderElements()
    return delete(self, ...)
end

function Element:virtual_constructor(position, size)
    self.id = getTickCount() .. string.random(10) .. math.random(1, 1000) -- # This is a unique identifier for the element.

    if Core:hasElement(self.id) then
        error('Element with id ' .. self.id .. ' already exists.')
        return false
    end

    self.position = position
    self.size = size

    self.alpha = 1
    self.visible = true

    self.parent = nil
    self.children = {}
    self.postGUI = false

    self.events = {}

    self.disabled = false

    self.renderMode = Element.renderMode.Normal
    self.renderIndex = 1

    Core:pushElement(self.id, self)
    Core:reOrderElements()
end

function Element:createEvent(event, callback)
    if not self.events[event] then
        self.events[event] = {}
    end

    table.insert(self.events[event], callback)
end

function Element:setRenderIndex(index)
    self.renderIndex = index
end

function Element:setRenderMode(mode)
    self.renderMode = mode
end

function Element:setId(id)
    if Core:hasElement(id) then
        error('Element with id ' .. id .. ' already exists.')
        return false
    end

    Core:removeElement(self.id)
    self.id = id
    Core:pushElement(self.id, self)
end

function Element:hasChild(childId)
    for _, child in pairs(self.children) do
        if child == childId then
            return true
        end
    end

    return false
end

function Element:getChildCount(recursive)
    if recursive == nil then
        recursive = true
    end

    local count = size(self.children)

    if recursive then
        for _, child in pairs(self.children) do
            local childElement = Core:hasElement(child)
            if childElement then
                count = count + childElement:getChildCount(recursive)
            end
        end
    end

    return count
end

function Element:removeChildren()
    for _, child in pairs(self.children) do
        local childElement = Core:hasElement(child)
        if childElement then
            childElement:destroy()
        end
    end
    self.children = {}
end

function Element:removeChildrenExcept(type)
    for _, child in pairs(self.children) do
        local childElement = Core:hasElement(child)
        if childElement and childElement.type ~= type then
            childElement:destroy()
        end
    end
end

function Element:addChild(child)
    table.insert(self.children, child)
end

function Element:removeChild(childId)
    for i, c in ipairs(self.children) do
        if c.id == childId then
            table.remove(self.children, i)
            break
        end
    end

    if self.events.OnChildRemove then
        for _, callback in ipairs(self.events.OnChildRemove) do
            callback()
        end
    end
end

function Element:setVisible(visible, recursive)
    if recursive == nil then
        recursive = true
    end

    self.visible = visible

    if recursive then
        for _, child in pairs(self.children) do
            local childElement = Core:hasElement(child)
            if childElement then
                childElement:setVisible(visible, recursive)
            end
        end
    end

    if self.events.OnVisibleChange then
        for _, callback in ipairs(self.events.OnVisibleChange) do
            callback()
        end
    end
end

function Element:isVisible()
    return self.visible
end

function Element:setDisabled(disabled)
    self.disabled = disabled
end

function Element:isDisabled()
    return self.disabled
end

function Element:setPosition(position)
    self.position = position
end

function Element:setSize(size)
    self.size = size
end

function Element:setPostGUI(postGUI)
    self.postGUI = postGUI
end

function Element:setAlpha(alpha)
    self.alpha = alpha
end

function Element:virtual_render(children)
    if not self:isVisible() then
        return
    end

    if self.render then
        self:render()
    end

    for _, child in ipairs(children) do
        local childElement = Core:hasElement(child.element)
        if childElement and childElement.renderMode == Element.renderMode.Normal then
            childElement:virtual_render(child.children)
        end
    end
end

function Element:virtual_callEvent(event, ...)
    if self.events[event] then
        for _, callback in ipairs(self.events[event]) do
            callback(...)
        end
    end
end

function Element:callRecursiveEvent(event, ...)
    if self.events[event] then
        for _, callback in ipairs(self.events[event]) do
            callback(...)
        end
    end

    local parent = Core:hasElement(self.parent)
    if parent then
        local args = { ... }
        local callLevel = args[#args] or 0
        args[#args] = callLevel + 1

        parent:callRecursiveEvent(event, unpack(args))
    end
end

function Element:setParent(parent)
    self.parent = parent.id
    parent:addChild(self.id)

    Core:reOrderElements()

    if parent.events.OnChildAdd then
        local callLevel = 0
        parent:callRecursiveEvent(Element.events.OnChildAdd, self, callLevel)
    end
end

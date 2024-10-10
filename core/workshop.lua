Workshop = {}

function Workshop:new(...)
    return new(self, ...)
end

function Workshop:constructor()
    self.elements = {}
end

function Workshop:show()
    local window = Window:new(Vector2(0, 0), Vector2(1400, 900), 'UIKit - Workshop (' .. Core.version .. ')')
    window:toCenter()
    window:setTitlebarVisible(true)

    local tabs = Tabs:new(window.content.position, window.content.size, Tabs.placement.Start, Tabs.variants.Solid, Element.color.Dark, Element.size.Medium)
    tabs:setParent(window)

    for type, cb in pairs(self.elements) do
        local tab = Tab:new(type, nil, tabs)
        cb(tabs, tab)
    end
end

function Workshop:registerElement(type, callback)
    self.elements[type] = callback
end

Workshop = Workshop:new()

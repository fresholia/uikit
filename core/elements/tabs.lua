Tabs = inherit(Element)
Tabs.placement = {
    Top = 'top',
    Bottom = 'bottom',
    Start = 'start',
    End = 'end',
}
Tabs.variants = {
    Solid = 'solid',
    Underlined = 'underlined',
    Bordered = 'bordered',
    Light = 'light',
}

function Tabs:constructor(_, _, placement, variant, color, tabsSize)
    self.type = ElementType.Tabs
    self.tabs = {}

    self.theme = TabsTheme:new()

    self.placement = placement or Tabs.placement.Top
    self.variant = variant or Tabs.variants.Solid
    self.color = color or Element.color.Dark
    self.tabsSize = tabsSize or Element.size.Medium

    self.activeTab = nil

    self.tabActivePositionMap = {}
    self:doPulse()

    self:createEvent(Element.events.OnChildAdd, bind(self.onChildAdd, self))
    self:createEvent(Element.events.OnChildRemove, bind(self.onChildRemove, self))
end

function Tabs:setActiveTab(tab)
    if not tab then
        return
    end

    if self.activeTab == tab.id then
        return
    end

    self.activeTab = tab.id

    for i = 1, #self.tabs do
        local tabElement = self.tabs[i]
        if tabElement then
            tabElement:setActive(tabElement.id == tab.id)
        end
    end

    -- # Skip animation
    if not self.activeTabRect then
        self:doPulse()
        return
    end

    self:animateToActiveTabRect(tab.id)
end

function Tabs:animateToActiveTabRect(id)
    local newActiveTabData = self.tabActivePositionMap[id]

    Core.animate:doPulse(self.activeTabRect.id,
            { self.activeTabRect.position.x, self.activeTabRect.position.y, 0 },
            { newActiveTabData.position.x, newActiveTabData.position.y, 0 },
            150, 'Linear', function(x, y)
                self.activeTabRect:setPosition(Vector2(x, y))
            end)

    Core.animate:doPulse(self.activeTabRect.id .. 'size',
            { self.activeTabRect.size.x, self.activeTabRect.size.y, 0 },
            { newActiveTabData.size.x, newActiveTabData.size.y, 0 },
            150, 'Linear', function(x, y)
                self.activeTabRect:setSize(Vector2(x, y), true)

                if x == newActiveTabData.size.x then
                    self.activeTabRect:setSize(Vector2(x, y), false)
                end
            end)
end

function Tabs:getTabHeight()
    local padding = self.theme:getProperty('padding')[self.tabsSize]

    return dxGetFontHeight(padding.fontSize, self.theme:getProperty('font')) + padding.y * 2
end

function Tabs:setFitTabs(fitTabs)
    self.fitTabs = fitTabs
    self:doPulse()
end

function Tabs:getLayout()
    local layout = {}

    local gap = self.theme:getProperty('gap')[self.tabsSize]
    local innerPadding = self.theme:getProperty('innerPadding')
    local tabHeight = self:getTabHeight()
    local padding = self.theme:getProperty('padding')[self.tabsSize]

    if self.placement == Tabs.placement.Top then
        local tabsListSize = {
            x = self.size.x,
            y = tabHeight + innerPadding.y * 2
        }

        layout.tabsListSize = tabsListSize
        layout.tabsListPosition = self.position

        local contentSize = {
            x = self.size.x,
            y = self.size.y - tabsListSize.y - gap
        }

        layout.contentSize = contentSize

        local contentPosition = {
            x = self.position.x,
            y = self.position.y + tabsListSize.y + gap
        }

        layout.contentPosition = contentPosition
    elseif self.placement == Tabs.placement.Bottom then
        local contentSize = {
            x = self.size.x,
            y = self.size.y - tabHeight - innerPadding.y * 2
        }

        layout.contentSize = contentSize

        local contentPosition = {
            x = self.position.x,
            y = self.position.y
        }

        layout.contentPosition = contentPosition

        local tabsListSize = {
            x = self.size.x,
            y = tabHeight + innerPadding.y * 2
        }

        layout.tabsListSize = tabsListSize

        local tabsListPosition = {
            x = self.position.x,
            y = self.position.y + contentSize.y + gap
        }

        layout.tabsListPosition = tabsListPosition

    elseif self.placement == Tabs.placement.Start then
        local tabsListWidth = 0

        for i = 1, #self.tabs do
            local tab = self.tabs[i]
            if tab then
                local textWidth = dxGetTextWidth(tab.label, padding.fontSize, self.theme:getProperty('font')) + innerPadding.x * 4
                if textWidth > tabsListWidth then
                    tabsListWidth = textWidth

                    if tab.icon then
                        tabsListWidth = tabsListWidth + 30 + innerPadding.x
                    end
                end
            end
        end

        local tabsListSize = {
            x = self.size.x * 0.3,
            y = self.size.y
        }

        if self.fitTabs and tabsListWidth ~= 0 then
            tabsListSize.x = tabsListWidth
        end

        layout.tabsListSize = tabsListSize

        local tabsListPosition = {
            x = self.position.x,
            y = self.position.y
        }

        layout.tabsListPosition = tabsListPosition

        local contentSize = {
            x = self.size.x - tabsListSize.x - gap,
            y = self.size.y
        }

        layout.contentSize = contentSize

        local contentPosition = {
            x = self.position.x + tabsListSize.x + gap,
            y = self.position.y
        }

        layout.contentPosition = contentPosition
    elseif self.placement == Tabs.placement.End then
        local contentSize = {
            x = self.size.x * 0.7,
            y = self.size.y
        }

        layout.contentSize = contentSize

        local contentPosition = {
            x = self.position.x,
            y = self.position.y
        }

        layout.contentPosition = contentPosition

        local tabsListSize = {
            x = self.size.x - contentSize.x - gap,
            y = self.size.y
        }

        layout.tabsListSize = tabsListSize

        local tabsListPosition = {
            x = self.position.x + contentSize.x + gap,
            y = self.position.y
        }

        layout.tabsListPosition = tabsListPosition
    end

    self.content = {
        position = {
            x = layout.contentPosition.x + innerPadding.x,
            y = layout.contentPosition.y + innerPadding.y
        },
        size = {
            x = layout.contentSize.x - innerPadding.x * 2,
            y = layout.contentSize.y - innerPadding.y * 2
        }
    }

    return layout
end

function Tabs:onChildAdd(child, level)
    if level ~= 0 then
        return
    end

    if child.type == ElementType.Tab then
        table.insert(self.tabs, child)

        if not self.activeTab then
            self.activeTab = child.id
            child:setActive(true)
        end

        self:doPulse()
    end
end

function Tabs:onChildRemove(child)

end

function Tabs:doPulse()
    self:removeChildrenExcept(ElementType.Tab)

    if self.activeTabRect then
        self.activeTabRect:destroy()
    end

    local layout = self:getLayout()

    local color = self.theme:getColor(self.color)
    local gap = self.theme:getProperty('gap')[self.tabsSize]
    local innerPadding = self.theme:getProperty('innerPadding')

    local tabsRect = Rectangle:new(layout.tabsListPosition, layout.tabsListSize, self.theme:getProperty('borderRadius'))
    tabsRect:setParent(self)
    tabsRect:setRenderIndex(-1)
    tabsRect:setColor(color.Background.element)

    local contentRect = Rectangle:new(layout.contentPosition, layout.contentSize, self.theme:getProperty('borderRadius'))
    contentRect:setParent(self)
    contentRect:setRenderIndex(-1)
    contentRect:setColor(color.Background.element)

    local bgRect = Rectangle:new(
            Vector2(0, 0), Vector2(300, 20), 4)
    bgRect:setParent(contentRect)
    bgRect:setRenderMode(Element.renderMode.Hidden)
    bgRect:setColor(color.BackgroundHover.element)

    self.activeTabRect = bgRect

    local buttonX, buttonY = tabsRect.position.x + innerPadding.x, tabsRect.position.y + innerPadding.y

    local tabsWidth = 0
    for i = 1, #self.tabs do
        local tab = self.tabs[i]
        if tab then
            local isActive = self.activeTab == tab.id
            local tabButton = Button:new(
                    Vector2(buttonX, buttonY),
                    nil,
                    tab.label,
                    Button.variants.Light,
                    self.color,
                    self.tabsSize
            )
            tabButton:setParent(contentRect)
            tabButton:setRenderIndex(10)

            if tab.icon then
                tabButton:setStartContent(tab.icon)
            end

            tabButton:createEvent(Element.events.OnClick, bind(self.setActiveTab, self, tab))

            if self.placement == Tabs.placement.Start or self.placement == Tabs.placement.End then
                tabButton:setFixedWidth(layout.tabsListSize.x - innerPadding.x * 2)
                buttonY = buttonY + tabButton.size.y + gap
            else
                buttonX = buttonX + tabButton.size.x + gap
            end

            if isActive then
                bgRect:setSize(tabButton.size, false)
                bgRect:setPosition(tabButton.position)
                bgRect:setRenderMode(Element.renderMode.Normal)
            end

            self.tabActivePositionMap[tab.id] = {
                position = tabButton.position,
                size = tabButton.size
            }

            tabsWidth = tabsWidth + tabButton.size.x + gap
        end
    end

    if self.placement == Tabs.placement.Start or self.placement == Tabs.placement.End then
        tabsRect:setSize(Vector2(layout.tabsListSize.x, buttonY - tabsRect.position.y + innerPadding.y))
    elseif tabsWidth > 0 then
        tabsRect:setSize(Vector2(tabsWidth + innerPadding.x * 2 - gap, tabsRect.size.y))
    end
end

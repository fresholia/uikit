Select = inherit(Element)
Select.variants = {
    Solid = 'solid',
    Light = 'light',
}

function Select:constructor(_, _, label, variant, color, inputSize)
    self.type = ElementType.Select

    self.label = label
    self.variant = variant or Select.variants.Solid
    self.color = color or Element.color.Dark
    self.inputSize = inputSize or Element.size.Medium

    self.selectMode = ScrollableList.selectMode.Single

    self.selections = {}
    self.items = {}

    self.isLoading = false
    self:doPulse()
end

function Select:setItems(items)
    self.items = items

    self.noDataIcon:setRenderMode(#items > 0 and Element.renderMode.Normal or Element.renderMode.Hidden)
    self.scrollableList:setItems(items)

    if #items > 0 then
        self:setIsLoading(false)
    end
end

function Select:setIsLoading(isLoading)
    self.isLoading = isLoading

    self.noDataIcon:setRenderMode(not isLoading and #self.items == 0 and Element.renderMode.Normal or Element.renderMode.Hidden)
    self.spinnerIcon:setRenderMode(isLoading and Element.renderMode.Normal or Element.renderMode.Hidden)
end

function Select:getSelections()
    if self.selectMode == ScrollableList.selectMode.Single then
        local value = nil

        for key, _ in pairs(self.selections) do
            value = key
        end

        return value
    end

    return self.selections
end

function Select:setSelectMode(selectMode)
    assert(ScrollableList.selectMode[selectMode], 'Invalid select mode for Select')

    self.selectMode = selectMode

    self.scrollableList:setSelectMode(selectMode)
end

function Select:onChangeSelection(selections)
    self.selections = selections

    if sizeArray(selections) == 0 then
        self.selectInput:setLabel(self.label)
        return
    end

    if sizeArray(selections) == 1 then
        for key, value in pairs(selections) do
            self.selectInput:setLabel(value)
        end
        return
    end

    self.selectInput:setLabel(sizeArray(selections) .. 'x')
end

function Select:doPulse()
    self:removeChildren()

    local selectInput = Input:new(self.position, self.size, self.variant, self.color, self.inputSize)
    selectInput:setParent(self)
    selectInput:setLabel(self.label)
    selectInput:setReadOnly(true)
    selectInput:setEndContent(Icon:new(Vector2(-200, -200), Vector2(20, 20), 'chevron-down', Icon.style.Solid))
    self.selectInput = selectInput

    local popover = Popover:new(Vector2(selectInput.size.x, 175), selectInput, Popover.placement.Bottom, Element.color.Dark)
    local scrollableList = ScrollableList:new(popover.position, popover.size, {})
    scrollableList:setParent(popover)
    scrollableList:setRowHeight(26)
    scrollableList:setSelectMode(self.selectMode)
    scrollableList:createEvent(Element.events.OnChange, bind(self.onChangeSelection, self))

    local noDataIcon = Icon:new(Vector2(popover.position.x + popover.size.x / 2 - 24, popover.position.y + popover.size.y / 2 - 24),
            Vector2(48, 48), 'empty-set', Icon.style.Solid)
    noDataIcon:setParent(popover)
    noDataIcon:setRenderMode(Element.renderMode.Normal)
    noDataIcon:setRenderIndex(1)
    self.noDataIcon = noDataIcon

    local spinnerIcon = Icon:new(Vector2(popover.position.x + popover.size.x / 2 - 24, popover.position.y + popover.size.y / 2 - 24),
            Vector2(48, 48), 'spinner-third', Icon.style.Solid)
    spinnerIcon:setParent(popover)
    spinnerIcon:rotate(true)
    spinnerIcon:setRenderMode(Element.renderMode.Hidden)
    spinnerIcon:setRenderIndex(999)
    self.spinnerIcon = spinnerIcon

    self.scrollableList = scrollableList
end
Workshop:registerElement(ElementType.Modal, function(tabs, tab)
    local sizesMap = {
        Modal.size.XSmall,
        Modal.size.Small,
        Modal.size.Medium,
        Modal.size.Large,
        Modal.size.XLarge,
    }

    local placementsMap = {
        Modal.placement.Top,
        Modal.placement.Center,
        Modal.placement.Bottom,
    }

    local backdropsMap = {
        Modal.backdrop.Transparent,
        Modal.backdrop.Opaque,
        Modal.backdrop.Blur,
    }

    local modalWorkshopCache = {}

    local sizeHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Size',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    sizeHeader:setParent(tab)

    local buttonX = tabs.content.position.x
    for i = 1, #sizesMap do
        local size = sizesMap[i]

        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 30),
                nil,
                size,
                Button.variants.Solid,
                Element.color.Primary,
                Element.size.Medium
        )
        button:setParent(tab)
        button:createEvent(Element.events.OnClick, function()
            if not modalWorkshopCache[size] then
                modalWorkshopCache[size] = Modal:new(nil, nil, 'Modal Size', size, nil, Modal.backdrop.Opaque, true)
                modalWorkshopCache[size]:setRenderIndex(10000)
            end

            modalWorkshopCache[size]:setVisible(true)
            modalWorkshopCache[size]:createEvent(Element.events.OnVisibleChange, function()
                if not modalWorkshopCache[size]:isVisible() then
                    modalWorkshopCache[size]:destroy()
                    modalWorkshopCache[size] = nil
                end
            end)
        end)

        buttonX = buttonX + button.size.x + 5
    end

    local placementHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 80),
            Vector2(tabs.content.size.x, 30),
            'Placement',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    placementHeader:setParent(tab)

    buttonX = tabs.content.position.x

    for i = 1, #placementsMap do
        local placement = placementsMap[i]

        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 110),
                nil,
                placement,
                Button.variants.Solid,
                Element.color.Primary,
                Element.size.Medium
        )

        button:setParent(tab)
        button:createEvent(Element.events.OnClick, function()
            if not modalWorkshopCache[placement] then
                modalWorkshopCache[placement] = Modal:new(nil, nil, 'Modal Placement', Modal.size.Medium, placement, Modal.backdrop.Opaque, true)
                modalWorkshopCache[placement]:setRenderIndex(10000)
            end

            modalWorkshopCache[placement]:setVisible(true)
            modalWorkshopCache[placement]:createEvent(Element.events.OnVisibleChange, function()
                if not modalWorkshopCache[placement]:isVisible() then
                    modalWorkshopCache[placement]:destroy()
                    modalWorkshopCache[placement] = nil
                end
            end)
        end)

        buttonX = buttonX + button.size.x + 5
    end

    local backdropHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y + 160),
            Vector2(tabs.content.size.x, 30),
            'Backdrop',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )

    backdropHeader:setParent(tab)

    buttonX = tabs.content.position.x

    for i = 1, #backdropsMap do
        local backdrop = backdropsMap[i]

        local button = Button:new(
                Vector2(buttonX, tabs.content.position.y + 190),
                nil,
                backdrop,
                Button.variants.Solid,
                Element.color.Primary,
                Element.size.Medium
        )

        button:setParent(tab)
        button:createEvent(Element.events.OnClick, function()
            if not modalWorkshopCache[backdrop] then
                modalWorkshopCache[backdrop] = Modal:new(nil, nil, 'Modal Backdrop', Modal.size.Medium, Modal.placement.Center, backdrop, true)
                modalWorkshopCache[backdrop]:setRenderIndex(10000)
            end

            modalWorkshopCache[backdrop]:setVisible(true)
            modalWorkshopCache[backdrop]:createEvent(Element.events.OnVisibleChange, function()
                if not modalWorkshopCache[backdrop]:isVisible() then
                    modalWorkshopCache[backdrop]:destroy()
                    modalWorkshopCache[backdrop] = nil
                end
            end)
        end)

        buttonX = buttonX + button.size.x + 5
    end
end)
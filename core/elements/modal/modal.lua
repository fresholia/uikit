Modal = inherit(Element)
Modal.placement = {
    Top = 'Top',
    Center = 'Center',
    Bottom = 'Bottom',
}
Modal.size = {
    XSmall = 'XSmall',
    Small = 'Small',
    Medium = 'Medium',
    Large = 'Large',
    XLarge = 'XLarge',
}
Modal.backdrop = {
    Transparent = 'Transparent',
    Opaque = 'Opaque',
    Blur = 'Blur',
}
Modal.variant = {
    Primary = 'Primary',
}

function Modal:constructor(_, _, header, modalSize, placement, backdrop, isDismissible)
    self.header = header or ''
    self.modalSize = modalSize or Modal.size.Medium
    self.type = ElementType.Modal
    self.placement = placement or Modal.placement.Center
    self.backdrop = backdrop or Modal.backdrop.Transparent
    self.isDismissible = isDismissible or false
    self.theme = ModalTheme:new()

    self.elements = {}

    self:createEvent(Element.events.OnChildAdd, bind(self.onChildAdd, self))
    self:createEvent(Element.events.OnVisibleChange, bind(self.onVisibleChange, self))

    self:setVisible(false)

    self:setRenderIndex(10000)

    self:calculateSize()
    self:calculatePosition()
    self:doPulse()
end

function Modal:onChildAdd(child)
    child:setVisible(self:isVisible())
end

function Modal:onVisibleChange()
    if self:isVisible() then
        self:doPulse()
    end

    for _, child in pairs(self.children) do
        local childElement = Core:hasElement(child)
        if childElement then
            childElement:setVisible(self:isVisible())
        end
    end
end

function Modal:calculateSize()
    self.size = self.theme:getProperty('sizes')[self.modalSize]
end

function Modal:calculatePosition()
    local innerPadding = self.theme:getProperty('innerPadding')
    local headerSize = self.theme:getProperty('headerSize')

    if self.placement == Modal.placement.Center then
        self.position = Vector2((screenSize.x / 2) - (self.size.x / 2), (screenSize.y / 2) - (self.size.y / 2))
    elseif self.placement == Modal.placement.Top then
        self.position = Vector2((screenSize.x / 2) - (self.size.x / 2), 0)
    elseif self.placement == Modal.placement.Bottom then
        self.position = Vector2((screenSize.x / 2) - (self.size.x / 2), screenSize.y - self.size.y)
    end

    self.content = {
        position = Vector2(
                self.position.x + innerPadding,
                self.position.y + innerPadding + headerSize
        ),
        size = Vector2(
                self.size.x - (innerPadding * 2),
                self.size.y - (innerPadding * 2) - headerSize
        )
    }
end

function Modal:animatePulse()
    local palette = self.theme:getColor(Modal.variant.Primary)
    local bgColor = palette.Card.original

    Core.animate:doPulse(self.elements.card.id,
            { 0, 0, 0 },
            { 255, 150, 0 },
            self.theme:getProperty('openDuration'), 'Linear', function(a, a2)
                self.elements.card:setColor(tocolor(bgColor.r, bgColor.g, bgColor.b, a))

                if self.elements.background then
                    self.elements.background:setColor(tocolor(
                            palette.Background.original.r,
                            palette.Background.original.g,
                            palette.Background.original.b, a2))
                end
            end)
end

function Modal:onRequestClose()
    if self.elements.card.isHovered then
        return
    end

    if self.isDismissible then
        self:setVisible(false)
    end
end

function Modal:doPulse()
    if not self:isVisible() then
        return
    end

    self:removeChildren()

    local sizes = self.theme:getProperty('sizes')[self.modalSize]
    local palette = self.theme:getColor(Modal.variant.Primary)
    local borderRadius = self.theme:getProperty('borderRadius')
    local headerSize = self.theme:getProperty('headerSize')
    local font = self.theme:getProperty('font')
    local innerPadding = self.theme:getProperty('innerPadding')

    if self.backdrop == Modal.backdrop.Opaque or self.backdrop == Modal.backdrop.Blur then
        local bgRect = Rectangle:new(Vector2(0, 0), screenSize, 0)
        bgRect:setColor(tocolor(palette.Background.original.r, palette.Background.original.g, palette.Background.original.b, 0))
        bgRect:setParent(self)
        bgRect:setRenderIndex(-1)
        bgRect:createEvent(Element.events.OnClick, bind(self.onRequestClose, self))

        self.elements.background = bgRect
    end

    if self.backdrop == Modal.backdrop.Blur then
        local blur = Blur:new(Vector2(0, 0), screenSize, 5)
        blur:setParent(self)
    end

    local rect = Rectangle:new(self.position, self.size, borderRadius)
    rect:setColor(tocolor(palette.Card.original.r, palette.Card.original.g, palette.Card.original.b, 0))
    rect:setParent(self)

    self.elements.card = rect

    local text = Text:new(Vector2(self.content.position.x, self.content.position.y - headerSize), self.content.size, self.header,
            font, sizes.fontSize, nil, Text.alignment.LeftTop)
    text:setParent(rect)

    local closeButton = IconButton:new(
            Vector2(self.position.x + self.size.x - headerSize - innerPadding / 2, self.position.y + innerPadding),
            nil,
            Icon:new(Vector2(0, 0), Vector2(30, 30), 'times', Icon.style.Solid),
            Button.variants.Light, Element.color.Danger, Element.size.Medium)
    closeButton:setParent(rect)
    closeButton:createEvent(Element.events.OnClick, bind(self.setVisible, self, false))

    self:animatePulse()
end

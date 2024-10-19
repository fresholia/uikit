Tab = inherit(Element)

function Tab:constructor(label, icon, parent)
    assert(parent, 'Parent is required for Tab')

    self.type = ElementType.Tab

    self.label = label
    self.icon = icon
    self.visible = false
    self.isActive = false

    self:setParent(parent)

    self:createEvent(Element.events.OnChildAdd, bind(self.onChildAdd, self))
end

function Tab:doPulse()
    -- # TODO: Fix tab child(ren) visibility
end

function Tab:setActive(isActive)
    if self.isActive == isActive then
        return
    end

    self.isActive = isActive

    if isActive then
        self:doPulse()
    end

    self:setVisible(isActive, true)
end

function Tab:onChildAdd(child, level)
    child:setVisible(self.isActive, true)
end

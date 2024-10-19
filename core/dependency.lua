--[[
    ** MODULE: Dependency **
    The Dependency module is used to define the required modules for each element type.
    This is used to ensure that all required modules are loaded before the element is created.
    Since the module is only OOP based, it is intended to be used only to load the required modules
    for performance purposes. It is still under development and is not in use.
]]--

Dependency = {}

function Dependency:new()
    return new(self, ...)
end

function Dependency:addModule(moduleAlias, requiredModules)
    if not self.modules then
        self.modules = {}
    end

    self.modules[moduleAlias] = requiredModules
end

Dependency = Dependency:new()

Dependency:addModule(ElementType.BaseInput, { ElementType.Icon, ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Blur, {})
Dependency:addModule(ElementType.Button, { ElementType.Rectangle, ElementType.Text, ElementType.Icon })
Dependency:addModule(ElementType.Chart, { ElementType.RenderTexture, ElementType.Line, ElementType.GradientFill, ElementType.Rectangle, ElementType.Tooltip, ElementType.Text, ElementType.Text })
Dependency:addModule(ElementType.Checkbox, { ElementType.Button, ElementType.Icon, ElementType.Text })
Dependency:addModule(ElementType.DatePicker, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton })
Dependency:addModule(ElementType.GradientFill, {})
Dependency:addModule(ElementType.Icon, {})
Dependency:addModule(ElementType.IconButton, { ElementType.Button })
Dependency:addModule(ElementType.Input, { ElementType.BaseInput, ElementType.Icon, ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Line, {})
Dependency:addModule(ElementType.Modal, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton })
Dependency:addModule(ElementType.Pagination, { ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Rectangle, {})
Dependency:addModule(ElementType.RenderTexture, {})
Dependency:addModule(ElementType.Skeleton, {})
Dependency:addModule(ElementType.Tab, {})
Dependency:addModule(ElementType.Tabs, { ElementType.Tab, ElementType.Rectangle, ElementType.Button, ElementType.Icon })
Dependency:addModule(ElementType.Table, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton })
Dependency:addModule(ElementType.Text, {})
Dependency:addModule(ElementType.Tooltip, { ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Window, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton })
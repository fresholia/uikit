--[[
    ** MODULE: Dependency **
    The Dependency module is used to define the required modules for each element type.
    This is used to ensure that all required modules are loaded before the element is created.
    Since the module is only OOP based, it is intended to be used only to load the required modules
    for performance purposes. It is still under development and is not in use.
]]--

Dependency = {}

function Dependency:new(...)
    return new(self, ...)
end

function Dependency:constructor()
    self.modules = {}

    self.injectedModulesMap = {}
end

function Dependency:addModule(moduleAlias, requiredModules)
    self.modules[moduleAlias] = requiredModules
end

function Dependency:inject(sourceResource, ...)
    local modules = { ... }

    if modules[1] == '*' then
        modules = {}
        for module, _ in pairs(self.modules) do
            table.insert(modules, module)
        end

        return self:inject(sourceResource, unpack(modules))
    end

    if not self.injectedModulesMap[sourceResource] then
        self.injectedModulesMap[sourceResource] = {}
    end

    local injectToStr = ''
    for i = 1, #modules do
        local module = modules[i]
        if module then
            if not self.injectedModulesMap[sourceResource][module] then
                self.injectedModulesMap[sourceResource][module] = true

                if Exporter.modules[module] then
                    local requiredModules = self.modules[module]
                    if requiredModules then
                        injectToStr = injectToStr .. self:inject(sourceResource, unpack(requiredModules))
                    end

                    injectToStr = injectToStr .. ' ' .. Exporter.modules[module]
                end
            end
        end
    end

    return injectToStr
end

Dependency = Dependency:new()

Dependency:addModule(ElementType.BaseInput, { ElementType.Icon, ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Blur, {})
Dependency:addModule(ElementType.Button, { ElementType.Rectangle, ElementType.Text, ElementType.Icon })
Dependency:addModule(ElementType.ButtonGroup, { ElementType.Button })
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
Dependency:addModule(ElementType.Table, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton, ElementType.Pagination, ElementType.Skeleton, ElementType.Checkbox })
Dependency:addModule(ElementType.Text, {})
Dependency:addModule(ElementType.Tooltip, { ElementType.Rectangle, ElementType.Text })
Dependency:addModule(ElementType.Window, { ElementType.Rectangle, ElementType.Text, ElementType.IconButton })

function import(...)
    return Dependency:inject(sourceResource, ...)
end

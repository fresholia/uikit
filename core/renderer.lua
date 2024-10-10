local Renderer = {}
Renderer.debugEnabled = false

function Renderer.render()
    Core.animate:updateFrame()

    for i = 1, #Core.elementsArray do
        local element = Core:hasElement(Core.elementsArray[i])
        if element and element:isVisible() then
            local elementTree = Core.elementsTree[element.id]
            element:virtual_render(elementTree.children)
        end
    end

    if Renderer.debugEnabled then
        dxDrawText(inspect(Core.elementsTree), 0, 0)
        --dxDrawText(inspect(map(Core.elementsArray, function(_, element) return element.type end)), 0, 0)
    end
end
createNativeEvent(ClientEventNames.onClientRender, root, Renderer.render)

Workshop:registerElement(ElementType.Icon, function(tabs, tab)
    local iconsHeader = Text:new(
            Vector2(tabs.content.position.x, tabs.content.position.y),
            Vector2(tabs.content.size.x, 30),
            'Icons',
            Core.fonts.Regular.element,
            0.6,
            nil, Text.alignment.LeftTop
    )
    iconsHeader:setParent(tab)

    local someIcons = {
        { name = 'home', style = Icon.style.Solid },
        { name = 'youtube', style = Icon.style.Brands },
        { name = 'home', style = Icon.style.Regular },
        { name = 'home', style = Icon.style.Light },

        { name = 'user', style = Icon.style.Solid },
        { name = 'discord', style = Icon.style.Brands },
        { name = 'user', style = Icon.style.Regular },
        { name = 'user', style = Icon.style.Light },

        { name = 'cog', style = Icon.style.Solid },
        { name = 'facebook', style = Icon.style.Brands },
        { name = 'cog', style = Icon.style.Regular },
        { name = 'cog', style = Icon.style.Light },

        { name = 'bell', style = Icon.style.Solid },
        { name = 'twitter', style = Icon.style.Brands },
        { name = 'bell', style = Icon.style.Regular },
        { name = 'bell', style = Icon.style.Light },

        { name = 'envelope', style = Icon.style.Solid },
        { name = 'instagram', style = Icon.style.Brands },
        { name = 'envelope', style = Icon.style.Regular },
        { name = 'envelope', style = Icon.style.Light },
    }

    local iconX = tabs.content.position.x

    for i = 1, #someIcons do
        local icon = Icon:new(
                Vector2(iconX, tabs.content.position.y + 30),
                Vector2(30, 30),
                someIcons[i].name,
                someIcons[i].style
        )
        icon:setParent(tab)

        iconX = iconX + icon.size.x + 10
    end
end)

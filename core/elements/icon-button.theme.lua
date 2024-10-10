IconButtonTheme = inherit(ButtonTheme)

function IconButtonTheme:constructor()
    ButtonTheme.constructor(self)

    self:setProperty('buttonSizes', {
        [Element.size.Small] = {
            x = 24,
            y = 24,
            iconSize = 16
        },
        [Element.size.Medium] = {
            x = 32,
            y = 32,
            iconSize = 20
        },
        [Element.size.Large] = {
            x = 40,
            y = 40,
            iconSize = 24
        },
    })
end

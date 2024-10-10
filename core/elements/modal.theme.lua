ModalTheme = inherit(Theme)

function ModalTheme:constructor()
    self:setProperty('sizes', {
        [Modal.size.XSmall] = {
            x = screenSize.x * 0.2,
            y = screenSize.y * 0.2,
            fontSize = 0.5,
        },
        [Modal.size.Small] = {
            x = screenSize.x * 0.2,
            y = screenSize.y * 0.4,
            fontSize = 0.6,
        },
        [Modal.size.Medium] = {
            x = screenSize.x * 0.3,
            y = screenSize.y * 0.5,
            fontSize = 0.6,
        },
        [Modal.size.Large] = {
            x = screenSize.x * 0.7,
            y = screenSize.y * 0.7,
            fontSize = 0.6,
        },
        [Modal.size.XLarge] = {
            x = screenSize.x * 0.9,
            y = screenSize.y * 0.9,
            fontSize = 0.6,
        },
    })
    self:setProperty('borderRadius', 12)
    self:setProperty('openDuration', 200)
    self:setProperty('innerPadding', 20)

    self:setProperty('headerSize', 40)

    self:setProperty('font', Core.fonts.Regular.element)

    self:setColor(Modal.variant.Primary, {
        Background = self:combine('DARK', 900, 0.6),
        Card = self:combine('DARK', 900, 1),
        Foreground = self:combine('WHITE', 100, 1),
    })
end
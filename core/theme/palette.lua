Palette = {}

Palette.GRAY = {
    [50] = '#f8f9fa',
    [100] = '#e9ecef',
    [200] = '#dee2e6',
    [300] = '#ced4da',
    [400] = '#adb5bd',
    [500] = '#6c757d',
    [600] = '#495057',
    [700] = '#343a40',
    [800] = '#212529',
    [900] = '#121212'
}

Palette.WHITE = {
    [50] = '#ffffff',
    [100] = '#ffffff',
    [200] = '#ffffff',
    [300] = '#ffffff',
    [400] = '#ffffff',
    [500] = '#ffffff',
    [600] = '#ffffff',
    [700] = '#ffffff',
    [800] = '#ffffff',
    [900] = '#ffffff'
}

Palette.GREEN = {
    [50] = '#ebfbee',
    [100] = '#d3f9d8',
    [200] = '#b2f2bb',
    [300] = '#8ce99a',
    [400] = '#69db7c',
    [500] = '#51cf66',
    [600] = '#40c057',
    [700] = '#37b24d',
    [800] = '#2f9e44',
    [900] = '#2b8a3e'
}

Palette.RED = {
    [50] = '#fff5f5',
    [100] = '#ffe3e3',
    [200] = '#ffc9c9',
    [300] = '#ffa8a8',
    [400] = '#ff8787',
    [500] = '#ff6b6b',
    [600] = '#fa5252',
    [700] = '#f03e3e',
    [800] = '#e03131',
    [900] = '#c92a2a'
}

Palette.YELLOW = {
    [50] = '#fff9db',
    [100] = '#fff3bf',
    [200] = '#ffec99',
    [300] = '#ffe066',
    [400] = '#ffd43b',
    [500] = '#fcc419',
    [600] = '#fab005',
    [700] = '#f59f00',
    [800] = '#f08c00',
    [900] = '#e67700'
}

Palette.BLUE = {
    [50] = '#e7f5ff',
    [100] = '#d0ebff',
    [200] = '#a5d8ff',
    [300] = '#74c0fc',
    [400] = '#4dabf7',
    [500] = '#339af0',
    [600] = '#228be6',
    [700] = '#1c7ed6',
    [800] = '#1971c2',
    [900] = '#1864ab'
}

Palette.ORANGE = {
    [50] = '#fff4e6',
    [100] = '#ffe8cc',
    [200] = '#ffd8a8',
    [300] = '#ffc078',
    [400] = '#ffa94d',
    [500] = '#ff922b',
    [600] = '#fd7e14',
    [700] = '#f76707',
    [800] = '#e8590c',
    [900] = '#d9480f'
}

Palette.BLACK = {
    [50] = '#f8f9fa',
    [100] = '#e9ecef',
    [200] = '#dee2e6',
    [300] = '#ced4da',
    [400] = '#adb5bd',
    [500] = '#6c757d',
    [600] = '#495057',
    [700] = '#343a40',
    [800] = '#212529',
    [900] = '#121212'
}

Palette.PRIMARY = Palette.BLUE
Palette.SECONDARY = Palette.GRAY
Palette.LIGHT = Palette.GRAY
Palette.DARK = Palette.BLACK
Palette.WHITE = Palette.WHITE

function hex2rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

Palette = {}

Palette.GRAY = {
    [50] = '#18181b',
    [100] = '#27272a',
    [200] = '#3f3f46',
    [300] = '#52525b',
    [400] = '#71717a',
    [500] = '#a1a1aa',
    [600] = '#d4d4d8',
    [700] = '#e4e4e7',
    [800] = '#f4f4f5',
    [900] = '#fafafa'
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
    [50] = '#052814',
    [100] = '#095028',
    [200] = '#0e793c',
    [300] = '#12a150',
    [400] = '#17c964',
    [500] = '#45d483',
    [600] = '#74dfa2',
    [700] = '#a2e9c1',
    [800] = '#d1f4e0',
    [900] = '#e8faf0'
}

Palette.RED = {
    [50] = '#310413',
    [100] = '#610726',
    [200] = '#920b3a',
    [300] = '#c20e4d',
    [400] = '#f31260',
    [500] = '#f54180',
    [600] = '#f871a0',
    [700] = '#faa0bf',
    [800] = '#fdd0df',
    [900] = '#fee7ef'
}

Palette.BLUE = {
    [50] = '#001731',
    [100] = '#002e62',
    [200] = '#004493',
    [300] = '#005bc4',
    [400] = '#006FEE',
    [500] = '#338ef7',
    [600] = '#66aaf9',
    [700] = '#99c7fb',
    [800] = '#cce3fd',
    [900] = '#e6f1fe'
}

Palette.ORANGE = {
    [50] = '#312107',
    [100] = '#62420e',
    [200] = '#936316',
    [300] = '#c4841d',
    [400] = '#f5a524',
    [500] = '#f7b750',
    [600] = '#f9c97c',
    [700] = '#fbdba7',
    [800] = '#fdedd3',
    [900] = '#fefce8'
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

Palette.PURPLE = {
    [50] = '#180828',
    [100] = '#301050',
    [200] = '#481878',
    [300] = '#6020a0',
    [400] = '#7828c8',
    [500] = '#9353d3',
    [600] = '#ae7ede',
    [700] = '#c9a9e9',
    [800] = '#e4d4f4',
    [900] = '#f2eafa'
}

Palette.LAYOUT = {
    Background = '#000000',
    Foreground = '#ECEDEE',
    Focus = '#006FEE'
}

Palette.CONTENT = {
    [1] = '#18181b',
    [2] = '#27272a',
    [3] = '#3f3f46',
    [4] = '#52525b'
}

Palette.PRIMARY = Palette.BLUE
Palette.SECONDARY = Palette.PURPLE
Palette.LIGHT = Palette.GRAY
Palette.DARK = Palette.BLACK
Palette.WHITE = Palette.WHITE

function hex2rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

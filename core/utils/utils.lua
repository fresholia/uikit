local charset = {}

for i = 48, 57 do
    table.insert(charset, string.char(i))
end

for i = 65, 90 do
    table.insert(charset, string.char(i))
end

for i = 97, 122 do
    table.insert(charset, string.char(i))
end

function string.random(length)
    if length > 0 then
        return string.random(length - 1) .. charset[math.random(1, #charset)]
    end

    return ""
end

function clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

function splitString(value)
    local values = {}

    for line in value:gmatch("[^\r\n]+") do
        table.insert(values, line)
    end

    return values
end

function rgb2hex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

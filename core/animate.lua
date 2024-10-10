Animate = {}

function Animate:new(...)
    return new(self, ...)
end

function Animate:constructor()
    self.animateData = {}
    self.nowTick = getTickCount()
end

function Animate:doPulse(key, from, to, duration, animateType, callback)
    duration = duration or 500
    animateType = animateType or 'Linear'

    self.animateData[key] = {
        tick = getTickCount(),
        from = from,
        to = to,
        duration = duration,
        animateType = animateType,
        callback = callback
    }
end

function Animate:updateFrame()
    self.nowTick = getTickCount()

    for key, data in pairs(self.animateData) do
        local startTick = data.tick

        local elapsedTime = self.nowTick - startTick
        local duration = (startTick + data.duration) - startTick
        local progress = elapsedTime / duration

        local a, b, c = interpolateBetween(
                data.from[1], data.from[2], data.from[3],
                data.to[1], data.to[2], data.to[3],
                progress, data.animateType
        )

        if data.callback then
            data.callback(a, b, c, progress)
        end

        if progress >= 1 then
            self.animateData[key] = nil
        end
    end
end
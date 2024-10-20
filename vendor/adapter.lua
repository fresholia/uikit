ClientEventNames = {
    onClientBrowserCreated = 'onClientBrowserCreated',
    onClientBrowserCursorChange = 'onClientBrowserCursorChange',
    onClientBrowserDocumentReady = 'onClientBrowserDocumentReady',
    onClientBrowserInputFocusChanged = 'onClientBrowserInputFocusChanged',
    onClientBrowserLoadingFailed = 'onClientBrowserLoadingFailed',
    onClientBrowserLoadingStart = 'onClientBrowserLoadingStart',
    onClientBrowserNavigate = 'onClientBrowserNavigate',
    onClientBrowserPopup = 'onClientBrowserPopup',
    onClientBrowserResourceBlocked = 'onClientBrowserResourceBlocked',
    onClientBrowserTooltip = 'onClientBrowserTooltip',
    onClientBrowserWhitelistChange = 'onClientBrowserWhitelistChange',
    onClientCharacter = 'onClientCharacter',
    onClientClick = 'onClientClick',
    onClientCursorMove = 'onClientCursorMove',
    onClientDoubleClick = 'onClientDoubleClick',
    onClientKey = 'onClientKey',
    onClientMouseMove = 'onClientMouseMove',
    onClientMouseWheel = 'onClientMouseWheel',
    onClientPaste = 'onClientPaste',
    onClientConsole = 'onClientConsole',
    onClientDebugMessage = 'onClientDebugMessage',
    onClientFileDownloadComplete = 'onClientFileDownloadComplete',
    onClientHUDRender = 'onClientHUDRender',
    onClientMinimize = 'onClientMinimize',
    onClientMTAFocusChange = 'onClientMTAFocusChange',
    onClientPlayerNetworkStatus = 'onClientPlayerNetworkStatus',
    onClientPreRender = 'onClientPreRender',
    onClientRender = 'onClientRender',
    onClientRestore = 'onClientRestore',
    onClientResourceFileDownload = 'onClientResourceFileDownload',
    onClientResourceStart = 'onClientResourceStart',
    onClientResourceStop = 'onClientResourceStop',
}

local events = {}
local workers = {}

function createWorker(workerName, workerFunction, interval, repetitions)
    assert(type(workerName) == 'string', 'Worker name must be a string.')
    assert(type(workerFunction) == 'function', 'Worker function must be a function.')
    assert(type(interval) == 'number', 'Worker interval must be a number.')
    assert(type(repetitions) == 'number', 'Worker repetitions must be a number.')

    if workers[workerName] then
        return false, 'Worker already exists.'
    end

    local timer = setTimer(workerFunction, interval, repetitions)
    workers[workerName] = timer

    return timer
end

function removeWorker(workerName)
    if not workers[workerName] then
        return false, 'Worker not found.'
    end

    return killTimer(workers[workerName])
end

function createEvent(eventName, eventFunction, eventRoot)
    addEvent(eventName, true)
    addEventHandler(eventName, eventRoot or resourceRoot, eventFunction)

    events[eventName] = eventFunction
end

function createNativeEvent(eventName, sourceEvent, eventFunction)
    if isEventHandlerAdded(eventName, sourceEvent, eventFunction) then
        return false, 'Event handler already exists.'
    end

    return addEventHandler(eventName, sourceEvent, eventFunction)
end

function removeNativeEvent(eventName, sourceEvent, eventFunction)
    if not isEventHandlerAdded(eventName, sourceEvent, eventFunction) then
        return false, 'Event handler not found.'
    end

    return removeEventHandler(eventName, sourceEvent, eventFunction)
end

function emitEvent(eventName, entity, ...)
    if events[eventName] then
        return triggerEvent(eventName, resourceRoot, ...)
    end

    return localPlayer and triggerServerEvent(eventName, resourceRoot, ...) or triggerClientEvent(entity, eventName, resourceRoot, ...)
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

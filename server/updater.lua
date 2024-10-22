Updater = {}

function Updater:new(...)
    return new(self, ...)
end

function Updater:constructor()
    self.filePath = 'version.cfg'
    self.hashesPath = 'hashes.json'

    self.repository = 'fresholia/uikit'
    self.branch = 'main'

    self.tempPath = 'temp'

    self.isEnabled = true

    self.version = self:getVersion()

    self.progress = {
        downloaded = 0,
        total = 0
    }

    if not File.exists(self.filePath) then
        outputDebugString('UIKit: Version file not found')
        return
    end

    self:checkVersion()
end

function Updater:complete()
    if File.exists(self.hashesPath) then
        File.delete(self.hashesPath)
    end

    if File.exists(self.filePath) then
        File.delete(self.filePath)
    end

    local file = File.new(self.hashesPath)
    file:write(toJSON(self.hashes))
    file:close()

    local versionFile = File.new(self.filePath)
    versionFile:write(self.newVersion)
    versionFile:close()

    outputDebugString('UIKit: Update completed.')

    if hasObjectPermissionTo(Resource.getThis(), 'function.restartResource', true) then
        restartResource(Resource.getThis())
    else
        outputDebugString('UIKit: Permission denied to restart resource, please restart manually')
    end
end

function Updater:downloadFile()
    local filePath = self.missingFiles[self.progress.downloaded]

    if not filePath then
        outputDebugString('UIKit: All files downloaded')
        self:complete()
        return
    end

    fetchRemote('https://raw.githubusercontent.com/' .. self.repository .. '/' .. self.branch .. '/' .. file, function(data, errno)
        if errno ~= 0 then
            outputDebugString('UIKit: Failed to download file: ' .. file)
            return
        end

        if File.exists(filePath) then
            File.delete(filePath)
        end

        local file = File.new(filePath)
        file:write(data)
        file:close()

        self.progress.downloaded = self.progress.downloaded + 1

        if self.progress.downloaded % 5 == 0 then
            local percent = math.floor(self.progress.downloaded / self.progress.total * 100)
            outputDebugString('UIKit: Downloaded ' .. percent .. '%')
        end

        self:downloadFile(self.progress.downloaded)
    end)
end

function Updater:downloadFiles()
    local localHashes = nil
    if File.exists(self.hashesPath) then
        local file = File.open(self.hashesPath)
        local data = file:read(file:getSize())
        file:close()

        localHashes = fromJSON(data)
    end

    local missingFiles = {}

    -- # Check missing files
    if localHashes then
        for path, hash in pairs(self.hashes) do
            if not localHashes[path] or localHashes[path] ~= hash then
                table.insert(missingFiles, path)
            end
        end
    else
        for path, _ in pairs(self.hashes) do
            table.insert(missingFiles, path)
        end
    end

    self.missingFiles = missingFiles
    self.progress.downloaded = 0
    self.progress.total = #missingFiles
    self:downloadFile(self.progress.downloaded + 1)
end

function Updater:downloadHashes()
    fetchRemote('https://api.github.com/repos/' .. self.repository .. '/git/trees/' .. self.branch .. '?recursive=1', function(data, errno)
        if errno ~= 0 then
            outputDebugString('UIKit: Failed to fetch files - ERR: ' .. errno)
            return
        end

        local files = fromJSON(data)
        if not files then
            outputDebugString('UIKit: Failed to parse files')
            return
        end

        local hashesMap = {}
        for _, file in ipairs(files.tree) do
            if file.type == 'blob' then
                hashesMap[file.path] = file.sha
            end
        end

        self.hashes = hashesMap
        self:downloadFiles()
    end)
end

function Updater:onVersionCheck(data, errno)
    if errno ~= 0 then
        outputDebugString('UIKit: Failed to check version')
        return
    end

    if data ~= self.version then
        if not self.isEnabled then
            outputDebugString('UIKit: New version available, but updater is disabled')
            return
        end

        self.newVersion = data

        outputDebugString('UIKit: New version available (' .. self.newVersion .. '), updating...')

        self:downloadHashes()
    else
        outputDebugString('UIKit: The resource is up to date.')
    end
end

function Updater:checkVersion()
    if not hasObjectPermissionTo(Resource.getThis(), 'function.fetchRemote', true) then
        outputDebugString('UIKit: Permission denied for updater')
        outputDebugString('UIKit: Please add fetchRemote to ACL')
        return
    end

    outputDebugString('UIKit: Checking for updates...')

    fetchRemote('https://raw.githubusercontent.com/' .. self.repository .. '/' .. self.branch .. '/version.cfg', bind(self.onVersionCheck, self))
end

function Updater:getVersion()
    local file = fileOpen(self.filePath)
    local version = fileRead(file, fileGetSize(file))
    fileClose(file)
    return version
end

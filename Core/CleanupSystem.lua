-- Core/CleanupSystem.lua
-- Sistem cleanup komprehensif

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local CleanupSystem = {
    Connections = {},
    Tweens = {},
    Interfaces = {},
    Processes = {}
}

function CleanupSystem:AddConnection(connection)
    if connection and typeof(connection) == "RBXScriptConnection" then
        table.insert(self.Connections, connection)
    end
end

function CleanupSystem:AddTween(tween)
    if tween and tween.PlaybackState == Enum.PlaybackState.Playing then
        table.insert(self.Tweens, tween)
    end
end

function CleanupSystem:AddInterface(interface)
    if interface and interface:IsA("Instance") then
        table.insert(self.Interfaces, interface)
    end
end

function CleanupSystem:AddProcess(process)
    if type(process) == "function" then
        table.insert(self.Processes, process)
    end
end

function CleanupSystem:ExecuteCleanup()
    print("🧹 Executing comprehensive cleanup...")
    
    -- Stop all connections
    for _, connection in pairs(self.Connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            pcall(function() connection:Disconnect() end)
        end
    end
    
    -- Cancel all tweens
    for _, tween in pairs(self.Tweens) do
        if tween and tween.PlaybackState == Enum.PlaybackState.Playing then
            pcall(function() tween:Cancel() end)
        end
    end
    
    -- Destroy all interfaces
    for _, interface in pairs(self.Interfaces) do
        if interface and interface:IsA("Instance") then
            pcall(function() interface:Destroy() end)
        end
    end
    
    -- Stop all processes
    for _, process in pairs(self.Processes) do
        pcall(process)
    end
    
    -- Clear all tables
    self.Connections = {}
    self.Tweens = {}
    self.Interfaces = {}
    self.Processes = {}
    
    -- Clear global variables
    _G.ChloeXFishIt = nil
    _G.ChloeXLoaded = nil
    
    print("✅ Cleanup completed! All processes stopped.")
end

-- Auto cleanup ketika game closing
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child.Name == "ChloeXCyberGUI" then
        CleanupSystem:ExecuteCleanup()
    end
end)

return CleanupSystem

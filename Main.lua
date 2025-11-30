-- Chloe X | Fish It Special Edition | Main Loader
-- GitHub: https://github.com/studentWq/roblox

local function LoadModule(moduleName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/" .. moduleName))()
    end)
    
    if success then
        return result
    else
        warn("❌ Failed to load " .. moduleName .. ": " .. result)
        return nil
    end
end

-- Load semua modules
local Config = LoadModule("Core/Config.lua")
local CleanupSystem = LoadModule("Core/CleanupSystem.lua")
local FishItBot = LoadModule("Core/FishItBot.lua")
local CyberNeonGUI = LoadModule("GUI/CyberNeonGUI.lua")
local MinimizableControls = LoadModule("GUI/MinimizableControls.lua")

-- Initialize system
print("⚡ Chloe X - Fish It Special Edition")
print("🎯 Optimized for: Fish It")
print("🎨 Cyber-Neon Transparent GUI")
print("🧹 Comprehensive Cleanup System")

-- Cleanup previous instances
if _G.ChloeXFishIt then
    pcall(function() 
        print("🔄 Cleaning up previous instance...")
        if _G.ChloeXCleanup then
            _G.ChloeXCleanup()
        end
        _G.ChloeXFishIt:Destroy() 
    end)
end

-- Register global cleanup function
_G.ChloeXCleanup = function()
    if CleanupSystem then
        CleanupSystem.ExecuteCleanup()
    end
end

-- Stop any running bot
if FishItBot and FishItBot.Enabled then
    FishItBot.Stop()
end

-- Create GUI
local success, err = pcall(function()
    local gui = CyberNeonGUI.Create()
    _G.ChloeXFishIt = gui.ScreenGui
    MinimizableControls.Create(gui, FishItBot, CleanupSystem)
    print("✅ Cyber-Neon GUI Loaded!")
    print("📍 Click − to minimize, + to expand")
    print("📍 Drag title bar to move")
    print("📍 Click × to COMPLETELY cleanup everything")
    print("🧹 Use _G.ChloeXCleanup() to manually cleanup")
end)

if not success then
    warn("❌ GUI Error: " .. err)
    print("🔧 Starting command mode...")
    
    _G.StartFishIt = function() 
        if FishItBot then FishItBot.Start() end
    end
    _G.StopFishIt = function() 
        if FishItBot then FishItBot.Stop() end
    end
    _G.FishItStats = function() 
        if FishItBot then 
            local stats = FishItBot.GetStats()
            print(string.format("🐟 %d | ⏱️ %ds | %s", 
                  stats.FishCaught, stats.RunningTime, stats.State))
        end
    end
    _G.CleanupAll = function() 
        if CleanupSystem then CleanupSystem.ExecuteCleanup() end
    end
end

return {
    Bot = FishItBot,
    Cleanup = CleanupSystem,
    GUI = _G.ChloeXFishIt,
    Version = "3.0"
}

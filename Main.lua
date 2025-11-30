-- Chloe X | Fish It Special Edition | Main Loader dengan Auto Refresh
-- GitHub: https://github.com/studentWq/roblox

local function LoadModule(moduleName)
    local success, result = pcall(function()
        -- Tambahkan cache busting parameter untuk force update
        local url = "https://raw.githubusercontent.com/studentWq/roblox/main/" .. moduleName .. "?v=" .. tick()
        return loadstring(game:HttpGet(url))()
    end)
    
    if success then
        return result
    else
        warn("❌ Failed to load " .. moduleName .. ": " .. result)
        return nil
    end
end

-- Function untuk reload script sepenuhnya
local function ReloadScript()
    print("🔄 Reloading Chloe X Script...")
    
    -- Cleanup existing instances
    if _G.ChloeXFishIt then
        pcall(function() 
            if _G.ChloeXCleanup then
                _G.ChloeXCleanup()
            end
            _G.ChloeXFishIt:Destroy() 
        end)
    end
    
    -- Clear cache
    _G.ChloeXFishIt = nil
    _G.ChloeXLoaded = nil
    _G.ChloeXCleanup = nil
    _G.ChloeXVersion = nil
    
    -- Tunggu sebentar untuk cleanup
    wait(0.5)
    
    -- Load ulang semua modules
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
    print("🔄 Auto Refresh: ENABLED")

    -- Stop any running bot
    if FishItBot and FishItBot.Enabled then
        FishItBot.Stop()
    end

    -- Create GUI
    local success, err = pcall(function()
        local gui = CyberNeonGUI.Create()
        _G.ChloeXFishIt = gui.ScreenGui
        MinimizableControls.Create(gui, FishItBot, CleanupSystem)
        print("✅ Cyber-Neon GUI Reloaded Successfully!")
        print("📍 Click − to minimize, + to expand")
        print("📍 Drag title bar to move")
        print("📍 Click ⟳ to reload latest version")
        print("📍 Click × to COMPLETELY cleanup everything")
        print("🧹 Use _G.ChloeXCleanup() to manually cleanup")
        print("🔄 Use _G.ChloeXReload() to reload script")
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
        _G.ReloadScript = ReloadScript
    end
    
    return {
        Bot = FishItBot,
        Cleanup = CleanupSystem,
        GUI = _G.ChloeXFishIt,
        Version = "3.1",
        Reload = ReloadScript
    }
end

-- Register global functions
_G.ChloeXReload = ReloadScript
_G.ChloeXCleanup = function()
    if _G.ChloeXCleanupInstance then
        _G.ChloeXCleanupInstance()
    end
end

-- Load version info
local versionInfo = {
    Version = "3.1",
    LastUpdate = "2024",
    Features = "Auto Refresh, Auto Equip Rod, Cyber-Neon GUI"
}

print("⚡ Chloe X Fishing Bot v" .. versionInfo.Version)
print("📅 Last Update: " .. versionInfo.LastUpdate)
print("🎯 Features: " .. versionInfo.Features)

-- Execute reload
return ReloadScript()

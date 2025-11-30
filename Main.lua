-- SiPETUALANG210 | Fish It Bot | Main Loader
-- GitHub: https://github.com/studentWq/roblox

local function LoadModule(moduleName)
    local success, result = pcall(function()
        local url = "https://raw.githubusercontent.com/studentWq/roblox/main/" .. moduleName
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
    print("🔄 Reloading SiPETUALANG210 Script...")
    
    -- Cleanup existing instances
    if _G.SiPETUALANG210_GUI then
        pcall(function() 
            _G.SiPETUALANG210_GUI:Destroy() 
        end)
    end
    
    -- Clear cache
    _G.SiPETUALANG210_GUI = nil
    _G.SiPETUALANG210_Loaded = nil
    
    -- Tunggu sebentar untuk cleanup
    wait(0.5)
    
    -- Load ulang semua modules
    local Config = LoadModule("Core/Config.lua")
    local CleanupSystem = LoadModule("Core/CleanupSystem.lua")
    local FishItBot = LoadModule("Core/FishItBot.lua")
    local CyberNeonGUI = LoadModule("GUI/CyberNeonGUI.lua")
    local MinimizableControls = LoadModule("GUI/MinimizableControls.lua")
    
    -- Initialize system
    print("⚡ SiPETUALANG210 - Fish It Bot")
    print("🎯 Optimized for: Fish It")
    print("🎨 Cyber-Neon Transparent GUI")
    print("🔄 Auto Refresh: ENABLED")

    -- Stop any running bot
    if FishItBot and FishItBot.Enabled then
        FishItBot.Stop()
    end

    -- Create GUI
    local success, err = pcall(function()
        local gui = CyberNeonGUI.Create()
        _G.SiPETUALANG210_GUI = gui.ScreenGui
        MinimizableControls.Create(gui, FishItBot, CleanupSystem)
        print("✅ SiPETUALANG210 GUI Loaded Successfully!")
    end)

    if not success then
        warn("❌ GUI Error: " .. err)
    end
    
    return {
        Bot = FishItBot,
        Cleanup = CleanupSystem,
        GUI = _G.SiPETUALANG210_GUI,
        Version = "1.0"
    }
end

-- Register global functions
_G.SiPETUALANG210_Reload = ReloadScript

-- Load version info
print("⚡ SiPETUALANG210 Fishing Bot v1.0")
print("🎯 Ready for Fish It!")

-- Execute reload
return ReloadScript()

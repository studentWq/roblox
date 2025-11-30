-- Core/Config.lua
-- Konfigurasi khusus untuk game Fish It dengan Auto Refresh

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Config = {
    -- Fishing configuration
    CastKey = "E",
    ReelKey = "F", 
    CastDuration = 1.5,
    WaitForBiteMin = 2,
    WaitForBiteMax = 6,
    ReelDuration = 1,
    
    -- Fish It specific detection
    FishingRodNames = {"Fishing Rod", "FishingRod", "Rod", "Fish Rod", "Fishing Pole", "Angling Rod"},
    BiteIndicators = {"Bite!", "Fish!", "Pull!", "Reel!", "Catch!", "Got one!"},
    
    -- Auto Equip settings
    AutoEquip = true,
    MaxEquipAttempts = 3,
    EquipDelay = 1.5,
    
    -- Auto Refresh settings
    AutoRefresh = true,
    RefreshCheckInterval = 30, -- Check for updates every 30 seconds
    GitHubURL = "https://github.com/studentWq/roblox",
    
    -- GUI configuration
    GUI = {
        DefaultSize = UDim2.new(0, 300, 0, 60),
        ExpandedSize = UDim2.new(0, 300, 0, 240),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 0.3,
        BackgroundColor = Color3.fromRGB(10, 10, 20)
    },
    
    -- Performance settings
    UpdateInterval = 0.1,
    MaxWaitTime = 30
}

-- Neon color scheme
Config.Colors = {
    Primary = Color3.fromRGB(0, 255, 255),   -- Cyan
    Secondary = Color3.fromRGB(255, 0, 255), -- Magenta  
    Accent = Color3.fromRGB(0, 255, 170),    -- Green Cyan
    Danger = Color3.fromRGB(255, 50, 50),    -- Red
    Success = Color3.fromRGB(50, 255, 50),   -- Green
    Warning = Color3.fromRGB(255, 255, 0),   -- Yellow
    Info = Color3.fromRGB(100, 100, 255),    -- Blue
    Refresh = Color3.fromRGB(255, 165, 0)    -- Orange
}

-- Version info
Config.Version = {
    Major = 3,
    Minor = 1,
    Patch = 0,
    String = "3.1.0",
    ReleaseDate = "2024",
    Features = "Auto Refresh, Auto Equip Rod, Cyber-Neon GUI"
}

return Config

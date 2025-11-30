-- Core/Config.lua
-- Konfigurasi khusus untuk game Fish It

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
    FishingRodNames = {"Fishing Rod", "FishingRod", "Rod", "Fish Rod"},
    BiteIndicators = {"Bite!", "Fish!", "Pull!", "Reel!", "Catch!"},
    
    -- GUI configuration
    GUI = {
        DefaultSize = UDim2.new(0, 300, 0, 60),
        ExpandedSize = UDim2.new(0, 300, 0, 220),
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
    Warning = Color3.fromRGB(255, 255, 0)    -- Yellow
}

return Config

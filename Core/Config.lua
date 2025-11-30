-- Core/Config.lua
-- Konfigurasi untuk Fish It

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
    BiteIndicators = {"Bite!", "Fish!", "Pull!", "Reel!"},
    
    -- Auto Equip settings
    AutoEquip = true,
    MaxEquipAttempts = 3
}

return Config

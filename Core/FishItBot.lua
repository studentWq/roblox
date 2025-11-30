-- Core/FishItBot.lua
-- Bot fishing khusus untuk game Fish It dengan Auto Equip Rod

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- Load config dari GitHub
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/Core/Config.lua"))()

local FishItBot = {
    Enabled = false,
    FishCaught = 0,
    StartTime = 0,
    Connection = nil,
    CurrentState = "🛑 IDLE",
    IsMinimized = false,
    ActiveProcesses = {},
    EquipAttempts = 0,
    MaxEquipAttempts = 3
}

-- Deteksi fishing rod khusus Fish It
function FishItBot:GetFishingRod()
    -- Cek di character terlebih dahulu
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            for _, rodName in pairs(Config.FishingRodNames) do
                if string.lower(tool.Name) == string.lower(rodName) then
                    return tool, true -- Return rod dan status equipped
                end
            end
        end
    end
    
    -- Cek di backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                for _, rodName in pairs(Config.FishingRodNames) do
                    if string.lower(item.Name) == string.lower(rodName) then
                        return item, false -- Return rod dan status not equipped
                    end
                end
            end
        end
    end
    
    return nil, false
end

-- Auto equip fishing rod untuk Fish It
function FishItBot:EquipRod()
    local rod, isEquipped = self:GetFishingRod()
    
    if not rod then
        self.CurrentState = "❌ NO ROD"
        return false
    end
    
    -- Jika rod sudah di-equip, langsung return true
    if isEquipped then
        return true
    end
    
    -- Jika rod belum di-equip, coba equip
    self.CurrentState = "🔧 EQUIPPING ROD"
    print("🎣 Attempting to equip fishing rod...")
    
    -- Simpan backpack reference untuk prevent errors
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then
        print("❌ Backpack not found!")
        return false
    end
    
    -- Coba equip rod
    pcall(function()
        rod.Parent = player.Character
    end)
    
    -- Tunggu equip animation
    wait(1.5)
    
    -- Verifikasi rod sudah di-equip
    local character = player.Character
    if character then
        local equippedTool = character:FindFirstChildOfClass("Tool")
        if equippedTool and equippedTool == rod then
            print("✅ Fishing rod equipped successfully!")
            self.EquipAttempts = 0 -- Reset attempts
            return true
        end
    end
    
    -- Jika gagal, coba lagi
    self.EquipAttempts = self.EquipAttempts + 1
    print("⚠️ Equip attempt " .. self.EquipAttempts .. " failed, retrying...")
    
    if self.EquipAttempts >= self.MaxEquipAttempts then
        print("❌ Max equip attempts reached, stopping bot...")
        self:Stop()
        return false
    end
    
    -- Coba method alternatif: gunakan toolbar slot
    self:AlternativeEquip()
    wait(1)
    
    return self:EquipRod() -- Recursive retry
end

-- Method alternatif untuk equip rod
function FishItBot:AlternativeEquip()
    print("🔄 Trying alternative equip method...")
    
    -- Method 1: Coba klik rod di backpack via GUI (jika ada)
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, element in pairs(gui:GetDescendants()) do
                    if element:IsA("TextButton") or element:IsA("ImageButton") then
                        local rod = self:GetFishingRod()
                        if rod and string.find(string.lower(element.Text or ""), string.lower(rod.Name)) then
                            element:FireServer("Equip")
                            return true
                        end
                    end
                end
            end
        end
    end
    
    -- Method 2: Coba gunakan number keys (1-9) untuk equip dari hotbar
    for i = 1, 9 do
        self:SendKey(tostring(i))
        wait(0.2)
        
        -- Cek jika rod sudah equipped
        local rod, isEquipped = self:GetFishingRod()
        if isEquipped then
            print("✅ Rod equipped via hotkey " .. i)
            return true
        end
    end
    
    return false
end

-- Unequip fishing rod
function FishItBot:UnequipRod()
    local rod, isEquipped = self:GetFishingRod()
    
    if rod and isEquipped then
        pcall(function()
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                rod.Parent = backpack
                print("📦 Rod unequipped to backpack")
            end
        end)
    end
end

-- Deteksi bite khusus Fish It
function FishItBot:DetectBite()
    -- Method 1: Deteksi UI Text khusus Fish It
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, element in pairs(gui:GetDescendants()) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") then
                        local text = string.upper(element.Text or "")
                        for _, indicator in pairs(Config.BiteIndicators) do
                            if string.find(text, string.upper(indicator)) then
                                if element.Visible and element.TextColor3 ~= Color3.fromRGB(255, 0, 0) then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Method 2: Deteksi partikel bubble/efek air
    local workspace = game:GetService("Workspace")
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("ParticleEmitter") then
            if string.find(string.lower(part.Name), "bubble") or string.find(string.lower(part.Name), "splash") then
                return true
            end
        end
    end
    
    -- Method 3: Deteksi sound effect (jika ada)
    local soundService = game:GetService("SoundService")
    for _, sound in pairs(soundService:GetDescendants()) do
        if sound:IsA("Sound") and sound.Playing then
            if string.find(string.lower(sound.Name), "bite") or string.find(string.lower(sound.Name), "fish") then
                return true
            end
        end
    end
    
    return false
end

-- Input key untuk Fish It
function FishItBot:SendKey(key)
    pcall(function()
        local keyCode = Enum.KeyCode[key]
        VirtualInput:SendKeyEvent(true, keyCode, false, game)
        wait(0.1)
        VirtualInput:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- Cek jika player sudah ready untuk fishing
function FishItBot:IsReadyForFishing()
    -- Cek jika character ada
    local character = player.Character
    if not character then
        self.CurrentState = "❌ NO CHARACTER"
        return false
    end
    
    -- Cek jika humanoid alive
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        self.CurrentState = "❌ PLAYER DEAD"
        return false
    end
    
    return true
end

-- Main fishing loop untuk Fish It
function FishItBot:FishLoop()
    if not self.Enabled then return end
    
    -- Cek readiness
    if not self:IsReadyForFishing() then
        wait(2)
        return
    end
    
    -- Auto equip rod
    self.CurrentState = "🔧 EQUIPPING ROD"
    if not self:EquipRod() then
        self.CurrentState = "❌ EQUIP FAILED"
        wait(2)
        return
    end
    
    -- Cast fishing
    self.CurrentState = "🎣 CASTING"
    self:SendKey(Config.CastKey)
    wait(Config.CastDuration)
    
    if not self.Enabled then return end
    
    -- Wait for bite dengan timeout
    self.CurrentState = "⏳ WAITING BITE"
    local maxWait = math.random(Config.WaitForBiteMin, Config.WaitForBiteMax)
    local startWait = tick()
    local biteDetected = false
    
    while tick() - startWait < maxWait do
        if not self.Enabled then break end
        
        if self:DetectBite() then
            biteDetected = true
            break
        end
        
        -- Small delay untuk prevent CPU overload
        wait(0.1)
    end
    
    if biteDetected and self.Enabled then
        -- Bite detected! Reel in
        self.CurrentState = "🐟 BITE DETECTED!"
        self:SendKey(Config.ReelKey)
        wait(Config.ReelDuration)
        
        -- Success catch
        self.FishCaught = self.FishCaught + 1
        self.CurrentState = "✅ FISH CAUGHT"
        print("🎉 Fish caught! Total: " .. self.FishCaught)
        
    else
        -- No bite detected, recast
        self.CurrentState = "⏰ NO BITE"
        print("🕒 No bite detected, recasting...")
    end
    
    -- Random delay antara fishing attempts (human-like)
    if self.Enabled then
        local delay = math.random(2, 5)
        wait(delay)
    end
end

function FishItBot:Start()
    if self.Enabled then 
        print("⚠️ FishIt Bot already running!")
        return 
    end
    
    self.Enabled = true
    self.FishCaught = 0
    self.StartTime = tick()
    self.EquipAttempts = 0
    self.CurrentState = "🚀 STARTING"
    
    print("🎣 FishIt Bot STARTED!")
    print("🔧 Auto Equip Rod: ENABLED")
    print("📍 Make sure you have fishing rod in backpack!")
    
    -- Main connection
    self.Connection = RunService.Heartbeat:Connect(function()
        if self.Enabled then
            self:FishLoop()
        end
    end)
end

function FishItBot:Stop()
    if not self.Enabled then return end
    
    self.Enabled = false
    self.CurrentState = "🛑 STOPPED"
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    -- Unequip rod ketika stop
    self:UnequipRod()
    
    local runTime = tick() - self.StartTime
    print("🛑 FishIt Bot STOPPED!")
    print("📊 Final Stats: " .. self.FishCaught .. " fish in " .. math.floor(runTime) .. "s")
    
    if runTime > 0 then
        local fishPerHour = (self.FishCaught / runTime) * 3600
        print("📈 Rate: " .. math.floor(fishPerHour) .. " fish/hour")
    end
end

function FishItBot:GetStats()
    local runTime = self.StartTime > 0 and (tick() - self.StartTime) or 0
    local fph = runTime > 0 and (self.FishCaught / runTime) * 3600 or 0
    return {
        FishCaught = self.FishCaught,
        RunningTime = math.floor(runTime),
        FishPerHour = math.floor(fph),
        State = self.CurrentState,
        EquipAttempts = self.EquipAttempts
    }
end

-- Function untuk manual equip rod
function FishItBot:ManualEquipRod()
    print("🔧 Manual equip rod requested...")
    return self:EquipRod()
end

-- Function untuk cek rod status
function FishItBot:GetRodStatus()
    local rod, isEquipped = self:GetFishingRod()
    if rod then
        return {
            HasRod = true,
            IsEquipped = isEquipped,
            RodName = rod.Name
        }
    else
        return {
            HasRod = false,
            IsEquipped = false,
            RodName = "None"
        }
    end
end

return FishItBot

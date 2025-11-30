-- Core/FishItBot.lua
-- Bot fishing khusus untuk game Fish It

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
    ActiveProcesses = {}
}

-- Deteksi fishing rod khusus Fish It
function FishItBot:GetFishingRod()
    -- Cek di character
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            for _, rodName in pairs(Config.FishingRodNames) do
                if string.lower(tool.Name) == string.lower(rodName) then
                    return tool
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
                        return item
                    end
                end
            end
        end
    end
    
    return nil
end

-- Equip fishing rod untuk Fish It
function FishItBot:EquipRod()
    local rod = self:GetFishingRod()
    if not rod then
        self.CurrentState = "❌ NO ROD"
        return false
    end
    
    if rod.Parent ~= player.Character then
        rod.Parent = player.Character
        wait(0.5)
    end
    
    return true
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

-- Main fishing loop untuk Fish It
function FishItBot:FishLoop()
    if not self.Enabled then return end
    
    -- Equip rod
    self.CurrentState = "🎣 EQUIPPING"
    if not self:EquipRod() then return end
    
    -- Cast
    self.CurrentState = "🎣 CASTING"
    self:SendKey(Config.CastKey)
    wait(Config.CastDuration)
    
    if not self.Enabled then return end
    
    -- Wait for bite dengan timeout
    self.CurrentState = "⏳ WAITING"
    local maxWait = math.random(Config.WaitForBiteMin, Config.WaitForBiteMax)
    local startWait = tick()
    
    while tick() - startWait < maxWait do
        if not self.Enabled then break end
        
        if self:DetectBite() then
            -- Bite detected!
            self.CurrentState = "🐟 BITE!"
            self:SendKey(Config.ReelKey)
            wait(Config.ReelDuration)
            
            self.FishCaught = self.FishCaught + 1
            self.CurrentState = "✅ CAUGHT"
            break
        end
        
        wait(0.1)
    end
    
    -- Delay antara fishing attempts
    if self.Enabled then
        wait(math.random(1, 3))
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
    self.CurrentState = "🚀 STARTING"
    
    print("🎣 FishIt Bot STARTED!")
    
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
    
    -- Unequip rod
    pcall(function()
        local character = player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                for _, rodName in pairs(Config.FishingRodNames) do
                    if string.lower(tool.Name) == string.lower(rodName) then
                        tool.Parent = player.Backpack
                        break
                    end
                end
            end
        end
    end)
    
    local runTime = tick() - self.StartTime
    print("🛑 FishIt Bot STOPPED!")
    print("📊 Final: " .. self.FishCaught .. " fish in " .. math.floor(runTime) .. "s")
end

function FishItBot:GetStats()
    local runTime = self.StartTime > 0 and (tick() - self.StartTime) or 0
    local fph = runTime > 0 and (self.FishCaught / runTime) * 3600 or 0
    return {
        FishCaught = self.FishCaught,
        RunningTime = math.floor(runTime),
        FishPerHour = math.floor(fph),
        State = self.CurrentState
    }
end

return FishItBot

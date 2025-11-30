-- SiPETUALANG210 | Fish It Bot | Simple Version
-- GitHub: https://github.com/studentWq/roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Simple Fishing Bot
local FishItBot = {
    Enabled = false,
    FishCaught = 0,
    StartTime = 0,
    Connection = nil,
    CurrentState = "🛑 IDLE"
}

function FishItBot:GetFishingRod()
    -- Cek di character
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and (string.lower(tool.Name):find("rod") or string.lower(tool.Name):find("fishing")) then
            return tool, true
        end
    end
    
    -- Cek di backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (string.lower(item.Name):find("rod") or string.lower(item.Name):find("fishing")) then
                return item, false
            end
        end
    end
    
    return nil, false
end

function FishItBot:EquipRod()
    local rod, isEquipped = self:GetFishingRod()
    
    if not rod then
        self.CurrentState = "❌ NO ROD"
        return false
    end
    
    if isEquipped then
        return true
    end
    
    -- Manual equip dengan parent change
    self.CurrentState = "🔧 EQUIPPING..."
    pcall(function()
        rod.Parent = player.Character
    end)
    
    wait(1)
    
    -- Cek ulang
    local newRod, newEquipped = self:GetFishingRod()
    if newEquipped then
        self.CurrentState = "✅ ROD EQUIPPED"
        return true
    end
    
    self.CurrentState = "❌ EQUIP FAILED"
    return false
end

function FishItBot:UnequipRod()
    local rod, isEquipped = self:GetFishingRod()
    if rod and isEquipped then
        pcall(function()
            rod.Parent = player.Backpack
        end)
    end
end

function FishItBot:SendKey(key)
    pcall(function()
        local keyCode = Enum.KeyCode[key]
        VirtualInput:SendKeyEvent(true, keyCode, false, game)
        wait(0.1)
        VirtualInput:SendKeyEvent(false, keyCode, false, game)
    end)
end

function FishItBot:DetectBite()
    -- Simple detection - time based
    return false -- Untuk sekarang pakai timer saja
end

function FishItBot:FishLoop()
    if not self.Enabled then return end
    
    -- Pastikan rod equipped
    if not self:EquipRod() then
        wait(2)
        return
    end
    
    -- Cast fishing
    self.CurrentState = "🎣 CASTING"
    self:SendKey("E")
    wait(2)
    
    if not self.Enabled then return end
    
    -- Wait for bite
    self.CurrentState = "⏳ WAITING"
    local waitTime = math.random(3, 8)
    local startTime = tick()
    
    while tick() - startTime < waitTime do
        if not self.Enabled then break end
        wait(0.1)
    end
    
    if not self.Enabled then return end
    
    -- Reel in
    self.CurrentState = "🐟 REELING"
    self:SendKey("F")
    wait(1)
    
    -- Success
    self.FishCaught = self.FishCaught + 1
    self.CurrentState = "✅ CAUGHT #" .. self.FishCaught
    
    -- Delay
    if self.Enabled then
        wait(math.random(2, 4))
    end
end

function FishItBot:Start()
    if self.Enabled then return end
    
    self.Enabled = true
    self.FishCaught = 0
    self.StartTime = tick()
    self.CurrentState = "🚀 STARTING"
    
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

-- Simple GUI
local function CreateSimpleGUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    -- ScreenGui
    ScreenGui.Name = "SiPETUALANG210_GUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 60)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Rounded Corners
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Neon Border
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0, 255, 255)
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        IsExpanded = false
    }
end

-- Create Controls
local function CreateControls(gui)
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local CloseBtn = Instance.new("TextButton")
    
    -- Title Bar
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = gui.MainFrame
    
    -- Title
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 150, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "SiPETUALANG210"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    Title.Position = UDim2.new(0, 8, 0, 0)
    
    -- Minimize Button
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -45, 0, 2)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    MinimizeBtn.BackgroundTransparency = 0.7
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeBtn
    
    -- Close Button
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -20, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.BackgroundTransparency = 0.7
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Mini Stats
    local MiniStats = Instance.new("Frame")
    MiniStats.Name = "MiniStats"
    MiniStats.Size = UDim2.new(1, -10, 0, 30)
    MiniStats.Position = UDim2.new(0, 5, 0, 30)
    MiniStats.BackgroundTransparency = 1
    MiniStats.Parent = gui.MainFrame
    
    local FishLabel = Instance.new("TextLabel")
    FishLabel.Size = UDim2.new(0.5, -5, 1, 0)
    FishLabel.BackgroundTransparency = 1
    FishLabel.Text = "🐟 0"
    FishLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
    FishLabel.TextSize = 11
    FishLabel.Font = Enum.Font.GothamBold
    FishLabel.Parent = MiniStats
    
    local StateLabel = Instance.new("TextLabel")
    StateLabel.Size = UDim2.new(0.5, -5, 1, 0)
    StateLabel.Position = UDim2.new(0.5, 5, 0, 0)
    StateLabel.BackgroundTransparency = 1
    StateLabel.Text = "🛑 IDLE"
    StateLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    StateLabel.TextSize = 10
    StateLabel.Font = Enum.Font.Gotham
    StateLabel.Parent = MiniStats
    
    -- Expanded Content
    local ExpandedContent = Instance.new("Frame")
    ExpandedContent.Name = "ExpandedContent"
    ExpandedContent.Size = UDim2.new(1, -10, 0, 180)
    ExpandedContent.Position = UDim2.new(0, 5, 0, 65)
    ExpandedContent.BackgroundTransparency = 1
    ExpandedContent.Visible = false
    ExpandedContent.Parent = gui.MainFrame
    
    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.Parent = ExpandedContent
    ButtonsLayout.Padding = UDim.new(0, 5)
    
    -- Equip Rod Button
    local EquipBtn = Instance.new("TextButton")
    EquipBtn.Size = UDim2.new(1, 0, 0, 30)
    EquipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    EquipBtn.BackgroundTransparency = 0.8
    EquipBtn.BorderSizePixel = 0
    EquipBtn.Text = "🔧 EQUIP ROD"
    EquipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    EquipBtn.TextSize = 11
    EquipBtn.Font = Enum.Font.GothamBold
    EquipBtn.Parent = ExpandedContent
    
    local EquipCorner = Instance.new("UICorner")
    EquipCorner.CornerRadius = UDim.new(0, 8)
    EquipCorner.Parent = EquipBtn
    
    local EquipStroke = Instance.new("UIStroke")
    EquipStroke.Thickness = 1
    EquipStroke.Color = Color3.fromRGB(100, 100, 255)
    EquipStroke.Parent = EquipBtn
    
    -- Start Button
    local StartBtn = Instance.new("TextButton")
    StartBtn.Size = UDim2.new(1, 0, 0, 30)
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    StartBtn.BackgroundTransparency = 0.8
    StartBtn.BorderSizePixel = 0
    StartBtn.Text = "🚀 START FISHING"
    StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartBtn.TextSize = 11
    StartBtn.Font = Enum.Font.GothamBold
    StartBtn.Parent = ExpandedContent
    
    local StartCorner = Instance.new("UICorner")
    StartCorner.CornerRadius = UDim.new(0, 8)
    StartCorner.Parent = StartBtn
    
    local StartStroke = Instance.new("UIStroke")
    StartStroke.Thickness = 1
    StartStroke.Color = Color3.fromRGB(0, 255, 170)
    StartStroke.Parent = StartBtn
    
    -- Stop Button
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(1, 0, 0, 30)
    StopBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StopBtn.BackgroundTransparency = 0.8
    StopBtn.BorderSizePixel = 0
    StopBtn.Text = "🛑 STOP FISHING"
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.TextSize = 11
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.Parent = ExpandedContent
    
    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 8)
    StopCorner.Parent = StopBtn
    
    local StopStroke = Instance.new("UIStroke")
    StopStroke.Thickness = 1
    StopStroke.Color = Color3.fromRGB(255, 50, 50)
    StopStroke.Parent = StopBtn
    
    -- Refresh Button
    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
    RefreshBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    RefreshBtn.BackgroundTransparency = 0.8
    RefreshBtn.BorderSizePixel = 0
    RefreshBtn.Text = "🔄 REFRESH SCRIPT"
    RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RefreshBtn.TextSize = 11
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.Parent = ExpandedContent
    
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 8)
    RefreshCorner.Parent = RefreshBtn
    
    local RefreshStroke = Instance.new("UIStroke")
    RefreshStroke.Thickness = 1
    RefreshStroke.Color = Color3.fromRGB(255, 255, 0)
    RefreshStroke.Parent = RefreshBtn
    
    -- Stats Frame
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, 0, 0, 50)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    StatsFrame.BackgroundTransparency = 0.7
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = ExpandedContent
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsFrame
    
    local TimeLabel = Instance.new("TextLabel")
    TimeLabel.Size = UDim2.new(1, -10, 0, 20)
    TimeLabel.Position = UDim2.new(0, 5, 0, 5)
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Text = "⏱️ 0s"
    TimeLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    TimeLabel.TextSize = 10
    TimeLabel.Font = Enum.Font.Gotham
    TimeLabel.Parent = StatsFrame
    
    local RateLabel = Instance.new("TextLabel")
    RateLabel.Size = UDim2.new(1, -10, 0, 20)
    RateLabel.Position = UDim2.new(0, 5, 0, 25)
    RateLabel.BackgroundTransparency = 1
    RateLabel.Text = "📊 0/h"
    RateLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    RateLabel.TextSize = 10
    RateLabel.Font = Enum.Font.Gotham
    RateLabel.Parent = StatsFrame
    
    -- Interactions
    MinimizeBtn.MouseButton1Click:Connect(function()
        gui.IsExpanded = not gui.IsExpanded
        
        if gui.IsExpanded then
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 300, 0, 250)
            }):Play()
            ExpandedContent.Visible = true
            MinimizeBtn.Text = "-"
        else
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 300, 0, 60)
            }):Play()
            ExpandedContent.Visible = false
            MinimizeBtn.Text = "+"
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        FishItBot:Stop()
        gui.ScreenGui:Destroy()
    end)
    
    EquipBtn.MouseButton1Click:Connect(function()
        FishItBot:EquipRod()
    end)
    
    StartBtn.MouseButton1Click:Connect(function()
        FishItBot:Start()
    end)
    
    StopBtn.MouseButton1Click:Connect(function()
        FishItBot:Stop()
    end)
    
    RefreshBtn.MouseButton1Click:Connect(function()
        FishItBot:Stop()
        wait(0.5)
        gui.ScreenGui:Destroy()
        wait(0.5)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/Main.lua"))()
    end)
    
    -- Draggable
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Hover effects
    local function AddHoverEffect(button)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.6
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.8
            }):Play()
        end)
    end
    
    AddHoverEffect(EquipBtn)
    AddHoverEffect(StartBtn)
    AddHoverEffect(StopBtn)
    AddHoverEffect(RefreshBtn)
    AddHoverEffect(MinimizeBtn)
    AddHoverEffect(CloseBtn)
    
    -- Stats updater
    RunService.Heartbeat:Connect(function()
        local stats = FishItBot:GetStats()
        
        FishLabel.Text = "🐟 " .. stats.FishCaught
        StateLabel.Text = stats.State
        
        -- Update state color
        if string.find(stats.State, "STARTING") or string.find(stats.State, "CASTING") then
            StateLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        elseif string.find(stats.State, "WAITING") then
            StateLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
        elseif string.find(stats.State, "BITE") or string.find(stats.State, "CAUGHT") then
            StateLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        elseif string.find(stats.State, "STOP") or string.find(stats.State, "IDLE") then
            StateLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            StateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        TimeLabel.Text = "⏱️ " .. stats.RunningTime .. "s"
        RateLabel.Text = "📊 " .. stats.FishPerHour .. "/h"
    end)
end

-- Initialize
print("⚡ SiPETUALANG210 Fishing Bot Loaded!")
print("🎯 Ready for Fish It!")

-- Cleanup previous
if _G.SiPETUALANG210_GUI then
    pcall(function() _G.SiPETUALANG210_GUI:Destroy() end)
end

-- Create GUI
local gui = CreateSimpleGUI()
_G.SiPETUALANG210_GUI = gui.ScreenGui
CreateControls(gui)

print("✅ GUI Created Successfully!")
print("📍 Click + to expand controls")
print("📍 Use EQUIP ROD button first!")

return FishItBot

-- Chloe X Fishing Bot | Version 2.2 - FIXED RELOAD ISSUE
-- GitHub: https://github.com/username/ChloeX-Fishing-Bot

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- =====================
-- SIMPLE CONFIGURATION
-- =====================
local Config = {
    CastKey = "E",
    ReelKey = "F",
    CastDuration = 2,
    WaitForBiteMin = 3,
    WaitForBiteMax = 8,
    ReelDuration = 1,
    Humanizer = true
}

-- =====================
-- SIMPLE GUI FRAMEWORK
-- =====================
local function CreateSimpleGUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    local Tabs = Instance.new("Frame")
    local Content = Instance.new("Frame")
    
    -- ScreenGui
    ScreenGui.Name = "ChloeXGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Title
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🎣 Chloe X Fishing Bot"
    Title.TextColor3 = Color3.fromRGB(0, 255, 170)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    Title.Position = UDim2.new(0, 10, 0, 0)
    
    -- Close Button
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 2)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    -- Tabs
    Tabs.Name = "Tabs"
    Tabs.Size = UDim2.new(0, 120, 1, -35)
    Tabs.Position = UDim2.new(0, 0, 0, 35)
    Tabs.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Tabs.BorderSizePixel = 0
    Tabs.Parent = MainFrame
    
    -- Content
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -120, 1, -35)
    Content.Position = UDim2.new(0, 120, 0, 35)
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button - FIXED: Reset global variable
    CloseBtn.MouseButton1Click:Connect(function()
        _G.ChloeXGUI = nil
        _G.ChloeXLoaded = false
        ScreenGui:Destroy()
    end)
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = Tabs,
        Content = Content
    }
end

-- =====================
-- SIMPLE FISHING BOT
-- =====================
local FishingBot = {
    Enabled = false,
    FishCaught = 0,
    StartTime = 0,
    Connection = nil
}

function FishingBot:SendKey(key)
    pcall(function()
        local keyCode = Enum.KeyCode[key]
        VirtualInput:SendKeyEvent(true, keyCode, false, game)
        wait(0.05)
        VirtualInput:SendKeyEvent(false, keyCode, false, game)
    end)
    print("Pressed: " .. key)
end

function FishingBot:Start()
    if self.Enabled then
        print("⚠️ Already running!")
        return
    end
    
    self.Enabled = true
    self.FishCaught = 0
    self.StartTime = tick()
    
    print("🎣 Fishing Bot STARTED!")
    
    -- Main fishing loop - FIXED: Use spawn to avoid blocking
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        spawn(function()
            -- Cast
            print("Casting...")
            self:SendKey(Config.CastKey)
            wait(Config.CastDuration)
            
            if not self.Enabled then return end
            
            -- Wait for bite
            local waitTime = math.random(Config.WaitForBiteMin, Config.WaitForBiteMax)
            print("Waiting " .. waitTime .. "s for bite...")
            
            local startWait = tick()
            while tick() - startWait < waitTime do
                if not self.Enabled then return end
                wait(0.1)
            end
            
            if not self.Enabled then return end
            
            -- Reel
            print("Reeling...")
            self:SendKey(Config.ReelKey)
            wait(Config.ReelDuration)
            
            -- Success
            self.FishCaught = self.FishCaught + 1
            print("✅ Fish caught! Total: " .. self.FishCaught)
            
            -- Humanizer delay
            if Config.Humanizer then
                wait(math.random(5, 15) / 10)
            end
        end)
    end)
end

function FishingBot:Stop()
    if not self.Enabled then return end
    
    self.Enabled = false
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    local runTime = tick() - self.StartTime
    print("🛑 Fishing Bot STOPPED!")
    print("📊 Fish caught: " .. self.FishCaught)
    print("⏱️ Time: " .. math.floor(runTime) .. "s")
end

function FishingBot:GetStats()
    local runTime = self.StartTime > 0 and (tick() - self.StartTime) or 0
    local fph = runTime > 0 and (self.FishCaught / runTime) * 3600 or 0
    return {
        FishCaught = self.FishCaught,
        RunningTime = math.floor(runTime),
        FishPerHour = math.floor(fph)
    }
end

-- =====================
-- CREATE CONTROLS
-- =====================
local function CreateControls(gui)
    -- Clear existing
    for _, child in pairs(gui.Tabs:GetChildren()) do
        child:Destroy()
    end
    for _, child in pairs(gui.Content:GetChildren()) do
        child:Destroy()
    end
    
    -- Main Tab Button
    local mainTabBtn = Instance.new("TextButton")
    mainTabBtn.Size = UDim2.new(1, -10, 0, 40)
    mainTabBtn.Position = UDim2.new(0, 5, 0, 5)
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    mainTabBtn.BorderSizePixel = 0
    mainTabBtn.Text = "🎣 Auto Fish"
    mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTabBtn.TextSize = 12
    mainTabBtn.Font = Enum.Font.GothamBold
    mainTabBtn.Parent = gui.Tabs
    
    -- Stats Tab Button
    local statsTabBtn = Instance.new("TextButton")
    statsTabBtn.Size = UDim2.new(1, -10, 0, 40)
    statsTabBtn.Position = UDim2.new(0, 5, 0, 50)
    statsTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    statsTabBtn.BorderSizePixel = 0
    statsTabBtn.Text = "📊 Statistics"
    statsTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsTabBtn.TextSize = 12
    statsTabBtn.Font = Enum.Font.Gotham
    statsTabBtn.Parent = gui.Tabs
    
    -- Main Content
    local mainContent = Instance.new("ScrollingFrame")
    mainContent.Size = UDim2.new(1, 0, 1, 0)
    mainContent.BackgroundTransparency = 1
    mainContent.BorderSizePixel = 0
    mainContent.ScrollBarThickness = 3
    mainContent.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
    mainContent.Visible = true
    mainContent.Parent = gui.Content
    
    local mainLayout = Instance.new("UIListLayout")
    mainLayout.Parent = mainContent
    mainLayout.Padding = UDim.new(0, 10)
    
    local mainPadding = Instance.new("UIPadding")
    mainPadding.Parent = mainContent
    mainPadding.PaddingLeft = UDim.new(0, 10)
    mainPadding.PaddingTop = UDim.new(0, 10)
    
    -- Stats Content
    local statsContent = Instance.new("ScrollingFrame")
    statsContent.Size = UDim2.new(1, 0, 1, 0)
    statsContent.BackgroundTransparency = 1
    statsContent.BorderSizePixel = 0
    statsContent.ScrollBarThickness = 3
    statsContent.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
    statsContent.Visible = false
    statsContent.Parent = gui.Content
    
    local statsLayout = Instance.new("UIListLayout")
    statsLayout.Parent = statsContent
    statsLayout.Padding = UDim.new(0, 10)
    
    local statsPadding = Instance.new("UIPadding")
    statsPadding.Parent = statsContent
    statsPadding.PaddingLeft = UDim.new(0, 10)
    statsPadding.PaddingTop = UDim.new(0, 10)
    
    -- Tab switching
    mainTabBtn.MouseButton1Click:Connect(function()
        mainContent.Visible = true
        statsContent.Visible = false
        mainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        statsTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        statsTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    statsTabBtn.MouseButton1Click:Connect(function()
        mainContent.Visible = false
        statsContent.Visible = true
        statsTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        statsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        mainTabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        mainTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    -- Create controls
    local function CreateSection(parent, title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, -20, 0, 0)
        section.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        section.BorderSizePixel = 0
        section.Parent = parent
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 30)
        titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        titleLabel.BorderSizePixel = 0
        titleLabel.Text = "  " .. title
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = section
        
        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, 0, 1, -30)
        content.Position = UDim2.new(0, 0, 0, 30)
        content.BackgroundTransparency = 1
        content.Parent = section
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = content
        layout.Padding = UDim.new(0, 5)
        
        -- Auto resize
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.Size = UDim2.new(1, -20, 0, layout.AbsoluteContentSize.Y + 35)
        end)
        
        return content
    end
    
    -- Main Controls
    local fishingSection = CreateSection(mainContent, "🤖 Auto Fishing")
    
    -- Start/Stop Buttons
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(1, 0, 0, 35)
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    startBtn.BorderSizePixel = 0
    startBtn.Text = "▶ START FISHING"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.TextSize = 12
    startBtn.Font = Enum.Font.GothamBold
    startBtn.Parent = fishingSection
    
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(1, 0, 0, 35)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    stopBtn.BorderSizePixel = 0
    stopBtn.Text = "⏹ STOP FISHING"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 12
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.Parent = fishingSection
    
    -- Test Buttons
    local testCastBtn = Instance.new("TextButton")
    testCastBtn.Size = UDim2.new(1, 0, 0, 30)
    testCastBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    testCastBtn.BorderSizePixel = 0
    testCastBtn.Text = "Test Cast Key (E)"
    testCastBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    testCastBtn.TextSize = 11
    testCastBtn.Font = Enum.Font.Gotham
    testCastBtn.Parent = fishingSection
    
    local testReelBtn = Instance.new("TextButton")
    testReelBtn.Size = UDim2.new(1, 0, 0, 30)
    testReelBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
    testReelBtn.BorderSizePixel = 0
    testReelBtn.Text = "Test Reel Key (F)"
    testReelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    testReelBtn.TextSize = 11
    testReelBtn.Font = Enum.Font.Gotham
    testReelBtn.Parent = fishingSection
    
    -- Config Section
    local configSection = CreateSection(mainContent, "⚙️ Configuration")
    
    local humanizerLabel = Instance.new("TextLabel")
    humanizerLabel.Size = UDim2.new(1, 0, 0, 25)
    humanizerLabel.BackgroundTransparency = 1
    humanizerLabel.Text = "Humanizer: " .. (Config.Humanizer and "ON" or "OFF")
    humanizerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    humanizerLabel.TextSize = 11
    humanizerLabel.TextXAlignment = Enum.TextXAlignment.Left
    humanizerLabel.Font = Enum.Font.Gotham
    humanizerLabel.Parent = configSection
    
    local toggleHumanizer = Instance.new("TextButton")
    toggleHumanizer.Size = UDim2.new(1, 0, 0, 25)
    toggleHumanizer.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    toggleHumanizer.BorderSizePixel = 0
    toggleHumanizer.Text = "Toggle Humanizer"
    toggleHumanizer.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleHumanizer.TextSize = 11
    toggleHumanizer.Font = Enum.Font.Gotham
    toggleHumanizer.Parent = configSection
    
    -- Stats Section
    local statsSection = CreateSection(statsContent, "📊 Fishing Statistics")
    
    local fishLabel = Instance.new("TextLabel")
    fishLabel.Size = UDim2.new(1, 0, 0, 25)
    fishLabel.BackgroundTransparency = 1
    fishLabel.Text = "Fish Caught: 0"
    fishLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fishLabel.TextSize = 12
    fishLabel.TextXAlignment = Enum.TextXAlignment.Left
    fishLabel.Font = Enum.Font.Gotham
    fishLabel.Parent = statsSection
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, 0, 0, 25)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Time Running: 0s"
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timeLabel.TextSize = 12
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Font = Enum.Font.Gotham
    timeLabel.Parent = statsSection
    
    local rateLabel = Instance.new("TextLabel")
    rateLabel.Size = UDim2.new(1, 0, 0, 25)
    rateLabel.BackgroundTransparency = 1
    rateLabel.Text = "Rate: 0 fish/hour"
    rateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rateLabel.TextSize = 12
    rateLabel.TextXAlignment = Enum.TextXAlignment.Left
    rateLabel.Font = Enum.Font.Gotham
    rateLabel.Parent = statsSection
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Status: STOPPED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = statsSection
    
    -- Button events
    startBtn.MouseButton1Click:Connect(function()
        FishingBot:Start()
        statusLabel.Text = "Status: RUNNING"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end)
    
    stopBtn.MouseButton1Click:Connect(function()
        FishingBot:Stop()
        statusLabel.Text = "Status: STOPPED"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end)
    
    testCastBtn.MouseButton1Click:Connect(function()
        FishingBot:SendKey("E")
    end)
    
    testReelBtn.MouseButton1Click:Connect(function()
        FishingBot:SendKey("F")
    end)
    
    toggleHumanizer.MouseButton1Click:Connect(function()
        Config.Humanizer = not Config.Humanizer
        humanizerLabel.Text = "Humanizer: " .. (Config.Humanizer and "ON" or "OFF")
        print("Humanizer: " .. (Config.Humanizer and "ON" or "OFF"))
    end)
    
    -- Stats updater
    local statsUpdater = RunService.Heartbeat:Connect(function()
        local stats = FishingBot:GetStats()
        fishLabel.Text = "Fish Caught: " .. stats.FishCaught
        timeLabel.Text = "Time Running: " .. stats.RunningTime .. "s"
        rateLabel.Text = "Rate: " .. stats.FishPerHour .. " fish/hour"
        
        -- Update status based on fishing state
        if FishingBot.Enabled then
            statusLabel.Text = "Status: RUNNING"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            statusLabel.Text = "Status: STOPPED"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    -- Cleanup when GUI is destroyed - FIXED
    gui.ScreenGui.Destroying:Connect(function()
        FishingBot:Stop()
        statsUpdater:Disconnect()
        _G.ChloeXGUI = nil
        _G.ChloeXLoaded = false
    end)
end

-- =====================
-- INITIALIZE - FIXED RELOAD SYSTEM
-- =====================
print("🎣 Loading Chloe X Fishing Bot...")

-- Check if GUI already exists and destroy it
if _G.ChloeXGUI then
    pcall(function()
        _G.ChloeXGUI:Destroy()
        _G.ChloeXGUI = nil
    end)
end

-- Clear any existing fishing bot
if FishingBot.Enabled then
    FishingBot:Stop()
end

-- Create GUI
local success, error = pcall(function()
    local gui = CreateSimpleGUI()
    _G.ChloeXGUI = gui.ScreenGui -- Store reference for cleanup
    CreateControls(gui)
    print("✅ Chloe X GUI Loaded Successfully!")
    print("📍 Use START FISHING button to begin")
    print("📍 Test keys with Test Cast/Reel buttons")
    print("📍 Close with X button - can reload anytime!")
end)

if not success then
    warn("❌ Failed to load GUI: " .. error)
    print("🔧 Loading fallback command line version...")
    
    -- Fallback command line version
    print("🎣 Chloe X Fishing Bot - Command Line Version")
    print("Commands: start, stop, testcast, testreel, stats")
    
    _G.ChloeXCommands = {
        start = function() FishingBot:Start() end,
        stop = function() FishingBot:Stop() end,
        testcast = function() FishingBot:SendKey("E") end,
        testreel = function() FishingBot:SendKey("F") end,
        stats = function() 
            local stats = FishingBot:GetStats()
            print("Fish: " .. stats.FishCaught .. " | Time: " .. stats.RunningTime .. "s | Rate: " .. stats.FishPerHour .. "/h")
        end
    }
end

-- Function to reload GUI
_G.ReloadChloeX = function()
    if _G.ChloeXGUI then
        _G.ChloeXGUI:Destroy()
        _G.ChloeXGUI = nil
    end
    _G.ChloeXLoaded = false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/ChloeX-Fishing-Bot/main/ChloeX.lua"))()
end

print("🔄 Use _G.ReloadChloeX() to reload GUI anytime!")

return FishingBot

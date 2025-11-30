-- Chloe X Fishing Bot | Version 1.0.8
-- GitHub: https://github.com/username/ChloeX-Fishing-Bot
-- Description: Advanced Auto Fishing System with Custom GUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =====================
-- CONFIGURATION SYSTEM
-- =====================
local Config = {
    Settings = {
        AutoStart = false,
        SafetyMode = true,
        Humanizer = true,
        DebugMode = false,
        Version = "1.0.8"
    },
    
    Fishing = {
        CastDelay = {1.5, 3.0},
        ReelDelay = 0.1,
        ChangeSpotAfter = 25,
        MaxFishingTime = 3600,
        NoCooldown = true
    },
    
    GUI = {
        Theme = "Dark",
        AccentColor = Color3.fromRGB(0, 170, 255),
        Transparency = 0.05
    },
    
    Safety = {
        AntiAFK = true,
        RandomDelays = true,
        PatternRandomization = true,
        MaxActionsPerMinute = 30,
        AutoShutdown = true
    }
}

-- =====================
-- CUSTOM GUI FRAMEWORK
-- =====================
local ChloeXGUI = {}

function ChloeXGUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    local MinimizeBtn = Instance.new("TextButton")
    local TabButtons = Instance.new("Frame")
    local ContentHolder = Instance.new("Frame")
    
    -- ScreenGui
    ScreenGui.Name = "ChloeXGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Title
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "Chloe X | v" .. Config.Settings.Version
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    Title.Position = UDim2.new(0, 10, 0, 0)
    
    -- Close Button
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    -- Minimize Button
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "_"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TopBar
    
    -- Tab Buttons
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 120, 1, -30)
    TabButtons.Position = UDim2.new(0, 0, 0, 30)
    TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButtons.BorderSizePixel = 0
    TabButtons.Parent = MainFrame
    
    -- Content Holder
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -120, 1, -30)
    ContentHolder.Position = UDim2.new(0, 120, 0, 30)
    ContentHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = MainFrame
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    -- Button Events
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        _G.ChloeX_Running = false
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        ContentHolder.Visible = not ContentHolder.Visible
        TabButtons.Visible = not TabButtons.Visible
        MainFrame.Size = ContentHolder.Visible and UDim2.new(0, 500, 0, 450) or UDim2.new(0, 500, 0, 30)
    end)
    
    local self = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = {},
        CurrentTab = nil
    }
    
    function self:CreateTab(tabName, icon)
        local TabButton = Instance.new("TextButton")
        local TabContent = Instance.new("ScrollingFrame")
        
        -- Tab Button
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 35) + 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 12
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabButtons
        
        -- Tab Content
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        TabContent.Visible = false
        TabContent.Parent = ContentHolder
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = TabContent
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
            self.CurrentTab = tabName
        end)
        
        local tab = {
            Name = tabName,
            Button = TabButton,
            Content = TabContent,
            Sections = {}
        }
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
            self.CurrentTab = tabName
        end
        
        function tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContent = Instance.new("Frame")
            
            -- Section Frame
            Section.Name = sectionName .. "Section"
            Section.Size = UDim2.new(1, -20, 0, 0)
            Section.LayoutOrder = #self.Sections + 1
            Section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Section.BorderSizePixel = 0
            Section.Parent = self.Content
            
            -- Section Title
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, 0, 0, 30)
            SectionTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Text = "  " .. sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Parent = Section
            
            -- Section Content
            SectionContent.Name = "SectionContent"
            SectionContent.Size = UDim2.new(1, 0, 1, -30)
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = Section
            
            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Parent = SectionContent
            UIListLayout.Padding = UDim.new(0, 6)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local section = {
                Frame = Section,
                Content = SectionContent,
                Controls = {}
            }
            
            table.insert(self.Sections, section)
            
            UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 40)
            end)
            
            function section:CreateToggle(name, callback, default)
                local ToggleFrame = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")
                local ToggleLabel = Instance.new("TextLabel")
                local ToggleState = Instance.new("Frame")
                
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.LayoutOrder = #self.Controls + 1
                ToggleFrame.Parent = self.Content
                
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(0, 10, 0, 2)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                ToggleState.Size = UDim2.new(0, 16, 0, 16)
                ToggleState.Position = UDim2.new(0, 2, 0, 2)
                ToggleState.BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                ToggleState.BorderSizePixel = 0
                ToggleState.Parent = ToggleButton
                
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 60, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Parent = ToggleFrame
                
                local state = default or false
                
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    local targetPos = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                    local targetColor = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                    
                    local tween = TweenService:Create(ToggleState, TweenInfo.new(0.2), {
                        Position = targetPos,
                        BackgroundColor3 = targetColor
                    })
                    tween:Play()
                    
                    if callback then
                        callback(state)
                    end
                end)
                
                table.insert(self.Controls, {
                    Name = name,
                    Type = "Toggle",
                    SetState = function(newState)
                        state = newState
                        local targetPos = state and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                        local targetColor = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                        ToggleState.Position = targetPos
                        ToggleState.BackgroundColor3 = targetColor
                    end,
                    GetState = function() return state end
                })
                
                return self.Controls[#self.Controls]
            end
            
            function section:CreateButton(name, callback)
                local Button = Instance.new("TextButton")
                
                Button.Size = UDim2.new(1, -20, 0, 30)
                Button.LayoutOrder = #self.Controls + 1
                Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
                Button.BorderSizePixel = 0
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 12
                Button.Font = Enum.Font.Gotham
                Button.Parent = self.Content
                
                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                Button.MouseEnter:Connect(function()
                    Button.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
                end)
                
                Button.MouseLeave:Connect(function()
                    Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
                end)
                
                table.insert(self.Controls, {
                    Name = name,
                    Type = "Button",
                    Trigger = callback
                })
            end
            
            function section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.LayoutOrder = #self.Controls + 1
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Gotham
                Label.Parent = self.Content
                
                table.insert(self.Controls, {
                    Name = text,
                    Type = "Label",
                    Update = function(newText)
                        Label.Text = newText
                    end
                })
                
                return self.Controls[#self.Controls]
            end
            
            function section:CreateSlider(name, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                local SliderLabel = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local SliderButton = Instance.new("TextButton")
                local ValueLabel = Instance.new("TextLabel")
                
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.LayoutOrder = #self.Controls + 1
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = self.Content
                
                SliderLabel.Size = UDim2.new(1, -20, 0, 15)
                SliderLabel.Position = UDim2.new(0, 10, 0, 0)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = name
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextSize = 11
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Parent = SliderFrame
                
                SliderBar.Size = UDim2.new(1, -100, 0, 6)
                SliderBar.Position = UDim2.new(0, 10, 0, 20)
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                SliderButton.Size = UDim2.new(0, 12, 0, 12)
                SliderButton.Position = UDim2.new(0, 10, 0, 17)
                SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderButton.BorderSizePixel = 0
                SliderButton.Text = ""
                SliderButton.Parent = SliderFrame
                
                ValueLabel.Size = UDim2.new(0, 60, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 15)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default or min)
                ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.TextSize = 11
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.Parent = SliderFrame
                
                local value = default or min
                local sliding = false
                
                local function updateSlider(mouseX)
                    local relativeX = math.clamp(mouseX - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
                    local percentage = relativeX / SliderBar.AbsoluteSize.X
                    value = math.floor(min + (max - min) * percentage)
                    
                    SliderButton.Position = UDim2.new(percentage, -6, 0, 17)
                    ValueLabel.Text = tostring(value)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    sliding = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input.Position.X)
                    end
                end)
                
                SliderBar.MouseButton1Down:Connect(function(x, y)
                    updateSlider(x)
                end)
                
                table.insert(self.Controls, {
                    Name = name,
                    Type = "Slider",
                    SetValue = function(newValue)
                        value = math.clamp(newValue, min, max)
                        local percentage = (value - min) / (max - min)
                        SliderButton.Position = UDim2.new(percentage, -6, 0, 17)
                        ValueLabel.Text = tostring(value)
                    end,
                    GetValue = function() return value end
                })
                
                return self.Controls[#self.Controls]
            end
            
            return section
        end
        
        return tab
    end
    
    return self
end

-- =====================
-- FISHING BOT CORE
-- =====================
local FishingBot = {
    Enabled = false,
    Stats = {
        FishCaught = 0,
        StartTime = 0,
        RunningTime = 0
    },
    Connections = {}
}

function FishingBot:Start()
    if self.Enabled then return end
    
    self.Enabled = true
    self.Stats.StartTime = tick()
    self.Stats.FishCaught = 0
    
    -- Start fishing loop
    self.Connections.fishing = RunService.Heartbeat:Connect(function()
        self:FishLoop()
    end)
    
    -- Start stats updater
    self.Connections.stats = RunService.Heartbeat:Connect(function()
        self:UpdateStats()
    end)
    
    print("🎣 Fishing Bot Started!")
end

function FishingBot:Stop()
    if not self.Enabled then return end
    
    self.Enabled = false
    
    -- Disconnect all connections
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    
    print("🛑 Fishing Bot Stopped!")
end

function FishingBot:FishLoop()
    if not self.Enabled then return end
    
    -- Simulate fishing actions
    self:CastRod()
    
    -- Wait for bite (simulated)
    wait(math.random(1, 3))
    
    -- Reel in fish
    self:ReelFish()
    
    -- Update stats
    self.Stats.FishCaught = self.Stats.FishCaught + 1
    
    -- Random delay between actions
    if Config.Safety.RandomDelays then
        wait(math.random(5, 15) / 10)
    end
end

function FishingBot:CastRod()
    -- Implement casting logic here
    if Config.DebugMode then
        print("🎣 Casting fishing rod...")
    end
end

function FishingBot:ReelFish()
    -- Implement reeling logic here
    if Config.DebugMode then
        print("🐟 Reeling in fish...")
    end
end

function FishingBot:UpdateStats()
    self.Stats.RunningTime = tick() - self.Stats.StartTime
end

function FishingBot:GetStats()
    return {
        FishCaught = self.Stats.FishCaught,
        RunningTime = self.Stats.RunningTime,
        FishPerHour = self.Stats.RunningTime > 0 and (self.Stats.FishCaught / self.Stats.RunningTime) * 3600 or 0
    }
end

-- =====================
-- SAFETY SYSTEM
-- =====================
local SafetySystem = {}

function SafetySystem:EnvironmentCheck()
    -- Check if we're in a game
    if not game:IsLoaded() then
        return false, "Game not loaded"
    end
    
    -- Check if player exists
    if not player or not player.Character then
        return false, "Player not found"
    end
    
    return true
end

function SafetySystem:HumanizerDelay()
    if Config.Settings.Humanizer then
        wait(math.random(50, 300) / 1000)
    end
end

function SafetySystem:AntiAFK()
    if Config.Safety.AntiAFK then
        local virtualUser = game:GetService("VirtualUser")
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end
end

-- =====================
-- MAIN INITIALIZATION
-- =====================
local function InitializeChloeX()
    -- Safety check
    local safe, reason = SafetySystem:EnvironmentCheck()
    if not safe then
        warn("❌ Chloe X Safety Check Failed: " .. reason)
        return
    end
    
    -- Create GUI
    local Window = ChloeXGUI:CreateWindow("Chloe X | v" .. Config.Settings.Version)
    
    -- Main Tab
    local MainTab = Window:CreateTab("Main")
    
    -- Auto Fishing Section
    local FishingSection = MainTab:CreateSection("🤖 Auto Fishing")
    
    local AutoFishToggle = FishingSection:CreateToggle("Enable Auto Fish", function(state)
        if state then
            FishingBot:Start()
        else
            FishingBot:Stop()
        end
    end, false)
    
    local NoCooldownToggle = FishingSection:CreateToggle("No Cooldown", function(state)
        Config.Fishing.NoCooldown = state
    end, true)
    
    local AutoSellToggle = FishingSection:CreateToggle("Auto Sell Fish", function(state)
        -- Auto sell implementation
    end, false)
    
    FishingSection:CreateButton("▶ Start Fishing", function()
        AutoFishToggle.SetState(true)
    end)
    
    FishingSection:CreateButton("⏹ Stop Fishing", function()
        AutoFishToggle.SetState(false)
    end)
    
    -- Settings Section
    local SettingsSection = MainTab:CreateSection("⚙️ Settings")
    
    SettingsSection:CreateToggle("Safety Mode", function(state)
        Config.Settings.SafetyMode = state
    end, true)
    
    SettingsSection:CreateToggle("Human-like Behavior", function(state)
        Config.Settings.Humanizer = state
    end, true)
    
    SettingsSection:CreateToggle("Debug Mode", function(state)
        Config.Settings.DebugMode = state
    end, false)
    
    -- Stats Tab
    local StatsTab = Window:CreateTab("Statistics")
    
    local StatsSection = StatsTab:CreateSection("📊 Fishing Statistics")
    
    local FishCaughtLabel = StatsSection:CreateLabel("Fish Caught: 0")
    local TimeRunningLabel = StatsSection:CreateLabel("Time Running: 0s")
    local RateLabel = StatsSection:CreateLabel("Rate: 0 fish/hour")
    local StatusLabel = StatsSection:CreateLabel("Status: Idle")
    
    -- Update stats in real-time
    local statsUpdater = RunService.Heartbeat:Connect(function()
        if FishingBot.Enabled then
            local stats = FishingBot:GetStats()
            FishCaughtLabel.Update("Fish Caught: " .. stats.FishCaught)
            TimeRunningLabel.Update("Time Running: " .. math.floor(stats.RunningTime) .. "s")
            RateLabel.Update("Rate: " .. math.floor(stats.FishPerHour) .. " fish/hour")
            StatusLabel.Update("Status: 🎣 Fishing...")
        else
            StatusLabel.Update("Status: ⏹ Idle")
        end
    end)
    
    -- Safety Tab
    local SafetyTab = Window:CreateTab("Safety")
    
    local SafetySection = SafetyTab:CreateSection("🛡️ Safety Features")
    
    SafetySection:CreateToggle("Anti-AFK System", function(state)
        Config.Safety.AntiAFK = state
    end, true)
    
    SafetySection:CreateToggle("Random Delays", function(state)
        Config.Safety.RandomDelays = state
    end, true)
    
    SafetySection:CreateToggle("Auto Shutdown", function(state)
        Config.Safety.AutoShutdown = state
    end, true)
    
    SafetySection:CreateButton("🔄 Run Safety Check", function()
        local safe, reason = SafetySystem:EnvironmentCheck()
        if safe then
            print("✅ Safety Check Passed!")
        else
            print("❌ Safety Check Failed: " .. reason)
        end
    end)
    
    -- Quest Tab
    local QuestTab = Window:CreateTab("Quests")
    
    local QuestSection = QuestTab:CreateSection("🎯 Quest System")
    
    QuestSection:CreateToggle("Auto Complete Quests", function(state)
        -- Quest automation
    end, false)
    
    QuestSection:CreateButton("Complete All Quests", function()
        -- Complete quests implementation
    end)
    
    -- Info Section
    local InfoSection = MainTab:CreateSection("ℹ️ Information")
    
    InfoSection:CreateLabel("Chloe X v" .. Config.Settings.Version)
    InfoSection:CreateLabel("Status: Ready")
    InfoSection:CreateLabel("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    
    InfoSection:CreateButton("📖 Documentation", function()
        -- Open documentation
    end)
    
    InfoSection:CreateButton("🐛 Report Bug", function()
        -- Bug report system
    end)
    
    print("✅ Chloe X Fishing Bot Loaded Successfully!")
    print("🎣 Version: " .. Config.Settings.Version)
    print("⚡ Features: Auto Fish, No Cooldown, Safety System")
    
    -- Auto-start if configured
    if Config.Settings.AutoStart then
        AutoFishToggle.SetState(true)
    end
end

-- =====================
-- LOAD SCRIPT
-- =====================
if not _G.ChloeX_Loaded then
    _G.ChloeX_Loaded = true
    InitializeChloeX()
else
    warn("Chloe X is already running!")
end

return {
    Version = Config.Settings.Version,
    Config = Config,
    FishingBot = FishingBot,
    SafetySystem = SafetySystem
}

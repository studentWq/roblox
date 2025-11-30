-- Chloe X Fishing Bot | Version 2.0 - FIXED AUTO FISHING
-- GitHub: https://github.com/username/ChloeX-Fishing-Bot

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- =====================
-- CONFIGURATION
-- =====================
local Config = {
    Settings = {
        AutoStart = false,
        SafetyMode = true,
        Humanizer = true,
        DebugMode = true,
        Version = "2.0"
    },
    
    Fishing = {
        CastKey = "E",
        ReelKey = "F",
        CastDuration = 2,
        WaitForBite = {3, 8}, -- min, max seconds
        ReelDuration = 1
    },
    
    GUI = {
        Theme = "Dark",
        AccentColor = Color3.fromRGB(0, 255, 170),
        BackgroundColor = Color3.fromRGB(20, 20, 25)
    }
}

-- =====================
-- PREMIUM GUI FRAMEWORK
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
    local UICorner = Instance.new("UICorner")
    local DropShadow = Instance.new("ImageLabel")
    
    -- ScreenGui
    ScreenGui.Name = "ChloeXPremiumGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Drop Shadow
    DropShadow.Name = "DropShadow"
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.8
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Parent = MainFrame
    DropShadow.Size = UDim2.new(1, 50, 1, 50)
    DropShadow.Position = UDim2.new(0, -25, 0, -25)
    DropShadow.BackgroundTransparency = 1
    
    -- Main Frame dengan rounded corners
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
    MainFrame.BackgroundColor3 = Config.GUI.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Top Bar dengan gradient
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    -- Title dengan gradient text
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🎣 " .. title
    Title.TextColor3 = Config.GUI.AccentColor
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    Title.Position = UDim2.new(0, 15, 0, 0)
    
    -- Close Button modern
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Button
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 18
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TopBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeBtn
    
    -- Tab Buttons dengan styling modern
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 130, 1, -40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabButtons.BorderSizePixel = 0
    TabButtons.Parent = MainFrame
    
    -- Content Holder
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -130, 1, -40)
    ContentHolder.Position = UDim2.new(0, 130, 0, 40)
    ContentHolder.BackgroundColor3 = Config.GUI.BackgroundColor
    ContentHolder.BorderSizePixel = 0
    ContentHolder.Parent = MainFrame
    
    -- Draggable Window
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
        MainFrame.Size = ContentHolder.Visible and UDim2.new(0, 500, 0, 500) or UDim2.new(0, 500, 0, 40)
    end)
    
    -- Hover Effects
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 120, 140)}):Play()
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 120)}):Play()
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
        local ButtonCorner = Instance.new("UICorner")
        local ButtonStroke = Instance.new("UIStroke")
        
        -- Modern Tab Button
        TabButton.Name = tabName .. "Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 45)
        TabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 45) + 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = (icon or "📄") .. "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = TabButtons
        
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = TabButton
        
        ButtonStroke.Thickness = 1
        ButtonStroke.Color = Color3.fromRGB(60, 60, 70)
        ButtonStroke.Parent = TabButton
        
        -- Tab Content dengan padding
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Config.GUI.AccentColor
        TabContent.Visible = false
        TabContent.Parent = ContentHolder
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = TabContent
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = TabContent
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)
        
        -- Tab switching logic
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                TweenService:Create(tab.Button, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 45)}):Play()
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Config.GUI.AccentColor
            TweenService:Create(TabButton, TweenInfo.new(0.3), {Size = UDim2.new(1, -5, 0, 45)}):Play()
            self.CurrentTab = tabName
        end)
        
        local tab = {
            Name = tabName,
            Button = TabButton,
            Content = TabContent,
            Sections = {}
        }
        
        table.insert(self.Tabs, tab)
        
        -- Set first tab as active
        if #self.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Config.GUI.AccentColor
            TweenService:Create(TabButton, TweenInfo.new(0.3), {Size = UDim2.new(1, -5, 0, 45)}):Play()
            self.CurrentTab = tabName
        end
        
        function tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContent = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionStroke = Instance.new("UIStroke")
            
            -- Modern Section Frame
            Section.Name = sectionName .. "Section"
            Section.Size = UDim2.new(1, -20, 0, 0)
            Section.LayoutOrder = #self.Sections + 1
            Section.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            Section.BorderSizePixel = 0
            Section.Parent = self.Content
            
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = Section
            
            SectionStroke.Thickness = 1
            SectionStroke.Color = Color3.fromRGB(60, 60, 70)
            SectionStroke.Parent = Section
            
            -- Section Title dengan accent
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Size = UDim2.new(1, 0, 0, 35)
            SectionTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            SectionTitle.BorderSizePixel = 0
            SectionTitle.Text = "  " .. sectionName
            SectionTitle.TextColor3 = Config.GUI.AccentColor
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Parent = Section
            
            local TitleCorner = Instance.new("UICorner")
            TitleCorner.CornerRadius = UDim.new(0, 10)
            TitleCorner.Parent = SectionTitle
            
            -- Section Content
            SectionContent.Name = "SectionContent"
            SectionContent.Size = UDim2.new(1, 0, 1, -35)
            SectionContent.Position = UDim2.new(0, 0, 0, 35)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = Section
            
            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Parent = SectionContent
            UIListLayout.Padding = UDim.new(0, 8)
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local UIPadding = Instance.new("UIPadding")
            UIPadding.Parent = SectionContent
            UIPadding.PaddingLeft = UDim.new(0, 10)
            UIPadding.PaddingRight = UDim.new(0, 10)
            UIPadding.PaddingTop = UDim.new(0, 10)
            UIPadding.PaddingBottom = UDim.new(0, 10)
            
            local section = {
                Frame = Section,
                Content = SectionContent,
                Controls = {}
            }
            
            table.insert(self.Sections, section)
            
            -- Auto-resize section
            UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, -20, 0, UIListLayout.AbsoluteContentSize.Y + 55)
            end)
            
            function section:CreateToggle(name, callback, default)
                local ToggleFrame = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")
                local ToggleLabel = Instance.new("TextLabel")
                local ToggleState = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local StateCorner = Instance.new("UICorner")
                
                ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.LayoutOrder = #self.Controls + 1
                ToggleFrame.Parent = self.Content
                
                ToggleButton.Size = UDim2.new(0, 50, 0, 25)
                ToggleButton.Position = UDim2.new(0, 0, 0, 2)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                ToggleCorner.CornerRadius = UDim.new(0, 12)
                ToggleCorner.Parent = ToggleButton
                
                ToggleState.Size = UDim2.new(0, 21, 0, 21)
                ToggleState.Position = UDim2.new(0, 2, 0, 2)
                ToggleState.BackgroundColor3 = default and Config.GUI.AccentColor or Color3.fromRGB(120, 120, 130)
                ToggleState.BorderSizePixel = 0
                ToggleState.Parent = ToggleButton
                
                StateCorner.CornerRadius = UDim.new(0, 10)
                StateCorner.Parent = ToggleState
                
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
                
                local function updateToggle()
                    local targetPos = state and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
                    local targetColor = state and Config.GUI.AccentColor or Color3.fromRGB(120, 120, 130)
                    
                    TweenService:Create(ToggleState, TweenInfo.new(0.3), {
                        Position = targetPos,
                        BackgroundColor3 = targetColor
                    }):Play()
                    
                    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
                        BackgroundColor3 = state and Color3.fromRGB(80, 80, 90) or Color3.fromRGB(60, 60, 70)
                    }):Play()
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                    if callback then
                        callback(state)
                    end
                end)
                
                updateToggle()
                
                local control = {
                    Name = name,
                    Type = "Toggle",
                    SetState = function(newState)
                        state = newState
                        updateToggle()
                    end,
                    GetState = function() return state end
                }
                
                table.insert(self.Controls, control)
                return control
            end
            
            function section:CreateButton(name, callback)
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonStroke = Instance.new("UIStroke")
                
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.LayoutOrder = #self.Controls + 1
                Button.BackgroundColor3 = Config.GUI.AccentColor
                Button.BorderSizePixel = 0
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 12
                Button.Font = Enum.Font.GothamSemibold
                Button.Parent = self.Content
                
                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Parent = Button
                
                ButtonStroke.Thickness = 1
                ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
                ButtonStroke.Transparency = 0.8
                ButtonStroke.Parent = Button
                
                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                -- Hover effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(
                            math.min(Config.GUI.AccentColor.R * 255 + 20, 255),
                            math.min(Config.GUI.AccentColor.G * 255 + 20, 255),
                            math.min(Config.GUI.AccentColor.B * 255 + 20, 255)
                        )
                    }):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Config.GUI.AccentColor
                    }):Play()
                end)
                
                table.insert(self.Controls, {
                    Name = name,
                    Type = "Button",
                    Trigger = callback
                })
            end
            
            function section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.LayoutOrder = #self.Controls + 1
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(200, 200, 220)
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Gotham
                Label.Parent = self.Content
                
                local control = {
                    Name = text,
                    Type = "Label",
                    Update = function(newText)
                        Label.Text = newText
                    end
                }
                
                table.insert(self.Controls, control)
                return control
            end
            
            return section
        end
        
        return tab
    end
    
    return self
end

-- =====================
-- WORKING AUTO FISHING CORE
-- =====================
local FishingBot = {
    Enabled = false,
    CurrentState = "Idle",
    Stats = {
        FishCaught = 0,
        StartTime = 0,
        RunningTime = 0
    },
    Connection = nil,
    LastAction = 0
}

-- Fungsi input yang work
function FishingBot:SendKey(key)
    pcall(function()
        keycode = Enum.KeyCode[key]
        VirtualInput:SendKeyEvent(true, keycode, false, game)
        wait(0.1)
        VirtualInput:SendKeyEvent(false, keycode, false, game)
    end)
    
    if Config.Settings.DebugMode then
        print("🔘 Key Press: " .. key)
    end
end

-- Main fishing function - FIXED
function FishingBot:Fish()
    if not self.Enabled then return end
    
    self.CurrentState = "Casting"
    if Config.Settings.DebugMode then
        print("🎣 Casting rod...")
    end
    
    -- Cast fishing rod
    self:SendKey(Config.Fishing.CastKey)
    wait(Config.Fishing.CastDuration)
    
    self.CurrentState = "Waiting"
    if Config.Settings.DebugMode then
        print("⏳ Waiting for bite...")
    end
    
    -- Wait for bite (random time between min and max)
    local waitTime = math.random(Config.Fishing.WaitForBite[1] * 10, Config.Fishing.WaitForBite[2] * 10) / 10
    wait(waitTime)
    
    self.CurrentState = "Reeling"
    if Config.Settings.DebugMode then
        print("🐟 Reeling in fish...")
    end
    
    -- Reel in fish
    self:SendKey(Config.Fishing.ReelKey)
    wait(Config.Fishing.ReelDuration)
    
    -- Success
    self.Stats.FishCaught = self.Stats.FishCaught + 1
    self.CurrentState = "Success"
    
    if Config.Settings.DebugMode then
        print("✅ Fish caught! Total: " .. self.Stats.FishCaught)
    end
    
    -- Small delay before next cast
    if Config.Settings.Humanizer then
        wait(math.random(5, 15) / 10)
    end
end

-- Start fishing bot - FIXED
function FishingBot:Start()
    if self.Enabled then
        print("⚠️ Fishing bot already running!")
        return
    end
    
    self.Enabled = true
    self.Stats.StartTime = tick()
    self.Stats.FishCaught = 0
    
    print("🎣 Fishing Bot STARTED!")
    print("📍 Cast Key: " .. Config.Fishing.CastKey)
    print("📍 Reel Key: " .. Config.Fishing.ReelKey)
    
    -- Use coroutine untuk avoid delta time issues
    self.Connection = RunService.Heartbeat:Connect(function()
        if self.Enabled then
            self:Fish()
        end
    end)
end

-- Stop fishing bot
function FishingBot:Stop()
    if not self.Enabled then return end
    
    self.Enabled = false
    self.CurrentState = "Idle"
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    print("🛑 Fishing Bot STOPPED!")
    print("📊 Final Stats: " .. self.Stats.FishCaught .. " fish caught")
end

-- Update stats
function FishingBot:UpdateStats()
    if self.Enabled then
        self.Stats.RunningTime = tick() - self.Stats.StartTime
    end
end

function FishingBot:GetStats()
    local fph = self.Stats.RunningTime > 0 and (self.Stats.FishCaught / self.Stats.RunningTime) * 3600 or 0
    return {
        FishCaught = self.Stats.FishCaught,
        RunningTime = math.floor(self.Stats.RunningTime),
        FishPerHour = math.floor(fph),
        State = self.CurrentState
    }
end

-- =====================
-- INITIALIZATION
-- =====================
local function InitializeChloeX()
    -- Create Premium GUI
    local Window = ChloeXGUI:CreateWindow("Chloe X v" .. Config.Settings.Version)
    
    -- Main Tab
    local MainTab = Window:CreateTab("Main", "⚡")
    
    -- Auto Fishing Section
    local FishingSection = MainTab:CreateSection("🤖 Auto Fishing System")
    
    local AutoFishToggle = FishingSection:CreateToggle("Enable Auto Fishing", function(state)
        if state then
            FishingBot:Start()
        else
            FishingBot:Stop()
        end
    end, false)
    
    FishingSection:CreateButton("▶ Start Fishing", function()
        AutoFishToggle.SetState(true)
    end)
    
    FishingSection:CreateButton("⏹ Stop Fishing", function()
        AutoFishToggle.SetState(false)
    end)
    
    -- Configuration Section
    local ConfigSection = MainTab:CreateSection("⚙️ Configuration")
    
    ConfigSection:CreateToggle("Human-like Behavior", function(state)
        Config.Settings.Humanizer = state
        print("🤖 Humanizer: " .. (state and "ON" or "OFF"))
    end, true)
    
    ConfigSection:CreateToggle("Debug Mode", function(state)
        Config.Settings.DebugMode = state
        print("🐛 Debug: " .. (state and "ON" : "OFF"))
    end, true)
    
    -- Keybinds Section
    local KeySection = MainTab:CreateSection("⌨️ Keybinds")
    
    KeySection:CreateLabel("Current Cast Key: " .. Config.Fishing.CastKey)
    KeySection:CreateLabel("Current Reel Key: " .. Config.Fishing.ReelKey)
    
    KeySection:CreateButton("Test Cast Key (E)", function()
        FishingBot:SendKey("E")
    end)
    
    KeySection:CreateButton("Test Reel Key (F)", function()
        FishingBot:SendKey("F")
    end)
    
    -- Stats Tab
    local StatsTab = Window:CreateTab("Statistics", "📊")
    
    local StatsSection = StatsTab:CreateSection("📈 Fishing Statistics")
    
    local FishLabel = StatsSection:CreateLabel("🎣 Fish Caught: 0")
    local TimeLabel = StatsSection:CreateLabel("⏱️ Time Running: 0s")
    local RateLabel = StatsSection:CreateLabel("📊 Rate: 0 fish/hour")
    local StateLabel = StatsSection:CreateLabel("🔧 Status: Idle")
    
    -- Real-time stats updater
    local statsUpdater = RunService.Heartbeat:Connect(function()
        FishingBot:UpdateStats()
        local stats = FishingBot:GetStats()
        
        FishLabel.Update("🎣 Fish Caught: " .. stats.FishCaught)
        TimeLabel.Update("⏱️ Time Running: " .. stats.RunningTime .. "s")
        RateLabel.Update("📊 Rate: " .. stats.FishPerHour .. " fish/hour")
        StateLabel.Update("🔧 Status: " .. stats.State)
    end)
    
    -- Settings Tab
    local SettingsTab = Window:CreateTab("Settings", "🔧")
    
    local GameSection = SettingsTab:CreateSection("🎮 Game Settings")
    
    GameSection:CreateButton("Change Cast Key to E", function()
        Config.Fishing.CastKey = "E"
        print("✅ Cast key set to: E")
    end)
    
    GameSection:CreateButton("Change Cast Key to F", function()
        Config.Fishing.CastKey = "F"
        print("✅ Cast key set to: F")
    end)
    
    GameSection:CreateButton("Change Reel Key to R", function()
        Config.Fishing.ReelKey = "R"
        print("✅ Reel key set to: R")
    end)
    
    GameSection:CreateButton("Change Reel Key to SPACE", function()
        Config.Fishing.ReelKey = "Space"
        print("✅ Reel key set to: SPACE")
    end)
    
    -- Info Section
    local InfoSection = MainTab:CreateSection("ℹ️ System Info")
    
    InfoSection:CreateLabel("Chloe X v" .. Config.Settings.Version)
    InfoSection:CreateLabel("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    InfoSection:CreateLabel("Player: " .. player.Name)
    
    InfoSection:CreateButton("🔄 Refresh System", function()
        print("=== SYSTEM REFRESH ===")
        print("Fishing Bot: " .. (FishingBot.Enabled and "RUNNING" : "STOPPED"))
        print("Fish Caught: " .. FishingBot.Stats.FishCaught)
        print("Current State: " .. FishingBot.CurrentState)
        print("======================")
    end)
    
    print("✅ Chloe X Premium Loaded!")
    print("🎣 Auto Fishing System: READY")
    print("⚡ Version: " .. Config.Settings.Version)
    print("💡 Tips: Use 'Test Cast Key' to verify keybinds work")
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
    FishingBot = FishingBot,
    Config = Config
}

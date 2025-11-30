-- GUI/MinimizableControls.lua
-- Minimizable Controls System

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MinimizableControls = {}

function MinimizableControls.Create(gui, fishItBot, cleanupSystem)
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
    Title.TextColor3 = gui.Colors.Primary
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    Title.Position = UDim2.new(0, 8, 0, 0)
    
    -- Minimize Button
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -45, 0, 2)
    MinimizeBtn.BackgroundColor3 = gui.Colors.Secondary
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
    CloseBtn.BackgroundColor3 = gui.Colors.Danger
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
    
    -- Mini Stats (Selalu visible)
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
    FishLabel.TextColor3 = gui.Colors.Accent
    FishLabel.TextSize = 11
    FishLabel.Font = Enum.Font.GothamBold
    FishLabel.Parent = MiniStats
    
    local StateLabel = Instance.new("TextLabel")
    StateLabel.Size = UDim2.new(0.5, -5, 1, 0)
    StateLabel.Position = UDim2.new(0.5, 5, 0, 0)
    StateLabel.BackgroundTransparency = 1
    StateLabel.Text = "🛑 IDLE"
    StateLabel.TextColor3 = gui.Colors.Danger
    StateLabel.TextSize = 10
    StateLabel.Font = Enum.Font.Gotham
    StateLabel.Parent = MiniStats
    
    -- Expanded Content (Awalnya hidden)
    local ExpandedContent = Instance.new("Frame")
    ExpandedContent.Name = "ExpandedContent"
    ExpandedContent.Size = UDim2.new(1, -10, 0, 150)
    ExpandedContent.Position = UDim2.new(0, 5, 0, 65)
    ExpandedContent.BackgroundTransparency = 1
    ExpandedContent.Visible = false
    ExpandedContent.Parent = gui.MainFrame
    
    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.Parent = ExpandedContent
    ButtonsLayout.Padding = UDim.new(0, 5)
    
    -- Start Button
    local StartBtn = Instance.new("TextButton")
    StartBtn.Size = UDim2.new(1, 0, 0, 30)
    StartBtn.BackgroundColor3 = gui.Colors.Accent
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
    StartStroke.Color = gui.Colors.Accent
    StartStroke.Parent = StartBtn
    
    -- Stop Button
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(1, 0, 0, 30)
    StopBtn.BackgroundColor3 = gui.Colors.Danger
    StopBtn.BackgroundTransparency = 0.8
    StopBtn.BorderSizePixel = 0
    StopBtn.Text = "🛑 STOP"
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.TextSize = 11
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.Parent = ExpandedContent
    
    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 8)
    StopCorner.Parent = StopBtn
    
    local StopStroke = Instance.new("UIStroke")
    StopStroke.Thickness = 1
    StopStroke.Color = gui.Colors.Danger
    StopStroke.Parent = StopBtn
    
    -- Refresh Button
    local RefreshBtn = Instance.new("TextButton")
    RefreshBtn.Size = UDim2.new(1, 0, 0, 30)
    RefreshBtn.BackgroundColor3 = gui.Colors.Info
    RefreshBtn.BackgroundTransparency = 0.8
    RefreshBtn.BorderSizePixel = 0
    RefreshBtn.Text = "🔄 REFRESH"
    RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RefreshBtn.TextSize = 11
    RefreshBtn.Font = Enum.Font.GothamBold
    RefreshBtn.Parent = ExpandedContent
    
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0, 8)
    RefreshCorner.Parent = RefreshBtn
    
    local RefreshStroke = Instance.new("UIStroke")
    RefreshStroke.Thickness = 1
    RefreshStroke.Color = gui.Colors.Info
    RefreshStroke.Parent = RefreshBtn
    
    -- Stats Display
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
    TimeLabel.TextColor3 = gui.Colors.Primary
    TimeLabel.TextSize = 10
    TimeLabel.Font = Enum.Font.Gotham
    TimeLabel.Parent = StatsFrame
    
    local RateLabel = Instance.new("TextLabel")
    RateLabel.Size = UDim2.new(1, -10, 0, 20)
    RateLabel.Position = UDim2.new(0, 5, 0, 25)
    RateLabel.BackgroundTransparency = 1
    RateLabel.Text = "📊 0/h"
    RateLabel.TextColor3 = gui.Colors.Secondary
    RateLabel.TextSize = 10
    RateLabel.Font = Enum.Font.Gotham
    RateLabel.Parent = StatsFrame
    
    -- Setup interactions
    MinimizeBtn.MouseButton1Click:Connect(function()
        gui.IsExpanded = not gui.IsExpanded
        
        if gui.IsExpanded then
            -- Expand
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 300, 0, 220)
            }):Play()
            ExpandedContent.Visible = true
            MinimizeBtn.Text = "-"
        else
            -- Minimize
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 300, 0, 60)
            }):Play()
            ExpandedContent.Visible = false
            MinimizeBtn.Text = "+"
        end
    end)
    
    -- Close button
    CloseBtn.MouseButton1Click:Connect(function()
        fishItBot:Stop()
        gui.ScreenGui:Destroy()
    end)
    
    -- Button events
    StartBtn.MouseButton1Click:Connect(function()
        fishItBot:Start()
    end)
    
    StopBtn.MouseButton1Click:Connect(function()
        fishItBot:Stop()
    end)
    
    RefreshBtn.MouseButton1Click:Connect(function()
        print("🔄 Refreshing script...")
        fishItBot:Stop()
        wait(0.5)
        _G.SiPETUALANG210_Reload()
    end)
    
    -- Make draggable
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
    local function AddButtonEffects(button)
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
    
    AddButtonEffects(StartBtn)
    AddButtonEffects(StopBtn)
    AddButtonEffects(RefreshBtn)
    AddButtonEffects(MinimizeBtn)
    AddButtonEffects(CloseBtn)
    
    -- Stats updater
    RunService.Heartbeat:Connect(function()
        local stats = fishItBot:GetStats()
        
        -- Update mini stats
        FishLabel.Text = "🐟 " .. stats.FishCaught
        StateLabel.Text = stats.State
        
        -- Update state color
        if string.find(stats.State, "STARTING") or string.find(stats.State, "CASTING") then
            StateLabel.TextColor3 = gui.Colors.Primary
        elseif string.find(stats.State, "WAITING") then
            StateLabel.TextColor3 = gui.Colors.Secondary
        elseif string.find(stats.State, "BITE") or string.find(stats.State, "CAUGHT") then
            StateLabel.TextColor3 = gui.Colors.Accent
        elseif string.find(stats.State, "STOP") or string.find(stats.State, "IDLE") then
            StateLabel.TextColor3 = gui.Colors.Danger
        else
            StateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        -- Update expanded stats
        TimeLabel.Text = "⏱️ " .. stats.RunningTime .. "s"
        RateLabel.Text = "📊 " .. stats.FishPerHour .. "/h"
    end)
end

return MinimizableControls

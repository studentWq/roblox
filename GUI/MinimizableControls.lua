-- GUI/MinimizableControls.lua
-- Minimizable Controls System

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/ChloeX-FishIt-Bot/main/Core/Config.lua"))()
local CyberNeonGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/ChloeX-FishIt-Bot/main/GUI/CyberNeonGUI.lua"))()

local MinimizableControls = {}

function MinimizableControls.Create(gui, fishItBot, cleanupSystem)
    -- Title Bar (Minimal)
    local TitleBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local CloseBtn = Instance.new("TextButton")
    
    -- Title Bar
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = gui.MainFrame
    
    cleanupSystem:AddInterface(TitleBar)
    
    -- Title dengan efek neon
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 120, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ Chloe X"
    Title.TextColor3 = gui.Colors.Primary
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    Title.Position = UDim2.new(0, 8, 0, 0)
    
    cleanupSystem:AddInterface(Title)
    
    -- Minimize Button
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -45, 0, 2)
    MinimizeBtn.BackgroundColor3 = gui.Colors.Secondary
    MinimizeBtn.BackgroundTransparency = 0.7
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeBtn
    
    cleanupSystem:AddInterface(MinimizeBtn)
    
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
    
    cleanupSystem:AddInterface(CloseBtn)
    
    -- Mini Stats (Selalu visible)
    local MiniStats = MinimizableControls.CreateMiniStats(gui, fishItBot, cleanupSystem)
    
    -- Expanded Content
    local ExpandedContent = MinimizableControls.CreateExpandedContent(gui, fishItBot, cleanupSystem)
    
    -- Setup interactions
    MinimizableControls.SetupInteractions(gui, fishItBot, cleanupSystem, {
        TitleBar = TitleBar,
        MinimizeBtn = MinimizeBtn,
        CloseBtn = CloseBtn,
        ExpandedContent = ExpandedContent,
        MiniStats = MiniStats
    })
end

function MinimizableControls.CreateMiniStats(gui, fishItBot, cleanupSystem)
    local MiniStats = Instance.new("Frame")
    MiniStats.Name = "MiniStats"
    MiniStats.Size = UDim2.new(1, -10, 0, 30)
    MiniStats.Position = UDim2.new(0, 5, 0, 30)
    MiniStats.BackgroundTransparency = 1
    MiniStats.Parent = gui.MainFrame
    
    cleanupSystem:AddInterface(MiniStats)
    
    local FishLabel = Instance.new("TextLabel")
    FishLabel.Size = UDim2.new(0.5, -5, 1, 0)
    FishLabel.BackgroundTransparency = 1
    FishLabel.Text = "🐟 0"
    FishLabel.TextColor3 = gui.Colors.Accent
    FishLabel.TextSize = 11
    FishLabel.Font = Enum.Font.GothamBold
    FishLabel.Parent = MiniStats
    
    cleanupSystem:AddInterface(FishLabel)
    
    local StateLabel = Instance.new("TextLabel")
    StateLabel.Size = UDim2.new(0.5, -5, 1, 0)
    StateLabel.Position = UDim2.new(0.5, 5, 0, 0)
    StateLabel.BackgroundTransparency = 1
    StateLabel.Text = "🛑 IDLE"
    StateLabel.TextColor3 = gui.Colors.Danger
    StateLabel.TextSize = 10
    StateLabel.Font = Enum.Font.Gotham
    StateLabel.Parent = MiniStats
    
    cleanupSystem:AddInterface(StateLabel)
    
    return {
        FishLabel = FishLabel,
        StateLabel = StateLabel
    }
end

function MinimizableControls.CreateExpandedContent(gui, fishItBot, cleanupSystem)
    local ExpandedContent = Instance.new("Frame")
    ExpandedContent.Name = "ExpandedContent"
    ExpandedContent.Size = UDim2.new(1, -10, 0, 150)
    ExpandedContent.Position = UDim2.new(0, 5, 0, 65)
    ExpandedContent.BackgroundTransparency = 1
    ExpandedContent.Visible = false
    ExpandedContent.Parent = gui.MainFrame
    
    cleanupSystem:AddInterface(ExpandedContent)
    
    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.Parent = ExpandedContent
    ButtonsLayout.Padding = UDim.new(0, 5)
    
    cleanupSystem:AddInterface(ButtonsLayout)
    
    -- Start Button
    local StartBtn = CyberNeonGUI.CreateNeonButton(ExpandedContent, "🚀 START FISHING", gui.Colors.Accent)
    cleanupSystem:AddInterface(StartBtn)
    
    -- Stop Button
    local StopBtn = CyberNeonGUI.CreateNeonButton(ExpandedContent, "🛑 STOP", gui.Colors.Danger)
    cleanupSystem:AddInterface(StopBtn)
    
    -- Stats Display
    local StatsFrame = MinimizableControls.CreateStatsDisplay(ExpandedContent, gui, cleanupSystem)
    
    return {
        Frame = ExpandedContent,
        StartBtn = StartBtn,
        StopBtn = StopBtn,
        StatsFrame = StatsFrame
    }
end

function MinimizableControls.CreateStatsDisplay(parent, gui, cleanupSystem)
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, 0, 0, 50)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    StatsFrame.BackgroundTransparency = 0.7
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = parent
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsFrame
    
    cleanupSystem:AddInterface(StatsFrame)
    
    local TimeLabel = Instance.new("TextLabel")
    TimeLabel.Size = UDim2.new(1, -10, 0, 20)
    TimeLabel.Position = UDim2.new(0, 5, 0, 5)
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Text = "⏱️ 0s"
    TimeLabel.TextColor3 = gui.Colors.Primary
    TimeLabel.TextSize = 10
    TimeLabel.Font = Enum.Font.Gotham
    TimeLabel.Parent = StatsFrame
    
    cleanupSystem:AddInterface(TimeLabel)
    
    local RateLabel = Instance.new("TextLabel")
    RateLabel.Size = UDim2.new(1, -10, 0, 20)
    RateLabel.Position = UDim2.new(0, 5, 0, 25)
    RateLabel.BackgroundTransparency = 1
    RateLabel.Text = "📊 0/h"
    RateLabel.TextColor3 = gui.Colors.Secondary
    RateLabel.TextSize = 10
    RateLabel.Font = Enum.Font.Gotham
    RateLabel.Parent = StatsFrame
    
    cleanupSystem:AddInterface(RateLabel)
    
    return {
        TimeLabel = TimeLabel,
        RateLabel = RateLabel
    }
end

function MinimizableControls.SetupInteractions(gui, fishItBot, cleanupSystem, elements)
    -- Toggle minimize/expand
    local minimizeConnection = elements.MinimizeBtn.MouseButton1Click:Connect(function()
        gui.IsExpanded = not gui.IsExpanded
        
        if gui.IsExpanded then
            -- Expand
            local expandTween = TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = Config.GUI.ExpandedSize
            })
            expandTween:Play()
            cleanupSystem:AddTween(expandTween)
            elements.ExpandedContent.Frame.Visible = true
            elements.MinimizeBtn.Text = "−"
        else
            -- Minimize
            local minimizeTween = TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = Config.GUI.DefaultSize
            })
            minimizeTween:Play()
            cleanupSystem:AddTween(minimizeTween)
            elements.ExpandedContent.Frame.Visible = false
            elements.MinimizeBtn.Text = "+"
        end
    end)
    cleanupSystem:AddConnection(minimizeConnection)
    
    -- COMPREHENSIVE CLOSE BUTTON - Clean semua proses
    local closeConnection = elements.CloseBtn.MouseButton1Click:Connect(function()
        print("🔴 Close button clicked - Executing full cleanup...")
        
        -- Stop fishing bot pertama
        fishItBot:Stop()
        
        -- Execute comprehensive cleanup
        cleanupSystem:ExecuteCleanup()
        
        -- Destroy GUI
        if gui.ScreenGui then
            gui.ScreenGui:Destroy()
        end
        
        print("✅ All processes terminated and GUI destroyed.")
    end)
    cleanupSystem:AddConnection(closeConnection)
    
    -- Button events
    local startConnection = elements.ExpandedContent.StartBtn.MouseButton1Click:Connect(function()
        fishItBot:Start()
    end)
    cleanupSystem:AddConnection(startConnection)
    
    local stopConnection = elements.ExpandedContent.StopBtn.MouseButton1Click:Connect(function()
        fishItBot:Stop()
    end)
    cleanupSystem:AddConnection(stopConnection)
    
    -- Setup dragging
    MinimizableControls.SetupDragging(gui, elements.TitleBar, cleanupSystem)
    
    -- Setup hover effects
    MinimizableControls.SetupHoverEffects({
        elements.ExpandedContent.StartBtn,
        elements.ExpandedContent.StopBtn,
        elements.MinimizeBtn,
        elements.CloseBtn
    }, cleanupSystem)
    
    -- Setup stats updater
    MinimizableControls.SetupStatsUpdater(gui, fishItBot, cleanupSystem, elements)
end

function MinimizableControls.SetupDragging(gui, titleBar, cleanupSystem)
    local dragging = false
    local dragStart, startPos
    
    local dragStartConnection = titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.MainFrame.Position
        end
    end)
    cleanupSystem:AddConnection(dragStartConnection)
    
    local dragEndConnection = titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    cleanupSystem:AddConnection(dragEndConnection)
    
    local dragMoveConnection = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    cleanupSystem:AddConnection(dragMoveConnection)
end

function MinimizableControls.SetupHoverEffects(buttons, cleanupSystem)
    for _, button in pairs(buttons) do
        local enterConnection = button.MouseEnter:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.6
            })
            tween:Play()
            cleanupSystem:AddTween(tween)
        end)
        cleanupSystem:AddConnection(enterConnection)
        
        local leaveConnection = button.MouseLeave:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.8
            })
            tween:Play()
            cleanupSystem:AddTween(tween)
        end)
        cleanupSystem:AddConnection(leaveConnection)
    end
end

function MinimizableControls.SetupStatsUpdater(gui, fishItBot, cleanupSystem, elements)
    local statsConnection = RunService.Heartbeat:Connect(function()
        local stats = fishItBot:GetStats()
        
        -- Update mini stats
        elements.MiniStats.FishLabel.Text = "🐟 " .. stats.FishCaught
        elements.MiniStats.StateLabel.Text = stats.State
        
        -- Update state color
        if string.find(stats.State, "STARTING") or string.find(stats.State, "CASTING") then
            elements.MiniStats.StateLabel.TextColor3 = gui.Colors.Primary
        elseif string.find(stats.State, "WAITING") then
            elements.MiniStats.StateLabel.TextColor3 = gui.Colors.Secondary
        elseif string.find(stats.State, "BITE") or string.find(stats.State, "CAUGHT") then
            elements.MiniStats.StateLabel.TextColor3 = gui.Colors.Accent
        elseif string.find(stats.State, "STOP") or string.find(stats.State, "IDLE") then
            elements.MiniStats.StateLabel.TextColor3 = gui.Colors.Danger
        else
            elements.MiniStats.StateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        -- Update expanded stats
        if elements.ExpandedContent.StatsFrame then
            elements.ExpandedContent.StatsFrame.TimeLabel.Text = "⏱️ " .. stats.RunningTime .. "s"
            elements.ExpandedContent.StatsFrame.RateLabel.Text = "📊 " .. stats.FishPerHour .. "/h"
        end
    end)
    cleanupSystem:AddConnection(statsConnection)
    
    -- Auto cleanup ketika GUI di-destroy
    local destroyingConnection = gui.ScreenGui.Destroying:Connect(function()
        print("🧹 GUI destroying - Auto cleanup triggered")
        cleanupSystem:ExecuteCleanup()
    end)
    cleanupSystem:AddConnection(destroyingConnection)
end

return MinimizableControls

-- GUI/MinimizableControls.lua
-- Minimizable Controls System dengan Rod Status

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Load modules dari GitHub
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/Core/Config.lua"))()
local CyberNeonGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/GUI/CyberNeonGUI.lua"))()

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
    FishLabel.Size = UDim2.new(0.4, -5, 1, 0)
    FishLabel.BackgroundTransparency = 1
    FishLabel.Text = "🐟 0"
    FishLabel.TextColor3 = gui.Colors.Accent
    FishLabel.TextSize = 11
    FishLabel.Font = Enum.Font.GothamBold
    FishLabel.Parent = MiniStats
    
    cleanupSystem:AddInterface(FishLabel)
    
    local RodLabel = Instance.new("TextLabel")
    RodLabel.Size = UDim2.new(0.3, -5, 1, 0)
    RodLabel.Position = UDim2.new(0.4, 5, 0, 0)
    RodLabel.BackgroundTransparency = 1
    RodLabel.Text = "🎣 -"
    RodLabel.TextColor3 = gui.Colors.Warning
    RodLabel.TextSize = 10
    RodLabel.Font = Enum.Font.Gotham
    RodLabel.Parent = MiniStats
    
    cleanupSystem:AddInterface(RodLabel)
    
    local StateLabel = Instance.new("TextLabel")
    StateLabel.Size = UDim2.new(0.3, -5, 1, 0)
    StateLabel.Position = UDim2.new(0.7, 5, 0, 0)
    StateLabel.BackgroundTransparency = 1
    StateLabel.Text = "🛑 IDLE"
    StateLabel.TextColor3 = gui.Colors.Danger
    StateLabel.TextSize = 9
    StateLabel.Font = Enum.Font.Gotham
    StateLabel.Parent = MiniStats
    
    cleanupSystem:AddInterface(StateLabel)
    
    return {
        FishLabel = FishLabel,
        RodLabel = RodLabel,
        StateLabel = StateLabel
    }
end

function MinimizableControls.CreateExpandedContent(gui, fishItBot, cleanupSystem)
    local ExpandedContent = Instance.new("Frame")
    ExpandedContent.Name = "ExpandedContent"
    ExpandedContent.Size = UDim2.new(1, -10, 0, 180) -- Increased height
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
    local StartBtn = CyberNeonGUI.CreateNeonButton(ExpandedContent, "🚀 START AUTO FISHING", gui.Colors.Accent)
    cleanupSystem:AddInterface(StartBtn)
    
    -- Stop Button
    local StopBtn = CyberNeonGUI.CreateNeonButton(ExpandedContent, "🛑 STOP FISHING", gui.Colors.Danger)
    cleanupSystem:AddInterface(StopBtn)
    
    -- Manual Equip Button
    local EquipBtn = CyberNeonGUI.CreateNeonButton(ExpandedContent, "🔧 MANUAL EQUIP ROD", gui.Colors.Info)
    cleanupSystem:AddInterface(EquipBtn)
    
    -- Stats Display
    local StatsFrame = MinimizableControls.CreateStatsDisplay(ExpandedContent, gui, cleanupSystem)
    
    -- Rod Status Display
    local RodFrame = MinimizableControls.CreateRodStatusDisplay(ExpandedContent, gui, cleanupSystem)
    
    return {
        Frame = ExpandedContent,
        StartBtn = StartBtn,
        StopBtn = StopBtn,
        EquipBtn = EquipBtn,
        StatsFrame = StatsFrame,
        RodFrame = RodFrame
    }
end

function MinimizableControls.CreateRodStatusDisplay(parent, gui, cleanupSystem)
    local RodFrame = Instance.new("Frame")
    RodFrame.Size = UDim2.new(1, 0, 0, 40)
    RodFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    RodFrame.BackgroundTransparency = 0.7
    RodFrame.BorderSizePixel = 0
    RodFrame.Parent = parent
    
    local RodCorner = Instance.new("UICorner")
    RodCorner.CornerRadius = UDim.new(0, 8)
    RodCorner.Parent = RodFrame
    
    cleanupSystem:AddInterface(RodFrame)
    
    local RodTitle = Instance.new("TextLabel")
    RodTitle.Size = UDim2.new(1, -10, 0, 15)
    RodTitle.Position = UDim2.new(0, 5, 0, 2)
    RodTitle.BackgroundTransparency = 1
    RodTitle.Text = "🎣 Rod Status"
    RodTitle.TextColor3 = gui.Colors.Info
    RodTitle.TextSize = 10
    RodTitle.Font = Enum.Font.GothamBold
    RodTitle.Parent = RodFrame
    
    cleanupSystem:AddInterface(RodTitle)
    
    local RodStatus = Instance.new("TextLabel")
    RodStatus.Size = UDim2.new(1, -10, 0, 20)
    RodStatus.Position = UDim2.new(0, 5, 0, 18)
    RodStatus.BackgroundTransparency = 1
    RodStatus.Text = "Checking..."
    RodStatus.TextColor3 = gui.Colors.Warning
    RodStatus.TextSize = 9
    RodStatus.Font = Enum.Font.Gotham
    RodStatus.Parent = RodFrame
    
    cleanupSystem:AddInterface(RodStatus)
    
    return {
        Frame = RodFrame,
        Status = RodStatus
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
    
    local equipConnection = elements.ExpandedContent.EquipBtn.MouseButton1Click:Connect(function()
        print("🔧 Manual equip rod requested...")
        fishItBot:ManualEquipRod()
    end)
    cleanupSystem:AddConnection(equipConnection)
    
    -- Setup dragging
    MinimizableControls.SetupDragging(gui, elements.TitleBar, cleanupSystem)
    
    -- Setup hover effects
    MinimizableControls.SetupHoverEffects({
        elements.ExpandedContent.StartBtn,
        elements.ExpandedContent.StopBtn,
        elements.ExpandedContent.EquipBtn,
        elements.MinimizeBtn,
        elements.CloseBtn
    }, cleanupSystem)
    
    -- Setup stats updater
    MinimizableControls.SetupStatsUpdater(gui, fishItBot, cleanupSystem, elements)
end

function MinimizableControls.SetupStatsUpdater(gui, fishItBot, cleanupSystem, elements)
    local statsConnection = RunService.Heartbeat:Connect(function()
        local stats = fishItBot:GetStats()
        local rodStatus = fishItBot:GetRodStatus()
        
        -- Update mini stats
        elements.MiniStats.FishLabel.Text = "🐟 " .. stats.FishCaught
        
        -- Update rod status in mini stats
        if rodStatus.HasRod then
            if rodStatus.IsEquipped then
                elements.MiniStats.RodLabel.Text = "🎣 ✓"
                elements.MiniStats.RodLabel.TextColor3 = gui.Colors.Success
            else
                elements.MiniStats.RodLabel.Text = "🎣 📦"
                elements.MiniStats.RodLabel.TextColor3 = gui.Colors.Warning
            end
        else
            elements.MiniStats.RodLabel.Text = "🎣 ❌"
            elements.MiniStats.RodLabel.TextColor3 = gui.Colors.Danger
        end
        
        elements.MiniStats.StateLabel.Text = stats.State
        
        -- Update state color
        if string.find(stats.State, "STARTING") or string.find(stats.State, "CASTING") then
            elements.MiniStats.StateLabel.TextColor3 = gui.Colors.Primary
        elseif string.find(stats.State, "WAITING") or string.find(stats.State, "EQUIPPING") then
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
        
        -- Update rod status in expanded view
        if elements.ExpandedContent.RodFrame then
            if rodStatus.HasRod then
                local statusText = rodStatus.RodName
                if rodStatus.IsEquipped then
                    statusText = statusText .. " (EQUIPPED ✓)"
                    elements.ExpandedContent.RodFrame.Status.TextColor3 = gui.Colors.Success
                else
                    statusText = statusText .. " (IN BAG 📦)"
                    elements.ExpandedContent.RodFrame.Status.TextColor3 = gui.Colors.Warning
                end
                elements.ExpandedContent.RodFrame.Status.Text = statusText
            else
                elements.ExpandedContent.RodFrame.Status.Text = "NO ROD FOUND ❌"
                elements.ExpandedContent.RodFrame.Status.TextColor3 = gui.Colors.Danger
            end
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

-- ... (fungsi SetupDragging dan SetupHoverEffects tetap sama)

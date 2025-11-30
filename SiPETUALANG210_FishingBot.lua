-- SiPETUALANG210 | Fish It Bot | Specialized for Fish It Game
-- Game: https://www.roblox.com/games/121864768012064/Fish-It

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Fish It Specific Bot
local FishItBot = {
    Enabled = false,
    FishCaught = 0,
    StartTime = 0,
    Connection = nil,
    CurrentState = "🛑 IDLE",
    IsFishing = false
}

-- Fish It Specific Rod Detection
function FishItBot:FindFishingRod()
    -- Di Fish It, rod biasanya bernama "Fishing Rod"
    local character = player.Character
    if character then
        -- Cek di tangan karakter
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            local name = string.lower(tool.Name)
            if name:find("rod") or name:find("fishing") then
                return tool, true
            end
        end
    end
    
    -- Cek di backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local name = string.lower(item.Name)
                if name:find("rod") or name:find("fishing") then
                    return item, false
                end
            end
        end
    end
    
    return nil, false
end

-- Fish It Specific Equip System
function FishItBot:EquipRod()
    local rod, isEquipped = self:FindFishingRod()
    
    if not rod then
        self.CurrentState = "❌ BELUM BELI ROD"
        print("[Fish It] Belum punya fishing rod! Beli dulu di shop.")
        return false
    end
    
    if isEquipped then
        self.CurrentState = "✅ ROD SIAP"
        return true
    end
    
    -- Equip rod untuk Fish It
    self.CurrentState = "🔧 MEMAKAI ROD..."
    print("[Fish It] Mencoba memakai fishing rod...")
    
    -- Method khusus Fish It
    pcall(function()
        rod.Parent = player.Character
    end)
    
    wait(1.5) -- Tunggu animasi equip di Fish It
    
    -- Verifikasi
    local newRod, newEquipped = self:FindFishingRod()
    if newEquipped then
        self.CurrentState = "✅ ROD TERPASANG"
        print("[Fish It] Berhasil memakai fishing rod!")
        return true
    end
    
    self.CurrentState = "❌ GAGAL PASANG ROD"
    print("[Fish It] Gagal memakai fishing rod!")
    return false
end

-- Fish It Specific Input System
function FishItBot:SendKey(key)
    pcall(function()
        local keyCode = Enum.KeyCode[key]
        -- Press and hold untuk Fish It mechanics
        VirtualInput:SendKeyEvent(true, keyCode, false, game)
        wait(0.2)
        VirtualInput:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- Fish It Bite Detection
function FishItBot:DetectFishBite()
    -- Di Fish It, biasanya ada UI indicator atau sound
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                -- Cari text yang menunjukkan bite
                for _, element in pairs(gui:GetDescendants()) do
                    if element:IsA("TextLabel") or element:IsA("TextButton") then
                        local text = string.lower(tostring(element.Text))
                        if text:find("bite") or text:find("pull") or text:find("fish") then
                            if element.Visible then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

-- Main Fishing Loop untuk Fish It
function FishItBot:FishLoop()
    if not self.Enabled then return end
    
    -- Auto equip rod
    if not self:EquipRod() then
        wait(3)
        return
    end
    
    -- Cast fishing rod (Fish It menggunakan E)
    self.CurrentState = "🎣 MELEMPAR JORAN..."
    self.IsFishing = true
    self:SendKey("E")
    wait(2.5) -- Tunggu animasi cast di Fish It
    
    if not self.Enabled then return end
    
    -- Wait for bite dengan detection
    self.CurrentState = "⏳ MENUNGGU IKAN..."
    local maxWaitTime = 15 -- Max 15 detik di Fish It
    local startTime = tick()
    local biteDetected = false
    
    while tick() - startTime < maxWaitTime do
        if not self.Enabled then break end
        
        -- Check for bite
        if self:DetectFishBite() then
            biteDetected = true
            break
        end
        
        wait(0.1)
    end
    
    if not self.Enabled then return end
    
    if biteDetected then
        -- Reel in fish (Fish It menggunakan F)
        self.CurrentState = "🐟 MENDAPAT IKAN!"
        self:SendKey("F")
        wait(1.5) -- Tunggu animasi reel
        
        -- Success
        self.FishCaught = self.FishCaught + 1
        self.CurrentState = "✅ IKAN DITANGKAP! #" .. self.FishCaught
        print("[Fish It] Berhasil menangkap ikan! Total: " .. self.FishCaught)
    else
        self.CurrentState = "⏰ TIDAK ADA IKAN"
        print("[Fish It] Tidak ada ikan yang menggigit, coba lagi...")
    end
    
    self.IsFishing = false
    
    -- Delay antara fishing attempts
    if self.Enabled then
        wait(math.random(2, 4))
    end
end

function FishItBot:Start()
    if self.Enabled then 
        print("[Fish It] Bot sudah berjalan!")
        return 
    end
    
    self.Enabled = true
    self.FishCaught = 0
    self.StartTime = tick()
    self.CurrentState = "🚀 MEMULAI BOT..."
    
    print("🎣 MEMULAI FISH IT BOT...")
    print("📍 Pastikan sudah beli fishing rod!")
    print("📍 Bot akan auto equip rod dan fishing!")
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if self.Enabled then
            self:FishLoop()
        end
    end)
end

function FishItBot:Stop()
    if not self.Enabled then return end
    
    self.Enabled = false
    self.IsFishing = false
    self.CurrentState = "🛑 BOT BERHENTI"
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    local runTime = tick() - self.StartTime
    print("🛑 Fish It Bot dihentikan!")
    print("📊 Total ikan: " .. self.FishCaught)
    print("⏱️ Waktu: " .. math.floor(runTime) .. " detik")
    
    if runTime > 0 then
        local fishPerHour = (self.FishCaught / runTime) * 3600
        print("📈 Rate: " .. math.floor(fishPerHour) .. " ikan/jam")
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

-- Simple GUI untuk Fish It
local function CreateFishItGUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    ScreenGui.Name = "SiPETUALANG210_FishIt_GUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 60)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
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

-- Create Controls untuk Fish It
local function CreateFishItControls(gui)
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local CloseBtn = Instance.new("TextButton")
    
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = gui.MainFrame
    
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 180, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "SiPETUALANG210 - Fish It"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    Title.Position = UDim2.new(0, 8, 0, 0)
    
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -45, 0, 2)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    MinimizeBtn.BackgroundTransparency = 0.7
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "+"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeBtn
    
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
    StateLabel.Text = "🛑 SIAP"
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
    
    -- Start Button
    local StartBtn = Instance.new("TextButton")
    StartBtn.Size = UDim2.new(1, 0, 0, 35)
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    StartBtn.BackgroundTransparency = 0.8
    StartBtn.BorderSizePixel = 0
    StartBtn.Text = "🚀 START AUTO FISHING"
    StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartBtn.TextSize = 12
    StartBtn.Font = Enum.Font.GothamBold
    StartBtn.Parent = ExpandedContent
    
    local StartCorner = Instance.new("UICorner")
    StartCorner.CornerRadius = UDim.new(0, 8)
    StartCorner.Parent = StartBtn
    
    -- Stop Button
    local StopBtn = Instance.new("TextButton")
    StopBtn.Size = UDim2.new(1, 0, 0, 35)
    StopBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StopBtn.BackgroundTransparency = 0.8
    StopBtn.BorderSizePixel = 0
    StopBtn.Text = "🛑 STOP FISHING"
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.TextSize = 12
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.Parent = ExpandedContent
    
    local StopCorner = Instance.new("UICorner")
    StopCorner.CornerRadius = UDim.new(0, 8)
    StopCorner.Parent = StopBtn
    
    -- Manual Equip Button
    local EquipBtn = Instance.new("TextButton")
    EquipBtn.Size = UDim2.new(1, 0, 0, 30)
    EquipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    EquipBtn.BackgroundTransparency = 0.8
    EquipBtn.BorderSizePixel = 0
    EquipBtn.Text = "🔧 MANUAL EQUIP ROD"
    EquipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    EquipBtn.TextSize = 11
    EquipBtn.Font = Enum.Font.GothamBold
    EquipBtn.Parent = ExpandedContent
    
    local EquipCorner = Instance.new("UICorner")
    EquipCorner.CornerRadius = UDim.new(0, 8)
    EquipCorner.Parent = EquipBtn
    
    -- Stats Display
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, 0, 0, 60)
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
    RateLabel.Text = "📊 0/jam"
    RateLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    RateLabel.TextSize = 10
    RateLabel.Font = Enum.Font.Gotham
    RateLabel.Parent = StatsFrame
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -10, 0, 20)
    StatusLabel.Position = UDim2.new(0, 5, 0, 45)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "📍 Ready for Fish It!"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 9
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = StatsFrame
    
    -- Interactions
    MinimizeBtn.MouseButton1Click:Connect(function()
        gui.IsExpanded = not gui.IsExpanded
        
        if gui.IsExpanded then
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 320, 0, 250)
            }):Play()
            ExpandedContent.Visible = true
            MinimizeBtn.Text = "-"
        else
            TweenService:Create(gui.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 320, 0, 60)
            }):Play()
            ExpandedContent.Visible = false
            MinimizeBtn.Text = "+"
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        FishItBot:Stop()
        gui.ScreenGui:Destroy()
    end)
    
    StartBtn.MouseButton1Click:Connect(function()
        FishItBot:Start()
    end)
    
    StopBtn.MouseButton1Click:Connect(function()
        FishItBot:Stop()
    end)
    
    EquipBtn.MouseButton1Click:Connect(function()
        FishItBot:EquipRod()
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
    
    -- Stats updater
    RunService.Heartbeat:Connect(function()
        local stats = FishItBot:GetStats()
        
        FishLabel.Text = "🐟 " .. stats.FishCaught
        StateLabel.Text = stats.State
        
        -- Update state color
        if string.find(stats.State, "STARTING") or string.find(stats.State, "CASTING") then
            StateLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        elseif string.find(stats.State, "WAITING") or string.find(stats.State, "MENUNGGU") then
            StateLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
        elseif string.find(stats.State, "IKAN") or string.find(stats.State, "CAUGHT") then
            StateLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        elseif string.find(stats.State, "STOP") or string.find(stats.State, "BERHENTI") then
            StateLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            StateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        TimeLabel.Text = "⏱️ " .. stats.RunningTime .. "s"
        RateLabel.Text = "📊 " .. stats.FishPerHour .. "/jam"
        
        if FishItBot.IsFishing then
            StatusLabel.Text = "🎣 Sedang Memancing..."
        else
            StatusLabel.Text = "📍 " .. stats.State
        end
    end)
end

-- Initialize Fish It Bot
print("==================================================================")
print("🎣 SiPETUALANG210 FISH IT BOT")
print("📍 Khusus untuk game: Fish It")
print("🌐 https://www.roblox.com/games/121864768012064/Fish-It")
print("==================================================================")
print("🚀 FITUR:")
print("   ✅ Auto Equip Fishing Rod")
print("   ✅ Auto Cast & Reel")
print("   ✅ Bite Detection System")
print("   ✅ Real-time Statistics")
print("==================================================================")

-- Cleanup previous
if _G.SiPETUALANG210_FishIt_GUI then
    pcall(function() _G.SiPETUALANG210_FishIt_GUI:Destroy() end)
end

-- Create GUI
local gui = CreateFishItGUI()
_G.SiPETUALANG210_FishIt_GUI = gui.ScreenGui
CreateFishItControls(gui)

print("✅ GUI Berhasil Dibuat!")
print("📍 Klik + untuk membuka controls")
print("📍 Pastikan sudah BELI FISHING ROD di shop!")
print("==================================================================")

return FishItBot

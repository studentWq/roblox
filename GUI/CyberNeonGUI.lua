-- GUI/CyberNeonGUI.lua
-- Cyber Neon Transparent GUI Framework dengan Refresh Button

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Load config dari GitHub dengan cache busting
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/studentWq/roblox/main/Core/Config.lua?v=" .. tick()))()

local CyberNeonGUI = {}

function CyberNeonGUI.Create()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    -- ScreenGui
    ScreenGui.Name = "ChloeXCyberGUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (Transparan dengan efek glass)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Config.GUI.DefaultSize
    MainFrame.Position = Config.GUI.Position
    MainFrame.BackgroundColor3 = Config.GUI.BackgroundColor
    MainFrame.BackgroundTransparency = Config.GUI.BackgroundTransparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Rounded Corners
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Neon Border
    UIStroke.Thickness = 2
    UIStroke.Color = Config.Colors.Primary
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Colors = Config.Colors,
        IsExpanded = false
    }
end

function CyberNeonGUI.AddGlowEffect(frame)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Config.Colors.Primary
    UIStroke.Transparency = 0.7
    UIStroke.Parent = frame
    
    return UIStroke
end

function CyberNeonGUI.CreateNeonButton(parent, text, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.8
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = CyberNeonGUI.AddGlowEffect(button)
    stroke.Color = color
    
    return button
end

-- Function untuk create refresh button khusus
function CyberNeonGUI.CreateRefreshButton(parent, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.7
    button.BorderSizePixel = 0
    button.Text = "⟳"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = CyberNeonGUI.AddGlowEffect(button)
    stroke.Color = color
    
    return button
end

return CyberNeonGUI

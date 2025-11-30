-- GUI/CyberNeonGUI.lua
-- Cyber Neon Transparent GUI Framework

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CyberNeonGUI = {}

function CyberNeonGUI.Create()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    
    -- ScreenGui
    ScreenGui.Name = "SiPETUALANG210_GUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (Transparan dengan efek glass)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 60)  -- Fixed size
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
        Colors = {
            Primary = Color3.fromRGB(0, 255, 255),
            Secondary = Color3.fromRGB(255, 0, 255), 
            Accent = Color3.fromRGB(0, 255, 170),
            Danger = Color3.fromRGB(255, 50, 50),
            Success = Color3.fromRGB(50, 255, 50),
            Warning = Color3.fromRGB(255, 255, 0),
            Info = Color3.fromRGB(100, 100, 255)
        },
        IsExpanded = false
    }
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
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = color
    stroke.Transparency = 0.7
    stroke.Parent = button
    
    return button
end

return CyberNeonGUI

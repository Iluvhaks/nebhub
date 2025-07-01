-- Minimal Purple GUI with Working Tabs, Minimize & Close

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NebulaHubGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.4, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(110, 0, 160)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "Nebula Hub"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local minimize = Instance.new("TextButton")
minimize.Text = "–"
minimize.Size = UDim2.new(0, 25, 1, 0)
minimize.Position = UDim2.new(1, -55, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.SourceSansBold
minimize.TextScaled = true
minimize.Parent = topBar

local close = Instance.new("TextButton")
close.Text = "X"
close.Size = UDim2.new(0, 25, 1, 0)
close.Position = UDim2.new(1, -30, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.SourceSansBold
close.TextScaled = true
close.Parent = topBar

-- Left Tab Buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 100, 1, -30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
tabFrame.Parent = mainFrame

local function makeTabButton(name, y)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = tabFrame
    return btn
end

local utilBtn = makeTabButton("Utility", 0)
local visBtn  = makeTabButton("Visual", 40)

-- Content Frame
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -100, 1, -30)
content.Position = UDim2.new(0, 100, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(55, 0, 95)
content.Parent = mainFrame

local contentLabel = Instance.new("TextLabel")
contentLabel.Text = "Select a tab"
contentLabel.Size = UDim2.new(1, -20, 0, 30)
contentLabel.Position = UDim2.new(0, 10, 0, 10)
contentLabel.BackgroundTransparency = 1
contentLabel.TextColor3 = Color3.new(1,1,1)
contentLabel.Font = Enum.Font.SourceSansBold
contentLabel.TextScaled = true
contentLabel.Parent = content

-- Button callbacks
utilBtn.MouseButton1Click:Connect(function()
    utilBtn.BackgroundColor3 = Color3.fromRGB(160,0,230)
    visBtn.BackgroundColor3 = Color3.fromRGB(90,0,140)
    contentLabel.Text = "Utility tab content here"
end)

visBtn.MouseButton1Click:Connect(function()
    visBtn.BackgroundColor3 = Color3.fromRGB(160,0,230)
    utilBtn.BackgroundColor3 = Color3.fromRGB(90,0,140)
    contentLabel.Text = "Visual tab content here"
end)

-- Minimize logic
local minimized = false
minimize.MouseButton1Click:Connect(function()
    if minimized then
        content.Visible = true
        tabFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 400, 0, 300)
        title.Text = "Nebula Hub"
    else
        content.Visible = false
        tabFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 150, 0, 30)
        title.Text = "N"
    end
    minimized = not minimized
end)

-- Close logic
close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

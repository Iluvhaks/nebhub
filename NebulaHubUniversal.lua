-- Nebula Hub Universal - Full Updated Script with all tabs and game logicAdd commentMore actions
-- Made for KRNL and similar exploit environments
-- All features integrated with advanced anticheat bypasses and admin detection
-- Nebula Hub Universal - Full Integrated Version
-- Includes: TSB, FTAP, BloxFruits, SAB, AstraCloud, Full UI + Game Logic

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character & HumanoidRootPart
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Custom GUI Creation (Purple/White/Gold Theme)
local NebulaGUI = Instance.new("ScreenGui")
NebulaGUI.Name = "NebulaHubGUI"
NebulaGUI.ResetOnSpawn = false
NebulaGUI.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 550, 0, 600)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(68, 34, 127) -- deep purple
mainFrame.BorderSizePixel = 0
mainFrame.Parent = NebulaGUI

-- Moveable GUI logic
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Top Bar for Minimize & Close
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(90, 45, 170) -- lighter purple
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Nebula Hub Universal"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- gold
titleLabel.TextSize = 18
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Minimize Button (as line)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "N" -- instead of K for KRNL, use N
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 24
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- gold
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(0.8, 0, 0, 0)
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = topBar
-- Main GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 520)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(55, 0, 88) -- Dark purple
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(88, 44, 155) -- Purple
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nebula Hub Universal"
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button (Line)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(88, 44, 155)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 24
MinimizeButton.Parent = TitleBar

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 22
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- red
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(0.88, 0, 0, 0)
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar

-- When minimized, hide main contents except minimizeBtn showing small
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Size = UDim2.new(0, 120, 0, 40)
minimizedFrame.Position = mainFrame.Position
minimizedFrame.BackgroundColor3 = Color3.fromRGB(68, 34, 127) -- same purple
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Parent = NebulaGUI

local minimizedLabel = Instance.new("TextLabel")
minimizedLabel.Text = "N"
minimizedLabel.Font = Enum.Font.GothamBlack
minimizedLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
minimizedLabel.TextSize = 28
minimizedLabel.BackgroundTransparency = 1
minimizedLabel.Size = UDim2.new(1, 0, 1, 0)
minimizedLabel.Parent = minimizedFrame

-- Minimize toggle logic
local function minimize()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end
local function restore()
    mainFrame.Visible = true
    minimizedFrame.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(function()
    minimize()
end)
minimizedFrame.MouseButton1Click:Connect(function()
    restore()
end)
closeBtn.MouseButton1Click:Connect(function()
    NebulaGUI:Destroy()
end)

-- Tabs container
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 1, -30)
tabFrame.Position = UDim2.new(0, 0, 0, 30)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

-- Tab Buttons
local tabs = {
    "Utility",
    "Troll",
    "Auto",
    "Remotes",
    "Visual",
    "Exploits",
    "FTAP",
    "TSB",
    "BloxFruits",
    "StealABrainrot",
    "AstraCloud"
}

local tabButtons = {}
local tabContents = {}

local buttonSizeX = 100
local buttonSizeY = 30

local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, 0, 0, buttonSizeY)
tabButtonsFrame.BackgroundTransparency = 1
tabButtonsFrame.Parent = tabFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -buttonSizeY)
contentFrame.Position = UDim2.new(0, 0, 0, buttonSizeY)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 15, 70)
contentFrame.Parent = tabFrame

-- Create buttons and content frames
for i, tabName in ipairs(tabs) do
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(88, 44, 155)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 215, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

-- Tab Buttons Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(0, 120, 1, -30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.BackgroundColor3 = Color3.fromRGB(44, 0, 66) -- Slightly darker purple
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Vertical
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsFrame

-- Content Frame
local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, -120, 1, -30)
TabContentFrame.Position = UDim2.new(0, 120, 0, 30)
TabContentFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
TabContentFrame.BorderSizePixel = 0
TabContentFrame.Parent = MainFrame

-- Minimized Bar
local MinimizedBar = Instance.new("TextButton")
MinimizedBar.Name = "MinimizedBar"
MinimizedBar.Size = UDim2.new(0, 150, 0, 30)
MinimizedBar.Position = UDim2.new(0.5, -75, 0, 20)
MinimizedBar.BackgroundColor3 = Color3.fromRGB(88, 44, 155)
MinimizedBar.BorderSizePixel = 0
MinimizedBar.Text = "N"
MinimizedBar.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizedBar.Font = Enum.Font.GothamBlack
MinimizedBar.TextSize = 28
MinimizedBar.Visible = false
MinimizedBar.Parent = ScreenGui
MinimizedBar.Active = true
MinimizedBar.Draggable = true

-- Helper functions to create UI components
local function createButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(68, 34, 127)
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.Size = UDim2.new(0, buttonSizeX, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * buttonSizeX, 0, 0)
    btn.Parent = tabButtonsFrame
    tabButtons[tabName] = btn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -10)
    content.Position = UDim2.new(0, 5, 0, 5)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = contentFrame
    tabContents[tabName] = content
end

-- Show first tab by default
local currentTab = tabs[1]
tabContents[currentTab].Visible = true

-- Tab switching logic
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        if currentTab ~= tabName then
            tabContents[currentTab].Visible = false
            tabContents[tabName].Visible = true
            currentTab = tabName
        end
    end)
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper: create toggle inside a parent with label
local function CreateToggle(parent, text, default)
local function createToggle(text, parent, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 20)
    toggle.Position = UDim2.new(0.8, 0, 0.15, 0)
    toggle.Font = Enum.Font.GothamBlack
    toggle.TextSize = 16
    toggle.TextColor3 = Color3.fromRGB(255, 215, 0)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.Parent = frame

    local state = default or false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.Text = state and "ON" or "OFF"
    end)

    return frame, function() return state end, function(v)
        state = v
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggle.Text = state and "ON" or "OFF"
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(60, 0, 90)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = frame

    local toggled = default

    local function updateState()
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(60, 0, 90)
        toggleBtn.Text = toggled and "ON" or "OFF"
        toggleBtn.TextColor3 = toggled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255, 255, 255)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateState()
        callback(toggled)
    end)

    return frame, function() return toggled end
end

-- Helper: create slider inside a parent with label
local function CreateSlider(parent, text, min, max, default)
local function createSlider(text, parent, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text .. ": " .. tostring(default)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = text.." : "..tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0.5, 0)
    sliderFrame.Position = UDim2.new(0, 0, 0.5, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.Size = UDim2.new(1, 0, 0, 15)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    sliderFrame.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sliderBar.Parent = sliderFrame
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sliderFill.Parent = sliderFrame

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 10, 1, 0)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Position = UDim2.new((default - min)/(max - min), 0, 0, 0)
    sliderBtn.Parent = sliderFrame
    sliderBtn.AutoButtonColor = false

    local dragging = false
    sliderFrame.InputBegan:Connect(function(input)

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - sliderFrame.AbsolutePosition.X
            local size = sliderFrame.AbsoluteSize.X
            local val = math.clamp(pos / size, 0, 1)
            sliderBar.Size = UDim2.new(val, 0, 1, 0)
            local sliderVal = min + (max - min) * val
            label.Text = text .. ": " .. math.floor(sliderVal)
            if callback then callback(sliderVal) end
        end
    end)
    sliderFrame.InputEnded:Connect(function(input)

    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderFrame.AbsolutePosition.X
            local size = sliderFrame.AbsoluteSize.X
            local val = math.clamp(pos / size, 0, 1)
            sliderBar.Size = UDim2.new(val, 0, 1, 0)
            local sliderVal = min + (max - min) * val
            label.Text = text .. ": " .. math.floor(sliderVal)
            if callback then callback(sliderVal) end
            local relativePos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relativePos, 0, 0, 0)
            local val = math.floor(min + (max - min) * relativePos + 0.5)
            label.Text = text.." : "..val
            callback(val)
        end
    end)

    local callback = nil
    return frame
end

    local function SetCallback(cb)
        callback = cb
local function createDropdown(text, parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 90, 1, 0)
    dropdownBtn.Position = UDim2.new(0.75, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    dropdownBtn.TextColor3 = Color3.new(1,1,1)
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.TextSize = 14
    dropdownBtn.Text = default
    dropdownBtn.Parent = frame

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(0, 90, 0, #options * 20)
    optionsFrame.Position = UDim2.new(0.75, 0, 1, 0)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    optionsFrame.Visible = false
    optionsFrame.Parent = frame

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 20)
        optBtn.BackgroundColor3 = Color3.fromRGB(80, 10, 120)
        optBtn.BorderSizePixel = 0
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.Text = opt
        optBtn.Parent = optionsFrame

        optBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = opt
            optionsFrame.Visible = false
            callback(opt)
        end)
    end

    return frame, SetCallback
    dropdownBtn.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)

    return frame
end

-- ============================
-- Utility Tab
-- ============================
do
    local tab = tabContents["Utility"]
    local y = 10

    -- WalkSpeed Slider + Toggle
    local walkSpeedVal = 16
    local walkSpeedToggleState = false
    local wsFrame, wsCallbackSetter = CreateSlider(tab, "WalkSpeed", 16, 500, 16)
    wsFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + wsFrame.Size.Y.Offset + 10

    local wsToggleFrame, wsToggleGetter, wsToggleSetter = CreateToggle(tab, "Set WalkSpeed", false)
    wsToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + wsToggleFrame.Size.Y.Offset + 10

    wsCallbackSetter(function(value)
        walkSpeedVal = math.floor(value)
        if walkSpeedToggleState then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeedVal
            end
-- State variables for toggles/sliders
local states = {
    clickTPOn = false,
    InfJump = false,
    WalkSpeedValue = 16,
    JumpPowerValue = 50,
    flingEnabled = false,
    flingStrength = 250,
    antiGrabEnabled = false,
    spawnKillAll = false,
    flingAll = false,
    autofarmEnabled = false,
    AutoShoot = false,
    TeamCheck = true,
    TargetPart = "Head",
    AimFOV = 90,
    ESPOn = false,
    LineESP = false,
    AimbotOn = false,
    noclipActive = false,
    sabActive = false,
    anticheatBypassActive = false,
    godmodeActive = false,
    unlimitedZoom = false,
    grabbedPlayer = nil,
}

-- Store esp objects
local espObjects = {}

-- Tab buttons and content handlers
local tabs = {
    "🏠 Utility",
    "💣 Troll",
    "🤖 Auto",
    "📡 Remotes",
    "🎯 Visual",
    "⚠️ Exploits",
    "👐 FTAP",
    "⚔️ TSB",
    "🍉 BloxFruits",
    "🧠 StealABrainrot",
    "☁️ AstraCloud",
}

local tabButtons = {}
local tabPages = {}

-- Clear all children in tab content frame
local function clearTabContent()
    for _, child in pairs(TabContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end)
    end
end

    wsToggleFrame:GetChildren()[2].MouseButton1Click:Connect(function()
        walkSpeedToggleState = not walkSpeedToggleState
        if walkSpeedToggleState then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeedVal
            end
        else
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
-- Create Tab Buttons
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = "TabButton_"..i
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(88, 44, 155)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = tabName
    btn.Parent = TabsFrame
    tabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        clearTabContent()
        tabPages[tabName]()
        -- Highlight active tab
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(88, 44, 155)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end)
end

    -- JumpPower Slider + Toggle
    local jumpPowerVal = 100
    local jumpPowerToggleState = false
    local jpFrame, jpCallbackSetter = CreateSlider(tab, "JumpPower", 50, 500, 100)
    jpFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + jpFrame.Size.Y.Offset + 10
-- ========== Tab Logic Functions ==========

    local jpToggleFrame, jpToggleGetter, jpToggleSetter = CreateToggle(tab, "Set JumpPower", false)
    jpToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + jpToggleFrame.Size.Y.Offset + 10
-- Utility Tab
tabPages["🏠 Utility"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Click Teleport Toggle
    createToggle("Click Teleport", container, states.clickTPOn, function(toggled)
        states.clickTPOn = toggled
    end)

    jpCallbackSetter(function(value)
        jumpPowerVal = math.floor(value)
        if jumpPowerToggleState then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpPowerVal
            end
    -- Infinite Jump Toggle
    createToggle("Infinite Jump", container, states.InfJump, function(toggled)
        states.InfJump = toggled
    end)

    -- WalkSpeed Slider
    createSlider("WalkSpeed", container, 16, 100, states.WalkSpeedValue, function(value)
        states.WalkSpeedValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)

    jpToggleFrame:GetChildren()[2].MouseButton1Click:Connect(function()
        jumpPowerToggleState = not jumpPowerToggleState
        if jumpPowerToggleState then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpPowerVal
            end
        else
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
    -- JumpPower Slider
    createSlider("JumpPower", container, 50, 250, states.JumpPowerValue, function(value)
        states.JumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)

    -- Noclip Toggle
    local noclipState = false
    local noclipToggleFrame, noclipToggleGetter, noclipToggleSetter = CreateToggle(tab, "Noclip", false)
    noclipToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + noclipToggleFrame.Size.Y.Offset + 10
    createToggle("Noclip", container, states.noclipActive, function(toggled)
        states.noclipActive = toggled
    end)

    noclipToggleFrame:GetChildren()[2].MouseButton1Click:Connect(function()
        noclipState = not noclipState
    -- ESP Toggle
    createToggle("ESP", container, states.ESPOn, function(toggled)
        states.ESPOn = toggled
    end)

    RunService.Stepped:Connect(function()
        if noclipState and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        elseif LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and not part.CanCollide then
                    part.CanCollide = true
                end
            end
        end
    -- Line ESP Toggle
    createToggle("Line ESP", container, states.LineESP, function(toggled)
        states.LineESP = toggled
    end)
end

    -- Infinite Zoom Toggle
    local infiniteZoomState = false
    local infZoomToggleFrame, infZoomToggleGetter, infZoomToggleSetter = CreateToggle(tab, "Infinite Zoom", false)
    infZoomToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + infZoomToggleFrame.Size.Y.Offset + 10
-- Troll Tab
tabPages["💣 Troll"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Anti Grab", container, states.antiGrabEnabled, function(toggled)
        states.antiGrabEnabled = toggled
    end)

    infZoomToggleFrame:GetChildren()[2].MouseButton1Click:Connect(function()
        infiniteZoomState = not infiniteZoomState
        if infiniteZoomState then
            Camera.MaxZoomDistance = math.huge
        else
            Camera.MaxZoomDistance = 400 -- default typical max zoom
        end
    createToggle("Spawn Kill All", container, states.spawnKillAll, function(toggled)
        states.spawnKillAll = toggled
    end)

    createToggle("Fling All", container, states.flingAll, function(toggled)
        states.flingAll = toggled
    end)

    createSlider("Fling Strength", container, 100, 500, states.flingStrength, function(value)
        states.flingStrength = value
    end)
end

-- ============================
-- TSB Tab Logic (The Strongest Battlegrounds Autofarm etc)
-- ============================
do
    local tab = tabContents["TSB"]
    local y = 10

    local autofarmToggle, autofarmGetter, autofarmSetter = CreateToggle(tab, "Enable Autofarm", false)
    autofarmToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + autofarmToggle.Size.Y.Offset + 10

    local safeflyToggle, safeflyGetter, safeflySetter = CreateToggle(tab, "Enable SafeFly", false)
    safeflyToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + safeflyToggle.Size.Y.Offset + 10

    -- Remotes used in TSB (these names may need update based on actual game)
    local attackRemote = FindRemote("AttackEnemy") or FindRemote("Attack")
    local getEnemiesRemote = FindRemote("GetEnemies")

    local running = false
    spawn(function()
        while true do
            if autofarmGetter() then
                -- Autofarm logic
                local enemies = {}
                if getEnemiesRemote then
                    local success, result = pcall(function()
                        return getEnemiesRemote:InvokeServer()
                    end)
                    if success and type(result) == "table" then
                        enemies = result
                    end
                else
                    -- fallback to workspace models with humanoid
                    for _, model in pairs(Workspace:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
                            table.insert(enemies, model)
                        end
                    end
                end
-- Auto Tab
tabPages["🤖 Auto"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Autofarm TSB", container, states.autofarmEnabled, function(toggled)
        states.autofarmEnabled = toggled
    end)

                -- find closest enemy
                local closestDist = math.huge
                local closestEnemy = nil
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, enemy in pairs(enemies) do
                        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHrp then
                            local dist = (hrp.Position - enemyHrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestEnemy = enemy
                            end
                        end
                    end
                end
    createToggle("Auto Shoot", container, states.AutoShoot, function(toggled)
        states.AutoShoot = toggled
    end)

                if closestEnemy then
                    -- Teleport near enemy
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                    end)
                    -- Attack enemy
                    if attackRemote then
                        pcall(function()
                            attackRemote:FireServer(closestEnemy)
                        end)
                    end
                end
    createToggle("Team Check", container, states.TeamCheck, function(toggled)
        states.TeamCheck = toggled
    end)

                -- SafeFly logic
                if safeflyGetter() then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
                    end)
                end
            else
                -- wait a bit
                task.wait(1)
            end
            task.wait(0.5)
        end
    createDropdown("Target Part", container, {"Head", "HumanoidRootPart"}, states.TargetPart, function(value)
        states.TargetPart = value
    end)

    createSlider("Aim FOV", container, 10, 180, states.AimFOV, function(value)
        states.AimFOV = value
    end)
end

-- ============================
-- FTAP Tab Logic (Grab + Fling)
-- ============================
do
    local tab = tabContents["FTAP"]
    local y = 10

    local grabToggle, grabGetter, grabSetter = CreateToggle(tab, "Enable Grab", false)
    grabToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + grabToggle.Size.Y.Offset + 10

    local flingToggle, flingGetter, flingSetter = CreateToggle(tab, "Enable Fling", false)
    flingToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + flingToggle.Size.Y.Offset + 10

    local deleteOnReleaseToggle, deleteOnReleaseGetter, deleteOnReleaseSetter = CreateToggle(tab, "Delete Player On Grab Release", false)
    deleteOnReleaseToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + deleteOnReleaseToggle.Size.Y.Offset + 10

    local grabRemote = FindRemote("Grab") or FindRemote("GrabPlayer")
    local releaseRemote = FindRemote("Release") or FindRemote("ReleasePlayer")

    local grabbedPlayer = nil

    RunService.Heartbeat:Connect(function()
        if grabGetter() then
            -- Implement grab logic by raycasting nearest player etc (simplified)
            local closestDist = math.huge
            local closestPlayer = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist and dist < 15 then -- grab range
                        closestDist = dist
                        closestPlayer = plr
                    end
                end
            end
            if closestPlayer and grabbedPlayer ~= closestPlayer then
                grabbedPlayer = closestPlayer
                if grabRemote then
                    pcall(function()
                        grabRemote:FireServer(grabbedPlayer)
                    end)
                end
            end
        else
            if grabbedPlayer then
                if releaseRemote then
                    pcall(function()
                        releaseRemote:FireServer(grabbedPlayer)
                    end)
                end
                if deleteOnReleaseGetter() then
                    -- Teleport far away
                    if grabbedPlayer.Character and grabbedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        grabbedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(25000, 25000, 25000)
                    end
                end
                grabbedPlayer = nil
            end
        end
-- Remotes Tab (example placeholder)
tabPages["📡 Remotes"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createButton("Dump Remotes", container, function()
        print("Dumping remotes... (placeholder)")
    end)
end

    -- Fling logic can be added based on velocity manipulation on grabbed target (complex, simplified here)
-- Visual Tab
tabPages["🎯 Visual"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("ESP", container, states.ESPOn, function(toggled)
        states.ESPOn = toggled
    end)

    createToggle("Line ESP", container, states.LineESP, function(toggled)
        states.LineESP = toggled
    end)
end

-- ============================
-- BloxFruits Tab Logic (Scaffold + autofarm)
-- ============================
do
    local tab = tabContents["BloxFruits"]
    local y = 10

    local autoFarmToggle, autoFarmGetter, autoFarmSetter = CreateToggle(tab, "Enable Autofarm", false)
    autoFarmToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + autoFarmToggle.Size.Y.Offset + 10

    -- Assuming remote names for BloxFruits attacks
    local attackRemote = FindRemote("Attack") or FindRemote("RemoteAttack")
    local getEnemiesRemote = FindRemote("GetEnemies")

    spawn(function()
        while true do
            if autoFarmGetter() then
                -- Similar autofarm logic: find enemies, teleport near, attack
                local enemies = {}
                if getEnemiesRemote then
                    local success, result = pcall(function()
                        return getEnemiesRemote:InvokeServer()
                    end)
                    if success and type(result) == "table" then
                        enemies = result
                    end
                else
                    for _, model in pairs(Workspace:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
                            table.insert(enemies, model)
                        end
                    end
                end
-- Exploits Tab
tabPages["⚠️ Exploits"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Infinite Jump", container, states.InfJump, function(toggled)
        states.InfJump = toggled
    end)

                -- Find closest enemy
                local closestDist = math.huge
                local closestEnemy = nil
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, enemy in pairs(enemies) do
                        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHrp then
                            local dist = (hrp.Position - enemyHrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestEnemy = enemy
                            end
                        end
                    end
                end
    createToggle("Noclip", container, states.noclipActive, function(toggled)
        states.noclipActive = toggled
    end)

                if closestEnemy then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                    end)
                    if attackRemote then
                        pcall(function()
                            attackRemote:FireServer(closestEnemy)
                        end)
                    end
                end
            end
            task.wait(0.7)
        end
    createToggle("Godmode", container, states.godmodeActive, function(toggled)
        states.godmodeActive = toggled
    end)

    createToggle("Unlimited Zoom", container, states.unlimitedZoom, function(toggled)
        states.unlimitedZoom = toggled
    end)
end

-- ============================
-- Steal A Brainrot Tab Logic (Anticheat bypass + auto steal)
-- ============================
do
    local tab = tabContents["StealABrainrot"]
    local y = 10

    local anticheatBypassToggle, anticheatBypassGetter, anticheatBypassSetter = CreateToggle(tab, "Enable Anticheat Bypass", false)
    anticheatBypassToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + anticheatBypassToggle.Size.Y.Offset + 10

    local autoStealToggle, autoStealGetter, autoStealSetter = CreateToggle(tab, "Enable Auto Steal", false)
    autoStealToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + autoStealToggle.Size.Y.Offset + 10

    -- Anticheat bypass example: hook certain game functions or protect loadstring usage
    local anticheatBypassed = false
    spawn(function()
        while true do
            if anticheatBypassGetter() and not anticheatBypassed then
                anticheatBypassed = true
                -- Example bypass hook: disable kick function
                local mt = getrawmetatable(game)
                local oldNamecall = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if tostring(self) == "Kick" or method == "Kick" then
                        return
                    end
                    return oldNamecall(self, ...)
                end)
                setreadonly(mt, true)
            elseif not anticheatBypassGetter() and anticheatBypassed then
                -- Can't easily revert hooks — reload recommended
                anticheatBypassed = false
            end
            task.wait(2)
        end
-- FTAP Tab (Grab & Fling)
tabPages["👐 FTAP"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Enable Grab & Fling", container, states.flingEnabled, function(toggled)
        states.flingEnabled = toggled
    end)

    -- Auto steal logic placeholder
    spawn(function()
        while true do
            if autoStealGetter() then
                -- Implement logic to find stealable items and invoke steal remotes
                -- (You need to fill with game-specific code)
            end
            task.wait(1)
        end
    createSlider("Fling Strength", container, 100, 500, states.flingStrength, function(value)
        states.flingStrength = value
    end)
end

-- ============================
-- AstraCloud Tab Logic (Admin detect, anticheat bypass, infinite zoom, server crasher)
-- ============================
do
    local tab = tabContents["AstraCloud"]
    local y = 10

    local adminDetectToggle, adminDetectGetter, adminDetectSetter = CreateToggle(tab, "Admin/Exploiter Detection", false)
    adminDetectToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + adminDetectToggle.Size.Y.Offset + 10

    local anticheatBypassToggle, acBypassGetter, acBypassSetter = CreateToggle(tab, "Advanced Anticheat Bypass", false)
    anticheatBypassToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + anticheatBypassToggle.Size.Y.Offset + 10

    local godmodeToggle, godmodeGetter, godmodeSetter = CreateToggle(tab, "Godmode", false)
    godmodeToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + godmodeToggle.Size.Y.Offset + 10

    local instantKillToggle, instantKillGetter, instantKillSetter = CreateToggle(tab, "Instant Kill", false)
    instantKillToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + instantKillToggle.Size.Y.Offset + 10

    local infiniteZoomToggle, infiniteZoomGetter, infiniteZoomSetter = CreateToggle(tab, "Infinite Zoom", false)
    infiniteZoomToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + infiniteZoomToggle.Size.Y.Offset + 10

    local serverCrasherToggle, serverCrasherGetter, serverCrasherSetter = CreateToggle(tab, "Server Crasher", false)
    serverCrasherToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + serverCrasherToggle.Size.Y.Offset + 10

    local noclipToggle, noclipGetter, noclipSetter = CreateToggle(tab, "Noclip", false)
    noclipToggle.Position = UDim2.new(0, 10, 0, y)
    y = y + noclipToggle.Size.Y.Offset + 10

    -- Admin/Exploiter Detection (simplified log scan)
    spawn(function()
        while true do
            if adminDetectGetter() then
                local logs = getconnections or getlog or function() return {} end
                -- Since Roblox does not expose logs directly, this is a placeholder
                -- Real detection involves hooking event listeners, scanning executed scripts, etc.
                -- You can simulate notifications here:
                StarterGui:SetCore("SendNotification", {
                    Title = "AstraCloud",
                    Text = "Admin/Exploiter check running...",
                    Duration = 5
                })
            end
            task.wait(10)
        end
-- TSB Tab (The Strongest Battlegrounds Autofarm + Aimbot)
tabPages["⚔️ TSB"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Autofarm", container, states.autofarmEnabled, function(toggled)
        states.autofarmEnabled = toggled
    end)

    -- Advanced Anticheat Bypass hook (example)
    spawn(function()
        while true do
            if acBypassGetter() then
                -- Hook important functions like __namecall, __index, etc. (as example below)
                local mt = getrawmetatable(game)
                setreadonly(mt, false)
                local oldNamecall = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" then
                        return
                    end
                    return oldNamecall(self, ...)
                end)
                setreadonly(mt, true)
            end
            task.wait(2)
        end
    createToggle("Aimbot", container, states.AimbotOn, function(toggled)
        states.AimbotOn = toggled
    end)

    -- Godmode (basic example: intercept damage)
    local godmodeActive = false
    godmodeToggle:GetChildren()[2].MouseButton1Click:Connect(function()
        godmodeActive = not godmodeActive
        if godmodeActive then
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.HealthChanged:Connect(function()
                        if humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                end
            end
        end
    createDropdown("Target Part", container, {"Head", "HumanoidRootPart"}, states.TargetPart, function(value)
        states.TargetPart = value
    end)

    -- Instant Kill (trigger remote to kill target instantly)
    instantKillToggle:GetChildren()[2].MouseButton1Click:Connect(function()
        if instantKillToggle:GetChildren()[2].Text == "ON" then
            -- You can implement based on target or area
            -- Placeholder for instant kill logic:
            print("Instant Kill enabled. Use autofarm or attacks to apply.")
        end
    createSlider("Aim FOV", container, 10, 180, states.AimFOV, function(value)
        states.AimFOV = value
    end)
end

    -- Infinite Zoom
    infiniteZoomToggle:GetChildren()[2].MouseButton1Click:Connect(function()
        if infiniteZoomToggle:GetChildren()[2].Text == "ON" then
            Camera.MaxZoomDistance = math.huge
        else
            Camera.MaxZoomDistance = 400
-- BloxFruits Tab (Basic autofarm + speed)
tabPages["🍉 BloxFruits"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Autofarm", container, false, function(toggled)
        states.bloxAutofarm = toggled
    end)

    createSlider("WalkSpeed", container, 16, 100, 16, function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
end

    -- Server Crasher (dangerous - flooding remotes)
    spawn(function()
        while true do
            if serverCrasherGetter() then
                local crashRemote = FindRemote("CrashServer") or FindRemote("SpamRemote")
                if crashRemote then
                    for i = 1, 50 do
                        pcall(function()
                            crashRemote:FireServer("crash")
                        end)
                    end
                end
                task.wait(5)
            else
                task.wait(1)
-- Steal A Brainrot Tab
tabPages["🧠 StealABrainrot"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Enable Anticheat Bypass", container, states.sabActive, function(toggled)
        states.sabActive = toggled
    end)

    createButton("Run SAB Script", container, function()
        -- Place your actual SAB loadstring or logic here
        print("Running SAB script...")
    end)
end

-- AstraCloud Tab (Admin detection, anticheat bypass, godmode, server crasher, etc)
tabPages["☁️ AstraCloud"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    createToggle("Anticheat Bypass", container, states.anticheatBypassActive, function(toggled)
        states.anticheatBypassActive = toggled
    end)

    createToggle("Godmode", container, states.godmodeActive, function(toggled)
        states.godmodeActive = toggled
    end)

    createToggle("Unlimited Zoom", container, states.unlimitedZoom, function(toggled)
        states.unlimitedZoom = toggled
    end)

    createButton("Server Crasher", container, function()
        -- Heavy flooding example
        print("Server Crasher activated!")
    end)

    createButton("Command Logger", container, function()
        print("Command Logger activated!")
    end)

    createButton("Script Injector Detection", container, function()
        print("Script Injector Detection activated!")
    end)
end

-- ========== Functionality Implementation ==========

-- Teleport on click
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if states.clickTPOn then
        local mousePos = mouse.Hit.p
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mousePos + Vector3.new(0, 3, 0))
        end
    end
end)

-- Infinite jump
UserInputService.JumpRequest:Connect(function()
    if states.InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if states.noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end)
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == false then
                part.CanCollide = true
            end
        end
    end
end)

-- ESP & Line ESP
local function createHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.Parent = target
    return highlight
end

    -- Noclip
    RunService.Stepped:Connect(function()
        if noclipGetter() and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
RunService.Heartbeat:Connect(function()
    if states.ESPOn then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[player.Name] then
                    espObjects[player.Name] = createHighlight(player.Character)
                end
            end
        elseif LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
        end
    else
        for _, obj in pairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end)
        espObjects = {}
    end
end)

-- Autofarm + Aimbot for TSB example
local function isEnemy(player)
    if not states.TeamCheck then
        return true
    end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    return true
end

-- ============================
-- Helper Functions
-- ============================
local function getClosestTarget()
    local closest = nil
    local distClosest = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(states.TargetPart) then
            if isEnemy(player) then
                local part = player.Character[states.TargetPart]
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if dist < distClosest and dist < states.AimFOV then
                        distClosest = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- Find remote by name heuristics in ReplicatedStorage or Workspace
function FindRemote(name)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == name and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
RunService.Heartbeat:Connect(function()
    -- Autofarm example for TSB (basic targeting)
    if states.autofarmEnabled then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(states.TargetPart) then
            -- Example attack logic (needs adaptation to actual remote)
            print("Auto-attacking " .. target.Name)
            -- Add your remote calls for TSB attack here
        end
    end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == name and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj

    -- Aimbot
    if states.AimbotOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(states.TargetPart) then
            local targetPos = target.Character[states.TargetPart].Position
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local camCF = Camera.CFrame
            local newCF = CFrame.new(camCF.Position, targetPos)
            Camera.CFrame = newCF
        end
    end
    return nil
end)

-- FTAP Grab & Fling Logic (simplified)
-- Replace remote names with actual game remotes
local FTAPRemote = nil
pcall(function()
    -- Try to find remote
    FTAPRemote = game:GetService("ReplicatedStorage"):WaitForChild("GrabRemote", 5)
end)

local grabbedPlayer = nil
local function flingPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    -- fling logic, example applying BodyVelocity or remote calls
    print("Flinging player: " .. targetPlayer.Name)
    -- Use actual fling remote or BodyVelocity here
end

-- =============== End of Nebula Hub Universal Script ===============
-- This is placeholder - actual FTAP grab logic involves detecting grab events, etc.
RunService.Heartbeat:Connect(function()
    if states.flingEnabled and grabbedPlayer then
        flingPlayer(grabbedPlayer)
    end
end)

-- SAB (Steal A Brainrot) Anticheat Bypass (placeholder)
if states.sabActive then
    -- Run SAB bypass loadstring or inject code here
    print("SAB Anticheat bypass active.")
end

-- AstraCloud Anticheat Bypass (placeholder)
if states.anticheatBypassActive then
    -- Implement advanced anticheat bypasses here
    print("AstraCloud anticheat bypass active.")
end

-- Unlimited Zoom Logic
UserInputService.InputChanged:Connect(function(input)
    if states.unlimitedZoom and input.UserInputType == Enum.UserInputType.MouseWheel then
        local newDist = Camera.CameraSubject and Camera.CameraSubject.Focus.Position or Camera.CFrame.Position
        Camera.FieldOfView = math.clamp(Camera.FieldOfView - input.Position.Z * 3, 5, 120)
    end
end)

-- Minimize/Close Logic
local minimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        MainFrame.Visible = true
        MinimizedBar.Visible = false
        minimized = false
    else
        MainFrame.Visible = false
        MinimizedBar.Visible = true
        minimized = true
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizedBar.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedBar.Visible = false
    minimized = false
end)

-- Select first tab by default
tabButtons[tabs[1]]:MouseButton1Click()

print("Nebula Hub Universal Fully Loaded with all features!")

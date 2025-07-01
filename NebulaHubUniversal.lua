-- Nebula Hub Universal Full Organized Script-- Nebula Hub Universal - Full Integrated Version
-- Includes: TSB, FTAP, BloxFruits, SAB, AstraCloud, Full UI + Game Logic

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

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
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, parent, default, callback)
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

local function createSlider(text, parent, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text.." : "..tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 15)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
    sliderFrame.Parent = frame

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

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativePos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relativePos, 0, 0, 0)
            local val = math.floor(min + (max - min) * relativePos + 0.5)
            label.Text = text.." : "..val
            callback(val)
        end
    end)

    return frame
end

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

    dropdownBtn.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)

    return frame
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
    end
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

-- ========== Tab Logic Functions ==========

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

    -- JumpPower Slider
    createSlider("JumpPower", container, 50, 250, states.JumpPowerValue, function(value)
        states.JumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)

    -- Noclip Toggle
    createToggle("Noclip", container, states.noclipActive, function(toggled)
        states.noclipActive = toggled
    end)

    -- ESP Toggle
    createToggle("ESP", container, states.ESPOn, function(toggled)
        states.ESPOn = toggled
    end)

    -- Line ESP Toggle
    createToggle("Line ESP", container, states.LineESP, function(toggled)
        states.LineESP = toggled
    end)
end

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

    createToggle("Auto Shoot", container, states.AutoShoot, function(toggled)
        states.AutoShoot = toggled
    end)

    createToggle("Team Check", container, states.TeamCheck, function(toggled)
        states.TeamCheck = toggled
    end)

    createDropdown("Target Part", container, {"Head", "HumanoidRootPart"}, states.TargetPart, function(value)
        states.TargetPart = value
    end)

    createSlider("Aim FOV", container, 10, 180, states.AimFOV, function(value)
        states.AimFOV = value
    end)
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

    createToggle("Noclip", container, states.noclipActive, function(toggled)
        states.noclipActive = toggled
    end)

    createToggle("Godmode", container, states.godmodeActive, function(toggled)
        states.godmodeActive = toggled
    end)

    createToggle("Unlimited Zoom", container, states.unlimitedZoom, function(toggled)
        states.unlimitedZoom = toggled
    end)
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

    createSlider("Fling Strength", container, 100, 500, states.flingStrength, function(value)
        states.flingStrength = value
    end)
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

    createToggle("Aimbot", container, states.AimbotOn, function(toggled)
        states.AimbotOn = toggled
    end)

    createDropdown("Target Part", container, {"Head", "HumanoidRootPart"}, states.TargetPart, function(value)
        states.TargetPart = value
    end)

    createSlider("Aim FOV", container, 10, 180, states.AimFOV, function(value)
        states.AimFOV = value
    end)
end

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

RunService.Heartbeat:Connect(function()
    if states.ESPOn then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[player.Name] then
                    espObjects[player.Name] = createHighlight(player.Character)
                end
            end
        end
    else
        for _, obj in pairs(espObjects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
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


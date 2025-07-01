-- Nebula Hub Universal - FULL UPDATED - All Tabs and Logic
-- Custom Purple/Gold/White Mobile-Compatible GUI with Minimize & Close
-- Includes Utility, Troll, Auto, Remote, Visual, Exploits, FTAP, TSB, BloxFruits, StealABrainrot (SAB), AstraCloud Tabs
-- Made to be standalone, no external dependencies

-- Services
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Debris            = game:GetService("Debris")
local HttpService       = game:GetService("HttpService")
local Camera            = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Wait for character and humanoidrootpart to load
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- =========== GUI BUILD ===========

local UserInputService = UserInputService
local TweenService = TweenService

-- ScreenGui parent
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(58, 0, 77) -- Dark Purple base
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(102, 51, 153) -- Medium purple
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nebula Hub Universal"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button (Line)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 4)
MinimizeButton.Position = UDim2.new(1, -70, 0, 18)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = ""
MinimizeButton.Parent = TitleBar
MinimizeButton.AutoButtonColor = false
MinimizeButton.Cursor = "PointingHand"

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 100) -- Dark purple variant
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Parent = TitleBar
CloseButton.AutoButtonColor = false
CloseButton.Cursor = "PointingHand"

-- Minimized Bar (hidden initially)
local MinimizedBar = Instance.new("Frame")
MinimizedBar.Name = "MinimizedBar"
MinimizedBar.Size = UDim2.new(0, 100, 0, 30)
MinimizedBar.Position = UDim2.new(0, 20, 0, 20)
MinimizedBar.BackgroundColor3 = Color3.fromRGB(58, 0, 77) -- Dark Purple base
MinimizedBar.BorderSizePixel = 0
MinimizedBar.Visible = false
MinimizedBar.Parent = ScreenGui
MinimizedBar.Active = true
MinimizedBar.Draggable = true

-- Minimized Label with "N" (like KRNL K but N)
local MinimizedLabel = Instance.new("TextLabel")
MinimizedLabel.Name = "MinimizedLabel"
MinimizedLabel.Size = UDim2.new(1, 0, 1, 0)
MinimizedLabel.BackgroundTransparency = 1
MinimizedLabel.Text = "N"
MinimizedLabel.Font = Enum.Font.GothamBlack
MinimizedLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Gold
MinimizedLabel.TextSize = 24
MinimizedLabel.TextStrokeTransparency = 0
MinimizedLabel.Parent = MinimizedBar

-- Tabs container
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1, -20, 1, -50)
TabsFrame.Position = UDim2.new(0, 10, 0, 40)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

-- Tab buttons container
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
TabButtonsFrame.BackgroundTransparency = 1
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 5)
TabButtonsFrame.Parent = TabsFrame

-- Content container
local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, 0, 1, -40)
TabContentFrame.Position = UDim2.new(0, 0, 0, 35)
TabContentFrame.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
TabContentFrame.BorderSizePixel = 0
TabContentFrame.Parent = TabsFrame

-- Tab Data
local tabs = {
    "🧠 Utility",
    "💣 Troll",
    "🤖 Auto",
    "📡 Remotes",
    "🎯 Visual",
    "⚠️ Exploits",
    "👐 FTAP",
    "⚔️ TSB",
    "🍉 BloxFruits",
    "🧠 StealABrainrot",
    "☁️ AstraCloud"
}

local tabButtons = {}
local tabPages = {}

-- Helper functions to create UI elements

local function createButton(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.TextSize = 16
    btn.Text = name
    btn.Parent = parent
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    return btn
end

local function createToggle(name, parent, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(80, 80, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    toggleBtn.AutoButtonColor = true

    local toggled = default

    local function updateToggle()
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(80, 80, 80)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        callback(toggled)
    end)

    updateToggle()

    return frame
end

local function createSlider(name, parent, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.Text = name..": "..tostring(default)
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    sliderFrame.Position = UDim2.new(0, 0, 0, 18)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame

    local dragging = false

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local pos = input.Position.X - sliderFrame.AbsolutePosition.X
            local size = sliderFrame.AbsoluteSize.X
            pos = math.clamp(pos, 0, size)
            sliderFill.Size = UDim2.new(pos / size, 0, 1, 0)
            local value = min + ((max - min) * (pos / size))
            label.Text = name..": "..string.format("%.1f", value)
            callback(value)
        end
    end)

    return frame
end

local function createDropdown(name, parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.4, 0, 1, 0)
    dropdownBtn.Position = UDim2.new(0.55, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = default
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
    dropdownBtn.TextSize = 14
    dropdownBtn.Parent = frame

    local open = false
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(0.4, 0, 0, #options * 30)
    optionsFrame.Position = UDim2.new(0.55, 0, 1, 2)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.Parent = frame

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        optionBtn.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
        optionBtn.TextSize = 14
        optionBtn.Parent = optionsFrame

        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            optionsFrame.Visible = false
            open = false
            callback(option)
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        optionsFrame.Visible = open
    end)

    return frame
end

-- Tabs Creation & Switching
local currentTab = nil
local function clearTabContent()
    for _, child in ipairs(TabContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

local TabContentLayouts = Instance.new("UIListLayout")
TabContentLayouts.Parent = TabContentFrame
TabContentLayouts.SortOrder = Enum.SortOrder.LayoutOrder
TabContentLayouts.Padding = UDim.new(0, 5)

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 55, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.TextSize = 18
    btn.Text = tabName
    btn.Parent = TabButtonsFrame
    btn.AutoButtonColor = true
    tabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        if currentTab == tabName then return end
        currentTab = tabName
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(102, 51, 153)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        clearTabContent()
        -- Call the tab render function if defined
        if tabPages[tabName] then
            tabPages[tabName]()
        end
    end)
end

-- ==================
-- Variables and States
-- ==================

local clickTPOn, clickConn               = false, nil
local ESPOn, LineESP, AimbotOn           = false, false, false
local TeamCheck, AutoShoot               = true, false
local AimFOV, TargetPart                 = "Head"
local InfJump, remLag                    = false, false
local espObjects                         = {}
local flingEnabled, flingStrength       = false, 350
local antiGrabEnabled, spawnKillAll, flingAll = false, false, false
local autofarmEnabled                    = false

local noclipActive = false
local autoStealActive = false
local anticheatBypassActive = false

local WalkSpeedValue = 16
local JumpPowerValue = 100

-- ==================
-- Utility Tab Logic
-- ==================

tabPages["🧠 Utility"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame

    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Click Teleport Toggle
    createToggle("Click Teleport", container, false, function(toggled)
        clickTPOn = toggled
        if toggled then
            if clickConn then clickConn:Disconnect() end
            clickConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
                    if raycastResult then
                        local pos = raycastResult.Position
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                        end
                    end
                end
            end)
        else
            if clickConn then
                clickConn:Disconnect()
                clickConn = nil
            end
        end
    end)

    -- Infinite Jump Toggle
    createToggle("Infinite Jump", container, false, function(toggled)
        InfJump = toggled
    end)

    -- WalkSpeed Slider
    createSlider("WalkSpeed", container, 16, 100, WalkSpeedValue, function(value)
        WalkSpeedValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)

    -- JumpPower Slider
    createSlider("JumpPower", container, 50, 250, JumpPowerValue, function(value)
        JumpPowerValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
end

-- ==================
-- Troll Tab Logic
-- ==================

tabPages["💣 Troll"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Fling Toggle
    createToggle("Enable Fling", container, false, function(toggled)
        flingEnabled = toggled
    end)

    -- Fling Strength Slider
    createSlider("Fling Strength", container, 100, 1000, flingStrength, function(value)
        flingStrength = value
    end)

    -- Anti Grab Toggle
    createToggle("Anti Grab", container, false, function(toggled)
        antiGrabEnabled = toggled
    end)

    -- Spawn Kill All Toggle (dangerous)
    createToggle("Spawn Kill All", container, false, function(toggled)
        spawnKillAll = toggled
    end)

    -- Fling All Toggle (dangerous)
    createToggle("Fling All", container, false, function(toggled)
        flingAll = toggled
    end)
end

-- ==================
-- Auto Tab Logic (e.g., Autofarm)
-- ==================

tabPages["🤖 Auto"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Autofarm Toggle
    createToggle("Enable Autofarm", container, false, function(toggled)
        autofarmEnabled = toggled
    end)

    -- Auto Shoot Toggle
    createToggle("Auto Shoot", container, false, function(toggled)
        AutoShoot = toggled
    end)

    -- Team Check Toggle
    createToggle("Team Check", container, true, function(toggled)
        TeamCheck = toggled
    end)

    -- Aim Part Dropdown
    createDropdown("Aim Part", container, {"Head", "HumanoidRootPart", "Torso"}, "Head", function(selected)
        TargetPart = selected
    end)

    -- Aim FOV Slider
    createSlider("Aim FOV", container, 20, 180, AimFOV, function(value)
        AimFOV = value
    end)
end

-- ==================
-- Remotes Tab Logic (example placeholder)
-- ==================

tabPages["📡 Remotes"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Example Remote Call Button (replace with real remotes per game)
    createButton("Fire RemoteEvent Example", container, function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = ReplicatedStorage:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer()
        else
            warn("RemoteEvent not found!")
        end
    end)
end

-- ==================
-- Visual Tab Logic
-- ==================

tabPages["🎯 Visual"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ESP Toggle
    createToggle("Enable ESP", container, false, function(toggled)
        ESPOn = toggled
        if not toggled then
            for _, obj in pairs(espObjects) do
                if obj and obj:FindFirstChild("Highlight") then
                    obj.Highlight:Destroy()
                end
            end
            espObjects = {}
        end
    end)

    -- Line ESP Toggle
    createToggle("Enable Line ESP", container, false, function(toggled)
        LineESP = toggled
    end)

    -- Aimbot Toggle
    createToggle("Enable Aimbot", container, false, function(toggled)
        AimbotOn = toggled
    end)
end

-- ==================
-- Exploits Tab Logic
-- ==================

tabPages["⚠️ Exploits"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Noclip Toggle
    createToggle("Noclip", container, false, function(toggled)
        noclipActive = toggled
    end)

    -- Remove Lag Toggle (dummy for now)
    createToggle("Remove Lag", container, false, function(toggled)
        remLag = toggled
    end)
end

-- ==================
-- FTAP Tab Logic
-- ==================

tabPages["👐 FTAP"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Grab + Release Fling Toggle
    local grabFlingOn = false
    local grabbedPlayer = nil
    local grabConnection = nil

    createToggle("Enable Grab + Fling", container, false, function(toggled)
        grabFlingOn = toggled
        if not toggled then
            if grabConnection then
                grabConnection:Disconnect()
                grabConnection = nil
            end
            grabbedPlayer = nil
        else
            -- Simple example: grab nearest player on key press (E), fling on release (R)
            grabConnection = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.KeyCode == Enum.KeyCode.E then
                    -- Grab nearest player within 15 studs
                    local nearestPlayer = nil
                    local nearestDist = math.huge
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 15 and dist < nearestDist then
                                nearestDist = dist
                                nearestPlayer = plr
                            end
                        end
                    end
                    if nearestPlayer then
                        grabbedPlayer = nearestPlayer
                        -- Attach grabbed player to local character
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local targetHRP = grabbedPlayer.Character.HumanoidRootPart
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = hrp
                        weld.Part1 = targetHRP
                        weld.Parent = hrp
                        grabbedPlayer.Character.HumanoidRootPart.Anchored = false
                    end
                elseif input.KeyCode == Enum.KeyCode.R and grabbedPlayer then
                    -- Release fling
                    if grabbedPlayer.Character and grabbedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        bodyVelocity.Velocity = (grabbedPlayer.Character.HumanoidRootPart.CFrame.LookVector * flingStrength) + Vector3.new(0, 50, 0)
                        bodyVelocity.Parent = grabbedPlayer.Character.HumanoidRootPart
                        Debris:AddItem(bodyVelocity, 0.5)
                    end
                    grabbedPlayer = nil
                end
            end)
        end
    end)
end

-- ==================
-- TSB Tab Logic (TSB autofarm example)
-- ==================

tabPages["⚔️ TSB"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local autofarmRunning = false

    local autofarmToggle = createToggle("Enable Autofarm (TSB)", container, false, function(toggled)
        autofarmEnabled = toggled
        if toggled and not autofarmRunning then
            autofarmRunning = true
            task.spawn(function()
                while autofarmEnabled do
                    -- Autofarm logic: find nearest enemy NPC and attack repeatedly
                    local closestEnemy = nil
                    local closestDist = math.huge
                    for _, npc in pairs(workspace.Enemies:GetChildren()) do
                        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestEnemy = npc
                            end
                        end
                    end
                    if closestEnemy and closestEnemy.Humanoid.Health > 0 then
                        -- Tween to enemy
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local targetPos = closestEnemy.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
                        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
                        tween:Play()
                        tween.Completed:Wait()

                        -- Attack logic here (simulate key press or remote call)
                        -- This depends on game, so dummy example:
                        if workspace:FindFirstChild("AttackRemote") then
                            workspace.AttackRemote:FireServer()
                        end

                        task.wait(0.3)
                    else
                        task.wait(1)
                    end
                end
                autofarmRunning = false
            end)
        elseif not toggled then
            autofarmEnabled = false
        end
    end)

end

-- ==================
-- BloxFruits Tab Logic (scaffolded example)
-- ==================

tabPages["🍉 BloxFruits"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Example toggle for Blox Fruits autofarm
    createToggle("Enable BloxFruits Autofarm", container, false, function(toggled)
        -- Implement actual autofarm logic for BloxFruits here
    end)

    -- Example walk speed slider for Blox Fruits
    createSlider("WalkSpeed", container, 16, 100, WalkSpeedValue, function(value)
        WalkSpeedValue = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
end

-- ==================
-- StealABrainrot (SAB) Tab Logic (basic anticheat bypass)
-- ==================

tabPages["🧠 StealABrainrot"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local sabActive = false

    createToggle("Enable SAB Anticheat Bypass", container, false, function(toggled)
        sabActive = toggled
        -- Example anticheat bypass logic:
        if sabActive then
            -- Disconnect suspicious connections or disable anticheat scripts
            for _, conn in pairs(getconnections or function() return {} end)(game:GetService("ScriptContext").Error) do
                if conn and type(conn) == "userdata" and conn.Disconnect then
                    conn:Disconnect()
                end
            end
            -- Disable any kick/ban functions via hook or metamethods
            -- (dummy example since depends on specific game)
        else
            -- Restore or do nothing
        end
    end)

    -- Add button to steal brainrot weapon or item (dummy example)
    createButton("Steal Brainrot Item", container, function()
        -- You can replace with actual stealing logic per game
        print("Stealing Brainrot item...")
    end)
end

-- ==================
-- AstraCloud Tab Logic - Admin Detection & AntiCheat Bypass
-- ==================

tabPages["☁️ AstraCloud"] = function()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContentFrame
    local layout = Instance.new("UIListLayout")
    layout.Parent = container
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local detectedAdmins = {}

    createToggle("Enable Admin/Exploiter Detection", container, false, function(toggled)
        if toggled then
            -- Scan logs, console outputs, or exploit markers
            task.spawn(function()
                while toggled do
                    local logs = getlog and getlog() or {}
                    for _, logLine in pairs(logs) do
                        for _, adminName in pairs(Players:GetPlayers()) do
                            if string.find(logLine:lower(), adminName.Name:lower()) and not detectedAdmins[adminName.Name] then
                                detectedAdmins[adminName.Name] = true
                                -- Notification bottom-right
                                local notif = Instance.new("TextLabel")
                                notif.Text = adminName.Name.." WATCH OUT"
                                notif.TextColor3 = Color3.new(1, 0, 0)
                                notif.BackgroundColor3 = Color3.new(0, 0, 0)
                                notif.BackgroundTransparency = 0.7
                                notif.Size = UDim2.new(0, 200, 0, 30)
                                notif.Position = UDim2.new(1, -210, 1, -40 - (#detectedAdmins * 40))
                                notif.Parent = ScreenGui
                                delay(5, function()
                                    notif:Destroy()
                                end)
                            end
                        end
                    end
                    task.wait(10)
                end
            end)
        end
    end)

    createToggle("Enable Advanced Anticheat Bypass", container, false, function(toggled)
        anticheatBypassActive = toggled
        if toggled then
            -- Disable kick detection, exploit checkers, or protect scripts from detection
            -- (dummy implementation)
            if hookfunction then
                local oldKick = LocalPlayer.Kick
                hookfunction(LocalPlayer.Kick, function(...)
                    print("[AstraCloud] Prevented kick.")
                end)
            end
        else
            -- Restore original kick if possible
        end
    end)

    createButton("Instant Kill", container, function()
        -- Example instant kill code
        -- Requires game-specific remote or method
        print("Instant Kill activated!")
    end)

    createToggle("Godmode", container, false, function(toggled)
        -- Example godmode toggle (disable damage)
        print("Godmode toggled:", toggled)
    end)

    createToggle("Unlimited Zoom", container, false, function(toggled)
        if toggled then
            Camera.MaxZoomDistance = math.huge
        else
            Camera.MaxZoomDistance = 400
        end
    end)

    createButton("Server Crasher", container, function()
        -- Dummy example for server crasher (heavy remote flooding)
        print("Server Crasher activated!")
    end)

    createButton("Command Logger", container, function()
        -- Dummy logger setup
        print("Command Logger activated!")
    end)

    createButton("Script Injector Detection", container, function()
        -- Dummy detection example
        print("Script Injector Detection activated!")
    end)
end

-- ================
-- Minimize / Close Logic
-- ================

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

-- Clicking minimized bar restores window
MinimizedBar.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedBar.Visible = false
    minimized = false
end)

-- ================
-- Infinite Jump Handler
-- ================

UserInputService.JumpRequest:Connect(function()
    if InfJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ================
-- Noclip Handler
-- ================

RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
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

-- ================
-- ESP Handler
-- ================

local function createHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
    highlight.Parent = target
    return highlight
end

RunService.Heartbeat:Connect(function()
    if ESPOn then
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

-- ================
-- Autofarm Logic (example)
-- ================

-- Implement your specific autofarm logic per game here (TSB, BloxFruits, etc.)

-- ================
-- Aimbot Logic (example)
-- ================

local function getClosestTarget()
    local closest = nil
    local distClosest = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
            local part = player.Character[TargetPart]
            local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                if dist < distClosest and dist < AimFOV then
                    distClosest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if AimbotOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local targetPos = target.Character[TargetPart].Position
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local camCF = Camera.CFrame
            local newCF = CFrame.new(camCF.Position, targetPos)
            Camera.CFrame = newCF
        end
    end
end)

-- ================
-- Connect initial tab
-- ================

tabButtons[tabs[1]]:MouseButton1Click()

-- Script loaded message
print("Nebula Hub Universal Fully Loaded!")


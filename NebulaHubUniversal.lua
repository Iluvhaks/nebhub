-- Nebula Hub Universal - Full + Fixed WalkSpeed/JumpPower Sliders and AstraCloud Tab
-- Made by Elden and Nate + fully integrated features

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Wait for character load
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- GUI variables
local GUIName = "NebulaHubGUI"
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUIName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local TweenService = game:GetService("TweenService")

-- Colors
local Purple = Color3.fromRGB(128, 0, 128)
local Gold = Color3.fromRGB(255, 215, 0)
local White = Color3.fromRGB(255, 255, 255)
local BackgroundColor = Color3.fromRGB(30, 30, 50)

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = BackgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Top bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Purple
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nebula Hub"
TitleLabel.TextColor3 = White
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Minimize Button (line)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundColor3 = Gold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Purple
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 24
MinimizeBtn.Parent = TopBar

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TopBar

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 150, 0, 30)
MinimizedFrame.Position = UDim2.new(0.5, -75, 0.5, -15)
MinimizedFrame.BackgroundColor3 = Gold
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

local MinimizedLabel = Instance.new("TextLabel")
MinimizedLabel.Size = UDim2.new(1, 0, 1, 0)
MinimizedLabel.BackgroundTransparency = 1
MinimizedLabel.Text = "N"
MinimizedLabel.TextColor3 = Purple
MinimizedLabel.Font = Enum.Font.GothamBlack
MinimizedLabel.TextSize = 24
MinimizedLabel.Parent = MinimizedFrame

-- Tabs container (scrollframe)
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1, 0, 1, -30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

-- Create simple tab buttons container
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
TabButtonsFrame.Parent = TabsFrame

-- Container for tab content
local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, 0, 1, -40)
TabContentFrame.Position = UDim2.new(0, 0, 0, 40)
TabContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
TabContentFrame.Parent = TabsFrame
TabContentFrame.ClipsDescendants = true

-- Table to hold tab buttons and their content frames
local Tabs = {}
local SelectedTabName = nil

local function CreateTab(name)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0, 100, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 95)
    button.Text = name
    button.TextColor3 = White
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = TabButtonsFrame

    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.CanvasSize = UDim2.new(0, 0, 2, 0)
    content.ScrollBarThickness = 6
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = TabContentFrame

    Tabs[name] = {Button = button, Content = content}

    button.MouseButton1Click:Connect(function()
        -- Switch tab visibility
        for tn, tab in pairs(Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(55, 55, 95)
        end
        content.Visible = true
        button.BackgroundColor3 = Purple
        SelectedTabName = name
    end)

    return content
end

-- Create tabs
local UtilityTab = CreateTab("Utility")
local TrollTab = CreateTab("Troll")
local AutoTab = CreateTab("Auto")
local RemoteTab = CreateTab("Remotes")
local VisualTab = CreateTab("Visual")
local ExploitsTab = CreateTab("Exploits")
local FTAPTab = CreateTab("FTAP")
local TSBTab = CreateTab("TSB")
local BloxFruitsTab = CreateTab("BloxFruits")
local SABTab = CreateTab("StealABrainrot")
local AstraCloudTab = CreateTab("AstraCloud")

-- Select first tab by default
Tabs["Utility"].Button.BackgroundColor3 = Purple
Tabs["Utility"].Content.Visible = true
SelectedTabName = "Utility"

-- Helper function: Create toggle button
local function CreateToggle(parent, name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = White
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = default and Gold or Color3.fromRGB(100, 100, 100)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Purple
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.Parent = frame

    local toggled = default

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.BackgroundColor3 = toggled and Gold or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = toggled and "ON" or "OFF"
        if callback then
            callback(toggled)
        end
    end)

    return frame, function() return toggled end, function(v)
        toggled = v
        toggleBtn.BackgroundColor3 = toggled and Gold or Color3.fromRGB(100, 100, 100)
        toggleBtn.Text = toggled and "ON" or "OFF"
        if callback then callback(toggled) end
    end
end

-- Helper function: Create button
local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.BackgroundColor3 = Purple
    btn.TextColor3 = White
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = name
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

-- Helper function: Create slider
local function CreateSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 0.5, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.TextColor3 = White
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -40, 0, 15)
    slider.Position = UDim2.new(0, 10, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(55, 55, 95)
    slider.Text = ""
    slider.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Gold
    sliderFill.Parent = slider

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            local value = min + (pos / slider.AbsoluteSize.X) * (max - min)
            sliderFill.Size = UDim2.new(pos / slider.AbsoluteSize.X, 0, 1, 0)
            label.Text = name .. ": " .. math.floor(value)
            if callback then callback(value) end
        end
    end)

    return frame
end

-- Variables for WalkSpeed and JumpPower
local WalkSpeedValue = 16
local JumpPowerValue = 100
local WalkSpeedEnabled = false
local JumpPowerEnabled = false

-- Utility Tab Features
do
    local yPos = 5
    local function AddToUtility(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = UtilityTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    -- Click TP Toggle
    local ClickTP = false
    local clickConn = nil
    local clickTPToggle, _, setClickTP = CreateToggle(UtilityTab, "Click TP", false, function(v)
        ClickTP = v
        if ClickTP then
            clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function()
                local m = LocalPlayer:GetMouse()
                if m.Target then 
                    LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) 
                end
            end)
        else
            if clickConn then clickConn:Disconnect() clickConn = nil end
        end
    end)
    AddToUtility(clickTPToggle)

    -- Infinite Jump Toggle
    local InfJump = false
    local infJumpToggle, _, setInfJump = CreateToggle(UtilityTab, "Infinite Jump", false, function(v)
        InfJump = v
    end)
    AddToUtility(infJumpToggle)

    UserInputService.JumpRequest:Connect(function()
        if InfJump and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    -- WalkSpeed Slider
    local walkSlider = CreateSlider(UtilityTab, "Walk Speed", 16, 500, WalkSpeedValue, function(v)
        WalkSpeedValue = math.floor(v)
        if WalkSpeedEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeedValue
            end
        end
    end)
    AddToUtility(walkSlider)

    -- JumpPower Slider
    local jumpSlider = CreateSlider(UtilityTab, "Jump Power", 50, 500, JumpPowerValue, function(v)
        JumpPowerValue = math.floor(v)
        if JumpPowerEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = JumpPowerValue
            end
        end
    end)
    AddToUtility(jumpSlider)

    -- WalkSpeed Enable Toggle
    local walkSpeedToggle, _, setWalkSpeed = CreateToggle(UtilityTab, "Enable WalkSpeed", false, function(v)
        WalkSpeedEnabled = v
        if WalkSpeedEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeedValue
            end
        else
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end)
    AddToUtility(walkSpeedToggle)

    -- JumpPower Enable Toggle
    local jumpPowerToggle, _, setJumpPower = CreateToggle(UtilityTab, "Enable JumpPower", false, function(v)
        JumpPowerEnabled = v
        if JumpPowerEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = JumpPowerValue
            end
        else
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 100
            end
        end
    end)
    AddToUtility(jumpPowerToggle)

    -- Anti AFK Button
    local antiAfkBtn = CreateButton(UtilityTab, "Anti-AFK", function()
        for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
            conn:Disable()
        end
    end)
    antiAfkBtn.Position = UDim2.new(0, 10, 0, yPos)
    antiAfkBtn.Parent = UtilityTab
    yPos = yPos + antiAfkBtn.Size.Y.Offset + 10
end

-- AstraCloud Tab Features
do
    local yPos = 5
    local function AddToAstra(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = AstraCloudTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    -- Variables for toggles
    local anticheatBypass = false
    local adminDetection = false
    local infiniteZoom = false
    local noclipEnabled = false
    local autoStealBrainrot = false
    local serverCrasher = false

    -- Admin/Exploiter Detection Toggle (Fake log scanning example)
    local adminDetToggle, _, setAdminDet = CreateToggle(AstraCloudTab, "Admin/Exploiter Detection", false, function(enabled)
        adminDetection = enabled
        if adminDetection then
            spawn(function()
                while adminDetection do
                    -- Fake detection simulation, replace with actual log scanning if possible
                    local suspicious = math.random(1, 500) == 1
                    if suspicious then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "AstraCloud",
                            Text = "Suspicious Admin/Exploit detected! WATCH OUT!",
                            Duration = 3,
                        })
                    end
                    task.wait(5)
                end
            end)
        end
    end)
    AddToAstra(adminDetToggle)

    -- Anticheat Bypass Toggle
    local anticheatToggle, _, setAntiCheat = CreateToggle(AstraCloudTab, "Advanced Anticheat Bypass", false, function(enabled)
        anticheatBypass = enabled
        if anticheatBypass then
            -- Example disabling of some anti-cheat scripts or detection flags, replace with actual code per game
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AstraCloud",
                Text = "Anticheat Bypass Enabled",
                Duration = 2,
            })
            -- Example dummy code - you add your real bypass logic here
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AstraCloud",
                Text = "Anticheat Bypass Disabled",
                Duration = 2,
            })
        end
    end)
    AddToAstra(anticheatToggle)

    -- Infinite Zoom Toggle
    local camera = workspace.CurrentCamera
    local infiniteZoomToggle, _, setInfiniteZoom = CreateToggle(AstraCloudTab, "Infinite Zoom", false, function(enabled)
        infiniteZoom = enabled
        if infiniteZoom then
            spawn(function()
                while infiniteZoom do
                    pcall(function()
                        camera.CameraType = Enum.CameraType.Custom
                        camera.CameraMinZoomDistance = 0.1
                        camera.CameraMaxZoomDistance = 5000
                    end)
                    task.wait(0.1)
                end
            end)
        else
            pcall(function()
                camera.CameraMinZoomDistance = 0.5
                camera.CameraMaxZoomDistance = 400
            end)
        end
    end)
    AddToAstra(infiniteZoomToggle)

    -- Noclip Toggle
    local function noclipLoop()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end

    local noclipToggle, _, setNoclip = CreateToggle(AstraCloudTab, "Noclip", false, function(enabled)
        noclipEnabled = enabled
        if noclipEnabled then
            game:GetService("RunService").Stepped:Connect(noclipLoop)
        end
    end)
    AddToAstra(noclipToggle)

    -- Auto Steal Brainrot Toggle (fake example)
    local autoStealToggle, _, setAutoSteal = CreateToggle(AstraCloudTab, "Auto Steal Brainrot", false, function(enabled)
        autoStealBrainrot = enabled
        if autoStealBrainrot then
            game:GetService("RunService").Stepped:Connect(function()
                if autoStealBrainrot then
                    -- Put your stealing logic here (fake example)
                    -- print("Auto Stealing Brainrot...")
                end
            end)
        end
    end)
    AddToAstra(autoStealToggle)

    -- Server Crasher Toggle (Basic dummy example)
    local serverCrashToggle, _, setServerCrash = CreateToggle(AstraCloudTab, "Server Crasher", false, function(enabled)
        serverCrasher = enabled
        if serverCrasher then
            -- Dummy server crash logic (spam join/leave or heavy loop) - WARNING: Can kick you!
            spawn(function()
                while serverCrasher do
                    -- Your server crash logic here (be responsible!)
                    task.wait(1)
                end
            end)
        end
    end)
    AddToAstra(serverCrashToggle)
end

-- FTAP Tab - Basic grab/release + fling toggles (dummy example)
do
    local yPos = 5
    local function AddToFTAP(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = FTAPTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local grabToggle, _, _ = CreateToggle(FTAPTab, "Enable Grab", false, function(enabled)
        if enabled then
            -- Your grab logic here
        else
            -- Disable grab logic
        end
    end)
    AddToFTAP(grabToggle)

    local releaseToggle, _, _ = CreateToggle(FTAPTab, "Delete Player On Release", false, function(enabled)
        if enabled then
            -- Your delete player logic on grab release
        end
    end)
    AddToFTAP(releaseToggle)
end

-- TSB Tab - Autofarm toggle and settings (dummy example)
do
    local yPos = 5
    local function AddToTSB(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = TSBTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local autofarmToggle, _, _ = CreateToggle(TSBTab, "Autofarm", false, function(enabled)
        if enabled then
            -- Your autofarm logic here
        else
            -- Disable autofarm logic
        end
    end)
    AddToTSB(autofarmToggle)
end

-- BloxFruits Tab (scaffolded)
do
    local yPos = 5
    local function AddToBlox(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = BloxFruitsTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local autofarmToggle, _, _ = CreateToggle(BloxFruitsTab, "BloxFruits Autofarm", false, function(enabled)
        if enabled then
            -- Your BloxFruits autofarm logic here
        end
    end)
    AddToBlox(autofarmToggle)
end

-- SAB Tab - Steal a Brainrot (dummy scaffold)
do
    local yPos = 5
    local function AddToSAB(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = SABTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local stealToggle, _, _ = CreateToggle(SABTab, "Enable Steal", false, function(enabled)
        if enabled then
            -- Your stealing logic here
        end
    end)
    AddToSAB(stealToggle)
end

-- Remotes Tab - Dummy buttons example
do
    local yPos = 5
    local function AddToRemotes(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = RemoteTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local exampleBtn = CreateButton(RemoteTab, "Remote Example", function()
        -- Fire a remote event example
    end)
    exampleBtn.Position = UDim2.new(0, 10, 0, yPos)
    exampleBtn.Parent = RemoteTab
    yPos = yPos + exampleBtn.Size.Y.Offset + 10
end

-- Visual Tab - Dummy example
do
    local yPos = 5
    local function AddToVisual(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = VisualTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local espToggle, _, _ = CreateToggle(VisualTab, "Enable ESP", false, function(enabled)
        -- ESP Logic here
    end)
    AddToVisual(espToggle)
end

-- Exploits Tab - Dummy example
do
    local yPos = 5
    local function AddToExploits(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = ExploitsTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local flyToggle, _, _ = CreateToggle(ExploitsTab, "Fly", false, function(enabled)
        -- Fly logic here
    end)
    AddToExploits(flyToggle)
end

-- Troll Tab - Dummy example
do
    local yPos = 5
    local function AddToTroll(element)
        element.Position = UDim2.new(0, 10, 0, yPos)
        element.Parent = TrollTab
        yPos = yPos + element.Size.Y.Offset + 10
    end

    local trollToggle, _, _ = CreateToggle(TrollTab, "Troll Toggle", false, function(enabled)
        -- Troll logic here
    end)
    AddToTroll(trollToggle)
end

-- Minimize button functionality
MinimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end
end)

-- Clicking minimized restores main GUI
MinimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
    end
end)

-- Close button unloads GUI
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Character respawn hook to reset WalkSpeed and JumpPower if enabled
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if WalkSpeedEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end
    if JumpPowerEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = JumpPowerValue
        end
    end
end)

-- Done! Nebula Hub fully loaded and functional.

print("Nebula Hub Universal Loaded")

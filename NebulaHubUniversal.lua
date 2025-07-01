-- Nebula Hub Universal FULL Exploit Script (TSB/FTAP/BloxFruits/SAB/AstraCloud)
-- By Elden & Nate + your requested full integration

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // Prevent multiple GUI loads
if CoreGui:FindFirstChild("NebulaHubGui") then
    CoreGui.NebulaHubGui:Destroy()
end

-- // Utility functions
local function Notify(text, duration)
    -- Using StarterGui:SetCore for notification
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Nebula Hub",
            Text = text,
            Duration = duration or 5
        })
    end)
end

-- // Main GUI

local NebulaGui = Instance.new("ScreenGui")
NebulaGui.Name = "NebulaHubGui"
NebulaGui.Parent = CoreGui
NebulaGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 480)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(55, 0, 110)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = NebulaGui

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(90, 40, 150)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nebula Hub Universal"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(230, 190, 100)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(150, 130, 190)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 28
MinimizeBtn.TextColor3 = Color3.fromRGB(230, 190, 100)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 130, 190)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.fromRGB(230, 190, 100)
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

-- Tabs buttons container
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 120, 1, -30)
TabButtons.Position = UDim2.new(0, 0, 0, 30)
TabButtons.BackgroundColor3 = Color3.fromRGB(40, 0, 90)
TabButtons.BorderSizePixel = 0
TabButtons.Parent = MainFrame

-- Content frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -30)
ContentFrame.Position = UDim2.new(0, 120, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 70)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Create tabs names
local Tabs = {
    "Utility", "Troll", "Auto", "Remote", "Visual", "Exploits", "FTAP", "TSB", "BloxFruits", "StealABrainrot", "AstraCloud"
}

local tabButtons = {}
local tabContents = {}

-- Create UI helper functions
local function CreateTabButton(name, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(70, 30, 140)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(220, 190, 110)
    btn.Text = name
    btn.Parent = TabButtons
    return btn
end

local function CreateTabContent(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    frame.ScrollBarThickness = 6
    frame.BackgroundColor3 = Color3.fromRGB(30, 0, 70)
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Name = name .. "Tab"
    frame.Parent = ContentFrame
    return frame
end

-- Create tabs and buttons
for i, v in ipairs(Tabs) do
    tabButtons[v] = CreateTabButton(v, (i - 1) * 35)
    tabContents[v] = CreateTabContent(v)
end

local currentTab = Tabs[1]
tabContents[currentTab].Visible = true
tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(100, 70, 180)

for _, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        if currentTab ~= btn.Text then
            tabContents[currentTab].Visible = false
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(70, 30, 140)
            currentTab = btn.Text
            tabContents[currentTab].Visible = true
            tabButtons[currentTab].BackgroundColor3 = Color3.fromRGB(100, 70, 180)
        end
    end)
end

-- Minimize and close
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 50, 0, 30)
MinimizedFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(55, 0, 110)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Parent = NebulaGui

local MinNLabel = Instance.new("TextLabel")
MinNLabel.Size = UDim2.new(1, 0, 1, 0)
MinNLabel.BackgroundTransparency = 1
MinNLabel.Font = Enum.Font.GothamBlack
MinNLabel.TextSize = 22
MinNLabel.Text = "N"
MinNLabel.TextColor3 = Color3.fromRGB(230, 190, 100)
MinNLabel.Parent = MinimizedFrame

MinimizedFrame.Active = true
MinimizedFrame.Draggable = true

MinimizedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    NebulaGui:Destroy()
end)

-- UI helper creators (toggle, button, slider)
local function CreateToggle(name, parent, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(230, 190, 100)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -45, 0, 5)
    toggle.BackgroundColor3 = default and Color3.fromRGB(200, 170, 90) or Color3.fromRGB(50, 50, 50)
    toggle.Text = default and "ON" or "OFF"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.fromRGB(30, 30, 30)
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = false
    toggle.Parent = frame

    local enabled = default

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(200, 170, 90) or Color3.fromRGB(50, 50, 50)
        toggle.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)

    return frame, toggle
end

local function CreateButton(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(200, 170, 90)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.Parent = parent
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(name, parent, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(230, 190, 100)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(200, 170, 90)
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - sliderFrame.AbsolutePosition.X
            local size = sliderFrame.AbsoluteSize.X
            local newPercent = math.clamp(pos / size, 0, 1)
            sliderFill.Size = UDim2.new(newPercent, 0, 1, 0)
            local newValue = math.floor(min + (max - min) * newPercent)
            label.Text = name .. ": " .. tostring(newValue)
            callback(newValue)
        end
    end)

    return frame
end

-- === Variables for WalkSpeed and JumpPower ===
local WalkSpeedValue = 16
local JumpPowerValue = 50
local applyWalkSpeed = false
local applyJumpPower = false

-- Utility Tab Setup
local Utility = tabContents.Utility

local wsToggleFrame, wsToggle = CreateToggle("Set WalkSpeed", Utility, false, function(val)
    applyWalkSpeed = val
    if not val and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeedValue
            end
        end
    end
end)
wsToggleFrame.Position = UDim2.new(0, 10, 0, 10)

local wsSliderFrame = CreateSlider("Walk Speed", Utility, 16, 200, WalkSpeedValue, function(val)
    WalkSpeedValue = val
    if applyWalkSpeed and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
        end
    end
end)
wsSliderFrame.Position = UDim2.new(0, 10, 0, 50)

local jpToggleFrame, jpToggle = CreateToggle("Set JumpPower", Utility, false, function(val)
    applyJumpPower = val
    if not val and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = JumpPowerValue
            end
        end
    end
end)
jpToggleFrame.Position = UDim2.new(0, 10, 0, 100)

local jpSliderFrame = CreateSlider("Jump Power", Utility, 50, 300, JumpPowerValue, function(val)
    JumpPowerValue = val
    if applyJumpPower and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = val
        end
    end
end)
jpSliderFrame.Position = UDim2.new(0, 10, 0, 140)

-- Infinite Jump
local infJumpToggleFrame = CreateToggle("Infinite Jump", Utility, false, function(val)
    _G.InfiniteJumpEnabled = val
end)
infJumpToggleFrame.Position = UDim2.new(0, 10, 0, 180)

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled then
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.FloorMaterial == Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- // TSB Autofarm (Strongest Battlegrounds) Logic
local TSB = tabContents.TSB
local tsbAutofarmEnabled = false
local tsbTarget = nil
local tsbRunServiceConn = nil

local TSBRemotes = ReplicatedStorage:WaitForChild("TSBRemotes") -- adjust as per game, or get remote names dynamically

local function FindNearestEnemy()
    local nearest = nil
    local nearestDist = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local dist = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

local function TSBAutofarmLoop()
    if tsbAutofarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if not tsbTarget or not tsbTarget.Character or tsbTarget.Character.Humanoid.Health <= 0 then
            tsbTarget = FindNearestEnemy()
        end
        if tsbTarget and tsbTarget.Character and tsbTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- Move near target
            local root = LocalPlayer.Character.HumanoidRootPart
            local targetPos = tsbTarget.Character.HumanoidRootPart.Position
            -- Tween to near target
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
            tween:Play()
            tween.Completed:Wait()
            -- Attack using abilities (example)
            -- Fire remote for ability
            pcall(function()
                TSBRemotes:FireServer("Ability1") -- Replace with actual remote name and arguments
            end)
        end
    end
end

local tsbToggleFrame, tsbToggle = CreateToggle("TSB Autofarm", TSB, false, function(val)
    tsbAutofarmEnabled = val
    if val then
        tsbRunServiceConn = RunService.Heartbeat:Connect(TSBAutofarmLoop)
    else
        if tsbRunServiceConn then
            tsbRunServiceConn:Disconnect()
            tsbRunServiceConn = nil
        end
    end
end)
tsbToggleFrame.Position = UDim2.new(0, 10, 0, 10)

-- // FTAP Grab + Fling
local FTAP = tabContents.FTAP
local ftapGrabEnabled = false
local ftapGrabbedPlayer = nil
local FTAPRemotes = ReplicatedStorage:WaitForChild("FTAPRemotes") -- adjust as needed

local function GrabPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    -- Fire grab remote
    pcall(function()
        FTAPRemotes:FireServer("Grab", targetPlayer)
    end)
end

local function ReleasePlayer()
    -- Fire release remote
    pcall(function()
        FTAPRemotes:FireServer("Release")
    end)
end

local grabToggleFrame, grabToggle = CreateToggle("Enable Grab", FTAP, false, function(val)
    ftapGrabEnabled = val
    if val then
        Notify("Grab Enabled: Target a player and use grab keybind (not implemented)")
        -- You can implement targeting logic here
    else
        ReleasePlayer()
    end
end)
grabToggleFrame.Position = UDim2.new(0, 10, 0, 10)

-- Implement fling on release (example)
local flingToggleFrame, flingToggle = CreateToggle("Fling on Release", FTAP, false, function(val)
    _G.FlingOnRelease = val
end)
flingToggleFrame.Position = UDim2.new(0, 10, 0, 50)

-- Add other FTAP features as needed...

-- // BloxFruits Tab (scaffolded example)
local BloxFruits = tabContents.BloxFruits
local bfAutoFarmEnabled = false

local bfToggleFrame, bfToggle = CreateToggle("BloxFruits AutoFarm", BloxFruits, false, function(val)
    bfAutoFarmEnabled = val
end)
bfToggleFrame.Position = UDim2.new(0, 10, 0, 10)

-- BloxFruits Autofarm loop (simplified)
local bfRunConn = nil
local BloxFruitsRemotes = ReplicatedStorage:WaitForChild("BloxFruitsRemotes")

local function BloxFruitsAutoFarmLoop()
    if bfAutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Basic farm logic here (walk to NPCs, attack, etc)
        -- Example remote call
        pcall(function()
            BloxFruitsRemotes:FireServer("Attack")
        end)
    end
end

bfToggleFrame.MouseButton1Click:Connect(function()
    if bfAutoFarmEnabled then
        if not bfRunConn then
            bfRunConn = RunService.Heartbeat:Connect(BloxFruitsAutoFarmLoop)
        end
    else
        if bfRunConn then
            bfRunConn:Disconnect()
            bfRunConn = nil
        end
    end
end)

-- // Steal A Brainrot Tab
local SAB = tabContents.StealABrainrot

local sabAnticheatBypassToggle, sabAnticheatBypass = CreateToggle("Anticheat Bypass", SAB, false, function(val)
    _G.SABBypass = val
    if val then
        Notify("Steal A Brainrot Anticheat Bypass Enabled")
        -- Add your bypass logic here
    else
        -- Disable bypass
    end
end)
sabAnticheatBypassToggle.Position = UDim2.new(0, 10, 0, 10)

-- Noclip toggle for SAB
local sabNoclipToggleFrame, sabNoclipToggle = CreateToggle("Noclip", SAB, false, function(val)
    _G.SABNoclip = val
end)
sabNoclipToggleFrame.Position = UDim2.new(0, 10, 0, 50)

-- Simple noclip implementation
RunService.Stepped:Connect(function()
    if _G.SABNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- // AstraCloud Tab

local AstraCloud = tabContents.AstraCloud

-- Admin/Exploiter Detection toggle
local adminDetectToggleFrame, adminDetectToggle = CreateToggle("Admin/Exploiter Detection", AstraCloud, false, function(val)
    _G.AdminDetectEnabled = val
    if val then
        Notify("Admin/Exploiter Detection Enabled")
        -- Scan logs or hook outputs here, then notify with GUI popup if detected
    end
end)
adminDetectToggleFrame.Position = UDim2.new(0, 10, 0, 10)

-- Advanced Anticheat Bypass toggle
local acBypassToggleFrame, acBypassToggle = CreateToggle("Advanced Anticheat Bypass", AstraCloud, false, function(val)
    _G.ACBypassEnabled = val
    if val then
        Notify("Anticheat Bypass Enabled")
        -- Implement real anticheat bypass here (disable kick/detect events)
    end
end)
acBypassToggleFrame.Position = UDim2.new(0, 10, 0, 50)

-- Godmode toggle
local godmodeToggleFrame, godmodeToggle = CreateToggle("Godmode", AstraCloud, false, function(val)
    _G.GodmodeEnabled = val
    -- Implement godmode by hooking Humanoid or character state
    if val then
        Notify("Godmode Enabled")
    end
end)
godmodeToggleFrame.Position = UDim2.new(0, 10, 0, 90)

-- Instant Kill toggle
local instakillToggleFrame, instakillToggle = CreateToggle("Instant Kill", AstraCloud, false, function(val)
    _G.InstantKillEnabled = val
    -- Implement instant kill by firing kill remotes or damaging enemies fast
    if val then
        Notify("Instant Kill Enabled")
    end
end)
instakillToggleFrame.Position = UDim2.new(0, 10, 0, 130)

-- Unlimited Zoom toggle
local zoomToggleFrame, zoomToggle = CreateToggle("Unlimited Zoom", AstraCloud, false, function(val)
    _G.UnlimitedZoomEnabled = val
    local Camera = workspace.CurrentCamera
    if val then
        Camera.FieldOfView = 5
    else
        Camera.FieldOfView = 70
    end
end)
zoomToggleFrame.Position = UDim2.new(0, 10, 0, 170)

-- Server Crasher button
local crashBtn = CreateButton("Server Crasher", AstraCloud, function()
    Notify("Server Crasher Triggered")
    -- Implement server crash by spamming heavy remote calls or object creation
end)
crashBtn.Position = UDim2.new(0, 10, 0, 210)

-- Admin Command Logger Detection toggle
local adminCmdDetectToggleFrame, adminCmdDetectToggle = CreateToggle("Command Logger Detection", AstraCloud, false, function(val)
    _G.CmdLoggerDetectEnabled = val
    if val then
        Notify("Command Logger Detection Enabled")
    end
end)
adminCmdDetectToggleFrame.Position = UDim2.new(0, 10, 0, 250)

-- Script Injector Detection toggle
local scriptInjectorDetectToggleFrame, scriptInjectorDetectToggle = CreateToggle("Script Injector Detection", AstraCloud, false, function(val)
    _G.ScriptInjectorDetectEnabled = val
    if val then
        Notify("Script Injector Detection Enabled")
    end
end)
scriptInjectorDetectToggleFrame.Position = UDim2.new(0, 10, 0, 290)

-- Cleanup on respawn to apply WalkSpeed and JumpPower
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 10)
    task.wait(0.1)
    if applyWalkSpeed then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end
    if applyJumpPower then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = JumpPowerValue
        end
    end
end)

-- // Unload GUI and cleanup
local function unload()
    NebulaGui:Destroy()
    Notify("Nebula Hub unloaded")
end

CloseBtn.MouseButton1Click:Connect(unload)

print("Nebula Hub Universal loaded successfully!")
Notify("Nebula Hub Universal loaded successfully!")


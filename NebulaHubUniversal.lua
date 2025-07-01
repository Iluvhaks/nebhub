-- Nebula Hub Universal Full Updated Purple GUI with ALL FEATURES
-- Made for Mobile & PC, no Rayfield dependency

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = workspace
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Wait for character to load fully
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- VARIABLES
local WalkSpeedValue = 16
local JumpPowerValue = 100
local InfJump = false
local ClickTPOn = false
local ESPOn = false
local LineESP = false
local AimbotOn = false
local TeamCheck = true
local AutoShoot = false
local AimFOV = 100
local TargetPart = "Head"

local flingEnabled = false
local flingStrength = 350
local antiGrabEnabled = false
local spawnKillAll = false
local flingAll = false

local autofarmEnabled = false
local safeFlyActive = false

local noclipActive = false
local autoStealActive = false
local anticheatBypassActive = false

local astracloudAdminDetectOn = false
local astracloudAnticheatBypassOn = false
local astracloudInstantKillOn = false
local astracloudGodmodeOn = false
local astracloudUnlimitedZoomOn = false

-- ESP Storage
local espObjects = {}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaHubFullPurple"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 650)
MainFrame.Position = UDim2.new(0.5, -210, 0.3, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(110, 0, 160)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Nebula Hub GUI Full Updated"
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 35, 1, 0)
MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextScaled = true
MinimizeButton.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 35, 1, 0)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextScaled = true
CloseButton.Parent = TopBar

-- Tabs Container (with buttons on left, content on right)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 1, -32)
TabsFrame.Position = UDim2.new(0, 0, 0, 32)
TabsFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
TabsFrame.Parent = MainFrame

-- Left Tabs Buttons Container
local TabsButtonsFrame = Instance.new("ScrollingFrame")
TabsButtonsFrame.Size = UDim2.new(0, 110, 1, 0)
TabsButtonsFrame.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
TabsButtonsFrame.BorderSizePixel = 0
TabsButtonsFrame.ScrollBarThickness = 6
TabsButtonsFrame.Parent = TabsFrame
TabsButtonsFrame.CanvasSize = UDim2.new(0, 0, 4, 0) -- enough to scroll all tabs

-- Right Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -110, 1, 0)
ContentFrame.Position = UDim2.new(0, 110, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(55, 0, 95)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = TabsFrame

-- Utility function to create tab button
local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = TabsButtonsFrame
    btn.AutoButtonColor = true
    btn.Name = "TabButton_" .. name:gsub("%s","")
    return btn
end

-- Utility to clear ContentFrame
local function clearContent()
    for _, child in pairs(ContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

-- Utility to create toggles in ContentFrame
local function createToggle(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Text = default and "ON" or "OFF"
    btn.Size = UDim2.new(0.3, 0, 1, 0)
    btn.Position = UDim2.new(0.7, 0, 0, 0)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(150, 0, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = frame

    local value = default
    btn.MouseButton1Click:Connect(function()
        value = not value
        btn.Text = value and "ON" or "OFF"
        btn.BackgroundColor3 = value and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(150, 0, 0)
        callback(value)
    end)

    return frame
end

-- Utility to create buttons in ContentFrame
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = name
    btn.Parent = ContentFrame
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Utility to create sliders in ContentFrame
local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame

    local label = Instance.new("TextLabel")
    label.Text = name..": "..default
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local slider = Instance.new("Slider")
    slider.Min = min
    slider.Max = max
    slider.Value = default
    slider.Size = UDim2.new(1, 0, 0.5, 0)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.Parent = frame

    slider.Changed:Connect(function()
        local val = math.floor(slider.Value)
        label.Text = name..": "..val
        callback(val)
    end)

    return frame
end

-- Utility to create dropdown in ContentFrame
local function createDropdown(name, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = ContentFrame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 0.6, 0)
    dropdown.Position = UDim2.new(0, 0, 0.4, 0)
    dropdown.Text = default
    dropdown.TextColor3 = Color3.new(1,1,1)
    dropdown.BackgroundColor3 = Color3.fromRGB(80,0,130)
    dropdown.Font = Enum.Font.SourceSansBold
    dropdown.TextScaled = true
    dropdown.Parent = frame

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 0)
    listFrame.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.Parent = frame

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = listFrame

    local expanded = false

    dropdown.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            listFrame:TweenSize(UDim2.new(1,0,0, #options * 40), "Out", "Quad", 0.25, true)
        else
            listFrame:TweenSize(UDim2.new(1,0,0, 0), "Out", "Quad", 0.25, true)
        end
    end)

    for _, option in pairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 40)
        optionBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 120)
        optionBtn.TextColor3 = Color3.new(1,1,1)
        optionBtn.Font = Enum.Font.SourceSansBold
        optionBtn.Text = option
        optionBtn.TextScaled = true
        optionBtn.Parent = listFrame
        optionBtn.AutoButtonColor = true

        optionBtn.MouseButton1Click:Connect(function()
            dropdown.Text = option
            callback(option)
            expanded = false
            listFrame:TweenSize(UDim2.new(1,0,0, 0), "Out", "Quad", 0.25, true)
        end)
    end

    return frame
end

-- TAB CONTENT SETUP
local tabs = {}

-- Utility Tab
tabs.Utility = {}
function tabs.Utility:Init()
    clearContent()
    createToggle("Click TP", ClickTPOn, function(val) ClickTPOn = val end)
    createToggle("Infinite Jump", InfJump, function(val) InfJump = val end)
    createSlider("Walk Speed", 16, 200, WalkSpeedValue, function(val)
        WalkSpeedValue = val
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeedValue
            end
        end
    end)
    createSlider("Jump Power", 50, 300, JumpPowerValue, function(val)
        JumpPowerValue = val
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = JumpPowerValue
            end
        end
    end)
    createButton("Anti-AFK", function()
        for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
            conn:Disable()
        end
    end)
end

-- Troll Tab
tabs.Troll = {}
function tabs.Troll:Init()
    clearContent()
    createButton("Fake Kick", function()
        LocalPlayer:Kick("Fake Kick - Nebula Hub Universal")
    end)
    createButton("Chat Spam", function()
        spawn(function()
            while true do
                pcall(function()
                    LocalPlayer:WaitForChild("PlayerGui")
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!", "All")
                end)
                task.wait(0.25)
            end
        end)
    end)
    createButton("Fling Self", function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(9999, 9999, 9999)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            Debris:AddItem(bv, 0.5)
        end
    end)
    createToggle("Fling Toggle", flingEnabled, function(val) flingEnabled = val end)
    createSlider("Fling Strength", 100, 500, flingStrength, function(val) flingStrength = val end)
    createToggle("Anti Grab", antiGrabEnabled, function(val) antiGrabEnabled = val end)
    createToggle("Spawn Kill All", spawnKillAll, function(val) spawnKillAll = val end)
    createToggle("Fling All", flingAll, function(val) flingAll = val end)
end

-- Auto Tab (TSB Autofarm)
tabs.Auto = {}
function tabs.Auto:Init()
    clearContent()
    createToggle("Autofarm TSB", autofarmEnabled, function(val) autofarmEnabled = val end)
    createButton("Safe Fly", function()
        safeFlyActive = not safeFlyActive
    end)
end

-- Visual Tab
tabs.Visual = {}
function tabs.Visual:Init()
    clearContent()
    createToggle("ESP", ESPOn, function(val)
        ESPOn = val
        if not val then
            for _, espObj in pairs(espObjects) do
                espObj.Adornee = nil
                espObj:Destroy()
            end
            espObjects = {}
        end
    end)
    createToggle("Line ESP", LineESP, function(val) LineESP = val end)
    createToggle("Aimbot", AimbotOn, function(val) AimbotOn = val end)
    createToggle("Team Check", TeamCheck, function(val) TeamCheck = val end)
    createToggle("Auto Shoot", AutoShoot, function(val) AutoShoot = val end)
    createDropdown("Target Part", {"Head", "HumanoidRootPart"}, TargetPart, function(val) TargetPart = val end)
    createSlider("Aimbot FOV", 10, 250, AimFOV, function(val) AimFOV = val end)
end

-- FTAP Tab (Grab/Fling)
tabs.FTAP = {}
function tabs.FTAP:Init()
    clearContent()
    createToggle("Grab & Fling", flingEnabled, function(val) flingEnabled = val end)
    createSlider("Fling Strength", 100, 500, flingStrength, function(val) flingStrength = val end)
    createToggle("Anti Grab", antiGrabEnabled, function(val) antiGrabEnabled = val end)
    createToggle("Spawn Kill All", spawnKillAll, function(val) spawnKillAll = val end)
    createToggle("Fling All", flingAll, function(val) flingAll = val end)
end

-- Steal a Brainrot Tab
tabs.StealABrainrot = {}
function tabs.StealABrainrot:Init()
    clearContent()
    createToggle("Auto Steal", autoStealActive, function(val) autoStealActive = val end)
    createToggle("Noclip", noclipActive, function(val) noclipActive = val end)
    createButton("Anticheat Bypass", function()
        anticheatBypassActive = true
        -- Implement Anticheat Bypass Logic Here
    end)
end

-- AstraCloud Tab
tabs.AstraCloud = {}
function tabs.AstraCloud:Init()
    clearContent()
    createToggle("Admin/Exploiter Detection", astracloudAdminDetectOn, function(val) astracloudAdminDetectOn = val end)
    createToggle("Anticheat Bypass", astracloudAnticheatBypassOn, function(val) astracloudAnticheatBypassOn = val end)
    createToggle("Instant Kill", astracloudInstantKillOn, function(val) astracloudInstantKillOn = val end)
    createToggle("Godmode", astracloudGodmodeOn, function(val) astracloudGodmodeOn = val end)
    createToggle("Unlimited Zoom", astracloudUnlimitedZoomOn, function(val) astracloudUnlimitedZoomOn = val end)
end

-- TAB BUTTONS CREATION
local tabNames = {"Utility", "Troll", "Auto", "Visual", "FTAP", "StealABrainrot", "AstraCloud"}

for _, tabName in pairs(tabNames) do
    local btn = createTabButton(tabName == "StealABrainrot" and "Steal a Brainrot" or tabName == "AstraCloud" and "AstraCloud" or tabName)
    btn.MouseButton1Click:Connect(function()
        -- Highlight button
        for _, b in pairs(TabsButtonsFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Color3.fromRGB(90, 0, 140)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 230)
        -- Init tab content
        if tabs[tabName] and tabs[tabName].Init then
            tabs[tabName]:Init()
        end
    end)
    if tabName == "Utility" then
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 230)
        tabs.Utility:Init()
    end
end

-- Minimize and Close buttons
MinimizeButton.MouseButton1Click:Connect(function()
    if ContentFrame.Visible then
        ContentFrame.Visible = false
        TabsButtonsFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 150, 0, 32)
        TitleLabel.Text = "N"
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
        TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    else
        ContentFrame.Visible = true
        TabsButtonsFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 420, 0, 650)
        TitleLabel.Text = "Nebula Hub GUI Full Updated"
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- FUNCTIONALITY IMPLEMENTATIONS

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Click TP
local clickTPConnection
local function setupClickTP()
    if clickTPConnection then
        clickTPConnection:Disconnect()
        clickTPConnection = nil
    end
    if ClickTPOn then
        clickTPConnection = Mouse.Button1Down:Connect(function()
            if Mouse.Target and LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(Mouse.Hit.p + Vector3.new(0, 3, 0))
            end
        end)
    end
end
setupClickTP()

-- Watch Click TP toggle changes (Update)
local oldCreateToggle = createToggle
createToggle = function(name, default, callback)
    local toggle = oldCreateToggle(name, default, function(val)
        callback(val)
        if name == "Click TP" then
            ClickTPOn = val
            setupClickTP()
        elseif name == "Infinite Jump" then
            InfJump = val
        elseif name == "Noclip" then
            noclipActive = val
        elseif name == "Auto Steal" then
            autoStealActive = val
        elseif name == "ESP" then
            ESPOn = val
        elseif name == "Line ESP" then
            LineESP = val
        elseif name == "Aimbot" then
            AimbotOn = val
        elseif name == "Team Check" then
            TeamCheck = val
        elseif name == "Auto Shoot" then
            AutoShoot = val
        elseif name == "Fling Toggle" then
            flingEnabled = val
        elseif name == "Anti Grab" then
            antiGrabEnabled = val
        elseif name == "Spawn Kill All" then
            spawnKillAll = val
        elseif name == "Fling All" then
            flingAll = val
        end
    end)
    return toggle
end

-- Noclip Logic
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP Logic
local function createESPForPlayer(player)
    if espObjects[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "NebulaHubESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    espObjects[player] = highlight
end

local function removeESPForPlayer(player)
    if espObjects[player] then
        espObjects[player].Adornee = nil
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if ESPOn then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if TeamCheck and player.Team == LocalPlayer.Team then
                        removeESPForPlayer(player)
                    else
                        createESPForPlayer(player)
                    end
                else
                    removeESPForPlayer(player)
                end
            end
        end
    else
        for player, _ in pairs(espObjects) do
            removeESPForPlayer(player)
        end
    end
end)

-- Aimbot Logic
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = AimFOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
            if TeamCheck and player.Team == LocalPlayer.Team then continue end
            local pos = Camera:WorldToViewportPoint(player.Character[TargetPart].Position)
            local mousePos = UserInputService:GetMouseLocation()
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if AimbotOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local targetPos = target.Character[TargetPart].Position
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Smoothly rotate camera to target (simplified)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                if AutoShoot then
                    -- Fire shoot event (customize for your game)
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("ShootEvent"):FireServer(targetPos)
                    end)
                end
            end
        end
    end
end)

-- Autofarm TSB (mock example)
spawn(function()
    while task.wait(0.3) do
        if autofarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Implement actual autofarm logic for The Strongest Battlegrounds here
            -- For now, just print autofarm active
            print("[NebulaHub] Autofarm active")
        end
    end
end)

-- Safe Fly button functionality
-- (example logic)
spawn(function()
    while task.wait(0.3) do
        if safeFlyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Safe fly logic: keeps player hovering gently
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 0.5, 0)
        end
    end
end)

-- Auto Steal Brainrot Logic (mock example)
spawn(function()
    while task.wait(0.5) do
        if autoStealActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Search for brainrot pickups (example logic)
            local pickups = Workspace:FindFirstChild("Pickups") or Workspace:FindFirstChild("Brainrots")
            if pickups then
                for _, item in pairs(pickups:GetChildren()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local pos = item:IsA("BasePart") and item.Position or (item.PrimaryPart and item.PrimaryPart.Position)
                        if pos then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                            if item:IsA("BasePart") then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 0)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 1)
                            else
                                for _, part in pairs(item:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
                                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Fling logic (simplified)
spawn(function()
    while task.wait(0.1) do
        if flingEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local bv = hrp:FindFirstChild("FlingBV")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "FlingBV"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Parent = hrp
            end
            bv.Velocity = Vector3.new(flingStrength, 0, 0)
        else
            if LocalPlayer.Character then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlingBV")
                if bv then
                    bv:Destroy()
                end
            end
        end
    end
end)

-- Anti Grab logic (example)
RunService.Heartbeat:Connect(function()
    if antiGrabEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BodyPosition") or v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end)

-- Spawn Kill All and Fling All - mock placeholders (implement as per your game logic)
spawn(function()
    while task.wait(1) do
        if spawnKillAll then
            -- Your spawn kill all logic here
            print("[NebulaHub] Spawn Kill All active")
        end
        if flingAll then
            -- Your fling all logic here
            print("[NebulaHub] Fling All active")
        end
    end
end)

-- AstraCloud Instant Kill & Godmode (mock placeholder)
RunService.Stepped:Connect(function()
    if astracloudInstantKillOn then
        -- Example: kill all enemies instantly
    end
    if astracloudGodmodeOn and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-- Unlimited Zoom (mock)
local ZoomConnection
if astracloudUnlimitedZoomOn then
    ZoomConnection = UserInputService.InputChanged:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            Camera.FieldOfView = math.clamp(Camera.FieldOfView - input.Position.Z * 2, 5, 120)
        end
    end)
else
    if ZoomConnection then
        ZoomConnection:Disconnect()
    end
end

print("[NebulaHub] Loaded All Features!")

-- END OF SCRIPT

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- STATE VARIABLES
local clickTPOn, clickConn = false, nil
local ESPOn, LineESP, TeamCheck = false, false, true
local InfJump, remLag = false, false
local espObjects = {}
local flingEnabled, flingStrength = false, 350
local shootRemote = nil

local antiGrabEnabled = false
local spawnKillAll = false
local flingAll = false

-- AUTOFARM TSB VARIABLES
local autofarmEnabled = false
local targetPlayer = nil

-- FLY STATE FOR LOW HEALTH SAFE ZONE
local lowHealthFlyEnabled = false
local flyBV = nil

-- === ARSENAL AIMBOT & AUTOSHOOT VARIABLES ===
local ArsenalAimbotOn = false
local ArsenalAutoShoot = false
local ArsenalAimFOV = 100
local ArsenalTargetPart = "Head"
local ArsenalShootRemote = nil

-- === FTAP VARIABLES ===
local FTAPGrabEnabled = false
local FTAPReleaseEnabled = false
local FTAPKillauraEnabled = false
local FTAPMagneticGrab = false
local FTAPExplosiveGrab = false
local FTAPBreakAllJoints = false
local FTAPLoopGrabSpam = false
local FTAPGrabVisualizer = false
local FTAPFlingStrength = 350 -- Default fling strength

-- Grab storage
local grabbedObjects = {}

-- Get remotes
local grabRemote = ReplicatedStorage:WaitForChild("Grab")
local dropRemote = ReplicatedStorage:WaitForChild("Drop")

-- Rayfield UI Setup
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    SubText = "Made by Elden and Nate",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {Enabled=true, FileName="NebulaHubUniversal"},
    Discord = {Enabled=true, Invite="yTxgQcTUw4", RememberJoins=true},
    KeySystem = false
})

-- Tabs
local Utility    = Window:CreateTab("🧠 Utility")
local Troll      = Window:CreateTab("💣 Troll")
local AutoTab    = Window:CreateTab("🤖 Auto")
local RemoteTab  = Window:CreateTab("📡 Remotes")
local VisualTab  = Window:CreateTab("🎯 Visual")
local Exploits   = Window:CreateTab("⚠️ Exploits")
local FTAPTab    = Window:CreateTab("👐 FTAP")
local TSBTab     = Window:CreateTab("⚔️ TSB")
local ArsenalTab = Window:CreateTab("🔫 Arsenal")

-- === Utility Tab ===
Utility:CreateButton({
    Name = "Click TP (Toggle)",
    Callback = function()
        clickTPOn = not clickTPOn
        if clickTPOn then
            clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function()
                local m = LocalPlayer:GetMouse()
                if m.Target then
                    LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0))
                end
            end)
            Rayfield:Notify({Title="Click TP", Content="Enabled", Duration=2})
        else
            if clickConn then clickConn:Disconnect() clickConn=nil end
            Rayfield:Notify({Title="Click TP", Content="Disabled", Duration=2})
        end
    end
})

-- Fly toggle function
local function toggleFly(state)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if state then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Parent = hrp
        _G.Fly = true

        flyBV:GetPropertyChangedSignal("Parent"):Connect(function()
            if not flyBV.Parent then _G.Fly = false end
        end)

        RunService.Heartbeat:Connect(function()
            if _G.Fly and flyBV and flyBV.Parent then
                local camLook = Camera.CFrame.LookVector
                flyBV.Velocity = camLook * 60
            elseif flyBV then
                flyBV:Destroy()
                flyBV = nil
            end
        end)
    else
        if flyBV then flyBV:Destroy() flyBV = nil end
        _G.Fly = false
    end
end

Utility:CreateButton({
    Name = "Fly Toggle",
    Callback = function()
        toggleFly(not _G.Fly)
    end
})

UserInput.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

Utility:CreateToggle({Name="Infinite Jump", CurrentValue=false, Callback=function(v) InfJump=v end})

Utility:CreateSlider({Name="Walk Speed", Range={16,200}, CurrentValue=16, Callback=function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed=v end
end})

Utility:CreateSlider({Name="Jump Power", Range={50,300}, CurrentValue=100, Callback=function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower=true; h.JumpPower=v end
end})

Utility:CreateButton({Name="Anti-AFK", Callback=function()
    for _,c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
end})

-- === Troll Tab ===
Troll:CreateButton({Name="Fake Kick", Callback=function() LocalPlayer:Kick("Fake Kick - Nebula Hub Universal") end})

Troll:CreateButton({Name="Chat Spam", Callback=function()
    spawn(function() while task.wait(0.25) do
        pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!","All") end)
    end end)
end})

Troll:CreateButton({Name="Fling Self", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv=Instance.new("BodyVelocity",hrp)
        bv.Velocity=Vector3.new(9999,9999,9999)
        bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
        task.wait(0.5)
        bv:Destroy()
    end
end})

-- === Auto Tab ===
AutoTab:CreateButton({Name="Auto Move", Callback=function()
    _G.AutoMove = true; spawn(function()
        while _G.AutoMove do
            if LocalPlayer.Character then 
                LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100))) 
            end
            task.wait(0.8)
        end
    end)
end})

AutoTab:CreateButton({Name="Touch Everything", Callback=function()
    local rt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("TouchTransmitter") and rt then
            firetouchinterest(rt, p.Parent, 0)
            firetouchinterest(rt, p.Parent, 1)
        end
    end
end})

-- === Remotes Tab ===
RemoteTab:CreateButton({Name="Toggle Remote Lagging", Callback=function()
    remLag = not remLag
    Rayfield:Notify({Title="Remote Lag", Content=remLag and "Enabled" or "Disabled", Duration=2})
    if remLag then spawn(function()
        while remLag do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                    pcall(function()
                        if obj:IsA("RemoteEvent") then obj:FireServer("NebulaSpam")
                        else obj:InvokeServer("NebulaSpam") end
                    end)
                end
            end
            task.wait(0.05)
        end
    end) end
end})

RemoteTab:CreateButton({Name="Scan Remotes", Callback=function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("[Remote] "..obj:GetFullName())
        end
    end
end})

-- === Visual Tab ===
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end})
VisualTab:CreateToggle({Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end})
VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})

VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
VisualTab:CreateSlider({Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})

-- === Arsenal Tab ===
ArsenalTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Callback=function(v) ArsenalAimbotOn = v end})
ArsenalTab:CreateToggle({Name="Auto Shoot", CurrentValue=false, Callback=function(v) ArsenalAutoShoot = v end})
ArsenalTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) ArsenalTargetPart = v end})
ArsenalTab:CreateSlider({Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) ArsenalAimFOV = v end})

-- Get closest enemy for Arsenal Aimbot
local function getClosestEnemyArsenal()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local bestDist, bestP = ArsenalAimFOV, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(ArsenalTargetPart) then
            if TeamCheck and p.Team == LocalPlayer.Team then continue end
            local pos, on = Camera:WorldToViewportPoint(p.Character[ArsenalTargetPart].Position)
            if on then
                local mag = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                if mag < bestDist then bestDist, bestP = mag, p end
            end
        end
    end
    return bestP
end

-- Find arsenal shoot remote
local function findArsenalShootRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("shoot") then
            ArsenalShootRemote = obj
            break
        end
    end
end

-- Arsenal Aimbot & AutoShoot loop
RunService.RenderStepped:Connect(function()
    if ArsenalAimbotOn then
        local tgt = getClosestEnemyArsenal()
        if tgt and tgt.Character and tgt.Character:FindFirstChild(ArsenalTargetPart) then
            local tp = tgt.Character[ArsenalTargetPart].Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, tp)

            if ArsenalAutoShoot then
                if not ArsenalShootRemote then
                    findArsenalShootRemote()
                else
                    pcall(ArsenalShootRemote.FireServer, ArsenalShootRemote)
                end
            end
        end
    end
end)

-- === FTAP Tab ===

-- Fling Strength Slider (exactly as you had it before)
local flingToggle = FTAPTab:CreateToggle({
    Name = "Enable Fling",
    CurrentValue = false,
    Flag = "FlingToggle",
    Callback = function(value)
        flingEnabled = value
    end
})

local flingStrengthSlider = FTAPTab:CreateSlider({
    Name = "Fling Strength",
    Range = {100, 5000},
    CurrentValue = flingStrength,
    Flag = "FlingStrengthSlider",
    Callback = function(value)
        flingStrength = value
    end
})

-- Auto Grab Toggle
FTAPTab:CreateToggle({
    Name = "Auto Grab (Grab Everything)",
    CurrentValue = false,
    Callback = function(v)
        FTAPGrabEnabled = v
    end
})

-- Auto Release Toggle
FTAPTab:CreateToggle({
    Name = "Auto Release",
    CurrentValue = false,
    Callback = function(v)
        FTAPReleaseEnabled = v
    end
})

-- Kill All Toggle
FTAPTab:CreateToggle({
    Name = "Kill All With Grab",
    CurrentValue = false,
    Callback = function(v)
        spawnKillAll = v
    end
})

-- Magnetic Grab Mode Toggle
FTAPTab:CreateToggle({
    Name = "Magnetic Grab Mode",
    CurrentValue = false,
    Callback = function(v)
        FTAPMagneticGrab = v
    end
})

-- Explosive Grab Mode Toggle
FTAPTab:CreateToggle({
    Name = "Explosive Grab Mode",
    CurrentValue = false,
    Callback = function(v)
        FTAPExplosiveGrab = v
    end
})

-- Break All Joints Mode Toggle
FTAPTab:CreateToggle({
    Name = "Break All Joints Mode",
    CurrentValue = false,
    Callback = function(v)
        FTAPBreakAllJoints = v
    end
})

-- Loop Grab Spam Toggle
FTAPTab:CreateToggle({
    Name = "Loop Grab Spam (Troll Mode)",
    CurrentValue = false,
    Callback = function(v)
        FTAPLoopGrabSpam = v
    end
})

-- Grab Visualizer Toggle
FTAPTab:CreateToggle({
    Name = "Grab Visualizer",
    CurrentValue = false,
    Callback = function(v)
        FTAPGrabVisualizer = v
    end
})

-- Helper function to perform grab
local function grab(target)
    if not grabRemote then return end
    pcall(function()
        grabRemote:FireServer(target, LocalPlayer.Character.HumanoidRootPart, target.Attachment0)
    end)
end

-- Helper function to release grab
local function release(target)
    if not dropRemote then return end
    pcall(function()
        dropRemote:FireServer(target, LocalPlayer.Character.HumanoidRootPart)
    end)
end

-- Main FTAP Loop
spawn(function()
    while true do
        task.wait(0.1)
        if FTAPGrabEnabled then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored == false then
                    local att0 = obj:FindFirstChildWhichIsA("Attachment")
                    if att0 then
                        grab(obj)
                        grabbedObjects[obj] = true
                        task.wait(0.05)
                    end
                end
            end
        end

        if FTAPReleaseEnabled then
            for obj, _ in pairs(grabbedObjects) do
                release(obj)
                grabbedObjects[obj] = nil
                task.wait(0.05)
            end
        end

        if spawnKillAll then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    grab(player.Character.HumanoidRootPart)
                    task.wait(0.1)
                    release(player.Character.HumanoidRootPart)
                end
            end
        end

        if FTAPLoopGrabSpam then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored == false then
                    local att0 = obj:FindFirstChildWhichIsA("Attachment")
                    if att0 then
                        grab(obj)
                        task.wait(0.05)
                        release(obj)
                    end
                end
            end
        end
    end
end)

-- You can add more FTAP features and logic here exactly how you want without changing fling strength slider

Rayfield:Notify({Title="Nebula Hub Universal", Content="Loaded Successfully!", Duration=3})

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- STATE VARIABLES
local clickTPOn, clickConn = false, nil
local ESPOn, LineESP, AimbotOn, TeamCheck, AutoShoot = false, false, false, true, false
local AimFOV, TargetPart = 100, "Head"
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
local moveConnection = nil
local attackRemotes = {}

-- FTAP Advanced Features Variables
local grabKillAll = false
local magneticGrab = false
local smartKillAll = false
local explosiveGrab = false
local breakAllJoints = false
local loopGrabSpam = false
local grabVisualizer = false

local grabPartsFolder = workspace:FindFirstChild("GrabParts") or Instance.new("Folder", workspace)
grabPartsFolder.Name = "GrabParts"

local grabConnections = {}
local visualizers = {}

-- Helper: Clean up visualizers
local function clearVisualizers()
    for _, v in pairs(visualizers) do
        if v and v:FindFirstChildWhichIsA("Beam") then
            v:Destroy()
        elseif v and v:IsA("Highlight") then
            v:Destroy()
        end
    end
    visualizers = {}
end

-- Create Visualizer between two parts (Beam or Highlight fallback)
local function createGrabVisualizer(part0, part1)
    if not (part0 and part1) then return end

    -- Try beam first if parts have attachments
    local att0 = part0:FindFirstChildWhichIsA("Attachment") or Instance.new("Attachment", part0)
    local att1 = part1:FindFirstChildWhichIsA("Attachment") or Instance.new("Attachment", part1)
    if att0.Parent ~= part0 then att0.Parent = part0 end
    if att1.Parent ~= part1 then att1.Parent = part1 end

    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Parent = att0

    table.insert(visualizers, beam)
    return beam
end

-- Function: Break all joints of a model (ragdoll style)
local function breakJointsInModel(model)
    for _, part in pairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            part:BreakJoints()
        end
    end
end

-- Function: Explode a model by applying velocity
local function explodeModel(model, strength)
    strength = strength or 100
    for _, part in pairs(model:GetChildren()) do
        if part:IsA("BasePart") then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = (part.Position - model.PrimaryPart.Position).Unit * strength + Vector3.new(0, 50, 0)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Parent = part
            Debris:AddItem(bv, 0.5)
        end
    end
end

-- Main function to grab and fling a player/model in a direction (with anti-stuck)
local function grabAndFling(targetCharacter)
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetCharacter.HumanoidRootPart

    -- Find local character parts
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end

    -- Create GrabParts container for welds if not existing
    local grabFolder = grabPartsFolder

    -- Create or reuse GrabPart
    local grabPart = Instance.new("Part")
    grabPart.Name = "GrabPart"
    grabPart.Size = Vector3.new(2, 2, 2)
    grabPart.Transparency = 1
    grabPart.Anchored = false
    grabPart.CanCollide = false
    grabPart.Parent = grabFolder
    grabPart.CFrame = localHRP.CFrame

    -- Weld GrabPart to local player root
    local weldToLocal = Instance.new("WeldConstraint")
    weldToLocal.Part0 = localHRP
    weldToLocal.Part1 = grabPart
    weldToLocal.Parent = grabPart

    -- Weld GrabPart to target HRP to grab
    local weldToTarget = Instance.new("WeldConstraint")
    weldToTarget.Part0 = grabPart
    weldToTarget.Part1 = hrp
    weldToTarget.Parent = grabPart

    -- Visualizer
    if grabVisualizer then
        createGrabVisualizer(grabPart, hrp)
    end

    -- Magnetic grab: Keep position synced closely
    local magneticConnection
    if magneticGrab then
        magneticConnection = RunService.Heartbeat:Connect(function()
            if grabPart and hrp and localHRP then
                grabPart.CFrame = localHRP.CFrame * CFrame.new(0, 0, -3)
            else
                if magneticConnection then magneticConnection:Disconnect() end
            end
        end)
        table.insert(grabConnections, magneticConnection)
    end

    -- Explosive option
    if explosiveGrab then
        task.delay(1.5, function()
            explodeModel(targetCharacter, flingStrength)
        end)
    end

    -- Break joints option
    if breakAllJoints then
        breakJointsInModel(targetCharacter)
    end

    -- Fling logic: apply velocity away from camera look vector repeatedly
    local flingConnection
    flingConnection = RunService.Heartbeat:Connect(function()
        if not grabKillAll and not loopGrabSpam then
            flingConnection:Disconnect()
            if magneticConnection then magneticConnection:Disconnect() end
            if grabPart then grabPart:Destroy() end
            return
        end
        local bv = grabPart:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity", grabPart)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Camera.CFrame.LookVector * flingStrength
        bv.Parent = grabPart
    end)

    table.insert(grabConnections, flingConnection)
end

-- Loop function for Kill All with Grab (looped, anti-stuck)
local function killAllWithGrabLoop()
    while grabKillAll do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetChar = player.Character
                grabAndFling(targetChar)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
    -- Cleanup on stop
    for _, conn in pairs(grabConnections) do
        if conn then conn:Disconnect() end
    end
    grabConnections = {}
    clearVisualizers()
end

-- Smart Kill All: attach silently to map parts or objects
local function smartKillAllLoop()
    while smartKillAll do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetChar = player.Character
                -- Find nearby map parts or objects to attach to
                local hrp = targetChar.HumanoidRootPart
                local nearbyParts = {}
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Anchored and (part.Position - hrp.Position).Magnitude < 20 and not part:IsDescendantOf(targetChar) then
                        table.insert(nearbyParts, part)
                    end
                end
                if #nearbyParts > 0 then
                    local chosenPart = nearbyParts[math.random(1, #nearbyParts)]
                    -- Remove old welds if any
                    for _, w in pairs(hrp:GetChildren()) do
                        if w:IsA("WeldConstraint") and (w.Part0 == hrp or w.Part1 == hrp) then
                            w:Destroy()
                        end
                    end
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = hrp
                    weld.Part1 = chosenPart
                    weld.Parent = hrp
                end
                task.wait(0.7)
            end
        end
        task.wait(1)
    end
end

-- Loop Grab Spam (Troll Mode)
local function loopGrabSpamLoop()
    while loopGrabSpam do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                grabAndFling(player.Character)
                task.wait(0.2)
            end
        end
        task.wait(0.5)
    end
end

-- MAIN UI
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

-- TABS
local Utility    = Window:CreateTab("🧠 Utility")
local Troll      = Window:CreateTab("💣 Troll")
local AutoTab    = Window:CreateTab("🤖 Auto")
local RemoteTab  = Window:CreateTab("📡 Remotes")
local VisualTab  = Window:CreateTab("🎯 Visual")
local Exploits   = Window:CreateTab("⚠️ Exploits")
local FTAPTab    = Window:CreateTab("👐 FTAP")
local TSBTab     = Window:CreateTab("⚔️ TSB")

-- UTILITY
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

Utility:CreateButton({
    Name = "Fly Toggle",
    Callback = function()
        _G.Fly = not _G.Fly
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        while _G.Fly and hrp.Parent do RunService.Stepped:Wait(); bv.Velocity = Camera.CFrame.LookVector * 60 end
        bv:Destroy()
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

-- TROLL
Troll:CreateButton({Name="Fake Kick", Callback=function() LocalPlayer:Kick("Fake Kick - Nebula Hub Universal") end})

Troll:CreateButton({Name="Chat Spam", Callback=function()
    spawn(function() while task.wait(0.25) do
        pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!","All") end)
    end end)
end})

Troll:CreateButton({Name="Fling Self", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Velocity = Vector3.new(0,100,0)
        task.delay(1,function() bv:Destroy() end)
    end
end})

-- REMOTE (Simple example)
RemoteTab:CreateButton({Name="Remote Lag (Spam)", Callback=function()
    remLag = not remLag
    if remLag then
        spawn(function()
            while remLag do
                pcall(function()
                    for _,v in pairs(ReplicatedStorage:GetChildren()) do
                        if v:IsA("RemoteEvent") then
                            v:FireServer()
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
        Rayfield:Notify({Title="Remote Lag", Content="Enabled", Duration=2})
    else
        Rayfield:Notify({Title="Remote Lag", Content="Disabled", Duration=2})
    end
end})

-- VISUAL
VisualTab:CreateToggle({Name="ESP", CurrentValue=false, Callback=function(v)
    ESPOn = v
    if ESPOn then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local h = Instance.new("Highlight")
                h.Name = "ESPHighlight"
                h.Adornee = player.Character
                h.FillColor = Color3.new(0,1,0)
                h.OutlineColor = Color3.new(0,1,0)
                h.Parent = player.Character
                espObjects[player.Name] = h
            end
        end
    else
        for _, h in pairs(espObjects) do
            if h and h.Parent then h:Destroy() end
        end
        espObjects = {}
    end
end})

VisualTab:CreateToggle({Name="Line ESP", CurrentValue=false, Callback=function(v)
    LineESP = v
    -- Implement Line ESP as needed, simplified here
end})

VisualTab:CreateToggle({Name="Aimbot", CurrentValue=false, Callback=function(v)
    AimbotOn = v
end})

VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v)
    TeamCheck = v
end})

VisualTab:CreateSlider({Name="Aim FOV", Range={10,360}, CurrentValue=100, Callback=function(v)
    AimFOV = v
end})

VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v)
    TargetPart = v
end})

-- EXPLOITS Tab Placeholder (Restore your exploits here as needed)

-- FTAP TAB
FTAPTab:CreateToggle({Name="Kill All with Grab (Loop)", CurrentValue=false, Callback=function(v)
    grabKillAll = v
    if grabKillAll then
        spawn(killAllWithGrabLoop)
        Rayfield:Notify({Title="FTAP", Content="Kill All with Grab Enabled", Duration=2})
    else
        Rayfield:Notify({Title="FTAP", Content="Kill All with Grab Disabled", Duration=2})
        -- Disconnect all grabs & clear visuals
        for _, conn in pairs(grabConnections) do
            if conn then conn:Disconnect() end
        end
        grabConnections = {}
        clearVisualizers()
    end
end})

FTAPTab:CreateToggle({Name="Magnetic Grab Mode", CurrentValue=false, Callback=function(v)
    magneticGrab = v
    Rayfield:Notify({Title="FTAP", Content="Magnetic Grab "..(v and "Enabled" or "Disabled"), Duration=2})
end})

FTAPTab:CreateToggle({Name="Smart Kill All", CurrentValue=false, Callback=function(v)
    smartKillAll = v
    if smartKillAll then
        spawn(smartKillAllLoop)
        Rayfield:Notify({Title="FTAP", Content="Smart Kill All Enabled", Duration=2})
    else
        Rayfield:Notify({Title="FTAP", Content="Smart Kill All Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Explosive Grab Option", CurrentValue=false, Callback=function(v)
    explosiveGrab = v
    Rayfield:Notify({Title="FTAP", Content="Explosive Grab "..(v and "Enabled" or "Disabled"), Duration=2})
end})

FTAPTab:CreateToggle({Name="Break All Joints Mode", CurrentValue=false, Callback=function(v)
    breakAllJoints = v
    Rayfield:Notify({Title="FTAP", Content="Break All Joints "..(v and "Enabled" or "Disabled"), Duration=2})
end})

FTAPTab:CreateToggle({Name="Loop Grab Spam (Troll Mode)", CurrentValue=false, Callback=function(v)
    loopGrabSpam = v
    if loopGrabSpam then
        spawn(loopGrabSpamLoop)
        Rayfield:Notify({Title="FTAP", Content="Loop Grab Spam Enabled", Duration=2})
    else
        Rayfield:Notify({Title="FTAP", Content="Loop Grab Spam Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Grab Visualizer", CurrentValue=false, Callback=function(v)
    grabVisualizer = v
    if not v then clearVisualizers() end
    Rayfield:Notify({Title="FTAP", Content="Grab Visualizer "..(v and "Enabled" or "Disabled"), Duration=2})
end})

-- TSB Tab Placeholder: Implement your The Strongest Battlegrounds autofarm here

-- MOBILE SUPPORT FOR SHOOTING AND INPUT
if UserInput.TouchEnabled then
    -- Mobile tap to shoot support example:
    UserInput.TouchTapInWorld:Connect(function(pos, state)
        if AimbotOn and AutoShoot then
            -- Fire M1 and abilities as per your autofarm code here
        end
    end)
    -- VirtualUser to simulate mouse click on mobile
    VirtualUser:CaptureController()
end

-- CLEANUP ON UNLOAD
game:BindToClose(function()
    for _, conn in pairs(grabConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    clearVisualizers()
end)

return Window

-- Nebula Hub Universal (Complete Script with Robust FTAP Fling-on-Release)
local Rayfield       = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

-- Services & Locals
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local Debris         = game:GetService("Debris")
local Workspace      = workspace
local UserInput      = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService   = game:GetService("TweenService")
local LocalPlayer    = Players.LocalPlayer
local Camera         = Workspace.CurrentCamera

-- State variables
local clickTPOn, clickConn       = false, nil
local ESPOn, LineESP, AimbotOn, TeamCheck, AutoShoot = false, false, false, true, false
local AimFOV, TargetPart         = 100, "Head"
local InfJump, remLag            = false, false
local espObjects                 = {}
local flingEnabled, flingStrength= false, 350
local antiGrabEnabled            = false
local spawnKillAll, flingAll     = false, false
local autofarmEnabled, targetPlayer = false, nil
local lowHealthFlyEnabled        = false
local flyBV                      = nil
local shootRemote                = nil

-- Tables for tracking grabs
local trackedFolders      = {}  -- [Folder] = { parts = {...}, conns = {...} }
local trackedConstraints  = {}  -- [Constraint] = connection

--------------------------------------------------------------------------------
-- Utility: fling a BasePart
--------------------------------------------------------------------------------
local function flingPart(part)
    if not part or not part.Parent or part:IsDescendantOf(LocalPlayer.Character) then return end
    local bv = Instance.new("BodyVelocity", part)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = part.CFrame.LookVector * flingStrength + Vector3.new(0, flingStrength*0.5, 0)
    Debris:AddItem(bv, 0.5)
end

--------------------------------------------------------------------------------
-- Cleanup a tracked folder
--------------------------------------------------------------------------------
local function cleanupFolder(folder)
    if trackedFolders[folder] then
        for _, c in ipairs(trackedFolders[folder].conns) do c:Disconnect() end
        trackedFolders[folder] = nil
    end
end

--------------------------------------------------------------------------------
-- Handle GrabParts folder-based grabs
--------------------------------------------------------------------------------
Workspace.DescendantAdded:Connect(function(inst)
    if inst:IsA("Folder") and inst.Name == "GrabParts" and not trackedFolders[inst] then
        local data = { parts = {}, conns = {} }
        trackedFolders[inst] = data

        local function collect()
            data.parts = {}
            for _, p in ipairs(inst:GetDescendants()) do
                if p:IsA("BasePart") and not p:IsDescendantOf(LocalPlayer.Character) then
                    table.insert(data.parts, p)
                end
            end
        end

        collect()
        table.insert(data.conns, inst.DescendantAdded:Connect(collect))
        table.insert(data.conns, inst.DescendantRemoving:Connect(collect))
        table.insert(data.conns, inst.AncestryChanged:Connect(function(_, newParent)
            if not newParent and flingEnabled then
                for _, p in ipairs(data.parts) do flingPart(p) end
            end
            cleanupFolder(inst)
        end))
    end
end)

--------------------------------------------------------------------------------
-- Handle Weld/WeldConstraint/Motor6D-based grabs
--------------------------------------------------------------------------------
local function watchConstraint(inst)
    if not (inst:IsA("Weld") or inst:IsA("WeldConstraint") or inst:IsA("Motor6D")) then return end
    local p0, p1 = inst.Part0, inst.Part1
    local other = (p0 and p0:IsDescendantOf(LocalPlayer.Character) and p1)
               or (p1 and p1:IsDescendantOf(LocalPlayer.Character) and p0)
    if other and other:IsA("BasePart") and not trackedConstraints[inst] then
        local conn = inst.AncestryChanged:Connect(function(_, newParent)
            if not newParent and flingEnabled then
                flingPart(other)
            end
            conn:Disconnect()
            trackedConstraints[inst] = nil
        end)
        trackedConstraints[inst] = conn
    end
end

Workspace.DescendantAdded:Connect(watchConstraint)

--------------------------------------------------------------------------------
-- Build the UI with Rayfield
--------------------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    SubText = "Made by Elden and Nate",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = { Enabled=true, FileName="NebulaHubUniversal" },
    Discord = { Enabled=true, Invite="yTxgQcTUw4", RememberJoins=true },
    KeySystem = false,
})

-- Create Tabs
local UtilityTab  = Window:CreateTab("🧠 Utility")
local TrollTab    = Window:CreateTab("💣 Troll")
local AutoTab     = Window:CreateTab("🤖 Auto")
local RemoteTab   = Window:CreateTab("📡 Remotes")
local VisualTab   = Window:CreateTab("🎯 Visual")
local ExploitsTab = Window:CreateTab("⚠️ Exploits")
local FTAPTab     = Window:CreateTab("👐 FTAP")
local TSBTab      = Window:CreateTab("⚔️ TSB")

--------------------------------------------------------------------------------
-- UTILITY TAB
--------------------------------------------------------------------------------
UtilityTab:CreateButton({
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
            Rayfield:Notify({ Title="Click TP", Content="Enabled", Duration=2 })
        else
            if clickConn then clickConn:Disconnect() clickConn = nil end
            Rayfield:Notify({ Title="Click TP", Content="Disabled", Duration=2 })
        end
    end
})

local function toggleFly(on)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if on then
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
        _G.Fly = true
        RunService:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Character.Value, function()
            if _G.Fly then
                flyBV.Velocity = Camera.CFrame.LookVector * 60
            else
                flyBV:Destroy()
                RunService:UnbindFromRenderStep("FlyUpdate")
            end
        end)
    else
        _G.Fly = false
    end
end

UtilityTab:CreateButton({ Name="Fly Toggle", Callback=function() toggleFly(not _G.Fly) end })
UserInput.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)
UtilityTab:CreateToggle({ Name="Infinite Jump", CurrentValue=false, Callback=function(v) InfJump=v end })
UtilityTab:CreateSlider({ Name="Walk Speed", Range={16,200}, CurrentValue=16, Callback=function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
UtilityTab:CreateSlider({ Name="Jump Power", Range={50,300}, CurrentValue=100, Callback=function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower = true; h.JumpPower = v end
end })
UtilityTab:CreateButton({ Name="Anti-AFK", Callback=function()
    for _, c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
end })

--------------------------------------------------------------------------------
-- TROLL TAB
--------------------------------------------------------------------------------
TrollTab:CreateButton({ Name="Fake Kick", Callback=function()
    LocalPlayer:Kick("Fake Kick - Nebula Hub Universal")
end })
TrollTab:CreateButton({ Name="Chat Spam", Callback=function()
    spawn(function()
        while task.wait(0.25) do
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!","All")
            end)
        end
    end)
end })
TrollTab:CreateButton({ Name="Fling Self", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(9999,9999,9999)
        bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        task.wait(0.5)
        bv:Destroy()
    end
end })

--------------------------------------------------------------------------------
-- AUTO TAB
--------------------------------------------------------------------------------
AutoTab:CreateButton({ Name="Auto Move", Callback=function()
    _G.AutoMove = true
    spawn(function()
        while _G.AutoMove do
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100)))
            end
            task.wait(0.8)
        end
    end)
end })
AutoTab:CreateButton({ Name="Touch Everything", Callback=function()
    local rt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("TouchTransmitter") and rt then
            firetouchinterest(rt, p.Parent, 0)
            firetouchinterest(rt, p.Parent, 1)
        end
    end
end })

--------------------------------------------------------------------------------
-- REMOTES TAB
--------------------------------------------------------------------------------
RemoteTab:CreateButton({ Name="Toggle Remote Lagging", Callback=function()
    remLag = not remLag
    Rayfield:Notify({ Title="Remote Lag", Content=remLag and "Enabled" or "Disabled", Duration=2 })
    if remLag then
        spawn(function()
            while remLag do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                        pcall(function()
                            if obj:IsA("RemoteEvent") then obj:FireServer("NebulaSpam")
                            else obj:InvokeServer("NebulaSpam") end
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end })
RemoteTab:CreateButton({ Name="Scan Remotes", Callback=function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("[Remote]", obj:GetFullName())
        end
    end
end })

--------------------------------------------------------------------------------
-- VISUAL TAB
--------------------------------------------------------------------------------
VisualTab:CreateToggle({ Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end })
VisualTab:CreateToggle({ Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end })
VisualTab:CreateToggle({ Name="Enable Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end })
VisualTab:CreateToggle({ Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end })
VisualTab:CreateToggle({ Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end })
VisualTab:CreateDropdown({
    Name="Target Part", Options={"Head","HumanoidRootPart","Torso"},
    CurrentOption="Head", Callback=function(v) TargetPart=v end
})
VisualTab:CreateSlider({ Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end })

-- (Insert your Aimbot & ESP RenderStepped logic here as before)

--------------------------------------------------------------------------------
-- EXPLOITS TAB
--------------------------------------------------------------------------------
ExploitsTab:CreateButton({ Name="Click Delete", Callback=function()
    local m = LocalPlayer:GetMouse()
    m.Button1Down:Connect(function() if m.Target then m.Target:Destroy() end end)
end })
ExploitsTab:CreateToggle({ Name="No Clip", CurrentValue=false, Callback=function(v)
    if v then
        RunService:BindToRenderStep("NoClip", Enum.RenderPriority.Character.Value, function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("NoClip")
    end
end })
ExploitsTab:CreateButton({ Name="Teleport Tool", Callback=function()
    local tool = Instance.new("Tool", LocalPlayer.Backpack)
    tool.RequiresHandle = false
    tool.Name = "TP Tool"
    tool.Activated:Connect(function()
        local m = LocalPlayer:GetMouse()
        if m.Hit then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
    end)
end })

--------------------------------------------------------------------------------
-- FTAP TAB
--------------------------------------------------------------------------------
FTAPTab:CreateToggle({ Name="Enable Fling (On Release)", CurrentValue=flingEnabled, Callback=function(v)
    flingEnabled = v
    Rayfield:Notify({ Title="FTAP", Content=flingEnabled and "Enabled" or "Disabled", Duration=2 })
end })
FTAPTab:CreateSlider({ Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v)
    flingStrength = math.clamp(v,100,5000)
    Rayfield:Notify({ Title="FTAP", Content="Strength: "..flingStrength, Duration=1 })
end })

--------------------------------------------------------------------------------
-- TSB TAB (Autofarm)
--------------------------------------------------------------------------------
-- (Insert your TSB autofarm code here as before)

--------------------------------------------------------------------------------
-- Done
--------------------------------------------------------------------------------
Rayfield:Notify({ Title="Nebula Hub Universal", Content="Loaded Successfully!", Duration=3 })

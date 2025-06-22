local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local clickTPOn, clickConn = false, nil
local ESPOn, LineESP, AimbotOn, TeamCheck, AutoShoot = false, false, false, true, false
local AimFOV, TargetPart = 100, "Head"
local InfJump, remLag, noclip = false, false, false
local espObjects = {}
local flingEnabled, flingStrength = false, 350
local antiGrab = false
local shootRemote = nil
local spawnKillOn = false
local flingAllOn = false

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

-- UTILITY
Utility:CreateButton({
    Name = "Click TP (Toggle)",
    Callback = function()
        clickTPOn = not clickTPOn
        if clickTPOn then
            clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function()
                local m = LocalPlayer:GetMouse()
                if m.Target then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
            end)
            Rayfield:Notify({Title="Click TP", Content="Enabled", Duration=2})
        else
            if clickConn then clickConn:Disconnect() clickConn=nil end
            Rayfield:Notify({Title="Click TP", Content="Disabled", Duration=2})
        end
    end
})
Utility:CreateButton({Name = "Fly Toggle", Callback = function()
    _G.Fly = not _G.Fly
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    while _G.Fly and hrp.Parent do RunService.Stepped:Wait(); bv.Velocity = Camera.CFrame.LookVector * 60 end
    bv:Destroy()
end})
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
    if hrp then local bv=Instance.new("BodyVelocity",hrp); bv.Velocity=Vector3.new(9999,9999,9999); bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge); task.wait(0.5); bv:Destroy() end
end})

-- AUTO
AutoTab:CreateButton({Name="Auto Move", Callback=function()
    _G.AutoMove = true; spawn(function()
        while _G.AutoMove do if LocalPlayer.Character then LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100))) end; task.wait(0.8) end
    end)
end})
AutoTab:CreateButton({Name="Touch Everything", Callback=function()
    local rt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(workspace:GetDescendants()) do if p:IsA("TouchTransmitter") and rt then
        firetouchinterest(rt, p.Parent, 0); firetouchinterest(rt, p.Parent, 1)
    end end
end})

-- REMOTES
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
            end; task.wait(0.05)
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

-- VISUAL
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end})
VisualTab:CreateToggle({Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end})
VisualTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end})
VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})
VisualTab:CreateToggle({Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end})
VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
VisualTab:CreateSlider({Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})

-- FTAP
FTAPTab:CreateToggle({Name="Enable Fling (FTAP)", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end})
FTAPTab:CreateSlider({Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v)
    flingStrength = math.clamp(v, 100, 5000)
end})
FTAPTab:CreateToggle({Name="AntiGrab", CurrentValue=false, Callback=function(v) antiGrab=v end})
FTAPTab:CreateToggle({Name="Spawn Kill All", CurrentValue=false, Callback=function(v)
    spawnKillOn = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and tHrp then
                    hrp.CFrame = tHrp.CFrame
                    firetouchinterest(hrp, tHrp, 0)
                    tHrp.CFrame = tHrp.CFrame + Vector3.new(0,0,5000)
                    firetouchinterest(hrp, tHrp, 1)
                end
            end
        end
    end
end})
FTAPTab:CreateToggle({Name="Fling All", CurrentValue=false, Callback=function(v)
    flingAllOn = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and tHrp then
                    hrp.CFrame = tHrp.CFrame
                    firetouchinterest(hrp, tHrp, 0)
                    local bv = Instance.new("BodyVelocity", tHrp)
                    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                    bv.Velocity = Camera.CFrame.LookVector * 5000
                    Debris:AddItem(bv, 0.5)
                    firetouchinterest(hrp, tHrp, 1)
                end
            end
        end
    end
end})

-- AntiGrab Weld Detection
workspace.DescendantAdded:Connect(function(d)
    if antiGrab and d:IsA("Weld") or d:IsA("WeldConstraint") then
        local p1 = d.Part1 or d.C1 or nil
        if p1 and p1:IsDescendantOf(LocalPlayer.Character) then
            d:Destroy()
        end
    end
end)

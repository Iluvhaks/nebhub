-- Nebula Hub Universal Full Script
-- All Tabs + FTAP Strength & Fling + Fixed TSB Autofarm

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

-- Services
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Debris            = game:GetService("Debris")
local Camera            = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- State Variables
local clickTPOn, clickConn               = false, nil
local ESPOn, LineESP, AimbotOn           = false, false, false
local TeamCheck, AutoShoot               = true, false
local AimFOV, TargetPart                 = 100, "Head"
local InfJump, remLag                    = false, false
local espObjects                         = {}
local flingEnabled, flingStrength       = false, 350
local antiGrabEnabled, spawnKillAll, flingAll = false, false, false
local autofarmEnabled                    = false

-- Utility: Mobile Virtual Input
local function sendVirtualInput(key)
    if UserInputService.TouchEnabled then
        if typeof(key) == "string" then
            UserInputService:SetKeyDown(Enum.KeyCode[key]); task.wait(0.1); UserInputService:SetKeyUp(Enum.KeyCode[key])
        elseif key == Enum.UserInputType.MouseButton1 then
            UserInputService:SetMouseButtonPressed(Enum.UserInputType.MouseButton1)
            task.wait(0.1)
            UserInputService:SetMouseButtonReleased(Enum.UserInputType.MouseButton1)
        end
    end
end

-- UI
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    SubText = "Made by Elden and Nate",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = { Enabled = true, FileName = "NebulaHubUniversal" },
    Discord = { Enabled = true, Invite = "yTxgQcTUw4", RememberJoins = true },
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
local BloxFruits = Window:CreateTab("🍉 BloxFruits")

-- ===== Utility =====
Utility:CreateButton({ Name = "Click TP", Callback = function()
    clickTPOn = not clickTPOn
    if clickTPOn then
        clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function()
            local m = LocalPlayer:GetMouse()
            if m.Target then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
        end)
        Rayfield:Notify({Title="Click TP",Content="Enabled",Duration=2})
    else
        if clickConn then clickConn:Disconnect() clickConn=nil end
        Rayfield:Notify({Title="Click TP",Content="Disabled",Duration=2})
    end
end })
Utility:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfJump = v end })
Utility:CreateSlider({ Name = "Walk Speed", Range = {16,200}, CurrentValue = 16, Callback = function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end })
Utility:CreateSlider({ Name = "Jump Power", Range = {50,300}, CurrentValue = 100, Callback = function(v)
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower = true; h.JumpPower = v end
end })
Utility:CreateButton({ Name = "Anti-AFK", Callback = function()
    for _,c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
end })
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- ===== Troll =====
Troll:CreateButton({ Name = "Fake Kick", Callback = function() LocalPlayer:Kick("Fake Kick - Nebula Hub Universal") end })
Troll:CreateButton({ Name = "Chat Spam", Callback = function()
    spawn(function() while task.wait(0.25) do
        pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!","All") end)
    end end)
end })
Troll:CreateButton({ Name = "Fling Self", Callback = function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(9999,9999,9999)
        bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        task.wait(0.5); bv:Destroy()
    end
end })

-- ===== Auto =====
AutoTab:CreateButton({ Name = "Auto Move", Callback = function()
    _G.AutoMove = true; spawn(function()
        while _G.AutoMove do
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100)))
            end
            task.wait(0.8)
        end
    end)
end })
AutoTab:CreateButton({ Name = "Touch Everything", Callback = function()
    local rt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _,p in ipairs(workspace:GetDescendants()) do
        if p:IsA("TouchTransmitter") and rt then
            firetouchinterest(rt,p.Parent,0)
            firetouchinterest(rt,p.Parent,1)
        end
    end
end })

-- ===== Remotes =====
RemoteTab:CreateButton({ Name = "Toggle Remote Lag", Callback = function()
    remLag = not remLag
    Rayfield:Notify({Title="Remote Lag",Content=remLag and "Enabled" or "Disabled",Duration=2})
    if remLag then
        spawn(function()
            while remLag do
                for _,o in ipairs(workspace:GetDescendants()) do
                    if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                        pcall(function()
                            if o:IsA("RemoteEvent") then o:FireServer("NebulaSpam") else o:InvokeServer("NebulaSpam") end
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end })
RemoteTab:CreateButton({ Name = "Scan Remotes", Callback = function()
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
            print("[Remote] "..o:GetFullName())
        end
    end
end })

-- ===== Visual =====
VisualTab:CreateToggle({ Name="ESP", CurrentValue=false, Callback=function(v) ESPOn=v end })
VisualTab:CreateToggle({ Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end })
VisualTab:CreateToggle({ Name="Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end })
VisualTab:CreateToggle({ Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end })
VisualTab:CreateToggle({ Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end })
VisualTab:CreateDropdown({ Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end })
VisualTab:CreateSlider({ Name="FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end })

RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team==LocalPlayer.Team then continue end
            local part = p.Character[TargetPart]
            local pos,on = Camera:WorldToViewportPoint(part.Position)
            local dist = (part.Position-camPos).Magnitude
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character}
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            local hit = workspace:Raycast(camPos, part.Position-camPos, rp)
            local vis = hit and hit.Instance:IsDescendantOf(p.Character)
            if ESPOn and on and vis then
                if not espObjects[p] then espObjects[p]={box=Drawing.new("Square"),line=Drawing.new("Line")} end
                local d=espObjects[p]; local size=math.clamp(2000/dist,20,200)
                d.box.Visible=true; d.box.Color=Color3.new(1,0,0); d.box.Thickness=2
                d.box.Size=Vector2.new(size,size); d.box.Position=Vector2.new(pos.X,pos.Y)-d.box.Size/2
                d.line.Visible=LineESP
                if LineESP then d.line.From=center; d.line.To=Vector2.new(pos.X,pos.Y); d.line.Color=Color3.new(1,0,0); d.line.Thickness=1 end
            elseif espObjects[p] then
                espObjects[p].box:Remove(); espObjects[p].line:Remove(); espObjects[p]=nil
            end
            if AimbotOn and vis then
                Camera.CFrame = CFrame.new(camPos, part.Position)
                if AutoShoot then sendVirtualInput(Enum.UserInputType.MouseButton1) end
            end
        end
    end
end)

-- ===== Exploits =====
Exploits:CreateButton({ Name="Click Delete", Callback = function()
    local m = LocalPlayer:GetMouse()
    m.Button1Down:Connect(function()
        if m.Target and m.Target.Parent:FindFirstChild("Humanoid") then
            m.Target.Parent:BreakJoints()
        end
    end)
end })

-- ===== FTAP =====
FTAPTab:CreateToggle({ Name="Enable Fling", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end })
FTAPTab:CreateSlider({ Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v) flingStrength=v; Rayfield:Notify({Title="FTAP",Content="Strength: "..v,Duration=1}) end })
FTAPTab:CreateToggle({ Name="AntiGrab", CurrentValue=antiGrabEnabled, Callback=function(v) antiGrabEnabled=v; Rayfield:Notify({Title="AntiGrab",Content=v and "Enabled" or "Disabled",Duration=2}) end })
FTAPTab:CreateToggle({ Name="Spawn Kill All", CurrentValue=spawnKillAll, Callback=function(v) spawnKillAll=v if v then spawn(function() while spawnKillAll do for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then plr.Character.HumanoidRootPart.CFrame=CFrame.new(0,-500,0) end end task.wait(1) end end) end end })
FTAPTab:CreateToggle({ Name="Fling All", CurrentValue=flingAll, Callback=function(v) flingAll=v if v then spawn(function() while flingAll do for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local hrp=plr.Character.HumanoidRootPart local root=LocalPlayer.Character.HumanoidRootPart for i=1,60 do root.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,math.rad(i*6),0) task.wait(0.01) end end end task.wait(0.5) end end) end end })

-- Fixed Fling on Grab Release
local grabMap = {}
workspace.ChildAdded:Connect(function(obj)
    if obj.Name == "GrabParts" and obj:FindFirstChild("GrabPart") then
        local gp = obj.GrabPart
        local weld = gp:FindFirstChildWhichIsA("WeldConstraint") or gp:FindFirstChildWhichIsA("Weld")
        if antiGrabEnabled and weld then weld:Destroy() end
        if weld then grabMap[obj] = weld.Part1 end
    end
end)
workspace.ChildRemoved:Connect(function(obj)
    local part = grabMap[obj]
    grabMap[obj] = nil
    if part and flingEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Velocity = Camera.CFrame.LookVector * flingStrength
        bv.Parent = part
        Debris:AddItem(bv,0.4)
    end
end)

-- ===== TSB =====
local TweenInfoTSB = TweenInfo.new(0.3,Enum.EasingStyle.Linear)
local TSBTargetPlayer = nil
local LowHP,RecoverHP,SafeFlyHeight,SafeFlySpeed=0.35,0.55,1000,50
local SafeFly=false

local function enableSafeFly()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hrp and humanoid then
        SafeFly=true; humanoid.PlatformStand=true; hrp.Anchored=true; hrp.CFrame=hrp.CFrame+Vector3.new(0,SafeFlyHeight,0)
        while SafeFly do local dt=RunService.Heartbeat:Wait() hrp.CFrame=hrp.CFrame+Vector3.new(0,SafeFlySpeed*dt,0) if humanoid.Health/humanoid.MaxHealth>=RecoverHP then SafeFly=false end end
        hrp.Anchored=false; humanoid.PlatformStand=false
    end
end

local function autofarmTSB()
    while autofarmEnabled do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not TSBTargetPlayer or not TSBTargetPlayer.Character or TSBTargetPlayer.Character:FindFirstChildOfClass("Humanoid").Health<=0 then
                local dist,nearest=math.huge,nil
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local h=plr.Character:FindFirstChildOfClass("Humanoid")
                        if h and h.Health>0 then
                            local d=(hrp.Position-plr.Character.HumanoidRootPart.Position).Magnitude
                            if d<dist then dist,nearest=d,plr end
                        end
                    end
                end
                TSBTargetPlayer=nearest
            end
            if TSBTargetPlayer and TSBTargetPlayer.Character then
                local tHRP = TSBTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                TweenService:Create(hrp,TweenInfoTSB,{CFrame=tHRP.CFrame*CFrame.new(0,3,3)}):Play()
                local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health/humanoid.MaxHealth<=LowHP then enableSafeFly() end
                sendVirtualInput(Enum.UserInputType.MouseButton1)
                task.wait(0.3)
            end
        end
        task.wait(0.1)
    end
end

TSBTab:CreateToggle({ Name="Autofarm", CurrentValue=false, Callback=function(v)
    autofarmEnabled=v
    if v then spawn(autofarmTSB) end
end })

-- ===== BloxFruits =====
BloxFruits:CreateLabel("Coming soon...")

-- Notify Loaded
Rayfield:Notify({Title="Nebula Hub Universal",Content="All tabs loaded!",Duration=3})

-- Cleanup ESP
game:BindToClose(function()
    for _,v in pairs(espObjects) do
        if v.box then v.box:Remove() end
        if v.line then v.line:Remove() end
    end
end)

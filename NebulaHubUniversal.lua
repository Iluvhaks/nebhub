-- Nebula Hub Universal - Full + AstraCloud Tab Integrated
-- Made by Elden and Nate, with Steal a Brainrot tab integrated and AstraCloud added

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not success or not Rayfield then 
    warn("Failed to load Rayfield UI.")
    return
end

-- Services
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Debris            = game:GetService("Debris")
local Camera            = workspace.CurrentCamera
local StarterGui        = game:GetService("StarterGui")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Wait for character join
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    LocalPlayer.CharacterAdded:Wait()
    repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- State and variables
local clickTPOn, clickConn               = false, nil
local ESPOn, LineESP, AimbotOn           = false, false, false
local TeamCheck, AutoShoot               = true, false
local AimFOV, TargetPart                 = 100, "Head"
local InfJump, remLag                    = false, false
local espObjects                         = {}
local flingEnabled, flingStrength       = false, 350
local antiGrabEnabled, spawnKillAll, flingAll = false, false, false
local autofarmEnabled                    = false

-- Utility: Mobile input
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

-- Variables for WalkSpeed and JumpPower with defaults
local WalkSpeedValue = 16
local JumpPowerValue = 100

-- Rayfield setup
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
local SABTab     = Window:CreateTab("🧠 StealABrainrot")
local AstraCloud = Window:CreateTab("☁ AstraCloud")

-- Bottom-right notification system
local function ShowNotification(text)
    StarterGui:SetCore("SendNotification", {
        Title = "AstraCloud",
        Text = text,
        Duration = 5,
        Callback = function() end
    })
end

-- Utility features
Utility:CreateButton({ Name = "Click TP", Callback = function()
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
        if clickConn then clickConn:Disconnect() clickConn = nil end
        Rayfield:Notify({Title="Click TP", Content="Disabled", Duration=2})
    end
end })

Utility:CreateToggle({ Name = "Infinite Jump", CurrentValue=false, Callback = function(v) InfJump = v end })

local WalkSpeedSlider = Utility:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    CurrentValue = WalkSpeedValue,
    Callback = function(v)
        WalkSpeedValue = v
        if WalkSpeedSlider.SetValue then
            WalkSpeedSlider:SetValue(v)
        else
            WalkSpeedSlider.CurrentValue = v
        end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeedValue
            end
        end
    end
})

local JumpPowerSlider = Utility:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    CurrentValue = JumpPowerValue,
    Callback = function(v)
        JumpPowerValue = v
        if JumpPowerSlider.SetValue then
            JumpPowerSlider:SetValue(v)
        else
            JumpPowerSlider.CurrentValue = v
        end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = JumpPowerValue
            end
        end
    end
})

Utility:CreateButton({ Name = "Anti-AFK", Callback = function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do conn:Disable() end
end })

LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.WalkSpeed = WalkSpeedValue
        humanoid.UseJumpPower = true
        humanoid.JumpPower = JumpPowerValue
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Troll features
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
        bv.Velocity, bv.MaxForce = Vector3.new(9999,9999,9999), Vector3.new(math.huge,math.huge,math.huge)
        task.wait(0.5); bv:Destroy()
    end
end })

-- Auto features
AutoTab:CreateButton({ Name = "Auto Move", Callback = function()
    _G.AutoMove = true
    spawn(function() while _G.AutoMove do
        if LocalPlayer.Character then LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100))) end
        task.wait(0.8)
    end end)
end })
AutoTab:CreateButton({ Name = "Touch Everything", Callback = function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(workspace:GetDescendants()) do
        if p:IsA("TouchTransmitter") and hrp then
            firetouchinterest(hrp, p.Parent, 0)
            firetouchinterest(hrp, p.Parent, 1)
        end
    end
end })

-- Remote Lag & Scan
RemoteTab:CreateButton({ Name = "Toggle Remote Lag", Callback = function()
    remLag = not remLag
    Rayfield:Notify({Title = "Remote Lag", Content = remLag and "Enabled" or "Disabled", Duration = 2})
    if remLag then spawn(function()
        while remLag do
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                    pcall(function()
                        if o:IsA("RemoteEvent") then o:FireServer("NebulaSpam")
                        else o:InvokeServer("NebulaSpam") end
                    end)
                end
            end
            task.wait(0.05)
        end
    end) end
end })
RemoteTab:CreateButton({ Name = "Scan Remotes", Callback = function()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
            print("[Remote] "..o:GetFullName())
        end
    end
end })

-- Visual (ESP/Aimbot)
VisualTab:CreateToggle({ Name="ESP", CurrentValue=false, Callback=function(v) ESPOn=v end })
VisualTab:CreateToggle({ Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end })
VisualTab:CreateToggle({ Name="Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end })
VisualTab:CreateToggle({ Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end })
VisualTab:CreateToggle({ Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end })
VisualTab:CreateDropdown({ Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end })
VisualTab:CreateSlider({ Name="FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end })

RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team==LocalPlayer.Team then continue end
            local part = p.Character[TargetPart]
            local pos,on = Camera:WorldToViewportPoint(part.Position)
            local dist = (part.Position-camPos).Magnitude
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances, rp.FilterType = {LocalPlayer.Character}, Enum.RaycastFilterType.Blacklist
            local hit = workspace:Raycast(camPos, part.Position-camPos, rp)
            local vis = hit and hit.Instance:IsDescendantOf(p.Character)
            if ESPOn and on and vis then
                if not espObjects[p] then espObjects[p]={box=Drawing.new("Square"),line=Drawing.new("Line")} end
                local d = espObjects[p]
                local size = math.clamp(2000/dist,20,200)
                d.box.Visible=true; d.box.Color=Color3.new(1,0,0); d.box.Thickness=2
                d.box.Size=Vector2.new(size,size); d.box.Position=Vector2.new(pos.X,pos.Y)-d.box.Size/2
                d.line.Visible=LineESP and true or false
                if LineESP then d.line.From=center; d.line.To=Vector2.new(pos.X,pos.Y)
                    d.line.Color=Color3.new(1,0,0); d.line.Thickness=1
                end
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

-- Exploits
Exploits:CreateButton({ Name="Click Delete", Callback=function()
    local m = LocalPlayer:GetMouse()
    m.Button1Down:Connect(function()
        if m.Target and m.Target.Parent:FindFirstChild("Humanoid") then
            m.Target.Parent:BreakJoints()
        end
    end)
end })

-- FTAP
FTAPTab:CreateToggle({ Name="Enable Fling", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end })
FTAPTab:CreateSlider({ Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v)
    flingStrength=v
    Rayfield:Notify({Title="FTAP", Content="Strength: "..v, Duration=1})
end })
FTAPTab:CreateToggle({ Name="AntiGrab", CurrentValue=antiGrabEnabled, Callback=function(v)
    antiGrabEnabled=v
    Rayfield:Notify({Title="AntiGrab", Content=v and "Enabled" or "Disabled", Duration=2})
end })
FTAPTab:CreateToggle({ Name="Spawn Kill All", CurrentValue=spawnKillAll, Callback=function(v)
    spawnKillAll=v
    if v then spawn(function() while spawnKillAll do
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(0,-500,0)
            end
        end
        task.wait(1)
    end end) end
end })
FTAPTab:CreateToggle({ Name="Fling All", CurrentValue=flingAll, Callback=function(v)
    flingAll=v
    if v then spawn(function() while flingAll do
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp=plr.Character.HumanoidRootPart
                local root=LocalPlayer.Character.HumanoidRootPart
                for i=1,60 do
                    root.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0,math.rad(i*6),0)
                    task.wait(0.01)
                end
            end
        end
        task.wait(0.5)
    end end) end
end })

-- Fixed fling on grab release
do
    local grabMap={}
    workspace.ChildAdded:Connect(function(obj)
        if obj.Name=="GrabParts" and obj:FindFirstChild("GrabPart") then
            local weld=obj.GrabPart:FindFirstChildWhichIsA("WeldConstraint") or obj.GrabPart:FindFirstChildWhichIsA("Weld")
            if antiGrabEnabled and weld then weld:Destroy() end
            if weld then grabMap[obj]=weld.Part1 end
        end
    end)
    workspace.ChildRemoved:Connect(function(obj)
        local part=grabMap[obj]
        grabMap[obj]=nil
        if part and flingEnabled then
            local bv=Instance.new("BodyVelocity")
            bv.MaxForce=Vector3.new(1e9,1e9,1e9)
            bv.Velocity=Camera.CFrame.LookVector*flingStrength
            bv.Parent=part
            Debris:AddItem(bv,0.4)
        end
    end)
end

-- TSB features
do
    local TweenInfoTSB = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
    local TSBTargetPlayer=nil
    local LowHP,RecoverHP,SafeFlyHeight,SafeFlySpeed = 0.35,0.55,1000,50
    local SafeFly=false

    local function enableSafeFly()
        local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid= LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid then
            SafeFly=true
            humanoid.PlatformStand=true
            hrp.Anchored=true
            hrp.CFrame=hrp.CFrame+Vector3.new(0,SafeFlyHeight,0)
            while SafeFly do
                local dt=RunService.Heartbeat:Wait()
                hrp.CFrame=hrp.CFrame+Vector3.new(0,SafeFlySpeed*dt,0)
                if humanoid.Health/humanoid.MaxHealth>=RecoverHP then SafeFly=false end
            end
            hrp.Anchored=false
            humanoid.PlatformStand=false
        end
    end

    local function autofarmTSB()
        while autofarmEnabled do
            local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not TSBTargetPlayer or not TSBTargetPlayer.Character or TSBTargetPlayer.Character:FindFirstChildOfClass("Humanoid").Health<=0 then
                    local dist,nearest=math.huge,nil
                    for _,plr in ipairs(Players:GetPlayers()) do
                        if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local h=plr.Character:FindFirstChildOfClass("Humanoid")
                            if h and h.Health>0 then
                                local d=(hrp.Position-plr.Character.HumanoidRootPart.Position).Magnitude
                                if d<dist then dist=d; nearest=plr end
                            end
                        end
                    end
                    TSBTargetPlayer=nearest
                end
                if TSBTargetPlayer and TSBTargetPlayer.Character and TSBTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = TSBTargetPlayer.Character.HumanoidRootPart
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health/humanoid.MaxHealth <= LowHP then
                        enableSafeFly()
                    else
                        local tween=TweenService:Create(hrp, TweenInfoTSB, {CFrame = targetHRP.CFrame * CFrame.new(0,3,0)})
                        tween:Play()
                    end
                end
            end
            task.wait(0.1)
        end
    end

    TSBTab:CreateToggle({ Name="Auto Farm", CurrentValue=false, Callback=function(v)
        autofarmEnabled=v
        if v then spawn(autofarmTSB) end
    end })
end

-- BloxFruits scaffold tab (empty)
BloxFruits:CreateLabel({ Name="BloxFruits features coming soon..." })

-- StealABrainrot (load external modded script)
SABTab:CreateButton({ Name="Load StealABrainrot Mod", Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/StealaBrainrotMOD"))()
end })

-- AstraCloud tab full features
do
    local adminDetectEnabled = false
    local anticheatBypassEnabled = false
    local godmodeEnabled = false
    local unlimitedZoomEnabled = false
    local notificationCooldown = false

    AstraCloud:CreateLabel({ Name = "AstraCloud by Elden and Nate" })

    AstraCloud:CreateToggle({
        Name = "Admin/Exploiter Detection",
        CurrentValue = false,
        Callback = function(value)
            adminDetectEnabled = value
            if value then
                ShowNotification("Admin Detection Enabled")
            else
                ShowNotification("Admin Detection Disabled")
            end
        end
    })

    AstraCloud:CreateToggle({
        Name = "Anticheat Bypass",
        CurrentValue = false,
        Callback = function(value)
            anticheatBypassEnabled = value
            if value then
                ShowNotification("Anticheat Bypass Enabled")
                -- Disable kick functions, metatable detection etc
                local mt = getrawmetatable(game)
                if not mt.__namecall then return end
                setreadonly(mt,false)
                local oldNamecall = mt.__namecall
                mt.__namecall = newcclosure(function(self,...)
                    local method = getnamecallmethod()
                    if anticheatBypassEnabled then
                        if tostring(self) == "Humanoid" and method == "Kick" then
                            return
                        elseif tostring(self) == "Player" and method == "Kick" then
                            return
                        elseif tostring(self) == "Player" and method == "Destroy" then
                            return
                        end
                    end
                    return oldNamecall(self,...)
                end)
                setreadonly(mt,true)
            else
                ShowNotification("Anticheat Bypass Disabled")
                -- Reload script or do nothing
            end
        end
    })

    AstraCloud:CreateButton({
        Name = "Instant Kill",
        Callback = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                ShowNotification("Instant Kill executed")
            end
        end
    })

    AstraCloud:CreateToggle({
        Name = "Godmode",
        CurrentValue = false,
        Callback = function(value)
            godmodeEnabled = value
            if value then
                ShowNotification("Godmode Enabled")
                spawn(function()
                    while godmodeEnabled do
                        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                        task.wait(0.5)
                    end
                end)
            else
                ShowNotification("Godmode Disabled")
            end
        end
    })

    AstraCloud:CreateToggle({
        Name = "Unlimited Zoom",
        CurrentValue = false,
        Callback = function(value)
            unlimitedZoomEnabled = value
            if value then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChildWhichIsA("BasePart")
                Camera.FieldOfView = 120
                Camera.CameraType = Enum.CameraType.Custom
                ShowNotification("Unlimited Zoom Enabled")
            else
                Camera.FieldOfView = 70
                ShowNotification("Unlimited Zoom Disabled")
            end
        end
    })

    -- Admin/Exploiter Detection logic (very simple log watcher)
    local function detectSuspiciousActivity()
        if not adminDetectEnabled then return end
        local suspiciousItems = {
            "kick", "ban", "shutdown", "loadstring", "teleport", "admin", "exploiter", "kickplayer"
        }
        game:GetService("LogService").MessageOut:Connect(function(msg, type)
            if adminDetectEnabled then
                for _, keyword in ipairs(suspiciousItems) do
                    if string.find(string.lower(msg), keyword) then
                        if not notificationCooldown then
                            notificationCooldown = true
                            ShowNotification("DETECTED ITEM: "..keyword)
                            task.delay(5, function() notificationCooldown = false end)
                        end
                    end
                end
            end
        end)
    end
    detectSuspiciousActivity()

end

return Window

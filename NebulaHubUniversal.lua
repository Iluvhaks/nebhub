local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
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

-- UTILITY FUNCTION: Virtual Input for Mobile
local function sendVirtualInput(key)
    if UserInputService.TouchEnabled then
        if typeof(key) == "string" then
            -- Virtual key press for keys "1","2","3","4"
            UserInputService:SetKeyDown(Enum.KeyCode[key])
            task.wait(0.1)
            UserInputService:SetKeyUp(Enum.KeyCode[key])
        elseif key == Enum.UserInputType.MouseButton1 then
            -- Virtual mouse button 1 press
            UserInputService:SetMouseButtonPressed(Enum.UserInputType.MouseButton1)
            task.wait(0.1)
            UserInputService:SetMouseButtonReleased(Enum.UserInputType.MouseButton1)
        end
    else
        -- On PC, fallback to firing shootRemote or other logic (not virtual keys)
        -- This is handled in autofarm loop
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

UserInputService.JumpRequest:Connect(function()
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
        local bv=Instance.new("BodyVelocity",hrp)
        bv.Velocity=Vector3.new(9999,9999,9999)
        bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
        task.wait(0.5)
        bv:Destroy()
    end
end})

-- AUTO
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

-- VISUAL
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end})
VisualTab:CreateToggle({Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end})
VisualTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end})
VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})
VisualTab:CreateToggle({Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end})
VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
VisualTab:CreateSlider({Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})

-- Get closest enemy for Aimbot
local function getClosestEnemy()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local bestDist, bestP = AimFOV, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team==LocalPlayer.Team then continue end
            local pos, on = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
            if on then
                local mag = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                if mag < bestDist then bestDist, bestP = mag, p end
            end
        end
    end
    return bestP
end

-- Find remote for AutoShoot
local function findShootRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("shoot") then
            shootRemote = obj; break
        end
    end
end

-- Loop: ESP, Aimbot & AutoShoot
RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team==LocalPlayer.Team then continue end
            local part = p.Character[TargetPart]
            local pos, on = Camera:WorldToViewportPoint(part.Position)
            local dist = (part.Position - camPos).Magnitude

            -- Visibility ray
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character}
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            local hit = workspace:Raycast(camPos, part.Position-camPos, rp)
            local vis = hit and hit.Instance:IsDescendantOf(p.Character)

            if ESPOn and on and vis then
                if not espObjects[p] then
                    espObjects[p] = {box=Drawing.new("Square"), line=Drawing.new("Line")}
                end
                local d=espObjects[p]
                local size=math.clamp(2000/dist,20,200)
                d.box.Visible=true; d.box.Color=Color3.new(1,0,0); d.box.Thickness=2
                d.box.Size=Vector2.new(size,size); d.box.Position=Vector2.new(pos.X,pos.Y)-d.box.Size/2
                d.line.Visible=LineESP
                if LineESP then
                    d.line.From=center; d.line.To=Vector2.new(pos.X,pos.Y)
                    d.line.Color=Color3.new(1,0,0); d.line.Thickness=1
                end
            elseif espObjects[p] then
                espObjects[p].box:Remove(); espObjects[p].line:Remove()
                espObjects[p]=nil
            end
        end
    end

    if AimbotOn then
        local tgt = getClosestEnemy()
        if tgt and tgt.Character and tgt.Character:FindFirstChild(TargetPart) then
            local tp = tgt.Character[TargetPart].Position
            Camera.CFrame = CFrame.new(camPos, tp)

            if AutoShoot then
                if shootRemote then pcall(shootRemote.FireServer, shootRemote) else findShootRemote() end
                if UserInputService.TouchEnabled then
                    for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("ImageButton") and gui.Name:lower():find("shoot") and gui.Visible then
                            pcall(function() gui:Activate() end); break
                        end
                    end
                end
            end
        end
    end
end)

-- EXPLOITS
Exploits:CreateButton({Name="Click Delete", Callback=function()
    local m=LocalPlayer:GetMouse()
    m.Button1Down:Connect(function() if m.Target then m.Target:Destroy() end end)
end})

local noclipConnection = nil
Exploits:CreateToggle({Name="No Clip", CurrentValue=false, Callback=function(v)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if v and LocalPlayer.Character then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end)
    end
end})

Exploits:CreateButton({Name="Teleport Tool", Callback=function()
    local tool=Instance.new("Tool")
    tool.RequiresHandle=false; tool.Name="TP Tool"; tool.Parent=LocalPlayer.Backpack
    tool.Activated:Connect(function()
        local m = LocalPlayer:GetMouse()
        if m.Hit then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
    end)
end})

-- FTAP Tab
FTAPTab:CreateToggle({Name="Enable Fling (FTAP)", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end})

FTAPTab:CreateSlider({Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v)
    flingStrength = math.clamp(v, 100, 5000)
    Rayfield:Notify({Title="FTAP", Content="Strength: "..flingStrength, Duration=1})
end})

FTAPTab:CreateToggle({Name="AntiGrab", CurrentValue=antiGrabEnabled, Callback=function(v)
    antiGrabEnabled = v
    Rayfield:Notify({Title="AntiGrab", Content=(v and "Enabled" or "Disabled"), Duration=2})
end})

FTAPTab:CreateToggle({Name="Spawn Kill All", CurrentValue=spawnKillAll, Callback=function(value)
    spawnKillAll = value
    if spawnKillAll then
        spawn(function()
            local voidPos = Vector3.new(0, -500, 0)
            while spawnKillAll do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(voidPos)
                    end
                end
                task.wait(1)
            end
        end)
        Rayfield:Notify({Title="Spawn Kill All", Content="Enabled", Duration=2})
    else
        Rayfield:Notify({Title="Spawn Kill All", Content="Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Fling All", CurrentValue=flingAll, Callback=function(value)
    flingAll = value
    if flingAll then
        spawn(function()
            while flingAll do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local root = LocalPlayer.Character.HumanoidRootPart
                            local spinSpeed = 30
                            local rot = 0
                            local spinConnection
                            spinConnection = RunService.Heartbeat:Connect(function(dt)
                                if not flingAll then spinConnection:Disconnect() return end
                                rot = rot + spinSpeed * dt
                                root.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(rot), 0)
                            end)

                            root.CFrame = hrp.CFrame * CFrame.new(0,0,2)
                            task.wait(2)

                            if spinConnection then spinConnection:Disconnect() end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
        Rayfield:Notify({Title="Fling All", Content="Enabled", Duration=2})
    else
        Rayfield:Notify({Title="Fling All", Content="Disabled", Duration=2})
    end
end})

-- FTAP release detection and AntiGrab implementation
workspace.ChildAdded:Connect(function(m)
    if m.Name == "GrabParts" and m:FindFirstChild("GrabPart") then
        local grabPart = m.GrabPart
        local weld = grabPart:FindFirstChild("WeldConstraint")
        if weld and antiGrabEnabled then
            weld:Destroy()
        end
        -- Additional safeguard: break weld if created again
        m:GetPropertyChangedSignal("Parent"):Connect(function()
            if not m.Parent and flingEnabled then
                local lastInput = UserInputService:GetLastInputType()
                if lastInput == Enum.UserInputType.MouseButton1 or lastInput == Enum.UserInputType.Touch then
                    local part = weld and weld.Part1 or nil
                    if part then
                        local bv = Instance.new("BodyVelocity")
                        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                        bv.Velocity = Vector3.new(0,0,50000)
                        bv.Parent = part
                        Debris:AddItem(bv, 0.5)
                    end
                end
            end
        end)
    end
end)

-- TSB TAB

-- TSB Autofarm Using Virtual Input (mobile support)
TSBTab:CreateToggle({
    Name = "TSB Autofarm (Virtual Input)",
    CurrentValue = false,
    Callback = function(state)
        autofarmEnabled = state
        if state then
            spawn(function()
                while autofarmEnabled do
                    local localChar = LocalPlayer.Character
                    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
                    if not localHRP then task.wait(1) continue end

                    local foundTarget = false
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 then
                                foundTarget = true
                                targetPlayer = p
                                print("Targeting: "..p.Name)

                                while hum.Health > 0 and autofarmEnabled do
                                    -- Tween to target smoothly
                                    local targetPos = p.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)
                                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
                                    local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(targetPos)})
                                    tween:Play()
                                    tween.Completed:Wait()

                                    -- Send moves randomly (1-4)
                                    local moveKey = tostring(math.random(1,4))
                                    sendVirtualInput(moveKey)

                                    -- Send attack (M1)
                                    sendVirtualInput(Enum.UserInputType.MouseButton1)

                                    task.wait(0.15)
                                end
                                break
                            end
                        end
                    end

                    if not foundTarget then
                        print("No target found, waiting 2 sec")
                        task.wait(2)
                    end
                end
                print("TSB Autofarm stopped")
            end)
        end
    end
})

TSBTab:CreateToggle({Name="Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end})
TSBTab:CreateToggle({Name="Auto Shoot", CurrentValue=false, Callback=function(v) AutoShoot=v end})
TSBTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
TSBTab:CreateSlider({Name="Aim FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})
TSBTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})

-- END SCRIPT

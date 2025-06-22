-- Nebula Hub Universal – Full Updated Script (with improved FTAP toggles)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
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

-- FTAP Toggles State
local antiGrabEnabled = false
local spawnKillAllEnabled = false
local flingAllEnabled = false

-- MAIN UI
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    SubText = "Made by Elden and Nate",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {Enabled=true, FileName="NebulaHubUniversal"},
    Discord = {Enabled=true, Invite="yTxgQcTUw4", RememberJoins=true},
    KeySystem = false -- Disabled key system
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
                if UserInput.TouchEnabled then
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
local noclip=false
Exploits:CreateToggle({Name="No Clip", CurrentValue=false, Callback=function(v)
    noclip=v
    RunService.Stepped:Connect(function()
        if noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end)
end})
Exploits:CreateButton({Name="Teleport Tool", Callback=function()
    local tool=Instance.new("Tool")
    tool.RequiresHandle=false; tool.Name="TP Tool"; tool.Parent=LocalPlayer.Backpack
    tool.Activated:Connect(function()
        local m = LocalPlayer:GetMouse()
        if m.Hit then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
    end)
end})

-- FTAP Tab Features

FTAPTab:CreateToggle({Name="Enable Fling (FTAP)", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end})
FTAPTab:CreateSlider({
    Name="Fling Strength",
    Range={100,5000},
    Increment=50,
    CurrentValue=flingStrength,
    Callback=function(v)
        flingStrength = math.clamp(v, 100, 5000)
        Rayfield:Notify({Title="FTAP", Content="Strength: "..flingStrength, Duration=1})
    end
})

-- AntiGrab toggle - instantly drop welds on grab attempts
FTAPTab:CreateToggle({Name="AntiGrab", CurrentValue=false, Callback=function(v)
    antiGrabEnabled = v
end})

-- Spawn Kill All toggle
FTAPTab:CreateToggle({Name="Spawn Kill All", CurrentValue=false, Callback=function(enabled)
    spawnKillAllEnabled = enabled
    if enabled then
        spawn(function()
            while spawnKillAllEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart

                        -- Create or find GrabParts model
                        local grabParts = workspace:FindFirstChild("GrabParts")
                        if not grabParts then
                            grabParts = Instance.new("Model")
                            grabParts.Name = "GrabParts"
                            grabParts.Parent = workspace
                        end

                        -- Create or find GrabPart
                        local grabPart = grabParts:FindFirstChild("GrabPart")
                        if not grabPart then
                            grabPart = Instance.new("Part")
                            grabPart.Name = "GrabPart"
                            grabPart.Size = Vector3.new(1,1,1)
                            grabPart.Transparency = 1
                            grabPart.CanCollide = false
                            grabPart.Anchored = false
                            grabPart.Parent = grabParts
                        end

                        -- Weld GrabPart to HumanoidRootPart
                        grabPart.CFrame = hrp.CFrame
                        local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
                        if weld then weld:Destroy() end
                        weld = Instance.new("WeldConstraint")
                        weld.Part0 = grabPart
                        weld.Part1 = hrp
                        weld.Parent = grabPart

                        -- Move GrabParts 2000 studs up (teleport away)
                        grabParts:SetPrimaryPartCFrame(CFrame.new(hrp.Position + Vector3.new(0, 2000, 0)))

                        -- Let go after 1 second
                        task.wait(1)
                        if weld and weld.Parent then weld:Destroy() end
                    end
                end
                task.wait(3)
            end
        end)
    end
end})

-- Fling All toggle - spin rig and fling everyone nearby
FTAPTab:CreateToggle({Name="Fling All", CurrentValue=false, Callback=function(enabled)
    flingAllEnabled = enabled
    if enabled then
        spawn(function()
            while flingAllEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                local hrp = LocalPlayer.Character.HumanoidRootPart

                -- Spin local player's HumanoidRootPart
                local bv = hrp:FindFirstChild("FlingVelocity")
                if not bv then
                    bv = Instance.new("BodyAngularVelocity")
                    bv.Name = "FlingVelocity"
                    bv.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
                    bv.AngularVelocity = Vector3.new(0, 50, 0) -- Fast spin
                    bv.Parent = hrp
                end

                -- Move to each player and collide
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) -- Slightly in front
                        task.wait(0.3)
                    end
                end
                task.wait(0.5)
            end
            -- Cleanup fling velocity when toggle off
            local bv = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlingVelocity")
            if bv then bv:Destroy() end
        end)
    else
        -- Destroy fling velocity if toggled off
        local bv = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlingVelocity")
        if bv then bv:Destroy() end
    end
end})

-- FTAP release detection for AntiGrab
workspace.ChildAdded:Connect(function(m)
    if m.Name == "GrabParts" and m:FindFirstChild("GrabPart") and m.GrabPart:FindFirstChild("WeldConstraint") then
        local part = m.GrabPart.WeldConstraint.Part1
        m:GetPropertyChangedSignal("Parent"):Connect(function()
            if not m.Parent and antiGrabEnabled then
                -- Player was grabbed and grab removed, apply fling on released part to throw grabber away
                local lastInput = UserInput:GetLastInputType()
                if lastInput == Enum.UserInputType.MouseButton1 or lastInput == Enum.UserInputType.Touch then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                    bv.Velocity = Camera.CFrame.LookVector * flingStrength
                    bv.Parent = part
                    Debris:AddItem(bv, 0.5)
                end
            end
        end)
    end
end)

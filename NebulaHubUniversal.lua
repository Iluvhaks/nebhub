local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
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

local antiGrabEnabled = false
local spawnKillAll = false
local flingAll = false
local deletePlayerOnRelease = false

-- AUTOFARM TSB VARIABLES
local autofarmEnabled = false
local targetPlayer = nil

-- HELPER FUNCTIONS --

local function getNextTarget()
    local closestDist = math.huge
    local bestTarget = nil
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
            local h = p.Character.Humanoid
            local hrp = p.Character.HumanoidRootPart
            if h.Health > 0 then
                if TeamCheck and p.Team == LocalPlayer.Team then continue end
                local dist = (hrp.Position - localHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    bestTarget = p
                end
            end
        end
    end
    return bestTarget
end

local function simulateMove(key)
    if UserInput.TouchEnabled then
        VirtualUser:SetKeyDown(key)
        task.wait(0.1)
        VirtualUser:SetKeyUp(key)
    else
        local kCode = Enum.KeyCode[key]
        if kCode then
            UserInput:SetKeyDown(kCode)
            task.wait(0.1)
            UserInput:SetKeyUp(kCode)
        end
    end
end

local function simulateMouse1()
    if UserInput.TouchEnabled then
        VirtualUser:Button1Down(Vector2.new(0,0))
        task.wait(0.1)
        VirtualUser:Button1Up(Vector2.new(0,0))
    else
        UserInput:SetMouseButtonDown(Enum.UserInputType.MouseButton1)
        task.wait(0.1)
        UserInput:SetMouseButtonUp(Enum.UserInputType.MouseButton1)
    end
end

local function tweenToTarget(target)
    local localChar = LocalPlayer.Character
    if not localChar then return end
    local hrp = localChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tgtChar = target.Character
    if not tgtChar then return end
    local tgtPart = tgtChar:FindFirstChild(TargetPart)
    if not tgtPart then return end

    local tweenTime = 0.5
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)

    local desiredPos = tgtPart.Position + Vector3.new(0, 5, 0)

    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(desiredPos)})
    tween:Play()

    Camera.CFrame = CFrame.new(Camera.CFrame.Position, tgtPart.Position)

    tween.Completed:Wait()
end

local function findShootRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("shoot") then
            shootRemote = obj; break
        end
    end
end

local function attackTarget(target)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if not target.Character or not target.Character:FindFirstChild("Humanoid") then return false end
    local targetHum = target.Character.Humanoid
    if targetHum.Health <= 0 then return false end

    local attackRemotes = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local nameLower = obj.Name:lower()
            if nameLower:find("attack") or nameLower:find("ability") or nameLower:find("m1") then
                table.insert(attackRemotes, obj)
            end
        end
    end

    for _, remote in pairs(attackRemotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(target.Character)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(target.Character)
            end
        end)
    end
    return true
end

local function teleportToTarget(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local offset = hrp.CFrame.LookVector * 1.5
    myChar.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(offset.X, 0, offset.Z)
end

local function getSafePosition()
    local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Spawn")
    if spawnLocation then
        return spawnLocation.Position + Vector3.new(0,5,0)
    else
        return Vector3.new(0, 50, 0)
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

-- UTILITY --
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

-- TROLL --
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

-- AUTO --
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

-- REMOTES --
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

-- VISUAL --
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end})
VisualTab:CreateToggle({Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end})
VisualTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Callback=function(v) AimbotOn=v end})
VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})
VisualTab:CreateToggle({Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end})
VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
VisualTab:CreateSlider({Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})

-- Get closest enemy for Visual Aimbot
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

-- EXPLOITS --
Exploits:CreateButton({Name="Click Delete", Callback=function()
    local m=LocalPlayer:GetMouse()
    m.Button1Down:Connect(function()
        if m.Target then m.Target:Destroy() end
    end)
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
    tool.RequiresHandle = false
    tool.Name = "Teleporter"
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse and mouse.Hit then
            LocalPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0,5,0)
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end})

-- FTAP --
local grabbedPlayers = {}

local function flingPlayer(player)
    local plrChar = player.Character
    local localChar = LocalPlayer.Character
    if not plrChar or not plrChar:FindFirstChild("HumanoidRootPart") or not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end

    local grabbedPart = Instance.new("Attachment", plrChar.HumanoidRootPart)
    local grabPart = Instance.new("Attachment", localChar.HumanoidRootPart)

    local rope = Instance.new("RopeConstraint", localChar.HumanoidRootPart)
    rope.Attachment0 = grabPart
    rope.Attachment1 = grabbedPart
    rope.Length = 0

    -- Fling movement
    local bv = Instance.new("BodyVelocity", localChar.HumanoidRootPart)
    bv.Velocity = Vector3.new(9999,9999,9999)
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)

    -- Teleport player to local player
    plrChar.HumanoidRootPart.CFrame = localChar.HumanoidRootPart.CFrame * CFrame.new(0,5,0)

    -- Store for later release
    grabbedPlayers[player] = {rope=rope, bv=bv, attachments={grabPart, grabbedPart}}

    -- Notify
    Rayfield:Notify({Title="FTAP", Content="Grabbed "..player.Name, Duration=2})
end

local function releasePlayer(player)
    if grabbedPlayers[player] then
        local data = grabbedPlayers[player]
        for _, v in ipairs(data.attachments) do
            if v then v:Destroy() end
        end
        if data.rope then data.rope:Destroy() end
        if data.bv then data.bv:Destroy() end

        -- Teleport away if toggle enabled
        if deletePlayerOnRelease and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0,50000,0)
        end

        grabbedPlayers[player] = nil
        Rayfield:Notify({Title="FTAP", Content="Released "..player.Name, Duration=2})
    end
end

local function grabAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            flingPlayer(p)
        end
    end
end

local function releaseAll()
    for p, _ in pairs(grabbedPlayers) do
        releasePlayer(p)
    end
end

local function spawnKillLoop()
    spawn(function()
        while spawnKillAll do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                    task.wait(0.2)
                end
            end
            task.wait(1)
        end
    end)
end

local function flingAllLoop()
    spawn(function()
        while flingAll do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local pHrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and pHrp then
                        pHrp.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
                        local bv = Instance.new("BodyVelocity", hrp)
                        bv.Velocity = Vector3.new(9999, 9999, 9999)
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        Debris:AddItem(bv, 0.3)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- FTAP UI

FTAPTab:CreateToggle({Name="Anti Grab", CurrentValue=false, Callback=function(v)
    antiGrabEnabled = v
    if v then
        LocalPlayer.Character.HumanoidRootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
            if LocalPlayer.Character.HumanoidRootPart.Anchored and antiGrabEnabled then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end)
        Rayfield:Notify({Title="FTAP", Content="Anti Grab Enabled", Duration=2})
    else
        Rayfield:Notify({Title="FTAP", Content="Anti Grab Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Spawn Kill All", CurrentValue=false, Callback=function(v)
    spawnKillAll = v
    if v then
        Rayfield:Notify({Title="FTAP", Content="Spawn Kill All Enabled", Duration=2})
        spawnKillLoop()
    else
        Rayfield:Notify({Title="FTAP", Content="Spawn Kill All Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Fling All", CurrentValue=false, Callback=function(v)
    flingAll = v
    if v then
        Rayfield:Notify({Title="FTAP", Content="Fling All Enabled", Duration=2})
        flingAllLoop()
    else
        Rayfield:Notify({Title="FTAP", Content="Fling All Disabled", Duration=2})
    end
end})

FTAPTab:CreateToggle({Name="Delete Player on Release", CurrentValue=false, Callback=function(v)
    deletePlayerOnRelease = v
    Rayfield:Notify({Title="FTAP", Content="Delete Player on Release "..(v and "Enabled" or "Disabled"), Duration=2})
end})

FTAPTab:CreateButton({Name="Grab All Players", Callback=grabAll})
FTAPTab:CreateButton({Name="Release All Players", Callback=releaseAll})

-- TSB TAB --

TSBTab:CreateToggle({
    Name = "Enable Autofarm",
    CurrentValue = false,
    Callback = function(value)
        autofarmEnabled = value
        if value then
            Rayfield:Notify({Title="TSB Autofarm", Content="Enabled", Duration=2})
        else
            Rayfield:Notify({Title="TSB Autofarm", Content="Disabled", Duration=2})
        end
    end
})

TSBTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(value)
        AimbotOn = value
        Rayfield:Notify({Title="TSB Aimbot", Content=AimbotOn and "Enabled" or "Disabled", Duration=2})
    end
})

TSBTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(value)
        TeamCheck = value
    end
})

TSBTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 300},
    CurrentValue = AimFOV,
    Callback = function(value)
        AimFOV = value
    end
})

TSBTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = TargetPart,
    Callback = function(value)
        TargetPart = value
    end
})

-- TSB Autofarm loop
spawn(function()
    while true do
        task.wait(0.1)
        if autofarmEnabled then
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Humanoid") or targetPlayer.Character.Humanoid.Health <= 0 then
                targetPlayer = getNextTarget()
                if targetPlayer then
                    Rayfield:Notify({Title="Autofarm", Content="New target: "..targetPlayer.Name, Duration=2})
                else
                    Rayfield:Notify({Title="Autofarm", Content="No valid target found", Duration=2})
                    task.wait(3)
                end
            end

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                tweenToTarget(targetPlayer)
                for _, key in ipairs({"One", "Two", "Three", "Four"}) do
                    simulateMove(key)
                    task.wait(0.15)
                end
                simulateMouse1()
                task.wait(0.3)
            end
        else
            task.wait(1)
        end
    end
end)

-- NOTIFY LOAD COMPLETE
Rayfield:Notify({Title="Nebula Hub Universal", Content="Loaded all tabs successfully", Duration=4})

-- Nebula Hub Universal — FULL UPDATED RAW SCRIPT --

-- Load Rayfield UI (make sure this URL is reachable)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Rayfield UI failed to load.") end

-- Game services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Shared state variables
local clickTPOn, clickConn = false, nil
local ESPOn, LineESP, TeamCheck, AutoShoot = false, false, true, false
local AimFOV, TargetPart = 100, "Head"
local InfJump, remLag = false, false
local espObjects = {}
local flingEnabled, flingStrength = false, 350
local antiGrabEnabled, spawnKillAll, flingAll = false, false, false
local shootRemote = nil

-- TSB Autofarm
local tsbEnabled, tsbTarget, tsbFly = false, nil, false
local safeY = 500

-- Blox Fruits Autofarm
local bfEnabled, bfPrimary = false, "Melee"
local bfLastAttack = 0
local bfTween = TweenInfo.new(3, Enum.EasingStyle.Linear)
local bfMap = {
    {min=1, max=9, pos=Vector3.new(340,7,1534), npc="Monkey D. Luffy", quest="Monkey D. Luffy"},
    {min=10,max=14,pos=Vector3.new(-1524,7,1602),npc="Pirate Morgan",quest="Pirate Morgan"},
    {min=15,max=29,pos=Vector3.new(-506,7,1067),npc="Bandit Leader",quest="Bandit Leader"},
    {min=30,max=39,pos=Vector3.new(452,7,-3673),npc="Desert Bandit",quest="Desert Bandit"},
    {min=40,max=59,pos=Vector3.new(1864,7,-3888),npc="Baroque Works",quest="Baroque Works"},
    {min=60,max=89,pos=Vector3.new(-537,7,-3076),npc="Ice Queen",quest="Ice Queen"},
    {min=90,max=99,pos=Vector3.new(-123,7,-6907),npc="Fishman Raider",quest="Fishman Raider"},
    {min=100,max=149,pos=Vector3.new(-198,7,-7482),npc="Shanks",quest="Shanks"},
    {min=150,max=199,pos=Vector3.new(-3500,7,-12000),npc="Kaido",quest="Kaido"},
}

-- Utility inputs
local function sendInput(key)
    if UserInputService.TouchEnabled then
        if typeof(key) == "string" then
            UserInputService:SetKeyDown(Enum.KeyCode[key]); task.wait(0.1); UserInputService:SetKeyUp(Enum.KeyCode[key])
        else
            UserInputService:SetMouseButtonPressed(key); task.wait(0.05); UserInputService:SetMouseButtonReleased(key)
        end
    end
end

-- Fly for TSB when in safe mode
local function toggleTSBFly(state)
    tsbFly = state
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if state then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "TSBFly"; bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            RunService.Heartbeat:Connect(function()
                if tsbFly then
                    local vel = Vector3.new()
                    local cf = Camera.CFrame
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cf.LookVector*60 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cf.LookVector*60 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cf.RightVector*60 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cf.RightVector*60 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0,60,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel -= Vector3.new(0,60,0) end
                    bv.Velocity = vel
                else bv:Destroy() end
            end)
        else
            local flyBV = hrp:FindFirstChild("TSBFly")
            if flyBV then flyBV:Destroy() end
        end
    end
end

-- Find shoot remote for TSB
local function findShoot()
    for _, o in ipairs(ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") and o.Name:lower():find("shoot") then
            shootRemote = o; break
        end
    end
end

-- TSB Autofarm loop
local function tsbLoop()
    findShoot()
    while tsbEnabled do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if hum.Health < hum.MaxHealth * 0.35 then
                hrp.CFrame = CFrame.new(hrp.Position.X, safeY, hrp.Position.Z)
                toggleTSBFly(true)
                task.wait(0.5)
            elseif hum.Health > hum.MaxHealth * 0.55 then
                toggleTSBFly(false)
            end

            if not tsbTarget or not tsbTarget.Character or not tsbTarget.Character:FindFirstChild("HumanoidRootPart") then
                tsbTarget = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        tsbTarget = p; break
                    end
                end
            end

            if tsbTarget and tsbTarget.Character then
                local targetHRP = tsbTarget.Character.HumanoidRootPart
                hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0,3,0))
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHRP.Position)

                if UserInputService.TouchEnabled then
                    sendInput(Enum.UserInputType.MouseButton1)
                elseif shootRemote then
                    pcall(shootRemote.FireServer, shootRemote)
                end

                task.wait(0.15)
            else
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end

-- Blox Fruits helper functions
local function getBFLevel()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local l = ls:FindFirstChild("Level") or ls:FindFirstChild("level")
        return l and l.Value or 1
    end
    return 1
end

local function getBFQuest(lv)
    for _, v in ipairs(bfMap) do
        if lv >= v.min and lv <= v.max then
            return v
        end
    end
end

local function tweenBF(pos)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        TweenService:Create(hrp, bfTween, {CFrame = CFrame.new(pos + Vector3.new(0,5,0))}):Play():Wait()
    end
end

local function findBFNPC(name)
    for _, n in ipairs(workspace:FindFirstChild("NPCs") and workspace.NPCs:GetChildren() or {}) do
        if n.Name == name then return n end
    end
end

local function acceptBFQuest(npc)
    local ev = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("StartQuest")
    if ev then pcall(function() ev:FireServer(npc.Name) end) end
end

local function BFQuestComplete(name)
    local pq = ReplicatedStorage:FindFirstChild("PlayerQuests") and ReplicatedStorage.PlayerQuests:FindFirstChild(name)
    return pq and pq.Value == "Complete"
end

local function findBFMobs(npc)
    local out = {}
    for _, m in ipairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
        local part = m:FindFirstChild("HumanoidRootPart")
        if part and npc and (part.Position - npc.HumanoidRootPart.Position).Magnitude < 60 then
            table.insert(out, m)
        end
    end
    return out
end

local function canAttackBF()
    return tick() - bfLastAttack >= 0.3
end

local function attackBF()
    bfLastAttack = tick()
    if bfPrimary == "Melee" or bfPrimary == "Sword" then
        if UserInputService.TouchEnabled then
            sendInput(Enum.UserInputType.MouseButton1)
        else
            local rn = bfPrimary == "Melee" and "MeleeAttack" or "SwordAttack"
            local ev = ReplicatedStorage:FindFirstChild(rn) or ReplicatedStorage:FindFirstChild(rn:sub(1, -7))
            if ev and ev:IsA("RemoteEvent") then
                pcall(function() ev:FireServer() end)
            end
        end
    else
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool.Name:find("Fruit") and tool:FindFirstChild("RemoteEvent") then
            pcall(function() tool.RemoteEvent:FireServer() end)
        elseif UserInputService.TouchEnabled then
            sendInput(Enum.UserInputType.MouseButton1)
        end
    end
end

local function killAuraBF(npc)
    for _, m in ipairs(findBFMobs(npc)) do
        local hum = m:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            tweenBF(m.HumanoidRootPart.Position)
            attackBF()
            task.wait(0.3)
        end
    end
end

-- Setup GUI
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    ConfigurationSaving = {Enabled=true, FileName="NebulaHubUniversal"},
    Discord = {Enabled=true, Invite="yTxgQcTUw4"},
    KeySystem = false
})

-- Create tabs
local U = Window:CreateTab("🧠 Utility")
local T = Window:CreateTab("💣 Troll")
local A = Window:CreateTab("🤖 Auto")
local R = Window:CreateTab("📡 Remotes")
local V = Window:CreateTab("🎯 Visual")
local X = Window:CreateTab("⚠️ Exploits")
local F = Window:CreateTab("👐 FTAP")
local S = Window:CreateTab("⚔️ TSB")
local B = Window:CreateTab("🍉 Blox Fruits")

-- Utility tab
U:CreateButton{ Name="Click TP", Callback=function()
    clickTPOn = not clickTPOn
    if clickTPOn then
        clickConn = LocalPlayer:GetMouse().Button1Down:Connect(function(m)
            if m.Target then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
        end)
        Rayfield:Notify{Title="Click TP",Content="Enabled",Duration=2}
    else
        if clickConn then clickConn:Disconnect() end
        Rayfield:Notify{Title="Click TP",Content="Disabled",Duration=2}
    end
end}
U:CreateButton{ Name="Fly Toggle", Callback=function()
    _G.Fly = not _G.Fly
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        while _G.Fly and hrp.Parent do
            RunService.Stepped:Wait()
            bv.Velocity = Camera.CFrame.LookVector * 60
        end
        bv:Destroy()
    end
end}
U:CreateToggle{ Name="Infinite Jump", CurrentValue=false, Callback=function(v) InfJump=v end }
U:CreateSlider{ Name="Walk Speed", Range={16,200}, CurrentValue=16, Callback=function(v)
    local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") 
    if h then h.WalkSpeed=v end
end}
U:CreateSlider{ Name="Jump Power", Range={50,300}, CurrentValue=100, Callback=function(v)
    local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower=true; h.JumpPower=v end
end}
U:CreateButton{ Name="Anti-AFK", Callback=function()
    for _,c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
end}

-- Troll tab
T:CreateButton{ Name="Fake Kick", Callback=function() LocalPlayer:Kick("Fake Kick - Nebula Hub Universal") end }
T:CreateButton{ Name="Chat Spam", Callback=function()
    spawn(function()
        while task.wait(0.25) do
            pcall(function() ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!","All") end)
        end
    end)
end}
T:CreateButton{ Name="Fling Self", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(9999,9999,9999)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        task.wait(0.5); bv:Destroy()
    end
end}

-- Auto tab
A:CreateButton{ Name="Auto Move", Callback=function()
    _G.AutoMove = true
    spawn(function()
        while _G.AutoMove do
            if LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100,100),10,math.random(-100,100)))
            end
            task.wait(0.8)
        end
    end)
end}
A:CreateButton{ Name="Touch Everything", Callback=function()
    local rt = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _,p in ipairs(workspace:GetDescendants()) do
        if p:IsA("TouchTransmitter") and rt then
            firetouchinterest(rt, p.Parent, 0); firetouchinterest(rt, p.Parent, 1)
        end
    end
end}

-- Remote tab
R:CreateButton{ Name="Toggle Remote Lagging", Callback=function()
    remLag = not remLag
    Rayfield:Notify{Title="Remote Lag",Content=(remLag and "Enabled" or "Disabled"),Duration=2}
    if remLag then
        spawn(function()
            while remLag do
                for _,obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                        pcall(function()
                            if obj:IsA("RemoteEvent") then obj:FireServer("NebulaSpam") end
                            if obj:IsA("RemoteFunction") then obj:InvokeServer("NebulaSpam") end
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end}
R:CreateButton{ Name="Scan Remotes", Callback=function()
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("[Remote] "..obj:GetFullName())
        end
    end
end}

-- Visual tab
V:CreateToggle{ Name="Enable ESP", CurrentValue=false, Callback=function(v) ESPOn=v end }
V:CreateToggle{ Name="Line ESP", CurrentValue=false, Callback=function(v) LineESP=v end }
V:CreateToggle{ Name="Enable Aimbot", CurrentValue=false, Callback=function(v) TeamCheck=v end }
V:CreateToggle{ Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end }
V:CreateToggle{ Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end }
V:CreateDropdown{ Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end }
V:CreateSlider{ Name="Aimbot FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end }

-- Aimbot render loop
RunService.RenderStepped:Connect(function()
    if ESPOn or AutoShoot then
        local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
                local part = p.Character[TargetPart]
                local pos,on = Camera:WorldToViewportPoint(part.Position)
                local dist = (part.Position - Camera.CFrame.Position).Magnitude
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {LocalPlayer.Character}; rp.FilterType = Enum.RaycastFilterType.Blacklist
                local hit = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rp)
                local vis = hit and hit.Instance:IsDescendantOf(p.Character)
                if ESPOn and on and vis then
                    if not espObjects[p] then
                        espObjects[p] = {box=Drawing.new("Square"), line=Drawing.new("Line")}
                    end
                    local d = espObjects[p]; local size = math.clamp(2000/dist, 20, 200)
                    d.box.Visible=true; d.box.Color=Color3.new(1,0,0); d.box.Size=Vector2.new(size,size)
                    d.box.Position=Vector2.new(pos.X,pos.Y)-d.box.Size/2; d.box.Thickness=2
                    d.line.Visible=LineESP
                    if LineESP then
                        d.line.From = center; d.line.To = Vector2.new(pos.X,pos.Y)
                        d.line.Color=Color3.new(1,0,0); d.line.Thickness=1
                    end
                elseif espObjects[p] then
                    espObjects[p].box:Remove(); espObjects[p].line:Remove(); espObjects[p]=nil
                end
                if AutoShoot and vis and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                    if shootRemote then
                        pcall(shootRemote.FireServer, shootRemote)
                    elseif UserInputService.TouchEnabled then
                        sendInput(Enum.UserInputType.MouseButton1)
                    end
                end
            end
        end
    end
end)

-- Exploits tab
X:CreateButton{ Name="Click Delete", Callback=function()
    local m=LocalPlayer:GetMouse()
    m.Button1Down:Connect(function()
        if m.Target then m.Target:Destroy() end
    end)
end}
X:CreateToggle{ Name="No Clip", CurrentValue=false, Callback=function(v)
    local conn
    if v then
        conn = RunService.Stepped:Connect(function()
            for _,p in ipairs(LocalPlayer.Character:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end}
X:CreateButton{ Name="Teleport Tool", Callback=function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false; tool.Name = "TP Tool"; tool.Parent = LocalPlayer.Backpack
    tool.Activated:Connect(function()
        local m = LocalPlayer:GetMouse()
        if m.Hit then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0,3,0)) end
    end)
end}

-- FTAP tab
F:CreateToggle{ Name="Enable Fling", CurrentValue=flingEnabled, Callback=function(v) flingEnabled=v end }
F:CreateSlider{ Name="Fling Strength", Range={100,5000}, Increment=50, CurrentValue=flingStrength, Callback=function(v)
    flingStrength=v; Rayfield:Notify{Title="FTAP",Content="Strength: "..v,Duration=1}
end}
F:CreateToggle{ Name="AntiGrab", CurrentValue=antiGrabEnabled, Callback=function(v) antiGrabEnabled=v end }
F:CreateToggle{ Name="Spawn Kill All", CurrentValue=spawnKillAll, Callback=function(v)
    spawnKillAll=v
    if v then
        spawn(function()
            while spawnKillAll do
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = CFrame.new(0,-500,0)
                    end
                end
                task.wait(1)
            end
        end)
    end
end}
F:CreateToggle{ Name="Fling All", CurrentValue=flingAll, Callback=function(v)
    flingAll=v
    if v then
        spawn(function()
            while flingAll do
                for _,p in ipairs(Players:GetPlayers()) do
                    if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local target = p.Character.HumanoidRootPart.Position
                        for i=1,60 do
                            hrp.CFrame = CFrame.new(target) * CFrame.Angles(0, math.rad(i*6), 0)
                            task.wait(0.01)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end}
workspace.ChildAdded:Connect(function(m)
    if m.Name=="GrabParts" and m:FindFirstChild("GrabPart") and antiGrabEnabled then
        local weld = m.GrabPart:FindFirstChild("WeldConstraint")
        if weld then weld:Destroy() end
    end
end)

-- TSB tab autofarm toggle
S:CreateToggle{ Name="TSB Autofarm", CurrentValue=false, Callback=function(v)
    tsbEnabled=v
    if v then spawn(tsbLoop) else toggleTSBFly(false) end
end}

-- Blox Fruits tab elements
B:CreateDropdown{ Name="Primary Weapon", Options={"Melee","Sword","Fruit"}, CurrentOption="Melee", Callback=function(o)
    bfPrimary=o; Rayfield:Notify{Title="Blox Fruits",Content="Primary set to "..o,Duration=2}
end}
B:CreateToggle{ Name="Auto Farm", CurrentValue=false, Callback=function(v)
    bfEnabled=v
    if v then
        spawn(function()
            while bfEnabled do
                local lv = getBFLevel()
                local qi = getBFQuest(lv)
                if not qi then
                    Rayfield:Notify{Title="Blox Fruits",Content="No quest for level "..lv,Duration=2}
                    task.wait(5)
                else
                    tweenBF(qi.pos)
                    local npc = findBFNPC(qi.npc)
                    if npc then
                        acceptBFQuest(npc); task.wait(2)
                        repeat
                            killAuraBF(npc)
                            task.wait(0.3)
                        until not bfEnabled or BFQuestComplete(qi.quest)
                        tweenBF(qi.pos)
                        task.wait(2)
                    else
                        Rayfield:Notify{Title="Blox Fruits",Content="Fail find NPC "..qi.npc,Duration=2}
                        task.wait(5)
                    end
                end
            end
        end)
    end
end}

Rayfield:Notify{Title="Nebula Hub",Content="Loaded Successfully!",Duration=3}

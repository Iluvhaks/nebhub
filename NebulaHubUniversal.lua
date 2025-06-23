-- Nebula Hub Universal Full Script (All Tabs + Fixed TSB Autofarm + Mobile & PC Compatible)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return warn("Failed to load Rayfield UI.") end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Variables and States
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

-- Autofarm TSB vars
local autofarmEnabled = false

-- Utility function: Virtual Input (mobile)
local function sendVirtualInput(key)
    if UserInputService.TouchEnabled then
        if typeof(key) == "string" then
            UserInputService:SetKeyDown(Enum.KeyCode[key])
            task.wait(0.1)
            UserInputService:SetKeyUp(Enum.KeyCode[key])
        elseif key == Enum.UserInputType.MouseButton1 then
            UserInputService:SetMouseButtonPressed(Enum.UserInputType.MouseButton1)
            task.wait(0.1)
            UserInputService:SetMouseButtonReleased(Enum.UserInputType.MouseButton1)
        end
    else
        -- On PC fallback (handled in autofarm loop)
    end
end

-- UI Creation
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
local BloxFruits = Window:CreateTab("🍉 BloxFruits") -- Placeholder tab

-- ===== UTILITY TAB =====
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

Utility:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v) InfJump = v end
})

Utility:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    CurrentValue = 16,
    Callback = function(v)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
})

Utility:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    CurrentValue = 100,
    Callback = function(v)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = true; h.JumpPower = v end
    end
})

Utility:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        for _, c in pairs(getconnections(LocalPlayer.Idled)) do c:Disable() end
    end
})

-- Infinite Jump connection
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- ===== TROLL TAB =====
Troll:CreateButton({
    Name = "Fake Kick",
    Callback = function() LocalPlayer:Kick("Fake Kick - Nebula Hub Universal") end
})

Troll:CreateButton({
    Name = "Chat Spam",
    Callback = function()
        spawn(function()
            while task.wait(0.25) do
                pcall(function()
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Nebula Hub OP!", "All")
                end)
            end
        end)
    end
})

Troll:CreateButton({
    Name = "Fling Self",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Velocity = Vector3.new(9999, 9999, 9999)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            task.wait(0.5)
            bv:Destroy()
        end
    end
})

-- ===== AUTO TAB =====
AutoTab:CreateButton({
    Name = "Auto Move",
    Callback = function()
        _G.AutoMove = true
        spawn(function()
            while _G.AutoMove do
                if LocalPlayer.Character then
                    LocalPlayer.Character:MoveTo(Vector3.new(math.random(-100, 100), 10, math.random(-100, 100)))
                end
                task.wait(0.8)
            end
        end)
    end
})

AutoTab:CreateButton({
    Name = "Touch Everything",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("TouchTransmitter") and hrp then
                firetouchinterest(hrp, p.Parent, 0)
                firetouchinterest(hrp, p.Parent, 1)
            end
        end
    end
})

-- ===== REMOTE TAB =====
RemoteTab:CreateButton({
    Name = "Toggle Remote Lagging",
    Callback = function()
        remLag = not remLag
        Rayfield:Notify({Title="Remote Lag", Content=remLag and "Enabled" or "Disabled", Duration=2})
        if remLag then
            spawn(function()
                while remLag do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                            pcall(function()
                                if obj:IsA("RemoteEvent") then
                                    obj:FireServer("NebulaSpam")
                                else
                                    obj:InvokeServer("NebulaSpam")
                                end
                            end)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end
})

RemoteTab:CreateButton({
    Name = "Scan Remotes",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                print("[Remote] " .. obj:GetFullName())
            end
        end
    end
})

-- ===== VISUAL TAB =====
VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(v) ESPOn = v end
})

VisualTab:CreateToggle({
    Name = "Line ESP",
    CurrentValue = false,
    Callback = function(v) LineESP = v end
})

VisualTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(v) AimbotOn = v end
})

VisualTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Callback = function(v) TeamCheck = v end
})

VisualTab:CreateToggle({
    Name = "AutoShoot",
    CurrentValue = false,
    Callback = function(v) AutoShoot = v end
})

VisualTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = "Head",
    Callback = function(v) TargetPart = v end
})

VisualTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {50, 300},
    CurrentValue = 100,
    Callback = function(v) AimFOV = v end
})

-- ESP Drawing
RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team == LocalPlayer.Team then continue end
            local part = p.Character[TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local dist = (part.Position - camPos).Magnitude

            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character}
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            local hit = workspace:Raycast(camPos, part.Position - camPos, rp)
            local visible = hit and hit.Instance:IsDescendantOf(p.Character)

            if ESPOn and onScreen and visible then
                if not espObjects[p] then
                    espObjects[p] = {
                        box = Drawing.new("Square"),
                        line = Drawing.new("Line")
                    }
                end
                local d = espObjects[p]
                local size = math.clamp(2000 / dist, 20, 200)
                d.box.Visible = true
                d.box.Color = Color3.new(1, 0, 0)
                d.box.Thickness = 2
                d.box.Size = Vector2.new(size, size)
                d.box.Position = Vector2.new(pos.X, pos.Y) - d.box.Size / 2
                d.line.Visible = LineESP
                if LineESP then
                    d.line.From = center
                    d.line.To = Vector2.new(pos.X, pos.Y)
                    d.line.Color = Color3.new(1, 0, 0)
                    d.line.Thickness = 1
                end
            elseif espObjects[p] then
                espObjects[p].box:Remove()
                espObjects[p].line:Remove()
                espObjects[p] = nil
            end
        end
    end

    if AimbotOn then
        local tgt = nil
        -- If autofarm enabled, aimbot targets that player, else nearest enemy in FOV
        if autofarmEnabled and _G.TSBTargetPlayer and _G.TSBTargetPlayer.Character and _G.TSBTargetPlayer.Character:FindFirstChild(TargetPart) then
            tgt = _G.TSBTargetPlayer
        else
            local bestDist, bestP = AimFOV, nil
            local centerVec = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
                    if TeamCheck and p.Team == LocalPlayer.Team then continue end
                    local pos, on = Camera:WorldToViewportPoint(p.Character[TargetPart].Position)
                    if on then
                        local mag = (Vector2.new(pos.X, pos.Y) - centerVec).Magnitude
                        if mag < bestDist then
                            bestDist = mag
                            bestP = p
                        end
                    end
                end
            end
            tgt = bestP
        end

        if tgt and tgt.Character and tgt.Character:FindFirstChild(TargetPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, tgt.Character[TargetPart].Position)
            if AutoShoot then
                if shootRemote then
                    pcall(shootRemote.FireServer, shootRemote)
                else
                    for _, gui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("ImageButton") and gui.Name:lower():find("shoot") and gui.Visible then
                            pcall(function() gui:Activate() end)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- ===== EXPLOITS TAB =====
Exploits:CreateButton({
    Name = "Click Delete",
    Callback = function()
        local m = LocalPlayer:GetMouse()
        m.Button1Down:Connect(function()
            if m.Target then m.Target:Destroy() end
        end)
    end
})

local noclipConnection = nil
Exploits:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(v)
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        if v and LocalPlayer.Character then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end
})

Exploits:CreateButton({
    Name = "Teleport Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TP Tool"
        tool.Parent = LocalPlayer.Backpack
        tool.Activated:Connect(function()
            local m = LocalPlayer:GetMouse()
            if m.Hit then LocalPlayer.Character:MoveTo(m.Hit.p + Vector3.new(0, 3, 0)) end
        end)
    end
})

-- ===== FTAP TAB =====
FTAPTab:CreateToggle({
    Name = "Enable Fling (FTAP)",
    CurrentValue = flingEnabled,
    Callback = function(v) flingEnabled = v end
})

FTAPTab:CreateSlider({
    Name = "Fling Strength",
    Range = {100, 5000},
    Increment = 50,
    CurrentValue = flingStrength,
    Callback = function(v)
        flingStrength = math.clamp(v, 100, 5000)
        Rayfield:Notify({Title = "FTAP", Content = "Strength: " .. flingStrength, Duration = 1})
    end
})

FTAPTab:CreateToggle({
    Name = "AntiGrab",
    CurrentValue = antiGrabEnabled,
    Callback = function(v)
        antiGrabEnabled = v
        Rayfield:Notify({Title = "AntiGrab", Content = (v and "Enabled" or "Disabled"), Duration = 2})
    end
})

FTAPTab:CreateToggle({
    Name = "Spawn Kill All",
    CurrentValue = spawnKillAll,
    Callback = function(value)
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
            Rayfield:Notify({Title = "Spawn Kill All", Content = "Enabled", Duration = 2})
        else
            Rayfield:Notify({Title = "Spawn Kill All", Content = "Disabled", Duration = 2})
        end
    end
})

FTAPTab:CreateToggle({
    Name = "Fling All",
    CurrentValue = flingAll,
    Callback = function(value)
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

                                root.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                                task.wait(2)

                                if spinConnection then spinConnection:Disconnect() end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
            Rayfield:Notify({Title = "Fling All", Content = "Enabled", Duration = 2})
        else
            Rayfield:Notify({Title = "Fling All", Content = "Disabled", Duration = 2})
        end
    end
})

-- AntiGrab and fling on release
workspace.ChildAdded:Connect(function(m)
    if m.Name == "GrabParts" and m:FindFirstChild("GrabPart") then
        local grabPart = m.GrabPart
        local weld = grabPart:FindFirstChild("WeldConstraint")
        if weld and antiGrabEnabled then
            weld:Destroy()
        end
        m:GetPropertyChangedSignal("Parent"):Connect(function()
            if not m.Parent and flingEnabled then
                local lastInput = UserInputService:GetLastInputType()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp:ApplyImpulse(hrp.CFrame.LookVector * flingStrength)
                end
            end
        end)
    end
end)

-- ===== TSB TAB =====
-- AutoFarm Variables for TSB
local TweenInfoDefault = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local TSBAutofarmTween = nil
local TSBTargetPlayer = nil
local SafeFlyEnabled = false
local LowHealthThreshold = 0.35
local RecoverHealthThreshold = 0.55
local SafeFlyHeight = 1000
local SafeFlySpeed = 50

-- Teleport player to safe location and fly when low hp
local function enableSafeFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    SafeFlyEnabled = true
    humanoid.PlatformStand = true
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(hrp.Position.X, SafeFlyHeight, hrp.Position.Z)
    while SafeFlyEnabled do
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 0, SafeFlySpeed * RunService.Heartbeat:Wait())
        if humanoid.Health / humanoid.MaxHealth >= RecoverHealthThreshold then
            SafeFlyEnabled = false
        end
        task.wait()
    end
    hrp.Anchored = false
    humanoid.PlatformStand = false
end

-- Autofarm Loop
local function autofarmTSB()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    while autofarmEnabled do
        -- Validate target player
        if not TSBTargetPlayer or not TSBTargetPlayer.Character or not TSBTargetPlayer.Character:FindFirstChild("HumanoidRootPart") or TSBTargetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            -- Find new target
            local nearest, dist = nil, math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local h = plr.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        local d = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            nearest = plr
                            dist = d
                        end
                    end
                end
            end
            if nearest then
                TSBTargetPlayer = nearest
            else
                task.wait(1)
                continue
            end
        end

        -- Teleport close to target & continuously tween to follow target
        if TSBTargetPlayer.Character and TSBTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = TSBTargetPlayer.Character.HumanoidRootPart
            if TSBAutofarmTween then
                TSBAutofarmTween:Cancel()
            end
            TSBAutofarmTween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = targetHRP.CFrame * CFrame.new(0, 3, 3)})
            TSBAutofarmTween:Play()
        else
            TSBTargetPlayer = nil
            task.wait(0.5)
            continue
        end

        -- Attack logic
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health / humanoid.MaxHealth <= LowHealthThreshold then
            -- Enable safe fly
            enableSafeFly()
        end

        -- Mouse Button 1 press simulation for mobile/pc attack with cooldown
        spawn(function()
            while autofarmEnabled and TSBTargetPlayer and TSBTargetPlayer.Character and TSBTargetPlayer.Character:FindFirstChild("HumanoidRootPart") do
                if UserInputService.TouchEnabled then
                    sendVirtualInput(Enum.UserInputType.MouseButton1)
                else
                    local mouse = LocalPlayer:GetMouse()
                    mouse1press()
                    task.wait(0.1)
                    mouse1release()
                end
                task.wait(0.3)
            end
        end)

        task.wait(0.35)
    end
end

TSBTab:CreateToggle({
    Name = "Autofarm",
    CurrentValue = false,
    Callback = function(v)
        autofarmEnabled = v
        if v then
            spawn(autofarmTSB)
        else
            if TSBAutofarmTween then
                TSBAutofarmTween:Cancel()
                TSBAutofarmTween = nil
            end
            TSBTargetPlayer = nil
        end
    end
})

-- ===== BLOXFRUITS TAB =====
BloxFruits:CreateLabel("BloxFruits AutoFarm coming soon...")

-- ===== FINAL =====
Rayfield:Notify({Title="Nebula Hub Universal", Content="Loaded all tabs with TSB Autofarm fixed.", Duration=4})

-- Cleanup ESP on unload
game:BindToClose(function()
    for _, v in pairs(espObjects) do
        if v.box then v.box:Remove() end
        if v.line then v.line:Remove() end
    end
end)


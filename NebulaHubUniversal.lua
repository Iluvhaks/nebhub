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
local ESPOn, LineESP, TeamCheck, AutoShoot = false, false, true, false
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

-- SAFETY & FLY MODE
local flyEnabled = false
local safePosition = Vector3.new(0, 500, 0) -- safe spot, change if you want

-- UTILITY FUNCTION: Virtual Input for Mobile
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
        -- PC firing handled in autofarm loop
    end
end

-- Fly function (toggle)
local function toggleFly(state)
    flyEnabled = state
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flyEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Parent = hrp
        task.spawn(function()
            while flyEnabled and hrp.Parent do
                RunService.Heartbeat:Wait()
                bv.Velocity = Vector3.new(0,0,0)
                local camLook = Camera.CFrame.LookVector
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then bv.Velocity = bv.Velocity + camLook*60 end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then bv.Velocity = bv.Velocity - camLook*60 end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then bv.Velocity = bv.Velocity - Camera.CFrame.RightVector*60 end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then bv.Velocity = bv.Velocity + Camera.CFrame.RightVector*60 end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bv.Velocity = bv.Velocity + Vector3.new(0,60,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bv.Velocity = bv.Velocity - Vector3.new(0,60,0) end
            end
            bv:Destroy()
        end)
    else
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FlyVelocity")
            if bv then bv:Destroy() end
        end
    end
end

-- Find shoot remote for PC autofire
local function findShootRemote()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("shoot") then
            shootRemote = obj
            break
        end
    end
end

-- Aim at current target function (always aimbot on current target)
local function aimAtTarget(target)
    if not target or not target.Character then return end
    local tp = target.Character:FindFirstChild(TargetPart)
    if not tp then return end
    local camPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.new(camPos, tp.Position)
end

-- Teleport to safe position & enable fly
local function goSafe()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(safePosition)
    toggleFly(true)
end

-- Teleport back to target & disable fly
local function goBackToTarget(target)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not target or not target.Character then return end
    local tgtHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not tgtHRP then return end
    toggleFly(false)
    hrp.CFrame = tgtHRP.CFrame + Vector3.new(0, 3, 0)
end

-- MAIN autofarm loop with health check, aimbot & attack
local function startAutofarm()
    findShootRemote()
    spawn(function()
        while autofarmEnabled do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then task.wait(1) continue end

            if hum.Health <= 0 then
                targetPlayer = nil
                task.wait(2)
                continue
            end

            -- Safety teleport logic
            if hum.Health <= (hum.MaxHealth * 0.35) and not flyEnabled then
                goSafe()
                task.wait(1)
                continue
            elseif hum.Health >= (hum.MaxHealth * 0.55) and flyEnabled and targetPlayer then
                goBackToTarget(targetPlayer)
            end

            -- Find target if none or target dead
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") or
                not targetPlayer.Character:FindFirstChildOfClass("Humanoid") or
                targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
                targetPlayer = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
                        local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if targetHum and targetHum.Health > 0 then
                            targetPlayer = p
                            break
                        end
                    end
                end
            end

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Tween to target
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Wait()

                -- Aim at current target (auto aimbot)
                aimAtTarget(targetPlayer)

                -- Attack
                if UserInputService.TouchEnabled then
                    sendVirtualInput(Enum.UserInputType.MouseButton1)
                else
                    if shootRemote then
                        pcall(shootRemote.FireServer, shootRemote)
                    else
                        sendVirtualInput(Enum.UserInputType.MouseButton1)
                    end
                end

                task.wait(0.15)
            else
                task.wait(2)
            end
        end
    end)
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
        toggleFly(not flyEnabled)
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

-- Add your Autofarm toggle button here (calls startAutofarm)
TSBTab:CreateToggle({
    Name = "TSB Autofarm (Virtual Input)",
    CurrentValue = false,
    Callback = function(state)
        autofarmEnabled = state
        if state then
            startAutofarm()
        else
            toggleFly(false)
            targetPlayer = nil
        end
    end
})

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
VisualTab:CreateToggle({Name="Team Check", CurrentValue=true, Callback=function(v) TeamCheck=v end})
VisualTab:CreateToggle({Name="AutoShoot", CurrentValue=false, Callback=function(v) AutoShoot=v end})
VisualTab:CreateDropdown({Name="Target Part", Options={"Head","HumanoidRootPart","Torso"}, CurrentOption="Head", Callback=function(v) TargetPart=v end})
VisualTab:CreateSlider({Name="Aim FOV", Range={50,300}, CurrentValue=100, Callback=function(v) AimFOV=v end})

-- ESP & Aimbot render loop for visuals (non-autofarm)
RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(TargetPart) then
            if TeamCheck and p.Team == LocalPlayer.Team then continue end
            local part = p.Character[TargetPart]
            local pos, on = Camera:WorldToViewportPoint(part.Position)
            local dist = (part.Position - camPos).Magnitude

            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {LocalPlayer.Character}
            rp.FilterType = Enum.RaycastFilterType.Blacklist
            local hit = workspace:Raycast(camPos, part.Position - camPos, rp)
            local vis = hit and hit.Instance:IsDescendantOf(p.Character)

            if ESPOn and on and vis then
                if not espObjects[p] then
                    espObjects[p] = {box=Drawing.new("Square"), line=Drawing.new("Line")}
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
end)

-- EXPLOITS
Exploits:CreateButton({Name="Click Delete", Callback=function()
    local m = LocalPlayer:GetMouse()
    m.Button1Down:Connect(function()
        if m.Target then
            m.Target:Destroy()
        end
    end)
end})

local noclipConnection = nil
Exploits:CreateToggle({Name="No Clip", CurrentValue=false, Callback=function(v)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if v and LocalPlayer.Character then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end})

-- FTAP (grab, fling, etc) -- You can put your existing FTAP code here as you want.

-- Optional: add your existing FTAP tab and features here.

-- END OF SCRIPT

Rayfield:Notify({Title="Nebula Hub", Content="Loaded Successfully!", Duration=3})

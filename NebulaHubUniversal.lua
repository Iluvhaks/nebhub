local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal v2.1",
    LoadingTitle = "Nebula Hub",
    LoadingSubtitle = "Made by Elden and Nate",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NebulaHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "FeAkp5e7d5",
        RememberJoins = true
    },
    KeySystem = false
})

-- VISUAL TAB
local VisualTab = Window:CreateTab("Visual")
local ESPSection = VisualTab:CreateSection("ESP")
local ESPEnabled, LineESPEnabled = false, false
VisualTab:CreateToggle({Name = "Enable ESP", CurrentValue = false, Callback = function(val) ESPEnabled = val end})
VisualTab:CreateToggle({Name = "Enable Line ESP", CurrentValue = false, Callback = function(val) LineESPEnabled = val end})

local ESPObjects = {}
local function CreateESPForPlayer(player)
    if ESPObjects[player] then return end
    local box = Drawing.new("Square")
    box.Color, box.Thickness, box.Filled, box.Visible = Color3.new(1,0,0), 2, false, false
    local line = Drawing.new("Line")
    line.Color, line.Thickness, line.Visible = Color3.new(1,1,1), 1, false
    ESPObjects[player] = {Box = box, Line = line}
end
local function RemoveESPForPlayer(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Line:Remove()
        ESPObjects[player] = nil
    end
end
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            CreateESPForPlayer(p)
            local root = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local esp = ESPObjects[p]
            if ESPEnabled and onScreen and pos.Z > 0 then
                local size = 1000 / pos.Z
                esp.Box.Size = Vector2.new(size / 2, size)
                esp.Box.Position = Vector2.new(pos.X - esp.Box.Size.X/2, pos.Y - esp.Box.Size.Y/2)
                esp.Box.Visible = true
            else esp.Box.Visible = false end
            if LineESPEnabled and onScreen and pos.Z > 0 then
                local mousePos = UserInputService:GetMouseLocation()
                esp.Line.From = Vector2.new(mousePos.X, mousePos.Y)
                esp.Line.To = Vector2.new(pos.X, pos.Y)
                esp.Line.Visible = true
            else esp.Line.Visible = false end
        else RemoveESPForPlayer(p)
        end
    end
end)

-- ARSENAL TAB
local ArsenalTab = Window:CreateTab("Arsenal")
local AimbotEnabled, AutoShootEnabled = false, false
local TargetPart = "Head"
ArsenalTab:CreateToggle({Name = "Aimbot", CurrentValue = false, Callback = function(v) AimbotEnabled = v end})
ArsenalTab:CreateToggle({Name = "Auto Shoot", CurrentValue = false, Callback = function(v) AutoShootEnabled = v end})
local function GetNearestTarget()
    local closest, closestDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(TargetPart) and plr.Team ~= LocalPlayer.Team then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character[TargetPart].Position)
            if onScreen and pos.Z > 0 then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < closestDist then closestDist = dist; closest = plr end
            end
        end
    end
    return closest
end
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetNearestTarget()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local pos = Camera:WorldToScreenPoint(target.Character[TargetPart].Position)
            if pos.Z > 0 then
                local dx = (pos.X - UserInputService:GetMouseLocation().X) * 0.1
                local dy = (pos.Y - UserInputService:GetMouseLocation().Y) * 0.1
                mousemoverel(dx, dy)
                if AutoShootEnabled then VirtualUser:ClickButton1(Vector2.new()) end
            end
        end
    end
end)

-- FTAP TAB
local FTAPTab = Window:CreateTab("FTAP")
local GrabStrength, MagneticGrab, LoopGrabSpam, SmartKillAllEnabled, ExplosiveGrab, BreakJointsMode = 2000, false, false, false, false, false
FTAPTab:CreateSlider({Name = "Fling Strength", Min = 100, Max = 5000, CurrentValue = GrabStrength, Callback = function(v) GrabStrength = v end})
FTAPTab:CreateToggle({Name = "Magnetic Grab Mode", CurrentValue = false, Callback = function(v) MagneticGrab = v end})
FTAPTab:CreateToggle({Name = "Loop Grab Spam", CurrentValue = false, Callback = function(v) LoopGrabSpam = v end})
FTAPTab:CreateToggle({Name = "Smart Kill All", CurrentValue = false, Callback = function(v) SmartKillAllEnabled = v end})
FTAPTab:CreateToggle({Name = "Explosive Grab", CurrentValue = false, Callback = function(v) ExplosiveGrab = v end})
FTAPTab:CreateToggle({Name = "Break All Joints Mode", CurrentValue = false, Callback = function(v) BreakJointsMode = v end})
FTAPTab:CreateButton({Name = "Grab All", Callback = function() Rayfield:Notify({Title = "FTAP", Content = "Grab All executed (placeholder)", Duration = 3}) end})
FTAPTab:CreateButton({Name = "Release All", Callback = function() Rayfield:Notify({Title = "FTAP", Content = "Release All executed (placeholder)", Duration = 3}) end})
FTAPTab:CreateButton({Name = "Kill All with Grab", Callback = function() Rayfield:Notify({Title = "FTAP", Content = "Kill All executed (placeholder)", Duration = 3}) end})

-- UTILITY TAB
local UtilityTab = Window:CreateTab("Utility")
UtilityTab:CreateButton({Name = "Enable Anti AFK", Callback = function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
    Rayfield:Notify({Title = "Utility", Content = "Anti AFK enabled", Duration = 3})
end})
UtilityTab:CreateButton({Name = "Rejoin Game", Callback = function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})

-- CORE TAB
local CoreTab = Window:CreateTab("Core")
local FlyEnabled, SpeedValue, InfiniteJumpEnabled = false, 16, false
CoreTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v)
    FlyEnabled = v
    if v then
        local vel = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        vel.MaxForce = Vector3.new(1e5,1e5,1e5)
        task.spawn(function()
            while FlyEnabled and LocalPlayer.Character do
                local move = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
                vel.Velocity = move.Unit * 50
                task.wait()
            end
            vel:Destroy()
        end)
    end
end})
CoreTab:CreateSlider({Name = "Walk Speed", Min = 16, Max = 250, CurrentValue = SpeedValue, Callback = function(v)
    SpeedValue = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end})
CoreTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJumpEnabled = v end})
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

Rayfield:Notify({Title = "Nebula Hub Universal", Content = "Loaded successfully! Enjoy your game.", Duration = 5})

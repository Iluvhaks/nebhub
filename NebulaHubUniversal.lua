-- Nebula Hub Universal v2.1 - Keyless Version
-- Made by Elden and Nate

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- No Key System here

local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal v2.1",
    LoadingTitle = "Nebula Hub",
    LoadingSubtitle = "Made by Elden and Nate",
    ConfigurationSaving = { Enabled = true, FolderName = "NebulaHub", FileName = "Config" },
    Discord = { Enabled = true, Invite = "FeAkp5e7d5", RememberJoins = true },
    KeySystem = false
})

----------------------
-- VISUAL TAB
----------------------
local VisualTab = Window:CreateTab("Visual")

local ESPSection = VisualTab:CreateSection("ESP")

local ESPEnabled = false
local LineESPEnabled = false

VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(val)
        ESPEnabled = val
    end
})

VisualTab:CreateToggle({
    Name = "Enable Line ESP",
    CurrentValue = false,
    Flag = "LineESPToggle",
    Callback = function(val)
        LineESPEnabled = val
    end
})

-- ESP and Line ESP Implementation
local Drawing = Drawing or (function()
    warn("Drawing library not supported in this executor!")
    return {}
end)()

local ESPObjects = {}

local function CreateESPForPlayer(player)
    if ESPObjects[player] then return end
    local box = Drawing.new("Square")
    box.Color = Color3.new(1,0,0)
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    
    local line = Drawing.new("Line")
    line.Color = Color3.new(1,1,1)
    line.Thickness = 1
    line.Visible = false
    
    ESPObjects[player] = {Box = box, Line = line}
end

local function RemoveESPForPlayer(player)
    if ESPObjects[player] then
        local esp = ESPObjects[player]
        esp.Box.Visible = false
        esp.Line.Visible = false
        esp.Box:Remove()
        esp.Line:Remove()
        ESPObjects[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            CreateESPForPlayer(player)
            local rootPart = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local esp = ESPObjects[player]
            if ESPEnabled and onScreen and pos.Z > 0 then
                local size = 1000 / pos.Z -- simple scale based on distance
                esp.Box.Size = Vector2.new(size / 2, size)
                esp.Box.Position = Vector2.new(pos.X - esp.Box.Size.X/2, pos.Y - esp.Box.Size.Y/2)
                esp.Box.Visible = true
            else
                esp.Box.Visible = false
            end
            
            if LineESPEnabled and onScreen and pos.Z > 0 then
                local mousePos = UserInputService:GetMouseLocation()
                esp.Line.From = Vector2.new(mousePos.X, mousePos.Y)
                esp.Line.To = Vector2.new(pos.X, pos.Y)
                esp.Line.Visible = true
            else
                esp.Line.Visible = false
            end
        else
            RemoveESPForPlayer(player)
        end
    end
end)

----------------------
-- ARSENAL TAB
----------------------
local ArsenalTab = Window:CreateTab("Arsenal")
local ArsenalSection = ArsenalTab:CreateSection("Aimbot & Auto Shoot")

local AimbotEnabled = false
local AutoShootEnabled = false
local TargetPart = "Head"

ArsenalTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val) AimbotEnabled = val end
})

ArsenalTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShootToggle",
    Callback = function(val) AutoShootEnabled = val end
})

local function GetNearestTarget()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(TargetPart) and player.Team ~= LocalPlayer.Team then
            local rootPos = player.Character[TargetPart].Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPos)
            if onScreen and screenPos.Z > 0 then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetNearestTarget()
        if target and target.Character and target.Character:FindFirstChild(TargetPart) then
            local pos = Camera:WorldToScreenPoint(target.Character[TargetPart].Position)
            if pos.Z > 0 then
                -- Move mouse gradually towards target
                local mouseDeltaX = (pos.X - UserInputService:GetMouseLocation().X) * 0.1
                local mouseDeltaY = (pos.Y - UserInputService:GetMouseLocation().Y) * 0.1
                mousemoverel(mouseDeltaX, mouseDeltaY)
                if AutoShootEnabled then
                    -- Simulate left mouse click for shooting
                    VirtualUser:ClickButton1(Vector2.new())
                end
            end
        end
    end
end)

----------------------
-- FTAP TAB (Fling Things And People)
----------------------
local FTAPTab = Window:CreateTab("FTAP")
local FTAPSection = FTAPTab:CreateSection("Fling Controls")

local GrabStrength = 2000
local MagneticGrab = false
local LoopGrabSpam = false
local SmartKillAllEnabled = false
local ExplosiveGrab = false
local BreakJointsMode = false

FTAPTab:CreateSlider({
    Name = "Fling Strength",
    Min = 100,
    Max = 5000,
    CurrentValue = GrabStrength,
    Flag = "FlingStrength",
    Callback = function(val) GrabStrength = val end
})

FTAPTab:CreateToggle({
    Name = "Magnetic Grab Mode",
    CurrentValue = false,
    Flag = "MagneticGrab",
    Callback = function(val) MagneticGrab = val end
})

FTAPTab:CreateToggle({
    Name = "Loop Grab Spam",
    CurrentValue = false,
    Flag = "LoopGrabSpam",
    Callback = function(val) LoopGrabSpam = val end
})

FTAPTab:CreateToggle({
    Name = "Smart Kill All",
    CurrentValue = false,
    Flag = "SmartKillAll",
    Callback = function(val) SmartKillAllEnabled = val end
})

FTAPTab:CreateToggle({
    Name = "Explosive Grab",
    CurrentValue = false,
    Flag = "ExplosiveGrab",
    Callback = function(val) ExplosiveGrab = val end
})

FTAPTab:CreateToggle({
    Name = "Break All Joints Mode",
    CurrentValue = false,
    Flag = "BreakJointsMode",
    Callback = function(val) BreakJointsMode = val end
})

local FTAPGrabbedObjects = {}

local function GrabAll()
    -- Implementation to grab all players/objects nearby with configured settings
    Rayfield:Notify({Title = "FTAP", Content = "Grab All executed (demo placeholder)", Duration = 3})
end

local function ReleaseAll()
    -- Release all grabs
    FTAPGrabbedObjects = {}
    Rayfield:Notify({Title = "FTAP", Content = "Released all grabs", Duration = 3})
end

FTAPTab:CreateButton({
    Name = "Grab All",
    Callback = GrabAll
})

FTAPTab:CreateButton({
    Name = "Release All",
    Callback = ReleaseAll
})

FTAPTab:CreateButton({
    Name = "Kill All with Grab",
    Callback = function()
        -- Smart Kill All implementation here (demo placeholder)
        Rayfield:Notify({Title = "FTAP", Content = "Kill All with Grab executed (demo placeholder)", Duration = 3})
    end
})

----------------------
-- UTILITY TAB
----------------------
local UtilityTab = Window:CreateTab("Utility")

UtilityTab:CreateButton({
    Name = "Enable Anti AFK",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
            wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
        end)
        Rayfield:Notify({Title = "Utility", Content = "Anti AFK enabled", Duration = 3})
    end
})

UtilityTab:CreateButton({
    Name = "Rejoin Game",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

----------------------
-- CORE FEATURES (Fly, Speed, Infinite Jump, etc.)
----------------------
local CoreTab = Window:CreateTab("Core")

local FlyEnabled = false
local SpeedValue = 16
local InfiniteJumpEnabled = false

CoreTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(val)
        FlyEnabled = val
        if FlyEnabled then
            -- Basic fly implementation
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0,0,0)
            BodyVelocity.MaxForce = Vector3.new(0,0,0)
            BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

            local FlySpeed = 50
            task.spawn(function()
                while FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                    BodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                    local moveVector = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveVector = moveVector + Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveVector = moveVector - Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveVector = moveVector - Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveVector = moveVector + Camera.CFrame.RightVector
                    end
                    BodyVelocity.Velocity = moveVector.Unit * FlySpeed
                    task.wait()
                end
                BodyVelocity:Destroy()
            end)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChildWhichIsA("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
})

CoreTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 250,
    CurrentValue = SpeedValue,
    Flag = "WalkSpeedSlider",
    Callback = function(val)
        SpeedValue = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
    end
})

CoreTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(val)
        InfiniteJumpEnabled = val
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

----------------------
-- FINAL NOTIFY
----------------------
Rayfield:Notify({Title = "Nebula Hub Universal", Content = "Loaded successfully! Enjoy your game.", Duration = 5})

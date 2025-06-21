--[[
Nebula Hub Universal - Roblox Exploit GUI
Author: YourNameHere
Dependencies: Rayfield UI Library (https://sirius.menu/rayfield)
No key system. All features in one script.
--]]

--// Rayfield Loader
if not game:IsLoaded() then game.Loaded:Wait() end
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// Connection management
local Connections = {}

local function DisconnectAll()
    for _, conn in ipairs(Connections) do
        if typeof(conn) == "RBXScriptConnection" and conn.Connected then
            conn:Disconnect()
        end
    end
    Connections = {}
end

local function AddConn(conn)
    table.insert(Connections, conn)
end

--// Utility Functions
local function Notify(title, content, duration)
    Rayfield:Notify({Title = title, Content = content, Duration = duration or 5})
end

local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    return getChar():FindFirstChild("HumanoidRootPart")
end

local function getHum()
    return getChar():FindFirstChildWhichIsA("Humanoid")
end

--// Main Window
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    LoadingSubtitle = "by YourNameHere",
    ConfigurationSaving = {Enabled = false},
})

--------------------------[ Utility Tab ]--------------------------
local UtilityTab = Window:CreateTab("Utility", 4483362458)
-- Click Teleport
UtilityTab:CreateButton({
    Name = "Click Teleport (Press T)",
    Callback = function()
        Notify("Click Teleport", "Press T and click to teleport!", 3)
        DisconnectAll()
        AddConn(UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe or input.KeyCode ~= Enum.KeyCode.T then return end
            Notify("Click Teleport", "Click somewhere to teleport...", 2)
            local mouseConn
            mouseConn = UserInputService.InputBegan:Connect(function(i, g)
                if g or i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                local mouse = LocalPlayer:GetMouse()
                local pos = mouse.Hit and mouse.Hit.p
                if pos then
                    local hrp = getHRP()
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                    Notify("Teleported!", "You have been teleported.", 2)
                end
                mouseConn:Disconnect()
            end)
        end))
    end
})

-- Fly Toggle
local FlyEnabled = false
local FlyConn = nil
local FlySpeed = 50
UtilityTab:CreateToggle({
    Name = "Fly Toggle (F)",
    CurrentValue = false,
    Callback = function(state)
        FlyEnabled = state
        if FlyEnabled then
            local Humanoid = getHum()
            Notify("Fly Enabled", "Press F to toggle fly.", 3)
            local bp = Instance.new("BodyPosition")
            local bg = Instance.new("BodyGyro")
            bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bp.P = 1e4
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bp.Parent = getHRP()
            bg.Parent = getHRP()
            FlyConn = RunService.RenderStepped:Connect(function()
                local cam = Camera.CFrame
                local move = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + cam.UpVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - cam.UpVector end
                bp.Position = getHRP().Position + (move.Unit * FlySpeed if move.Magnitude > 0 else Vector3.zero)
                bg.CFrame = cam
                getHum().PlatformStand = true
            end)
            AddConn(UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe or input.KeyCode ~= Enum.KeyCode.F then return end
                UtilityTab.Flags["Fly Toggle (F)"]:Set(false)
            end))
        else
            if FlyConn then FlyConn:Disconnect() FlyConn = nil end
            local hrp = getHRP()
            if hrp:FindFirstChild("BodyPosition") then hrp.BodyPosition:Destroy() end
            if hrp:FindFirstChild("BodyGyro") then hrp.BodyGyro:Destroy() end
            getHum().PlatformStand = false
        end
    end
})

-- Infinite Jump
local InfJump = false
UtilityTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        InfJump = state
        if state then
            AddConn(UserInputService.JumpRequest:Connect(function()
                if InfJump then getHum():ChangeState(Enum.HumanoidStateType.Jumping) end
            end))
        else
            DisconnectAll()
        end
    end
})

-- Walk Speed & Jump Power
UtilityTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        getHum().WalkSpeed = val
    end
})

UtilityTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(val)
        getHum().JumpPower = val
    end
})

-- Anti-AFK
UtilityTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        for _, v in ipairs(getconnections(LocalPlayer.Idled)) do
            v:Disable()
        end
        Notify("Anti-AFK", "You will not be kicked for idling.", 3)
    end
})

--------------------------[ Troll Tab ]--------------------------
local TrollTab = Window:CreateTab("Troll", 4483362460)
-- Fake Kick
TrollTab:CreateButton({
    Name = "Fake Kick (Shows kick GUI)",
    Callback = function()
        LocalPlayer:Kick("You have been kicked from Nebula Hub Universal (Fake!)")
    end
})

-- Chat Spam
local Spamming = false
TrollTab:CreateToggle({
    Name = "Chat Spam",
    CurrentValue = false,
    Callback = function(val)
        Spamming = val
        if val then
            AddConn(RunService.Heartbeat:Connect(function()
                if Spamming then
                    local msg = "Nebula Hub Universal 😈"
                    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                    wait(0.3)
                end
            end))
        else
            DisconnectAll()
        end
    end
})

-- Fling Self
TrollTab:CreateButton({
    Name = "Fling Self",
    Callback = function()
        local hrp = getHRP()
        local BV = Instance.new("BodyVelocity")
        BV.Velocity = Vector3.new(0, 9999, 0)
        BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BV.Parent = hrp
        game.Debris:AddItem(BV, 0.5)
        Notify("Fling", "You flung yourself!", 2)
    end
})

--------------------------[ Auto Tab ]--------------------------
local AutoTab = Window:CreateTab("Auto", 4483362454)
-- Auto Move
local AutoMove = false
AutoTab:CreateToggle({
    Name = "Auto Move Forward",
    CurrentValue = false,
    Callback = function(state)
        AutoMove = state
        if state then
            AddConn(RunService.Heartbeat:Connect(function()
                if AutoMove then
                    getChar():TranslateBy(getChar().HumanoidRootPart.CFrame.LookVector * 0.5)
                end
            end))
        else
            DisconnectAll()
        end
    end
})

-- Touch Everything
AutoTab:CreateButton({
    Name = "Touch Everything",
    Callback = function()
        local hrp = getHRP()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") and obj.Parent then
                firetouchinterest(hrp, obj.Parent, 0)
                wait(0.01)
                firetouchinterest(hrp, obj.Parent, 1)
            end
        end
        Notify("Touch Everything", "Attempted to touch all objects.", 2)
    end
})

--------------------------[ Remotes Tab ]--------------------------
local RemotesTab = Window:CreateTab("Remotes", 4483362461)
-- Remote Lagging Toggle
local RemoteLag = false
RemotesTab:CreateToggle({
    Name = "Remote Lag (Spam all remote events)",
    CurrentValue = false,
    Callback = function(state)
        RemoteLag = state
        if state then
            Notify("Remote Lag", "Started lagging via remotes.", 2)
            AddConn(RunService.RenderStepped:Connect(function()
                for _, v in ipairs(getgc(true)) do
                    if typeof(v) == "Instance" and v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(math.random(), math.random()) end)
                    end
                end
            end))
        else
            DisconnectAll()
        end
    end
})

-- Remote Scanner
RemotesTab:CreateButton({
    Name = "Remote Scanner (Prints to dev console)",
    Callback = function()
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "Instance" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
                print("Remote:", v:GetFullName())
            end
        end
        Notify("Remote Scanner", "Remotes printed to console (F9).", 2)
    end
})

--------------------------[ Visual Tab ]--------------------------
local VisualTab = Window:CreateTab("Visual", 4483362462)
-- ESP with Lines
local ESPEnabled = false
local LineESP = false
local ESPConns = {}
local function ClearESP()
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:FindFirstChild("NebulaESP") then v.NebulaESP:Destroy() end
    end
    for _, c in ipairs(ESPConns) do if typeof(c) == "RBXScriptConnection" and c.Connected then c:Disconnect() end end
    ESPConns = {}
end

VisualTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(state)
        ESPEnabled = state
        if not state then ClearESP() return end
        Notify("ESP", "ESP Enabled.", 2)
        AddConn(RunService.RenderStepped:Connect(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("NebulaESP") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "NebulaESP"
                        box.Adornee = plr.Character.HumanoidRootPart
                        box.Size = Vector3.new(3,6,2)
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Color3 = Color3.new(1,0,0)
                        box.Transparency = 0.5
                        box.Parent = plr.Character
                        -- Line ESP
                        if LineESP then
                            local beam = Instance.new("Beam")
                            beam.Name = "NebulaESPLine"
                            local a = Instance.new("Attachment", Camera)
                            local b = Instance.new("Attachment", plr.Character.HumanoidRootPart)
                            beam.Attachment0 = a
                            beam.Attachment1 = b
                            beam.FaceCamera = true
                            beam.Width0 = 0.1
                            beam.Width1 = 0.1
                            beam.Color = ColorSequence.new(Color3.new(1, 1, 0))
                            beam.Parent = plr.Character
                        end
                    end
                end
            end
        end))
    end
})

VisualTab:CreateToggle({
    Name = "Line ESP",
    CurrentValue = false,
    Callback = function(state)
        LineESP = state
        if ESPEnabled then
            ClearESP()
            ESPEnabled = false
            wait(0.2)
            ESPEnabled = true
            VisualTab.Flags["ESP"]:Set(true)
        end
    end
})

--------------------------[ Exploits Tab ]--------------------------
local ExploitsTab = Window:CreateTab("Exploits", 4483362463)
-- Aimbot
local AimbotEnabled = false
local TeamCheck = true
local AutoShoot = false
local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then
                    dist = mag
                    closest = plr
                end
            end
        end
    end
    return closest
end

ExploitsTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(state)
        AimbotEnabled = state
        if state then
            Notify("Aimbot", "Aimbot enabled.", 2)
            AddConn(RunService.RenderStepped:Connect(function()
                if not AimbotEnabled then return end
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                    if AutoShoot then
                        mouse1press()
                        wait(0.1)
                        mouse1release()
                    end
                end
            end))
        else
            DisconnectAll()
        end
    end
})

ExploitsTab:CreateToggle({
    Name = "Aimbot Team Check",
    CurrentValue = true,
    Callback = function(state)
        TeamCheck = state
    end
})

ExploitsTab:CreateToggle({
    Name = "Aimbot Auto Shoot",
    CurrentValue = false,
    Callback = function(state)
        AutoShoot = state
    end
})

-- Click Delete
ExploitsTab:CreateButton({
    Name = "Click Delete Tool",
    Callback = function()
        Notify("Click Delete", "Click on an object to delete it.", 3)
        AddConn(UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target then
                target:Destroy()
                Notify("Deleted", "Object deleted.", 1)
            end
        end))
    end
})

-- Noclip
local Noclip = false
ExploitsTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        Noclip = state
        if state then
            AddConn(RunService.Stepped:Connect(function()
                if Noclip then
                    for _, v in ipairs(getChar():GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end))
        else
            DisconnectAll()
        end
    end
})

-- Teleport Tool
ExploitsTab:CreateButton({
    Name = "Teleport Tool (Click to TP)",
    Callback = function()
        local tool = Instance.new("Tool", LocalPlayer.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Nebula TP Tool"
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local pos = mouse.Hit and mouse.Hit.p
            if pos then
                getHRP().CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            end
        end)
        Notify("Teleport Tool", "Tool added to backpack.", 2)
    end
})

--------------------------[ FTAP Tab ]--------------------------
local FTAPTab = Window:CreateTab("FTAP", 4483362464)
local FTAPStrength = 2000
local FTAPEnabled = false

-- FTAP Strength Slider
FTAPTab:CreateSlider({
    Name = "Fling Strength",
    Range = {100, 10000},
    Increment = 100,
    CurrentValue = 2000,
    Callback = function(val)
        FTAPStrength = val
    end
})

-- FTAP System: Detect GrabParts with WeldConstraint, fling on release
FTAPTab:CreateToggle({
    Name = "FTAP Fling System",
    CurrentValue = false,
    Callback = function(state)
        FTAPEnabled = state
        if not state then return end
        Notify("FTAP", "FTAP fling system enabled.", 2)
        AddConn(RunService.Stepped:Connect(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("grab") and obj:FindFirstChildWhichIsA("WeldConstraint") then
                    local weld = obj:FindFirstChildWhichIsA("WeldConstraint")
                    if not weld.Parent or not weld.Part1 then
                        -- Released, apply fling
                        obj.Velocity = Vector3.new(0, FTAPStrength, 0)
                        wait(0.1)
                        obj.Velocity = Vector3.zero
                    end
                end
            end
        end))
    end
})

--------------------------[ End ]--------------------------
Notify("Nebula Hub Universal", "Loaded successfully!", 4)

--// Clean up on window close
Window:OnClose(function()
    DisconnectAll()
    ClearESP()
end)

--// End of script
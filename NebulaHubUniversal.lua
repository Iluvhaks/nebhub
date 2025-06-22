-- Nebula Hub Universal with Mobile TSB Autofarm
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then return end

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local VirtualInput = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- STATE
local clickTPOn, clickConn = false, nil
local ESPOn, LineESP, AimbotOn, TeamCheck, AutoShoot = false, false, false, true, false
local AimFOV, TargetPart = 100, "Head"
local InfJump, remLag = false, false
local espObjects = {}
local flingEnabled, flingStrength = false, 350
local antiGrabEnabled, spawnKillAll, flingAll = false, false, false

-- TSB Autofarm state
local farming, attacking, tsbTarget = false, false, nil
local healSpot = Vector3.new(0, 1000, 0)

-- UTILITY FUNCTIONS
local function updateChar()
    local c = LocalPlayer.Character
    if not c then return end
    char = c
    humanoid = c:FindFirstChildOfClass("Humanoid")
    root = c:FindFirstChild("HumanoidRootPart")
end
Players.LocalPlayer.CharacterAdded:Connect(function() wait(1); updateChar() end)
updateChar()

local function pressVirt(key)
    VirtualInput:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInput:SendKeyEvent(false, key, false, game)
end
local function pressTap()
    VirtualInput:SendMouseButtonEvent(0,0,true,game)
    task.wait(0.1)
    VirtualInput:SendMouseButtonEvent(0,0,false,game)
end

local function aimAt(t)
    if not (t and t.Character and root) then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.HumanoidRootPart.Position)
end

local function tweenTo(pos)
    if not root then return end
    local ti = TweenInfo.new((root.Position - pos).Magnitude/100, Enum.EasingStyle.Linear)
    local tw = TweenService:Create(root, ti, {CFrame=CFrame.new(pos+Vector3.new(0,3,0))})
    tw:Play()
end

local function getTargets()
    local arr = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
            local h = p.Character.Humanoid
            if h.Health>0 then table.insert(arr, {p,h.Health}) end
        end
    end
    table.sort(arr, function(a,b) return a[2]<b[2] end)
    return arr
end

-- TSB AUTOFARM
local function attackLoop(target)
    attacking = true; tsbTarget = target
    while attacking and farming and target and target.Character and target.Character:FindFirstChild("Humanoid") do
        if humanoid.Health < (humanoid.MaxHealth*0.35) then
            root.CFrame = CFrame.new(healSpot)
            repeat task.wait(0.5) until humanoid.Health >= humanoid.MaxHealth*0.5 or not farming
        end
        local tgtHRP = target.Character.HumanoidRootPart
        tweenTo(tgtHRP.Position)
        aimAt(target)
        pressTap()
        for _,k in ipairs({"1","2","3","4"}) do pressVirt(k); task.wait(0.1) end
        task.wait(0.2)
        if target.Character.Humanoid.Health<=0 then break end
    end
    attacking = false
end

local function farmLoop()
    farming = true
    while farming do
        for _, data in ipairs(getTargets()) do
            if not farming then break end
            attackLoop(data[1])
            task.wait(0.5)
        end
        task.wait(1)
    end
end

-- GUI SETUP
local Window = Rayfield:CreateWindow({Name="Nebula Hub Universal", LoadingTitle="Nebula Hub", SubText="by Elden & Nate", Theme="Default", ToggleUIKeybind=Enum.KeyCode.K})
local Utility, Troll, AutoTab, RemoteTab, VisualTab, Exploits, FTAPTab, TSBTab =
      Window:CreateTab("🧠 Utility"), Window:CreateTab("💣 Troll"),
      Window:CreateTab("🤖 Auto"), Window:CreateTab("📡 Remotes"),
      Window:CreateTab("🎯 Visual"), Window:CreateTab("⚠️ Exploits"),
      Window:CreateTab("👐 FTAP"), Window:CreateTab("⚔️ TSB")

-- [Utility, Troll, AutoTab, RemoteTab, VisualTab, Exploits, FTAPTab setup...]
-- (Keep all your existing UI buttons/toggles for clickTP, Fly, ESP, Aimbot, fling, antiGrab, spawnKill etc.)

-- TSB TAB
TSBTab:CreateToggle({
    Name="AutoFarm (Mobile TSB)",
    CurrentValue=false,
    Callback=function(v)
        farming = v
        if v then spawn(farmLoop) else attacking=false; tsbTarget=nil end
    end
})

return Rayfield

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local RS = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local autoSpawnBlobman = true
local newBlobman = workspace:FindFirstChild(plr.Name.."SpawnedInToys") and workspace[plr.Name.."SpawnedInToys"]:FindFirstChild("CreatureBlobman")
local spawnFunction = RS.MenuToys:FindFirstChild("SpawnToyRemoteFunction")

-- Update character and HRP on respawn
plr.CharacterAdded:Connect(function(char)
    character = char
    HRP = character:WaitForChild("HumanoidRootPart")
end)

workspace:WaitForChild(plr.Name.."SpawnedInToys").ChildAdded:Connect(function(toy)
    if toy.Name == "CreatureBlobman" then
        newBlobman = toy
    end
end)

-- Blobman functions --
local function RemoveOcean(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.FollowThisPart.AlignOrientation, HRP)
end

local function BreakUFOs(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.OuterUFO.Object.FollowThisPart.AlignOrientation, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignOrientation, HRP)
end

local function BreakTrain(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignOrientation, HRP)
end

local function BreakIslandRocks(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignOrientation, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.LrgDebris2.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.LrgDebris2.Object.FollowThisPart.AlignOrientation, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.SmlDebris.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.SmlDebris.Object.FollowThisPart.AlignOrientation, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.SmlDebris2.Object.FollowThisPart.AlignPosition, HRP)
    CD:FireServer(workspace.Map.AlwaysHereTweenedObjects.SmlDebris2.Object.FollowThisPart.AlignOrientation, HRP)
end

local function RagdollKill(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(RF.ThrowPlayers.RagdollTemplate.Head.BallSocketConstraint, HRP)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("BallSocketConstraint") then
            CD:FireServer(v.Character.Head.BallSocketConstraint, HRP)
        end
    end
end

local function BreakGrabber(Blobman)
    local CD = Blobman:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop")
    CD:FireServer(RF.GrabParts.DragPart.AlignOrientation, HRP)
    CD:FireServer(RF.GrabParts.DragPart.AlignPosition, HRP)
end

-- Blobman helper functions --
local function EnsureBlobman()
    if autoSpawnBlobman then
        if not newBlobman or not newBlobman.Parent then
            spawnFunction:InvokeServer("CreatureBlobman", HRP.CFrame * CFrame.new(0, 10000, 0), Vector3.new(0, 0, 0))
            task.wait(0.5)
            newBlobman = workspace:FindFirstChild(plr.Name .. "SpawnedInToys") and workspace[plr.Name .. "SpawnedInToys"]:FindFirstChild("CreatureBlobman")
        end
    end
    if not newBlobman or not newBlobman.Parent then
        warn("No Blobman spawned.")
        return false
    end
    return true
end

local function UseBlobmanAndExecute(actionFunc)
    if not EnsureBlobman() then return end

    local Hum = character:WaitForChild("Humanoid")
    local seat = newBlobman:WaitForChild("VehicleSeat")
    local oldPosition = HRP.CFrame

    seat:Sit(Hum)
    task.wait(0.5)

    actionFunc(newBlobman)

    task.wait(0.2)
    Hum.Sit = false
    HRP.CFrame = oldPosition
end

-- Fling Strength Variables --
local flingStrengthEnabled = false
local flingStrengthValue = 1000

-- Grab/Release events for fling logic (Example placeholders)
local grabEvent = RS:FindFirstChild("GrabEvent") or RS:FindFirstChild("GrabRemote") or nil
local releaseEvent = RS:FindFirstChild("ReleaseEvent") or RS:FindFirstChild("ReleaseRemote") or nil

-- We'll listen to grab/release events to trigger fling on release
-- For demonstration, we'll fake these if not found (you'll need to adjust for your actual game remotes)

local grabbedObject = nil

if grabEvent and releaseEvent then
    grabEvent.OnClientEvent:Connect(function(target)
        grabbedObject = target
    end)

    releaseEvent.OnClientEvent:Connect(function()
        if flingStrengthEnabled and grabbedObject then
            -- Apply fling force logic here, example using BodyVelocity:
            if grabbedObject:IsA("BasePart") then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * flingStrengthValue) + Vector3.new(0, flingStrengthValue/2, 0)
                bv.Parent = grabbedObject
                task.delay(0.2, function()
                    bv:Destroy()
                end)
            elseif grabbedObject:IsA("Model") and grabbedObject.PrimaryPart then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * flingStrengthValue) + Vector3.new(0, flingStrengthValue/2, 0)
                bv.Parent = grabbedObject.PrimaryPart
                task.delay(0.2, function()
                    bv:Destroy()
                end)
            end
            grabbedObject = nil
        end
    end)
else
    -- Fallback: No events found, create dummy to avoid errors
    print("Warning: Grab/Release events not found! Fling strength may not work.")
end

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Nebula Hub Universal",
    LoadingTitle = "Nebula Hub Universal",
    LoadingSubtitle = "Made by Elden and Nate",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = false,
    },
})

-- ========== Utility Tab ==========
local UtilityTab = Window:CreateTab("Utility")
UtilityTab:CreateButton({
    Name = "Example Utility Button",
    Callback = function()
        print("Utility Button Pressed")
    end,
})

-- ========== Troll Tab ==========
local TrollTab = Window:CreateTab("Troll")
TrollTab:CreateButton({
    Name = "Example Troll Button",
    Callback = function()
        print("Troll Button Pressed")
    end,
})

-- ========== Auto Tab ==========
local AutoTab = Window:CreateTab("Auto")
AutoTab:CreateButton({
    Name = "Example Auto Button",
    Callback = function()
        print("Auto Button Pressed")
    end,
})

-- ========== Remotes Tab ==========
local RemotesTab = Window:CreateTab("Remotes")
RemotesTab:CreateButton({
    Name = "Example Remote Button",
    Callback = function()
        print("Remotes Button Pressed")
    end,
})

-- ========== Visual Tab ==========
local VisualTab = Window:CreateTab("Visual")
VisualTab:CreateButton({
    Name = "Example Visual Button",
    Callback = function()
        print("Visual Button Pressed")
    end,
})

-- ========== Fling Things & People Tab ==========
local FTAPTab = Window:CreateTab("Fling Things & People")

-- Blobman spawn toggle
local SectionBlobman = FTAPTab:CreateSection("Blobman Control")

local AutoSpawnToggle = FTAPTab:CreateToggle({
    Name = "Auto Spawn Blobman on Execute",
    CurrentValue = true,
    Flag = "AutoSpawnBlobman",
    Callback = function(value)
        autoSpawnBlobman = value
    end,
})

-- Map & player breakers section
local SectionBreakers = FTAPTab:CreateSection("Map & Player Breakers")

FTAPTab:CreateButton({
    Name = "Break UFOs",
    Callback = function()
        UseBlobmanAndExecute(BreakUFOs)
    end,
})

FTAPTab:CreateButton({
    Name = "Remove Ocean",
    Callback = function()
        UseBlobmanAndExecute(RemoveOcean)
    end,
})

FTAPTab:CreateButton({
    Name = "Break Train",
    Callback = function()
        UseBlobmanAndExecute(BreakTrain)
    end,
})

FTAPTab:CreateButton({
    Name = "Break Island Rocks",
    Callback = function()
        UseBlobmanAndExecute(BreakIslandRocks)
    end,
})

FTAPTab:CreateButton({
    Name = "Execute Ragdoll Kill",
    Callback = function()
        UseBlobmanAndExecute(RagdollKill)
    end,
})

FTAPTab:CreateButton({
    Name = "Execute Grabber Breaker",
    Callback = function()
        UseBlobmanAndExecute(BreakGrabber)
    end,
})

-- Strength fling section
local SectionStrength = FTAPTab:CreateSection("Fling Strength")

local StrengthToggle = FTAPTab:CreateToggle({
    Name = "Enable Strength Fling",
    CurrentValue = false,
    Flag = "StrengthToggle",
    Callback = function(value)
        flingStrengthEnabled = value
        print("Fling Strength Enabled:", flingStrengthEnabled)
    end,
})

local StrengthSlider = FTAPTab:CreateSlider({
    Name = "Fling Strength",
    Min = 100,
    Max = 5000,
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 1000,
    Flag = "StrengthSlider",
    Callback = function(value)
        flingStrengthValue = value
        print("Fling Strength set to:", flingStrengthValue)
    end,
})

return Window

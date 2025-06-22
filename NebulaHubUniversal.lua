local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local autofarmEnabled = false
local tsbTarget = nil
local healSpot = Vector3.new(0, 1000, 0) -- Safe spot for healing

-- Helper: Press virtual key (mobile)
local function pressVirtualKey(key)
    -- true = key down, false = key up
    VirtualInput:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInput:SendKeyEvent(false, key, false, game)
end

-- Helper: Press virtual mouse1 (tap screen)
local function pressVirtualMouse1()
    -- Coordinates 0,0 should work for general tap but you can adjust if needed
    VirtualInput:SendMouseButtonEvent(0, 0, true, game)
    task.wait(0.1)
    VirtualInput:SendMouseButtonEvent(0, 0, false, game)
end

-- Helper: Aim camera at target player's HumanoidRootPart
local function aimAtTarget(target)
    if not (target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then return end
    local targetPos = target.Character.HumanoidRootPart.Position
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
end

-- Helper: Teleport to a position safely
local function teleportTo(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
    end
end

-- Get next valid target with health > 0
local function getNextTarget()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                return p
            end
        end
    end
    return nil
end

-- Autofarm loop for mobile
spawn(function()
    while true do
        if autofarmEnabled then
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("Humanoid") or not myChar:FindFirstChild("HumanoidRootPart") then
                task.wait(1)
                continue
            end

            local myHum = myChar.Humanoid

            -- Heal if health too low
            if myHum.Health <= myHum.MaxHealth * 0.35 then
                teleportTo(healSpot)
                repeat task.wait(1) until myHum.Health >= myHum.MaxHealth * 0.5 or not autofarmEnabled
                if not autofarmEnabled then break end
            end

            -- Pick or keep target
            if not tsbTarget or not tsbTarget.Character or not tsbTarget.Character:FindFirstChild("Humanoid") or tsbTarget.Character.Humanoid.Health <= 0 then
                tsbTarget = getNextTarget()
                if not tsbTarget then task.wait(1) end
            end

            if tsbTarget and tsbTarget.Character and tsbTarget.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = tsbTarget.Character.HumanoidRootPart
                -- Teleport close to target with slight offset so attacks register
                local attackPos = targetHRP.Position - targetHRP.CFrame.LookVector * 3 + Vector3.new(0, 2, 0)
                teleportTo(attackPos)

                -- Aim at target
                aimAtTarget(tsbTarget)

                -- Use abilities 1 to 4 (virtual keys)
                for _, key in ipairs({"1", "2", "3", "4"}) do
                    pressVirtualKey(key)
                    task.wait(0.1)
                end

                -- Press M1 (tap screen)
                pressVirtualMouse1()

                -- Wait a bit before next loop to not overload
                task.wait(0.2)
            else
                tsbTarget = nil
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end)

-- Rayfield UI integration
TSBTab:CreateToggle({
    Name = "Autofarm (Mobile Compatible)",
    CurrentValue = false,
    Callback = function(value)
        autofarmEnabled = value
        if not autofarmEnabled then
            tsbTarget = nil
        end
    end
})

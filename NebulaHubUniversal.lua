-- Nebula Hub Universal - Full Organized Script
-- Made by Elden and Nate
-- Works with KRNL or supported executor

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

-- UI Creation Helpers (simplified)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "NebulaHubGUI"

local function CreateToggle(parent, text, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 200, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleButton = Instance.new("TextButton", frame)
    toggleButton.Size = UDim2.new(0.3, -5, 1, -6)
    toggleButton.Position = UDim2.new(0.7, 0, 0, 3)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)

    local state = default
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = state and "ON" or "OFF"
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    end)

    local function getter() return state end
    local function setter(val)
        state = val
        toggleButton.Text = state and "ON" or "OFF"
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    end

    return frame, getter, setter
end

local function CreateSlider(parent, text, min, max, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("TextBox", frame)
    slider.Text = tostring(default)
    slider.Size = UDim2.new(1, -10, 0.5, 0)
    slider.Position = UDim2.new(0, 5, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    slider.TextColor3 = Color3.new(1, 1, 1)
    slider.ClearTextOnFocus = false

    local value = default

    slider.FocusLost:Connect(function(enterPressed)
        local num = tonumber(slider.Text)
        if num and num >= min and num <= max then
            value = num
        else
            slider.Text = tostring(value)
        end
    end)

    local function getter() return value end
    local function setter(val)
        value = math.clamp(val, min, max)
        slider.Text = tostring(value)
    end

    return frame, getter, setter
end

-- Main GUI setup (tabs container)
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 70)
mainFrame.BorderSizePixel = 0

local tabButtonsFrame = Instance.new("Frame", mainFrame)
tabButtonsFrame.Size = UDim2.new(0, 100, 1, 0)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(70, 10, 100)
tabButtonsFrame.BorderSizePixel = 0

local tabContentFrame = Instance.new("Frame", mainFrame)
tabContentFrame.Size = UDim2.new(1, -100, 1, 0)
tabContentFrame.Position = UDim2.new(0, 100, 0, 0)
tabContentFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
tabContentFrame.BorderSizePixel = 0

local tabs = {"Utility", "TSB", "FTAP", "BloxFruits", "StealABrainrot", "AstraCloud"}
local tabFrames = {}

local function switchTab(name)
    for tabName, frame in pairs(tabFrames) do
        frame.Visible = tabName == name
    end
end

-- Create tab buttons and tab content frames
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabButtonsFrame)
    btn.Text = tabName
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*50)
    btn.BackgroundColor3 = Color3.fromRGB(100, 40, 150)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0

    local frame = Instance.new("Frame", tabContentFrame)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)

    tabFrames[tabName] = frame
end

switchTab("Utility") -- default

-- ====== UTILITY TAB ======
do
    local tab = tabFrames["Utility"]
    local y = 10

    local walkSpeedSliderFrame, walkSpeedGet, walkSpeedSet = CreateSlider(tab, "WalkSpeed", 16, 500, 16)
    walkSpeedSliderFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 50

    local jumpPowerSliderFrame, jumpPowerGet, jumpPowerSet = CreateSlider(tab, "JumpPower", 50, 500, 50)
    jumpPowerSliderFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 50

    local speedToggleFrame, speedGet, speedSet = CreateToggle(tab, "Set WalkSpeed", false)
    speedToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local jumpToggleFrame, jumpGet, jumpSet = CreateToggle(tab, "Set JumpPower", false)
    jumpToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    -- Speed & Jump Logic
    RunService.Heartbeat:Connect(function()
        if speedGet() and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = walkSpeedGet()
            end
        end
        if jumpGet() and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpPowerGet()
            end
        end
    end)

    -- Noclip Toggle
    local noclipToggleFrame, noclipGet, noclipSet = CreateToggle(tab, "Noclip", false)
    noclipToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    RunService.Stepped:Connect(function()
        if noclipGet() and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)

    -- Infinite Zoom Toggle
    local infZoomToggleFrame, infZoomGet, infZoomSet = CreateToggle(tab, "Infinite Zoom", false)
    infZoomToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    infZoomToggleFrame:GetChildren()[2].MouseButton1Click:Connect(function()
        if infZoomGet() then
            Camera.MaxZoomDistance = math.huge
        else
            Camera.MaxZoomDistance = 400
        end
    end)
end

-- ====== TSB TAB (The Strongest Battlegrounds) ======
do
    local tab = tabFrames["TSB"]
    local y = 10

    local autofarmToggleFrame, autofarmGet, autofarmSet = CreateToggle(tab, "Enable Autofarm", false)
    autofarmToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local safeflyToggleFrame, safeflyGet, safeflySet = CreateToggle(tab, "Enable SafeFly", false)
    safeflyToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local attackRemote = nil
    local getEnemiesRemote = nil

    -- Find remotes heuristically
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == "AttackEnemy" and obj:IsA("RemoteEvent") then
            attackRemote = obj
        elseif obj.Name == "GetEnemies" and obj:IsA("RemoteFunction") then
            getEnemiesRemote = obj
        end
    end

    spawn(function()
        while true do
            if autofarmGet() then
                local enemies = {}
                if getEnemiesRemote then
                    local success, result = pcall(function()
                        return getEnemiesRemote:InvokeServer()
                    end)
                    if success and typeof(result) == "table" then
                        enemies = result
                    end
                else
                    for _, model in pairs(Workspace:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
                            table.insert(enemies, model)
                        end
                    end
                end

                local closestDist = math.huge
                local closestEnemy = nil
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, enemy in pairs(enemies) do
                        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHrp then
                            local dist = (hrp.Position - enemyHrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestEnemy = enemy
                            end
                        end
                    end
                end

                if closestEnemy then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                    end)
                    if attackRemote then
                        pcall(function()
                            attackRemote:FireServer(closestEnemy)
                        end)
                    end
                end

                if safeflyGet() then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ====== FTAP TAB (Grab + Fling) ======
do
    local tab = tabFrames["FTAP"]
    local y = 10

    local grabToggleFrame, grabGet, grabSet = CreateToggle(tab, "Enable Grab", false)
    grabToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local flingToggleFrame, flingGet, flingSet = CreateToggle(tab, "Enable Fling", false)
    flingToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local deleteReleaseToggleFrame, deleteReleaseGet, deleteReleaseSet = CreateToggle(tab, "Delete Player On Grab Release", false)
    deleteReleaseToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local grabRemote = nil
    local releaseRemote = nil
    -- Find remotes heuristically
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == "Grab" and obj:IsA("RemoteEvent") then
            grabRemote = obj
        elseif obj.Name == "Release" and obj:IsA("RemoteEvent") then
            releaseRemote = obj
        end
    end

    local grabbedPlayer = nil

    RunService.Heartbeat:Connect(function()
        if grabGet() then
            local closestDist = math.huge
            local closestPlayer = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist and dist < 15 then
                        closestDist = dist
                        closestPlayer = plr
                    end
                end
            end
            if closestPlayer and grabbedPlayer ~= closestPlayer then
                grabbedPlayer = closestPlayer
                if grabRemote then
                    pcall(function()
                        grabRemote:FireServer(grabbedPlayer)
                    end)
                end
            end
        else
            if grabbedPlayer then
                if releaseRemote then
                    pcall(function()
                        releaseRemote:FireServer(grabbedPlayer)
                    end)
                end
                if deleteReleaseGet() then
                    if grabbedPlayer.Character and grabbedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        grabbedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(25000, 25000, 25000)
                    end
                end
                grabbedPlayer = nil
            end
        end
    end)

    -- Fling logic not implemented fully (placeholder)
end

-- ====== BloxFruits TAB ======
do
    local tab = tabFrames["BloxFruits"]
    local y = 10

    local autoFarmToggleFrame, autoFarmGet, autoFarmSet = CreateToggle(tab, "Enable Autofarm", false)
    autoFarmToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local attackRemote = nil
    local getEnemiesRemote = nil

    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == "Attack" and obj:IsA("RemoteEvent") then
            attackRemote = obj
        elseif obj.Name == "GetEnemies" and obj:IsA("RemoteFunction") then
            getEnemiesRemote = obj
        end
    end

    spawn(function()
        while true do
            if autoFarmGet() then
                local enemies = {}
                if getEnemiesRemote then
                    local success, result = pcall(function()
                        return getEnemiesRemote:InvokeServer()
                    end)
                    if success and typeof(result) == "table" then
                        enemies = result
                    end
                else
                    for _, model in pairs(Workspace:GetChildren()) do
                        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model ~= LocalPlayer.Character then
                            table.insert(enemies, model)
                        end
                    end
                end

                local closestDist = math.huge
                local closestEnemy = nil
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, enemy in pairs(enemies) do
                        local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHrp then
                            local dist = (hrp.Position - enemyHrp.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestEnemy = enemy
                            end
                        end
                    end
                end

                if closestEnemy then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
                    end)
                    if attackRemote then
                        pcall(function()
                            attackRemote:FireServer(closestEnemy)
                        end)
                    end
                end
            end
            task.wait(0.7)
        end
    end)
end

-- ====== Steal A Brainrot TAB ======
do
    local tab = tabFrames["StealABrainrot"]
    local y = 10

    local anticheatToggleFrame, anticheatGet, anticheatSet = CreateToggle(tab, "Enable Anticheat Bypass", false)
    anticheatToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local autoStealToggleFrame, autoStealGet, autoStealSet = CreateToggle(tab, "Enable Auto Steal", false)
    autoStealToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    -- Placeholder for StealABrainrot logic and anticheat bypass
    -- You can insert actual logic and remote calls here based on the game's specifics
end

-- ====== AstraCloud TAB ======
do
    local tab = tabFrames["AstraCloud"]
    local y = 10

    local adminDetectToggleFrame, adminDetectGet, adminDetectSet = CreateToggle(tab, "Admin/Exploiter Detection", false)
    adminDetectToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local anticheatBypassToggleFrame, anticheatBypassGet, anticheatBypassSet = CreateToggle(tab, "Anticheat Bypasser", false)
    anticheatBypassToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local godmodeToggleFrame, godmodeGet, godmodeSet = CreateToggle(tab, "Godmode", false)
    godmodeToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local instantKillToggleFrame, instantKillGet, instantKillSet = CreateToggle(tab, "Instant Kill", false)
    instantKillToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    local unlimitedZoomToggleFrame, unlimitedZoomGet, unlimitedZoomSet = CreateToggle(tab, "Unlimited Zoom", false)
    unlimitedZoomToggleFrame.Position = UDim2.new(0, 10, 0, y)
    y = y + 40

    -- Admin Detection Logic (basic example)
    spawn(function()
        while true do
            if adminDetectGet() then
                -- Scan logs, console or loaded scripts for admin/exploiter keywords (placeholder)
                local suspicious = false
                -- If detected, notify user
                if suspicious then
                    StarterGui:SetCore("SendNotification", {
                        Title = "Nebula Hub",
                        Text = "Suspicious admin/exploiter detected! WATCH OUT!",
                        Duration = 5
                    })
                end
            end
            task.wait(3)
        end
    end)

    -- Anticheat Bypass Logic (generic example)
    if anticheatBypassGet() then
        local mt = getrawmetatable(game)
        if mt and not mt.__namecall then
            setreadonly(mt, false)
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    return
                end
                return oldNamecall(...)
            end)
            setreadonly(mt, true)
        end
    end

    -- Godmode Logic (simple example)
    RunService.Heartbeat:Connect(function()
        if godmodeGet() and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)

    -- Instant Kill Logic (needs to be hooked to actual remote in-game, placeholder)
    -- Unlimited Zoom handled in Utility tab (Infinite Zoom toggle)
end

-- Helper: Find remotes (used in tabs above)
local function FindRemote(name)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == name and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == name and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    return nil
end

-- End of Script

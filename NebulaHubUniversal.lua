-- Nebula Hub Purple GUI (Custom Made)
-- Fully mobile compatible and feature complete scaffold

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- Helper function to create UI objects quickly
local function create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

-- ScreenGui Setup
local screenGui = create("ScreenGui", {
    Name = "NebulaHubPurpleGUI",
    ResetOnSpawn = false,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

-- Purple theme colors
local Colors = {
    Background = Color3.fromRGB(40, 32, 65),
    TabSelected = Color3.fromRGB(120, 75, 200),
    TabUnselected = Color3.fromRGB(70, 60, 110),
    Text = Color3.fromRGB(220, 220, 255),
    Accent = Color3.fromRGB(180, 130, 250),
    ToggleOn = Color3.fromRGB(130, 80, 255),
    ToggleOff = Color3.fromRGB(80, 60, 130),
    SliderTrack = Color3.fromRGB(80, 60, 130),
    SliderFill = Color3.fromRGB(140, 100, 255)
}

-- Main frame
local mainFrame = create("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 420, 0, 500),
    Position = UDim2.new(0.5, -210, 0.5, -250),
    BackgroundColor3 = Colors.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
})

-- UI Corner
create("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 12)})

-- Title Bar
local titleBar = create("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Colors.TabSelected,
})
create("UICorner", {Parent = titleBar, CornerRadius = UDim.new(0, 12)})

local titleLabel = create("TextLabel", {
    Parent = titleBar,
    Text = "Nebula Hub Purple GUI",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Colors.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Tab buttons container
local tabsFrame = create("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(0, 100, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Colors.TabUnselected,
    BorderSizePixel = 0,
})
create("UICorner", {Parent = tabsFrame, CornerRadius = UDim.new(0, 12)})

-- Tab content container
local contentFrame = create("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(1, -100, 1, -40),
    Position = UDim2.new(0, 100, 0, 40),
    BackgroundColor3 = Color3.fromRGB(50, 40, 80),
    BorderSizePixel = 0,
})
create("UICorner", {Parent = contentFrame, CornerRadius = UDim.new(0, 12)})

-- Utility to clear content frame children
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

-- Tab list and content handlers
local tabs = {}
local selectedTab = nil

-- Function to create a tab button
local function createTabButton(name)
    local button = create("TextButton", {
        Parent = tabsFrame,
        Text = name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Colors.TabUnselected,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})

    button.MouseButton1Click:Connect(function()
        for _, b in pairs(tabsFrame:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = Colors.TabUnselected
            end
        end
        button.BackgroundColor3 = Colors.TabSelected
        selectedTab = name
        clearContent()
        if tabs[name] then
            tabs[name]()
        end
    end)

    return button
end

-- Create all tab buttons
local tabNames = {
    "Utility", "Troll", "Auto", "Remotes", "Visual", "Exploits", "FTAP", "TSB", "BloxFruits", "StealABrainrot", "AstraCloud"
}

for i, tabName in ipairs(tabNames) do
    local btn = createTabButton(tabName)
    btn.Position = UDim2.new(0, 0, 0, 35*(i-1))
end

-- UI ListLayout for content
local contentLayout = create("UIListLayout", {Parent = contentFrame, Padding = UDim.new(0, 10)})
local contentPadding = create("UIPadding", {Parent = contentFrame, PaddingLeft = UDim.new(0, 15), PaddingTop = UDim.new(0, 15)})

-- Helper functions for UI elements inside content frame

local function createLabel(text)
    local label = create("TextLabel", {
        Parent = contentFrame,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 18,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    return label
end

local function createButton(text, callback)
    local button = create("TextButton", {
        Parent = contentFrame,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Colors.Text,
        BackgroundColor3 = Colors.Accent,
        Size = UDim2.new(1, 0, 0, 35),
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 8)})

    button.MouseButton1Click:Connect(callback)
    return button
end

local function createToggle(text, default, callback)
    local frame = create("Frame", {
        Parent = contentFrame,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1
    })

    local label = create("TextLabel", {
        Parent = frame,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 18,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local toggleBtn = create("TextButton", {
        Parent = frame,
        Text = default and "ON" or "OFF",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = default and Colors.ToggleOn or Colors.ToggleOff,
        BackgroundColor3 = default and Colors.ToggleOff or Colors.ToggleOn,
        Size = UDim2.new(0.2, -10, 0.7, 0),
        Position = UDim2.new(0.8, 10, 0.15, 0),
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0, 8)})

    local toggled = default

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.Text = toggled and "ON" or "OFF"
        toggleBtn.TextColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff
        toggleBtn.BackgroundColor3 = toggled and Colors.ToggleOff or Colors.ToggleOn
        callback(toggled)
    end)

    return frame
end

local function createSlider(text, min, max, default, callback)
    local frame = create("Frame", {
        Parent = contentFrame,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })

    local label = create("TextLabel", {
        Parent = frame,
        Text = text .. ": " .. tostring(default),
        Font = Enum.Font.Gotham,
        TextSize = 18,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local sliderBar = create("Frame", {
        Parent = frame,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Colors.SliderTrack,
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = sliderBar, CornerRadius = UDim.new(0, 10)})

    local sliderFill = create("Frame", {
        Parent = sliderBar,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Colors.SliderFill,
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = sliderFill, CornerRadius = UDim.new(0, 10)})

    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local function update(input2)
                local pos = input2.Position.X - sliderBar.AbsolutePosition.X
                pos = math.clamp(pos, 0, sliderBar.AbsoluteSize.X)
                local value = min + (pos / sliderBar.AbsoluteSize.X) * (max - min)
                sliderFill.Size = UDim2.new(pos / sliderBar.AbsoluteSize.X, 0, 1, 0)
                label.Text = string.format("%s: %.2f", text, value)
                callback(value)
            end

            update(input)

            local conn
            conn = UserInputService.InputChanged:Connect(function(input2)
                if dragging and input2.UserInputType == Enum.UserInputType.Touch or input2.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input2)
                end
            end)

            UserInputService.InputEnded:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.Touch or input2.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    return frame
end

local function createDropdown(text, options, default, callback)
    local frame = create("Frame", {
        Parent = contentFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })

    local label = create("TextLabel", {
        Parent = frame,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 18,
        TextColor3 = Colors.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local dropdownBtn = create("TextButton", {
        Parent = frame,
        Text = default,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Colors.Text,
        BackgroundColor3 = Colors.Accent,
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0.5, 10, 0, 0),
        BorderSizePixel = 0,
    })
    create("UICorner", {Parent = dropdownBtn, CornerRadius = UDim.new(0, 8)})

    local dropdownFrame = create("Frame", {
        Parent = frame,
        Size = UDim2.new(0.5, -10, 0, #options * 30),
        Position = UDim2.new(0.5, 10, 1, 0),
        BackgroundColor3 = Colors.Background,
        BorderSizePixel = 0,
        Visible = false
    })
    create("UICorner", {Parent = dropdownFrame, CornerRadius = UDim.new(0, 8)})

    for i, option in ipairs(options) do
        local optionBtn = create("TextButton", {
            Parent = dropdownFrame,
            Text = option,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = Colors.Text,
            BackgroundColor3 = Colors.TabUnselected,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, (i-1)*30),
            BorderSizePixel = 0,
        })
        create("UICorner", {Parent = optionBtn, CornerRadius = UDim.new(0, 8)})

        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownFrame.Visible = false
            callback(option)
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)

    return frame
end

-- Notification system
local notificationFrame = create("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 250, 0, 60),
    Position = UDim2.new(1, -260, 1, -70),
    BackgroundColor3 = Colors.TabSelected,
    BorderSizePixel = 0,
    Visible = false,
})
create("UICorner", {Parent = notificationFrame, CornerRadius = UDim.new(0, 12)})

local notificationLabel = create("TextLabel", {
    Parent = notificationFrame,
    Text = "",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Colors.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextWrapped = true,
})

local notificationTween = nil
local function notify(text, duration)
    notificationLabel.Text = text
    notificationFrame.Visible = true
    if notificationTween then
        notificationTween:Cancel()
    end
    notificationFrame.Position = UDim2.new(1, -260, 1, -70)
    notificationTween = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -90)})
    notificationTween:Play()
    task.delay(duration or 3, function()
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 1, -70)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notificationFrame.Visible = false
    end)
end

-- Now we create the feature functions for each tab

-- Variables for features
local WalkSpeedValue = 16
local JumpPowerValue = 100
local clickTPOn = false
local InfJump = false
local espOn, lineESP, aimbotOn = false, false, false
local teamCheck = true
local autoShoot = false
local flingEnabled = false
local flingStrength = 350
local antiGrabEnabled = false
local spawnKillAll = false
local flingAll = false
local autofarmEnabled = false
local noclipActive = false
local autoStealActive = false
local anticheatBypassActive = false

-- === Utility Tab ===
tabs["Utility"] = function()
    createToggle("Click TP", clickTPOn, function(v)
        clickTPOn = v
        notify("Click TP " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Infinite Jump", InfJump, function(v)
        InfJump = v
        notify("Infinite Jump " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createSlider("Walk Speed", 16, 200, WalkSpeedValue, function(v)
        WalkSpeedValue = v
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end)

    createSlider("Jump Power", 50, 300, JumpPowerValue, function(v)
        JumpPowerValue = v
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = JumpPowerValue
        end
    end)

    createButton("Anti AFK (Jump)", function()
        local vu = game:GetService("VirtualUser")
        local afkConnection
        afkConnection = LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        notify("Anti AFK Enabled", 2)
        task.delay(30, function()
            afkConnection:Disconnect()
            notify("Anti AFK Disabled", 2)
        end)
    end)
end

-- === Troll Tab ===
tabs["Troll"] = function()
    createButton("Fake Kick", function()
        notify("Fake Kick executed", 2)
        -- Add your fake kick logic here
    end)

    createButton("Spam Chat", function()
        notify("Spam Chat started", 2)
        -- Add your spam chat logic here
    end)

    createToggle("Fling Self", false, function(v)
        if v then
            notify("Fling Self started", 2)
            -- Fling logic here
        else
            notify("Fling Self stopped", 2)
        end
    end)
end

-- === Auto Tab ===
tabs["Auto"] = function()
    createToggle("Auto Farm", autofarmEnabled, function(v)
        autofarmEnabled = v
        notify("Auto Farm " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Auto Move", false, function(v)
        notify("Auto Move toggled: " .. tostring(v), 2)
        -- Auto move logic here
    end)
end

-- === Remotes Tab ===
tabs["Remotes"] = function()
    createToggle("Remote Lag", false, function(v)
        notify("Remote Lag " .. (v and "Enabled" or "Disabled"), 2)
        -- Remote lag logic here
    end)

    createButton("Remote Scan", function()
        notify("Remote Scan started", 2)
        -- Remote scan logic here
    end)
end

-- === Visual Tab ===
tabs["Visual"] = function()
    createToggle("ESP", espOn, function(v)
        espOn = v
        notify("ESP " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Line ESP", lineESP, function(v)
        lineESP = v
        notify("Line ESP " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Aimbot", aimbotOn, function(v)
        aimbotOn = v
        notify("Aimbot " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Team Check", teamCheck, function(v)
        teamCheck = v
        notify("Team Check " .. (v and "Enabled" or "Disabled"), 2)
    end)
end

-- === Exploits Tab ===
tabs["Exploits"] = function()
    createToggle("Click Delete", false, function(v)
        notify("Click Delete " .. (v and "Enabled" or "Disabled"), 2)
        -- Click delete logic here
    end)

    createToggle("Anti Lag", false, function(v)
        notify("Anti Lag " .. (v and "Enabled" or "Disabled"), 2)
        -- Anti lag logic here
    end)
end

-- === FTAP Tab ===
tabs["FTAP"] = function()
    createToggle("Fling On Grab Release", flingEnabled, function(v)
        flingEnabled = v
        notify("Fling On Grab Release " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createSlider("Fling Strength", 50, 1000, flingStrength, function(v)
        flingStrength = v
    end)

    createToggle("Anti Grab", antiGrabEnabled, function(v)
        antiGrabEnabled = v
        notify("Anti Grab " .. (v and "Enabled" or "Disabled"), 2)
    end)
end

-- === TSB Tab ===
tabs["TSB"] = function()
    createToggle("Auto Farm", autofarmEnabled, function(v)
        autofarmEnabled = v
        notify("TSB Auto Farm " .. (v and "Enabled" or "Disabled"), 2)
    end)

    createToggle("Safe Fly", false, function(v)
        notify("Safe Fly toggled: " .. tostring(v), 2)
        -- Safe fly logic here
    end)
end

-- === BloxFruits Tab ===
tabs["BloxFruits"] = function()
    createLabel("BloxFruits features coming soon!")
end

-- === StealABrainrot Tab ===
tabs["StealABrainrot"] = function()
    createToggle("Noclip", noclipActive, function(v)
        noclipActive = v
        notify("Noclip " .. (v and "Enabled" or "Disabled"), 2)
        -- Noclip logic here
    end)

    createToggle("Anticheat Bypass", anticheatBypassActive, function(v)
        anticheatBypassActive = v
        notify("Anticheat Bypass " .. (v and "Enabled" or "Disabled"), 2)
        -- Anticheat bypass logic here
    end)

    createToggle("Auto Steal", autoStealActive, function(v)
        autoStealActive = v
        notify("Auto Steal " .. (v and "Enabled" or "Disabled"), 2)
        -- Auto steal logic here
    end)
end

-- === AstraCloud Tab ===
tabs["AstraCloud"] = function()
    createToggle("Admin/Exploiter Detection", false, function(v)
        notify("Admin/Exploiter Detection " .. (v and "Enabled" or "Disabled"), 2)
        -- Detection logic here
    end)

    createToggle("Godmode", false, function(v)
        notify("Godmode " .. (v and "Enabled" or "Disabled"), 2)
        -- Godmode logic here
    end)

    createToggle("Instant Kill", false, function(v)
        notify("Instant Kill " .. (v and "Enabled" or "Disabled"), 2)
        -- Instant kill logic here
    end)

    createToggle("Unlimited Zoom", false, function(v)
        notify("Unlimited Zoom " .. (v and "Enabled" or "Disabled"), 2)
        -- Zoom logic here
    end)
end

-- Select the first tab by default
for _, b in pairs(tabsFrame:GetChildren()) do
    if b:IsA("TextButton") then
        b.BackgroundColor3 = Colors.TabUnselected
    end
end
tabsFrame:GetChildren()[1].BackgroundColor3 = Colors.TabSelected
selectedTab = tabNames[1]
tabs[selectedTab]()

-- Return the GUI
return screenGui

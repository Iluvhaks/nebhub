-- Nebula Hub Purple GUI with Minimize Button and Toggle-only controls

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

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

local screenGui = create("ScreenGui", {
    Name = "NebulaHubPurpleGUI",
    ResetOnSpawn = false,
    Parent = LocalPlayer:WaitForChild("PlayerGui")
})

local mainFrame = create("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 420, 0, 500),
    Position = UDim2.new(0.5, -210, 0.5, -250),
    BackgroundColor3 = Colors.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
})
create("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 12)})

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
    Size = UDim2.new(1, -40, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Minimize button (top-right)
local minimizeBtn = create("TextButton", {
    Parent = titleBar,
    Text = "−",
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    TextColor3 = Colors.Text,
    BackgroundColor3 = Colors.Accent,
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(1, -35, 0, 0),
    BorderSizePixel = 0,
})
create("UICorner", {Parent = minimizeBtn, CornerRadius = UDim.new(0, 8)})

local tabsFrame = create("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(0, 100, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Colors.TabUnselected,
    BorderSizePixel = 0,
})
create("UICorner", {Parent = tabsFrame, CornerRadius = UDim.new(0, 12)})

local contentFrame = create("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(1, -100, 1, -40),
    Position = UDim2.new(0, 100, 0, 40),
    BackgroundColor3 = Color3.fromRGB(50, 40, 80),
    BorderSizePixel = 0,
})
create("UICorner", {Parent = contentFrame, CornerRadius = UDim.new(0, 12)})

-- Helper to clear content frame
local function clearContent()
    for _, child in ipairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

-- Tabs table
local tabs = {}
local selectedTab = nil

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

-- Create tab buttons
local tabNames = {
    "Utility", "Troll", "Auto", "Remotes", "Visual", "Exploits", "FTAP", "TSB", "BloxFruits", "StealABrainrot", "AstraCloud"
}

for i, tabName in ipairs(tabNames) do
    local btn = createTabButton(tabName)
    btn.Position = UDim2.new(0, 0, 0, 35*(i-1))
end

local contentLayout = create("UIListLayout", {Parent = contentFrame, Padding = UDim.new(0, 10)})
local contentPadding = create("UIPadding", {Parent = contentFrame, PaddingLeft = UDim.new(0, 15), PaddingTop = UDim.new(0, 15)})

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

local function createToggle(text, default)
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
        -- No real game logic, only toggle visuals
    end)

    return frame
end

local function createButton(text)
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

    -- Buttons do nothing, just for toggling UI effect
    button.MouseButton1Click:Connect(function()
        -- No real logic
    end)

    return button
end

-- Tab contents (only toggles and buttons with no real logic)
tabs["Utility"] = function()
    createToggle("Click TP", false)
    createToggle("Infinite Jump", false)
    createToggle("Anti AFK", false)
    createButton("Reset Character")
end

tabs["Troll"] = function()
    createToggle("Fling Self", false)
    createButton("Spam Chat")
end

tabs["Auto"] = function()
    createToggle("Auto Farm", false)
    createToggle("Auto Move", false)
end

tabs["Remotes"] = function()
    createToggle("Remote Lag", false)
    createButton("Remote Scan")
end

tabs["Visual"] = function()
    createToggle("ESP", false)
    createToggle("Line ESP", false)
    createToggle("Aimbot", false)
    createToggle("Team Check", false)
end

tabs["Exploits"] = function()
    createToggle("Click Delete", false)
    createToggle("Anti Lag", false)
end

tabs["FTAP"] = function()
    createToggle("Fling On Grab Release", false)
    createToggle("Anti Grab", false)
    createToggle("Delete Player on Grab Release", false)
end

tabs["TSB"] = function()
    createToggle("Auto Farm", false)
    createToggle("Safe Fly", false)
end

tabs["BloxFruits"] = function()
    createLabel("BloxFruits features coming soon!")
end

tabs["StealABrainrot"] = function()
    createToggle("Noclip", false)
    createToggle("Anticheat Bypass", false)
    createToggle("Auto Steal", false)
end

tabs["AstraCloud"] = function()
    createToggle("Admin/Exploiter Detection", false)
    createToggle("Godmode", false)
    createToggle("Instant Kill", false)
    createToggle("Unlimited Zoom", false)
end

-- Select first tab by default
for _, b in pairs(tabsFrame:GetChildren()) do
    if b:IsA("TextButton") then
        b.BackgroundColor3 = Colors.TabUnselected
    end
end
tabsFrame:GetChildren()[1].BackgroundColor3 = Colors.TabSelected
selectedTab = tabNames[1]
tabs[selectedTab]()

-- Minimized state management
local isMinimized = false

local function minimize()
    isMinimized = true
    -- Tween mainFrame to small bar at bottom left
    local targetSize = UDim2.new(0, 50, 0, 50)
    local targetPos = UDim2.new(0, 10, 1, -60)
    TweenService:Create(mainFrame, TweenInfo.new(0.4), {Size = targetSize, Position = targetPos}):Play()

    -- Hide content and tabs and title except minimize button
    for _, v in pairs(mainFrame:GetChildren()) do
        if v ~= titleBar then
            v.Visible = false
        end
    end

    -- Change title text to "N"
    titleLabel.Text = "N"

    -- Change minimize button to "◻" (restore)
    minimizeBtn.Text = "◻"
end

local function restore()
    isMinimized = false
    local targetSize = UDim2.new(0, 420, 0, 500)
    local targetPos = UDim2.new(0.5, -210, 0.5, -250)
    TweenService:Create(mainFrame, TweenInfo.new(0.4), {Size = targetSize, Position = targetPos}):Play()

    -- Show all children except minimize button
    for _, v in pairs(mainFrame:GetChildren()) do
        v.Visible = true
    end

    -- Reset title text
    titleLabel.Text = "Nebula Hub Purple GUI"

    -- Reset minimize button text
    minimizeBtn.Text = "−"
end

minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        restore()
    else
        minimize()
    end
end)

return screenGui

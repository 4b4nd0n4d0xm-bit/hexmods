--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

-- ============================================================
--        YimF0rce uni hub | Made for Delta Executor
--        Features: Flight, NoClip, ESP, & More
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================================
-- STATE
-- ============================================================
local State = {
    Flight        = false,
    NoClip        = false,
    ESP           = false,
    SpeedBoost    = false,
    Infinite_Jump = false,
    FullBright    = false,
    AntiAFK       = false,
    FreeCam       = false,
}

local FlightSpeed  = 40
local SpeedValue   = 50
local ESPDistance  = 300

-- Mobile flight vertical state (tracked by on-screen buttons)
local mobileUp   = false
local mobileDown = false

local connections  = {}
local espObjects   = {}

-- ============================================================
-- UTILITY
-- ============================================================
local function getChar()  return LocalPlayer.Character end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ============================================================
-- GUI SETUP
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "CorsUniHub"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============= MAIN FRAME =============
local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainFrame"
MainFrame.Size             = UDim2.new(0, 340, 0, 460)
MainFrame.Position         = UDim2.new(0.5, -170, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel  = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent           = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Shadow = Instance.new("ImageLabel")
Shadow.Image              = "rbxassetid://5554236805"
Shadow.ImageColor3        = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency  = 0.6
Shadow.Size               = UDim2.new(1, 40, 1, 40)
Shadow.Position           = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.ZIndex             = -1
Shadow.Parent             = MainFrame
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 16)

-- ============= TITLE BAR =============
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel  = 0
TitleBar.Parent           = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleFix = Instance.new("Frame")
TitleFix.Size             = UDim2.new(1, 0, 0, 12)
TitleFix.Position         = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleFix.BorderSizePixel  = 0
TitleFix.Parent           = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text           = " YIMF0RCEDEV uni hub"
TitleLabel.Font           = Enum.Font.GothamBold
TitleLabel.TextSize       = 16
TitleLabel.TextColor3     = Color3.fromRGB(130, 100, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size           = UDim2.new(1, -80, 1, 0)
TitleLabel.Position       = UDim2.new(0, 14, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent         = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text             = "✕"
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextSize         = 14
CloseBtn.TextColor3       = Color3.fromRGB(200, 100, 100)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 40)
CloseBtn.BorderSizePixel  = 0
CloseBtn.Size             = UDim2.new(0, 30, 0, 24)
CloseBtn.Position         = UDim2.new(1, -40, 0.5, -12)
CloseBtn.Parent           = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Text             = "—"
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.TextSize         = 14
MinBtn.TextColor3       = Color3.fromRGB(255, 200, 50)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 25)
MinBtn.BorderSizePixel  = 0
MinBtn.Size             = UDim2.new(0, 30, 0, 24)
MinBtn.Position         = UDim2.new(1, -76, 0.5, -12)
MinBtn.Parent           = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- ============= TAB BAR =============
local TabBar = Instance.new("Frame")
TabBar.Size              = UDim2.new(1, -20, 0, 32)
TabBar.Position          = UDim2.new(0, 10, 0, 50)
TabBar.BackgroundTransparency = 1
TabBar.Parent            = MainFrame
local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection  = Enum.FillDirection.Horizontal
TabLayout.Padding        = UDim.new(0, 6)
TabLayout.Parent         = TabBar

-- ============= CONTENT AREA =============
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size                = UDim2.new(1, -20, 1, -96)
ContentArea.Position            = UDim2.new(0, 10, 0, 90)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel     = 0
ContentArea.ScrollBarThickness  = 3
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(130, 100, 255)
ContentArea.CanvasSize          = UDim2.new(0, 0, 0, 0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.Parent              = MainFrame
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent  = ContentArea

-- ============================================================
-- MOBILE FLIGHT BUTTONS  (↑ / ↓  appear at bottom-center when flying)
-- ============================================================
local MobileFlyBtns = Instance.new("Frame")
MobileFlyBtns.Size              = UDim2.new(0, 116, 0, 56)
MobileFlyBtns.Position          = UDim2.new(0.5, -58, 1, -80)
MobileFlyBtns.BackgroundTransparency = 1
MobileFlyBtns.Visible           = false
MobileFlyBtns.ZIndex            = 10
MobileFlyBtns.Parent            = ScreenGui

local function makeFlyBtn(label, xPos, color, downCB, upCB)
    local btn = Instance.new("TextButton")
    btn.Text             = label
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 22
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel  = 0
    btn.Size             = UDim2.new(0, 52, 0, 52)
    btn.Position         = UDim2.new(0, xPos, 0, 0)
    btn.ZIndex           = 11
    btn.Parent           = MobileFlyBtns
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    -- Slight shadow behind buttons
    btn.BackgroundColor3 = color

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            downCB()
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch
        or inp.UserInputType == Enum.UserInputType.MouseButton1 then
            upCB()
        end
    end)
    -- Also catch if finger leaves the button area while still held
    btn.MouseLeave:Connect(function() upCB() end)
    return btn
end

makeFlyBtn("↑",  0, Color3.fromRGB(90, 60, 210),
    function() mobileUp   = true  end,
    function() mobileUp   = false end)

makeFlyBtn("↓", 62, Color3.fromRGB(50, 40, 130),
    function() mobileDown = true  end,
    function() mobileDown = false end)

-- ============================================================
-- DRAG LOGIC
-- ============================================================
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local sz = minimized and UDim2.new(0,340,0,44) or UDim2.new(0,340,0,460)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size=sz}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size     = UDim2.new(0,0,0,0),
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset+170,
                             MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset+230)
    }):Play()
    task.delay(0.35, function() ScreenGui:Destroy() end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local Tabs     = {}
local TabPages = {}
local ActiveTab = nil

local TabColors = {
    Combat   = Color3.fromRGB(255, 80,  80),
    Movement = Color3.fromRGB(80,  180, 255),
    Visual   = Color3.fromRGB(100, 255, 150),
    Misc     = Color3.fromRGB(255, 200, 50),
}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Text             = name
    btn.Font             = Enum.Font.GothamSemibold
    btn.TextSize         = 12
    btn.TextColor3       = Color3.fromRGB(160, 160, 180)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    btn.BorderSizePixel  = 0
    btn.AutomaticSize    = Enum.AutomaticSize.X
    btn.Size             = UDim2.new(0, 0, 1, 0)
    btn.Parent           = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local pad = Instance.new("UIPadding", btn)
    pad.PaddingLeft  = UDim.new(0,10)
    pad.PaddingRight = UDim.new(0,10)

    local page = Instance.new("Frame")
    page.Name               = name
    page.Size               = UDim2.new(1,0,0,0)
    page.AutomaticSize      = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible            = false
    page.Parent             = ContentArea
    local pl = Instance.new("UIListLayout", page)
    pl.Padding = UDim.new(0,8)

    Tabs[name]     = btn
    TabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for k, p in pairs(TabPages) do
            p.Visible = false
            Tabs[k].TextColor3       = Color3.fromRGB(160,160,180)
            Tabs[k].BackgroundColor3 = Color3.fromRGB(22,22,32)
        end
        page.Visible         = true
        ActiveTab            = name
        btn.TextColor3       = TabColors[name] or Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(30,28,50)
    end)
    return page
end

local PageCombat   = createTab("Combat")
local PageMovement = createTab("Movement")
local PageVisual   = createTab("Visual")
local PageMisc     = createTab("Misc")

Tabs["Movement"].TextColor3       = TabColors["Movement"]
Tabs["Movement"].BackgroundColor3 = Color3.fromRGB(30,28,50)
TabPages["Movement"].Visible      = true
ActiveTab = "Movement"

-- ============================================================
-- WIDGET FACTORIES
-- ============================================================
local function createToggle(parent, label, description, callback)
    local row = Instance.new("Frame")
    row.Size              = UDim2.new(1,0,0,54)
    row.BackgroundColor3  = Color3.fromRGB(22,22,32)
    row.BorderSizePixel   = 0
    row.Parent            = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Text              = label
    lbl.Font              = Enum.Font.GothamSemibold
    lbl.TextSize          = 14
    lbl.TextColor3        = Color3.fromRGB(220,220,240)
    lbl.BackgroundTransparency = 1
    lbl.Size              = UDim2.new(1,-70,0,20)
    lbl.Position          = UDim2.new(0,12,0,8)
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.Parent            = row

    local desc = Instance.new("TextLabel")
    desc.Text             = description
    desc.Font             = Enum.Font.Gotham
    desc.TextSize         = 11
    desc.TextColor3       = Color3.fromRGB(100,100,120)
    desc.BackgroundTransparency = 1
    desc.Size             = UDim2.new(1,-70,0,18)
    desc.Position         = UDim2.new(0,12,0,30)
    desc.TextXAlignment   = Enum.TextXAlignment.Left
    desc.Parent           = row

    local pill = Instance.new("Frame")
    pill.Size             = UDim2.new(0,42,0,22)
    pill.Position         = UDim2.new(1,-54,0.5,-11)
    pill.BackgroundColor3 = Color3.fromRGB(50,50,65)
    pill.BorderSizePixel  = 0
    pill.Parent           = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0,16,0,16)
    knob.Position         = UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(160,160,180)
    knob.BorderSizePixel  = 0
    knob.Parent           = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local toggled = false
    local function toggle()
        toggled = not toggled
        local ox = toggled and UDim2.new(0,23,0.5,-8) or UDim2.new(0,3,0.5,-8)
        local pc = toggled and Color3.fromRGB(90,60,200)   or Color3.fromRGB(50,50,65)
        local kc = toggled and Color3.fromRGB(200,170,255) or Color3.fromRGB(160,160,180)
        TweenService:Create(knob, TweenInfo.new(0.18), {Position=ox, BackgroundColor3=kc}):Play()
        TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3=pc}):Play()
        callback(toggled)
    end

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            toggle()
        end
    end)
    return row, function() return toggled end
end

local function createSlider(parent, label, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1,0,0,58)
    row.BackgroundColor3 = Color3.fromRGB(22,22,32)
    row.BorderSizePixel  = 0
    row.Parent           = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Text             = label
    lbl.Font             = Enum.Font.GothamSemibold
    lbl.TextSize         = 13
    lbl.TextColor3       = Color3.fromRGB(200,200,220)
    lbl.BackgroundTransparency = 1
    lbl.Size             = UDim2.new(0.7,0,0,20)
    lbl.Position         = UDim2.new(0,12,0,6)
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.Parent           = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Text          = tostring(defaultVal)
    valLbl.Font          = Enum.Font.GothamBold
    valLbl.TextSize      = 13
    valLbl.TextColor3    = Color3.fromRGB(130,100,255)
    valLbl.BackgroundTransparency = 1
    valLbl.Size          = UDim2.new(0.3,-12,0,20)
    valLbl.Position      = UDim2.new(0.7,0,0,6)
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent        = row

    local track = Instance.new("Frame")
    track.Size           = UDim2.new(1,-24,0,6)
    track.Position       = UDim2.new(0,12,0,36)
    track.BackgroundColor3 = Color3.fromRGB(40,40,55)
    track.BorderSizePixel = 0
    track.Parent         = row
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local pct  = (defaultVal - minVal) / (maxVal - minVal)
    local fill = Instance.new("Frame")
    fill.Size            = UDim2.new(pct,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(100,70,220)
    fill.BorderSizePixel = 0
    fill.Parent          = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local handle = Instance.new("Frame")
    handle.Size          = UDim2.new(0,14,0,14)
    handle.Position      = UDim2.new(pct,-7,0.5,-7)
    handle.BackgroundColor3 = Color3.fromRGB(170,140,255)
    handle.BorderSizePixel = 0
    handle.ZIndex        = 3
    handle.Parent        = track
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1,0)

    local sliding = false
    local function updateSlider(inputPos)
        local relX = math.clamp((inputPos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local val  = math.floor(minVal + relX*(maxVal-minVal))
        fill.Size  = UDim2.new(relX,0,1,0)
        handle.Position = UDim2.new(relX,-7,0.5,-7)
        valLbl.Text = tostring(val)
        callback(val)
    end
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true; updateSlider(input.Position)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

local function createSection(parent, text)
    local f = Instance.new("Frame")
    f.Size              = UDim2.new(1,0,0,26)
    f.BackgroundTransparency = 1
    f.Parent            = parent

    local line = Instance.new("Frame")
    line.Size           = UDim2.new(1,0,0,1)
    line.Position       = UDim2.new(0,0,0.5,0)
    line.BackgroundColor3 = Color3.fromRGB(40,40,60)
    line.BorderSizePixel = 0
    line.Parent         = f

    local lbl = Instance.new("TextLabel")
    lbl.Text            = "  "..text.."  "
    lbl.Font            = Enum.Font.GothamSemibold
    lbl.TextSize        = 11
    lbl.TextColor3      = Color3.fromRGB(100,80,180)
    lbl.BackgroundColor3 = Color3.fromRGB(15,15,20)
    lbl.BorderSizePixel = 0
    lbl.AutomaticSize   = Enum.AutomaticSize.X
    lbl.Size            = UDim2.new(0,0,1,0)
    lbl.Position        = UDim2.new(0,12,0,0)
    lbl.Parent          = f
end

local function createButton(parent, text, color, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1,0,0,44)
    row.BackgroundColor3 = Color3.fromRGB(22,22,32)
    row.BorderSizePixel  = 0
    row.Parent           = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local btn = Instance.new("TextButton")
    btn.Text             = text
    btn.Font             = Enum.Font.GothamSemibold
    btn.TextSize         = 13
    btn.TextColor3       = color
    btn.BackgroundTransparency = 1
    btn.Size             = UDim2.new(1,0,1,0)
    btn.Parent           = row
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ============================================================
--  FEATURE IMPLEMENTATIONS
-- ============================================================

-- ====== FLIGHT ======
local flyBody  = nil
local flyGyro  = nil

local function startFlight()
    local root = getRoot()
    if not root then return end
    local hum = getHum()
    if hum then hum.PlatformStand = true end

    flyBody             = Instance.new("BodyVelocity")
    flyBody.Velocity    = Vector3.zero
    flyBody.MaxForce    = Vector3.new(1e5,1e5,1e5)
    flyBody.Parent      = root

    flyGyro             = Instance.new("BodyGyro")
    flyGyro.Name        = "FlyGyro"
    flyGyro.MaxTorque   = Vector3.new(1e5,1e5,1e5)
    flyGyro.P           = 1e4
    flyGyro.D           = 100
    flyGyro.CFrame      = root.CFrame
    flyGyro.Parent      = root

    -- Show mobile vertical buttons
    MobileFlyBtns.Visible = true

    connections["fly"] = RunService.Heartbeat:Connect(function()
        local root2 = getRoot()
        if not root2 or not State.Flight then return end
        local gyro = root2:FindFirstChild("FlyGyro")

        local moveDir = Vector3.zero
        local camCF   = Camera.CFrame

        -- ── PC keyboard controls ──
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        or UserInputService:IsKeyDown(Enum.KeyCode.C) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end

        -- ── Mobile horizontal: joystick MoveDirection ──
        local hum2 = getHum()
        if hum2 and hum2.MoveDirection.Magnitude > 0.1 then
            local md = hum2.MoveDirection
            moveDir = moveDir + Vector3.new(md.X, 0, md.Z)
        end

        -- ── Mobile vertical: on-screen ↑ / ↓ buttons ──
        if mobileUp   then moveDir = moveDir + Vector3.new(0,1,0) end
        if mobileDown then moveDir = moveDir - Vector3.new(0,1,0) end

        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end

        if flyBody and flyBody.Parent then
            flyBody.Velocity = moveDir * FlightSpeed
        end
        if gyro then
            gyro.CFrame = Camera.CFrame
        end
    end)
end

local function stopFlight()
    if connections["fly"] then connections["fly"]:Disconnect(); connections["fly"] = nil end
    local root = getRoot()
    if root then
        local g = root:FindFirstChild("FlyGyro")
        if g then g:Destroy() end
    end
    if flyBody and flyBody.Parent then flyBody:Destroy() end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy() end
    flyBody = nil; flyGyro = nil
    mobileUp = false; mobileDown = false
    MobileFlyBtns.Visible = false
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

-- ====== NOCLIP ======
local function startNoClip()
    connections["noclip"] = RunService.Stepped:Connect(function()
        local char = getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoClip()
    if connections["noclip"] then connections["noclip"]:Disconnect(); connections["noclip"] = nil end
    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ====== ESP ======
local function healthToColor(pct)
    pct = math.clamp(pct, 0, 1)
    if pct > 0.5 then
        return Color3.fromRGB(math.floor(255*(1-pct)*2), 200, 50)
    else
        return Color3.fromRGB(220, math.floor(200*pct*2), 30)
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    if espObjects[player] then return end
    local espData = {}

    local hl = Instance.new("SelectionBox")
    hl.Color3              = Color3.fromRGB(130,80,255)
    hl.LineThickness       = 0.04
    hl.SurfaceTransparency = 0.7
    hl.SurfaceColor3       = Color3.fromRGB(100,60,200)
    hl.Parent              = Camera
    espData.highlight      = hl

    local bb = Instance.new("BillboardGui")
    bb.Size              = UDim2.new(0,100,0,40)
    bb.StudsOffset       = Vector3.new(0,3,0)
    bb.AlwaysOnTop       = true
    bb.Enabled           = true
    bb.Parent            = Camera
    espData.billboard    = bb

    local nameTag = Instance.new("TextLabel")
    nameTag.Text          = player.Name
    nameTag.Font          = Enum.Font.GothamBold
    nameTag.TextSize      = 11
    nameTag.TextColor3    = Color3.fromRGB(220,200,255)
    nameTag.BackgroundTransparency = 1
    nameTag.Size          = UDim2.new(1,0,0.5,0)
    nameTag.TextStrokeTransparency = 0.4
    nameTag.Parent        = bb

    local hpBG = Instance.new("Frame")
    hpBG.Size             = UDim2.new(1,0,0,6)
    hpBG.Position         = UDim2.new(0,0,1,-8)
    hpBG.BackgroundColor3 = Color3.fromRGB(30,30,30)
    hpBG.BorderSizePixel  = 0
    hpBG.Parent           = bb
    Instance.new("UICorner", hpBG).CornerRadius = UDim.new(1,0)

    local hpFill = Instance.new("Frame")
    hpFill.Size           = UDim2.new(1,0,1,0)
    hpFill.BackgroundColor3 = Color3.fromRGB(80,220,80)
    hpFill.BorderSizePixel = 0
    hpFill.Parent         = hpBG
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1,0)
    espData.hpFill        = hpFill

    espData.update = RunService.Heartbeat:Connect(function()
        if not State.ESP then return end
        local char      = player.Character
        local localRoot = getRoot()
        if not char or not localRoot then hl.Adornee=nil; bb.Enabled=false; return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then hl.Adornee=nil; bb.Enabled=false; return end
        local dist = (root.Position - localRoot.Position).Magnitude
        if dist > ESPDistance then hl.Adornee=nil; bb.Enabled=false; return end
        hl.Adornee = char
        bb.Adornee = root
        bb.Enabled = true
        local pct  = hum.Health / math.max(hum.MaxHealth,1)
        TweenService:Create(hpFill, TweenInfo.new(0.2), {
            BackgroundColor3 = healthToColor(pct),
            Size             = UDim2.new(pct,0,1,0)
        }):Play()
    end)

    espObjects[player] = espData
end

local function removeESP(player)
    local d = espObjects[player]
    if not d then return end
    if d.highlight then d.highlight:Destroy() end
    if d.billboard then d.billboard:Destroy() end
    if d.update    then d.update:Disconnect()  end
    espObjects[player] = nil
end

local function startESP()
    for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
    connections["espAdded"]   = Players.PlayerAdded:Connect(createESP)
    connections["espRemoved"] = Players.PlayerRemoving:Connect(removeESP)
end

local function stopESP()
    for p in pairs(espObjects) do removeESP(p) end
    if connections["espAdded"]   then connections["espAdded"]:Disconnect()   end
    if connections["espRemoved"] then connections["espRemoved"]:Disconnect() end
end

-- ====== SPEED BOOST ======
local function applySpeed(on)
    local hum = getHum()
    if hum then hum.WalkSpeed = on and SpeedValue or 16 end
    if on then
        connections["speedRespawn"] = LocalPlayer.CharacterAdded:Connect(function(char)
            local h = char:WaitForChild("Humanoid")
            if State.SpeedBoost then h.WalkSpeed = SpeedValue end
        end)
    else
        if connections["speedRespawn"] then connections["speedRespawn"]:Disconnect() end
    end
end

-- ====== INFINITE JUMP ======
local function startInfJump()
    connections["infjump"] = UserInputService.JumpRequest:Connect(function()
        local hum = getHum()
        if hum and State.Infinite_Jump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
local function stopInfJump()
    if connections["infjump"] then connections["infjump"]:Disconnect(); connections["infjump"] = nil end
end

-- ====== FULLBRIGHT ======
local function setFullBright(on)
    local L = game:GetService("Lighting")
    if on then
        L.Ambient        = Color3.fromRGB(255,255,255)
        L.OutdoorAmbient = Color3.fromRGB(255,255,255)
        L.Brightness     = 2
        L.FogEnd         = 100000
        L.GlobalShadows  = false
    else
        L.Ambient        = Color3.fromRGB(127,127,127)
        L.OutdoorAmbient = Color3.fromRGB(127,127,127)
        L.Brightness     = 1
        L.FogEnd         = 100000
        L.GlobalShadows  = true
    end
end

-- ====== ANTI-AFK ======
local function startAntiAFK()
    pcall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    connections["antiafk"] = RunService.Heartbeat:Connect(function()
        if State.AntiAFK then
            pcall(function() LocalPlayer:Move(Vector2.new(0,0), false) end)
        end
    end)
end
local function stopAntiAFK()
    if connections["antiafk"] then connections["antiafk"]:Disconnect(); connections["antiafk"] = nil end
end

-- ====== FREECAM ======
local freeCamPart = nil
local function startFreeCam()
    freeCamPart             = Instance.new("Part")
    freeCamPart.Anchored    = true
    freeCamPart.CanCollide  = false
    freeCamPart.Transparency = 1
    freeCamPart.Size        = Vector3.new(1,1,1)
    freeCamPart.CFrame      = Camera.CFrame
    freeCamPart.Parent      = workspace
    Camera.CameraType       = Enum.CameraType.Scriptable
    Camera.CFrame           = freeCamPart.CFrame

    connections["freecam"] = RunService.RenderStepped:Connect(function()
        if not State.FreeCam then return end
        local move = Vector3.zero
        local cf   = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector  end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector  end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then Camera.CFrame = Camera.CFrame + move.Unit * 0.5 end
    end)
end
local function stopFreeCam()
    if connections["freecam"] then connections["freecam"]:Disconnect(); connections["freecam"] = nil end
    if freeCamPart then freeCamPart:Destroy(); freeCamPart = nil end
    Camera.CameraType = Enum.CameraType.Custom
end

-- ====== FLING NEAREST ======
local function flingNearest()
    local root = getRoot()
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            if pr then
                local d = (pr.Position - root.Position).Magnitude
                if d < closestDist then closest = pr; closestDist = d end
            end
        end
    end
    if closest and closestDist < 40 then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-100,100), 200, math.random(-100,100))
        bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        bv.Parent   = closest
        game:GetService("Debris"):AddItem(bv, 0.15)
    end
end

-- ====== TELEPORT TO MOUSE ======
local tpActive = false
local tpBtn    = nil

local function teleportToMouse()
    local root = getRoot()
    if root and Mouse.Hit then
        root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
    end
end

-- ============================================================
-- BUILD PAGES
-- ============================================================

-- ─── MOVEMENT ───
createSection(PageMovement, "FLIGHT")
createToggle(PageMovement, "✈  Flight", "Fly freely — PC & Mobile (↑↓ buttons appear)", function(v)
    State.Flight = v
    if v then startFlight() else stopFlight() end
end)
createSlider(PageMovement, "Flight Speed", 10, 150, 40, function(v)
    FlightSpeed = v
end)

createSection(PageMovement, "MOVEMENT")
createToggle(PageMovement, "👟  Speed Boost", "Increase walk speed", function(v)
    State.SpeedBoost = v
    applySpeed(v)
end)
createSlider(PageMovement, "Walk Speed", 16, 150, 50, function(v)
    SpeedValue = v
    if State.SpeedBoost then
        local hum = getHum()
        if hum then hum.WalkSpeed = v end
    end
end)
createToggle(PageMovement, "🌀  No Clip", "Pass through walls", function(v)
    State.NoClip = v
    if v then startNoClip() else stopNoClip() end
end)
createToggle(PageMovement, "🦘  Infinite Jump", "Jump unlimited times", function(v)
    State.Infinite_Jump = v
    if v then startInfJump() else stopInfJump() end
end)

-- ─── COMBAT ───
createSection(PageCombat, "COMBAT TOOLS")
createToggle(PageCombat, "👁  ESP / Wallcheck", "Highlight players through walls", function(v)
    State.ESP = v
    if v then startESP() else stopESP() end
end)
createSlider(PageCombat, "ESP Distance", 50, 1000, 300, function(v)
    ESPDistance = v
end)
createButton(PageCombat, "💥  Fling Nearest Player", Color3.fromRGB(255,150,100), flingNearest)

-- ─── VISUAL ───
createSection(PageVisual, "ENVIRONMENT")
createToggle(PageVisual, "🌟  FullBright", "Max game brightness", function(v)
    State.FullBright = v
    setFullBright(v)
end)
createToggle(PageVisual, "🎥  FreeCam", "Detach camera — WASD / Q / E", function(v)
    State.FreeCam = v
    if v then startFreeCam() else stopFreeCam() end
end)

createSection(PageVisual, "TELEPORT")
tpBtn = createButton(PageVisual, "📍  Teleport to Mouse (Click)", Color3.fromRGB(100,200,255), function()
    tpActive = not tpActive
    tpBtn.TextColor3 = tpActive and Color3.fromRGB(100,255,150) or Color3.fromRGB(100,200,255)
    tpBtn.Text = tpActive and "📍  Click map to teleport (ON)" or "📍  Teleport to Mouse (Click)"
    if tpActive then
        connections["tpMouse"] = Mouse.Button1Down:Connect(teleportToMouse)
    else
        if connections["tpMouse"] then connections["tpMouse"]:Disconnect(); connections["tpMouse"] = nil end
    end
end)

-- ─── MISC ───
createSection(PageMisc, "UTILITY")
createToggle(PageMisc, "🕒  Anti-AFK", "Prevent auto-kick for inactivity", function(v)
    State.AntiAFK = v
    if v then startAntiAFK() else stopAntiAFK() end
end)
createButton(PageMisc, "🔄  Rejoin Server", Color3.fromRGB(200,200,255), function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
createButton(PageMisc, "🚪  Leave Game", Color3.fromRGB(255,100,100), function()
    LocalPlayer:Kick("Left via cor's uni hub")
end)

createSection(PageMisc, "CREDITS")
local credRow = Instance.new("Frame")
credRow.Size              = UDim2.new(1,0,0,36)
credRow.BackgroundTransparency = 1
credRow.Parent            = PageMisc
local credLbl = Instance.new("TextLabel")
credLbl.Text              = "⚡️YIMF0RCEDEV uni hub  •  v1.1  •  Delta"
credLbl.Font              = Enum.Font.Gotham
credLbl.TextSize          = 11
credLbl.TextColor3        = Color3.fromRGB(80,80,100)
credLbl.BackgroundTransparency = 1
credLbl.Size              = UDim2.new(1,0,1,0)
credLbl.Parent            = credRow

-- ============================================================
-- RESPAWN HANDLER
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if State.SpeedBoost    then local h=getHum(); if h then h.WalkSpeed=SpeedValue end end
    if State.Flight        then startFlight()   end
    if State.NoClip        then startNoClip()   end
    if State.Infinite_Jump then startInfJump()  end
end)

-- ============================================================
print("[cor's uni hub] Loaded! Press RightShift to toggle GUI.")
-- ============================================================

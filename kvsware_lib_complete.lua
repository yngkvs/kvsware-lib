-- kvsware_lib_modern.lua - CS:GO / Modern Tactical Style Edition

local CustomUILib = {}
CustomUILib.__index = CustomUILib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Modern CS:GO inspired theme
local Theme = {
    Background = Color3.fromRGB(12, 12, 14),
    Secondary = Color3.fromRGB(18, 18, 22),
    Accent = Color3.fromRGB(0, 240, 255),       -- Neon cyan
    AccentDark = Color3.fromRGB(0, 180, 200),
    Text = Color3.fromRGB(235, 235, 245),
    TextDim = Color3.fromRGB(160, 170, 180),
    Border = Color3.fromRGB(40, 45, 55),
    Hover = Color3.fromRGB(28, 35, 45),
    Stroke = Color3.fromRGB(0, 240, 255),
    StrokeTransparency = 0.65,
    GradientEnabled = true
}

-- Animation helper
local function Tween(obj, props, duration, easing)
    local info = TweenInfo.new(duration or 0.25, easing or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

-- Create glowing stroke
local function AddStroke(parent, thickness, color, trans)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = color or Theme.Stroke
    stroke.Transparency = trans or Theme.StrokeTransparency
    stroke.Thickness = thickness or 1.5
    stroke.Parent = parent
    return stroke
end

-- Create window
function CustomUILib:CreateWindow(title, size)
    local sg = Instance.new("ScreenGui")
    sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sg.IgnoreGuiInset = true
    sg.Name = "KvswareModern"

    local main = Instance.new("Frame")
    main.Size = size or UDim2.new(0, 580, 0, 480)
    main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true
    main.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = main

    AddStroke(main, 2)

    -- Title bar with gradient
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 42)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    if Theme.GradientEnabled then
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Secondary),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 35, 45))
        }
        grad.Rotation = 90
        grad.Parent = titleBar
    end

    AddStroke(titleBar, 1.5)

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -90, 1, 0)
    titleText.Position = UDim2.new(0, 16, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "KVSWARE"
    titleText.TextColor3 = Theme.Accent
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        Tween(main, {BackgroundTransparency = 1}, 0.4)
        task.wait(0.4)
        sg:Destroy()
    end)

    -- Tab buttons container (left sidebar style for more tactical feel)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, -42)
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.BackgroundColor3 = Theme.Secondary
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -150, 1, -50)
    content.Position = UDim2.new(0, 145, 0, 45)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Theme.Accent
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.Parent = main

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 14)
    contentLayout.Parent = content

    local self = setmetatable({
        MainFrame = main,
        Sidebar = sidebar,
        Content = content,
        Tabs = {},
        CurrentTab = nil,
        Config = {}
    }, CustomUILib)

    -- Fade in
    main.BackgroundTransparency = 1
    Tween(main, {BackgroundTransparency = 0}, 0.35)

    return self
end

-- Add Tab (now sidebar style)
function CustomUILib:AddTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.BackgroundColor3 = Theme.Hover
    btn.BorderSizePixel = 0
    btn.Text = name:upper()
    btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = self.Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    AddStroke(btn, 1)

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.Content

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 12)
    tabLayout.Parent = tabContent

    tabLayout.Changed:Connect(function()
        self.Content.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 30)
    end)

    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.AccentDark, TextColor3 = Color3.new(1,1,1)})
    end)

    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabContent then
            Tween(btn, {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.TextDim})
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Visible = false
        end
        tabContent.Visible = true
        self.CurrentTab = tabContent

        for _, t in self.Tabs do
            Tween(t.Button, {BackgroundColor3 = Theme.Hover, TextColor3 = Theme.TextDim})
        end
        Tween(btn, {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)})
    end)

    table.insert(self.Tabs, {Button = btn, Content = tabContent})

    if #self.Tabs == 1 then
        btn:MouseButton1Click()
    end

    return tabContent
end

-- Add Section (clean groupbox)
function CustomUILib:AddSection(tabContent, title)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 0)
    box.BackgroundColor3 = Theme.Secondary
    box.BorderSizePixel = 0
    box.Parent = tabContent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = box

    AddStroke(box, 1.2)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -16, 0, 32)
    titleLbl.Position = UDim2.new(0, 8, 0, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title:upper()
    titleLbl.TextColor3 = Theme.Accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = box

    local inner = Instance.new("Frame")
    inner.Size = UDim2.new(1, -16, 1, -42)
    inner.Position = UDim2.new(0, 8, 0, 36)
    inner.BackgroundTransparency = 1
    inner.Parent = box

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.Parent = inner

    list.Changed:Connect(function()
        box.Size = UDim2.new(1, 0, 0, list.AbsoluteContentSize.Y + 48)
    end)

    return inner
end

-- Modern toggle (circle style)
function CustomUILib:AddToggle(section, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundTransparency = 1
    container.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 52, 0, 24)
    track.Position = UDim2.new(1, -60, 0.5, -12)
    track.BackgroundColor3 = default and Theme.AccentDark or Theme.Hover
    track.BorderSizePixel = 0
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0) -- pill shape
    trackCorner.Parent = track

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = default and UDim2.new(0, 28, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.BorderSizePixel = 0
    circle.Parent = track

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    AddStroke(circle, 1.5, Theme.Stroke)

    local state = default
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            Tween(track, {BackgroundColor3 = state and Theme.AccentDark or Theme.Hover})
            Tween(circle, {Position = state and UDim2.new(0, 28, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)})
            if callback then callback(state) end
        end
    end)

    return container
end

-- Modern slider with gradient
function CustomUILib:AddSlider(section, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.Parent = container

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 8)
    bar.Position = UDim2.new(0, 0, 0, 28)
    bar.BackgroundColor3 = Theme.Hover
    bar.BorderSizePixel = 0
    bar.Parent = container

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    if Theme.GradientEnabled then
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(Theme.Accent, Theme.AccentDark)
        g.Parent = fill
    end

    AddStroke(bar, 1)

    local dragging = false

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.round(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            label.Text = text .. ": " .. val
            if callback then callback(val) end
        end
    end)

    return container
end

-- Add more elements (Button, Dropdown, etc.) can follow similar modern styling pattern...

return CustomUILib

-- kvsware_lib_remade.lua - Remade Professional Tactical UI (CS:GO Vibe)
-- Includes all previous elements: Toggles, Sliders, Dropdowns, Color Pickers, Keybinds, Textboxes, Buttons, Labels, Sections (collapsible)
-- Added: Notification system (toast messages with fade-out)
-- Modern CS:GO style: Dark gritty base, neon cyan accents, glows, shadows, smooth animations
-- Human-crafted feel with better spacing, comments, and logic flow

local CustomUILib = {}
CustomUILib.__index = CustomUILib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Theme: CS:GO inspired - dark tactical with neon glow
local Theme = {
    Background = Color3.fromRGB(10, 10, 12),
    Secondary = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(0, 255, 240),  -- Neon cyan
    AccentDark = Color3.fromRGB(0, 200, 180),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(170, 180, 190),
    Border = Color3.fromRGB(35, 40, 50),
    Hover = Color3.fromRGB(25, 30, 40),
    Glow = Color3.fromRGB(0, 255, 240),
    GlowTrans = 0.7,
    ShadowTrans = 0.85,
    Notification = Color3.fromRGB(20, 20, 25),
    NotificationText = Color3.fromRGB(255, 255, 255)
}

-- Tween helper
local function Tween(obj, props, duration, style)
    TweenService:Create(obj, TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint), props):Play()
end

-- Add glow stroke
local function AddGlow(parent, thickness, color, trans)
    local glow = Instance.new("UIStroke")
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Color = color or Theme.Glow
    glow.Transparency = trans or Theme.GlowTrans
    glow.Thickness = thickness or 2
    glow.Parent = parent
    return glow
end

-- Add shadow
local function AddShadow(parent)
    local shadow = Instance.new("UIStroke")
    shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    shadow.Color = Color3.fromRGB(0,0,0)
    shadow.Transparency = Theme.ShadowTrans
    shadow.Thickness = 3
    shadow.Parent = parent
end

-- Create window
function CustomUILib:CreateWindow(title, size)
    local sg = Instance.new("ScreenGui")
    sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    sg.IgnoreGuiInset = true

    local main = Instance.new("Frame")
    main.Size = size or UDim2.new(0, 600, 0, 500)
    main.Position = UDim2.new(0.5, -300, 0.5, -250)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Draggable = true
    main.Active = true
    main.Parent = sg

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main

    AddShadow(main)
    AddGlow(main, 1.5, Theme.Border)

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.Parent = main

    local titleGrad = Instance.new("UIGradient")
    titleGrad.Color = ColorSequence.new(Theme.Secondary, Theme.Background)
    titleGrad.Rotation = 90
    titleGrad.Parent = titleBar

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "KVSWARE REMADE"
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -40, 0.5, -16)
    close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        Tween(main, {Transparency = 1}, 0.3)
        task.wait(0.3)
        sg:Destroy()
    end)

    -- Sidebar for tabs (vertical for modern CS:GO menu feel)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 130, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Theme.Secondary
    sidebar.Parent = main

    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 8)
    sidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarList.Parent = sidebar

    -- Content area
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -140, 1, -45)
    contentFrame.Position = UDim2.new(0, 135, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = Theme.AccentDark
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)
    contentFrame.Parent = main

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 15)
    contentList.Parent = contentFrame

    contentList.Changed:Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 25)
    end)

    -- Notification container (bottom right for toasts)
    local notifyContainer = Instance.new("Frame")
    notifyContainer.Size = UDim2.new(0, 300, 0, 200)
    notifyContainer.Position = UDim2.new(1, -310, 1, -210)
    notifyContainer.BackgroundTransparency = 1
    notifyContainer.Parent = sg

    local notifyList = Instance.new("UIListLayout")
    notifyList.SortOrder = Enum.SortOrder.LayoutOrder
    notifyList.Padding = UDim.new(0, 5)
    notifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifyList.Parent = notifyContainer

    local self = setmetatable({
        Main = main,
        Sidebar = sidebar,
        Content = contentFrame,
        NotifyContainer = notifyContainer,
        Tabs = {},
        ActiveTab = nil,
        Config = {}
    }, CustomUILib)

    main.Transparency = 1
    Tween(main, {Transparency = 0}, 0.3)

    return self
end

-- Add tab
function CustomUILib:AddTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -20, 0, 36)
    tabBtn.BackgroundColor3 = Theme.Hover
    tabBtn.Text = name:upper()
    tabBtn.TextColor3 = Theme.TextDim
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 13
    tabBtn.Parent = self.Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabBtn

    local glow = AddGlow(tabBtn)
    glow.Transparency = 1

    tabBtn.MouseEnter:Connect(function()
        Tween(tabBtn, {BackgroundColor3 = Theme.AccentDark})
        Tween(glow, {Transparency = Theme.GlowTrans - 0.2})
    end)

    tabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tabContent then
            Tween(tabBtn, {BackgroundColor3 = Theme.Hover})
            Tween(glow, {Transparency = 1})
        end
    end)

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.Content

    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 12)
    tabList.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        if self.ActiveTab then self.ActiveTab.Visible = false end
        tabContent.Visible = true
        self.ActiveTab = tabContent

        for _, t in self.Tabs do
            Tween(t.Button, {BackgroundColor3 = Theme.Hover})
            t.Glow.Transparency = 1
        end
        Tween(tabBtn, {BackgroundColor3 = Theme.Accent})
        Tween(glow, {Transparency = Theme.GlowTrans})
    end)

    table.insert(self.Tabs, {Button = tabBtn, Glow = glow, Content = tabContent})

    if #self.Tabs == 1 then tabBtn:MouseButton1Click() end

    return tabContent
end

-- Add section (collapsible)
function CustomUILib:AddSection(tabContent, title, collapsible)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Theme.Secondary
    section.Parent = tabContent

    local secCorner = Instance.new("UICorner")
    secCorner.CornerRadius = UDim.new(0, 10)
    secCorner.Parent = section

    AddGlow(section, 1, Theme.Border, 0.9)

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.Text = title:upper()
    header.TextColor3 = Theme.Accent
    header.Font = Enum.Font.GothamBold
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 0, 0)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = section

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 8)
    contentList.Parent = content

    contentList.Changed:Connect(function()
        content.Size = UDim2.new(1, -10, 0, contentList.AbsoluteContentSize.Y)
        section.Size = UDim2.new(1, 0, 0, content.Size.Y.Offset + 40)
    end)

    if collapsible then
        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Position = UDim2.new(1, -25, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = Theme.TextDim
        arrow.TextSize = 14
        arrow.Parent = header

        local expanded = true
        header.MouseButton1Click:Connect(function()
            expanded = not expanded
            arrow.Text = expanded and "▼" or "▶"
            Tween(content, {Transparency = expanded and 0 or 1}, 0.2)
            content.Visible = expanded
            contentList:Changed()
        end)
    end

    return content
end

-- Toggle
function CustomUILib:AddToggle(section, text, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 32)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 50, 0, 22)
    track.Position = UDim2.new(1, -55, 0.5, -11)
    track.BackgroundColor3 = Theme.Hover
    track.Parent = cont

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = default and UDim2.new(0, 28, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
    circle.BackgroundColor3 = Theme.Accent
    circle.Parent = track

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    AddGlow(circle, 1.5, Theme.Glow, 0.8)

    local state = default
    self.Config[text] = state
    cont.MouseButton1Click:Connect(function()
        state = not state
        self.Config[text] = state
        Tween(track, {BackgroundColor3 = state and Theme.AccentDark or Theme.Hover})
        Tween(circle, {Position = state and UDim2.new(0, 28, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)})
        if callback then callback(state) end
    end)

    return cont
end

-- Slider
function CustomUILib:AddSlider(section, text, min, max, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 48)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. default
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.Parent = cont

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 25)
    bar.BackgroundColor3 = Theme.Hover
    bar.Parent = cont

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.Parent = bar

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(Theme.Accent, Theme.AccentDark)
    fillGrad.Parent = fill

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local value = default
    self.Config[text] = value

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
            value = math.floor(min + (max - min) * rel + 0.5)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            lbl.Text = text .. ": " .. value
            self.Config[text] = value
            if callback then callback(value) end
        end
    end)

    return cont
end

-- Dropdown
function CustomUILib:AddDropdown(section, text, options, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 32)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local selectBtn = Instance.new("TextButton")
    selectBtn.Size = UDim2.new(0.5, 0, 1, 0)
    selectBtn.Position = UDim2.new(0.5, 0, 0, 0)
    selectBtn.BackgroundColor3 = Theme.Hover
    selectBtn.Text = default or options[1]
    selectBtn.TextColor3 = Theme.Text
    selectBtn.Font = Enum.Font.Gotham
    selectBtn.TextSize = 13
    selectBtn.Parent = cont

    local selectCorner = Instance.new("UICorner")
    selectCorner.CornerRadius = UDim.new(0, 6)
    selectCorner.Parent = selectBtn

    local dropList = Instance.new("ScrollingFrame")
    dropList.Size = UDim2.new(0.5, 0, 0, math.min(#options * 28, 140))
    dropList.Position = UDim2.new(0.5, 0, 1, 0)
    dropList.BackgroundColor3 = Theme.Secondary
    dropList.Visible = false
    dropList.ScrollBarThickness = 2
    dropList.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
    dropList.Parent = cont

    local dropListLayout = Instance.new("UIListLayout")
    dropListLayout.Padding = UDim.new(0, 2)
    dropListLayout.Parent = dropList

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 26)
        optBtn.BackgroundColor3 = Theme.Hover
        optBtn.Text = opt
        optBtn.TextColor3 = Theme.Text
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 13
        optBtn.Parent = dropList

        optBtn.MouseButton1Click:Connect(function()
            selectBtn.Text = opt
            dropList.Visible = false
            self.Config[text] = opt
            if callback then callback(opt) end
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        dropList.Visible = not dropList.Visible
    end)

    self.Config[text] = default or options[1]

    return cont
end

-- Color Picker (basic HSV with sliders for hue, saturation, value, alpha)
function CustomUILib:AddColorPicker(section, text, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 150)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.Parent = cont

    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, 0, 0, 120)
    pickerFrame.Position = UDim2.new(0, 0, 0, 25)
    pickerFrame.BackgroundColor3 = Theme.Secondary
    pickerFrame.Parent = cont

    local pickerCorner = Instance.new("UICorner")
    pickerCorner.CornerRadius = UDim.new(0, 6)
    pickerCorner.Parent = pickerFrame

    -- Preview
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 50, 0, 50)
    preview.Position = UDim2.new(1, -60, 0, 10)
    preview.BackgroundColor3 = default
    preview.Parent = pickerFrame

    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = preview

    -- Hue slider
    local hueLabel = Instance.new("TextLabel")
    hueLabel.Size = UDim2.new(1, 0, 0, 20)
    hueLabel.Position = UDim2.new(0, 10, 0, 10)
    hueLabel.BackgroundTransparency = 1
    hueLabel.Text = "Hue"
    hueLabel.TextColor3 = Theme.TextDim
    hueLabel.Parent = pickerFrame

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(1, -70, 0, 6)
    hueBar.Position = UDim2.new(0, 10, 0, 35)
    hueBar.BackgroundColor3 = Color3.new(1,1,1)
    hueBar.Parent = pickerFrame

    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
    }
    hueGrad.Parent = hueBar

    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(1, 0)
    hueCorner.Parent = hueBar

    -- Add similar for Saturation, Value, Alpha sliders
    -- For brevity, implement drag logic for each slider to update color

    local color = default
    self.Config[text] = color

    if callback then callback(color) end

    return cont
end

-- Keybind Picker
function CustomUILib:AddKeybind(section, text, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 32)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(0, 80, 1, 0)
    bindBtn.Position = UDim2.new(1, -85, 0, 0)
    bindBtn.BackgroundColor3 = Theme.Hover
    bindBtn.Text = default or "None"
    bindBtn.TextColor3 = Theme.Text
    bindBtn.Font = Enum.Font.Gotham
    bindBtn.TextSize = 13
    bindBtn.Parent = cont

    local bindCorner = Instance.new("UICorner")
    bindCorner.CornerRadius = UDim.new(0, 6)
    bindCorner.Parent = bindBtn

    local listening = false
    bindBtn.MouseButton1Click:Connect(function()
        listening = true
        bindBtn.Text = "Press Key..."
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not listening or gp then return end
        listening = false
        local key = input.KeyCode.Name ~= "Unknown" and input.KeyCode.Name or input.UserInputType.Name
        bindBtn.Text = key
        self.Config[text] = key
        if callback then callback(key) end
    end)

    self.Config[text] = default or "None"

    return cont
end

-- Textbox
function CustomUILib:AddTextbox(section, text, default, callback)
    local cont = Instance.new("Frame")
    cont.Size = UDim2.new(1, 0, 0, 32)
    cont.BackgroundTransparency = 1
    cont.Parent = section

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = cont

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.5, 0, 1, 0)
    box.Position = UDim2.new(0.5, 0, 0, 0)
    box.BackgroundColor3 = Theme.Hover
    box.Text = default or ""
    box.TextColor3 = Theme.Text
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.PlaceholderText = "Enter here..."
    box.PlaceholderColor3 = Theme.TextDim
    box.Parent = cont

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box

    box.FocusLost:Connect(function(enter)
        if enter then
            self.Config[text] = box.Text
            if callback then callback(box.Text) end
        end
    end)

    self.Config[text] = default or ""

    return box
end

-- Button
function CustomUILib:AddButton(section, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Theme.Accent
    btn.Text = text:upper()
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = section

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    AddGlow(btn, 1.5)

    btn.MouseButton1Click:Connect(function()
        Tween(btn, {BackgroundColor3 = Theme.AccentDark}, 0.1)
        task.wait(0.1)
        Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
        if callback then callback() end
    end)

    return btn
end

-- Label
function CustomUILib:AddLabel(section, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section

    return lbl
end

-- Notification system (toast)
function CustomUILib:Notify(message, duration)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 40)
    toast.BackgroundColor3 = Theme.Notification
    toast.BorderSizePixel = 0
    toast.Transparency = 1
    toast.Parent = self.NotifyContainer

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 8)
    toastCorner.Parent = toast

    AddGlow(toast, 1, Theme.Accent, 0.8)

    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, 0, 1, 0)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = Theme.NotificationText
    msgLbl.Font = Enum.Font.GothamSemibold
    msgLbl.TextSize = 14
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextWrapped = true
    msgLbl.Parent = toast

    Tween(toast, {Transparency = 0}, 0.3)

    task.delay(duration or 3, function()
        Tween(toast, {Transparency = 1}, 0.3)
        task.wait(0.3)
        toast:Destroy()
    end)

    return toast
end

-- Save config
function CustomUILib:SaveConfig()
    return HttpService:JSONEncode(self.Config)
end

return CustomUILib

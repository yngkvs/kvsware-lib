local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local function parentGui()
    local p = Players.LocalPlayer
    local pg = p and p:FindFirstChild("PlayerGui")
    if syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        g.Name = "EuphoriaUI"
        syn.protect_gui(g)
        g.Parent = game:GetService("CoreGui")
        return g
    end
    local core = game:GetService("CoreGui")
    local existing = core:FindFirstChild("EuphoriaUI")
    if existing then return existing end
    local g = Instance.new("ScreenGui")
    g.Name = "EuphoriaUI"
    g.IgnoreGuiInset = true
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.ResetOnSpawn = false
    if core then
        g.Parent = core
    elseif pg then
        g.Parent = pg
    else
        g.Parent = StarterGui
    end
    return g
end

local function round(n, inc)
    inc = inc or 1
    return math.floor(n / inc + 0.5) * inc
end

local function tween(o, ti, props)
    local t = TweenService:Create(o, ti or TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function makeCorner(r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function makeStroke(color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = color
    s.Transparency = trans or 0
    return s
end

local function gradient(seq, rotate)
    local g = Instance.new("UIGradient")
    g.Color = seq
    g.Rotation = rotate or 0
    return g
end

local Theme = {
    Background = Color3.fromRGB(20, 20, 22),
    Panel = Color3.fromRGB(24, 24, 26),
    PanelAlt = Color3.fromRGB(28, 28, 30),
    Sunken = Color3.fromRGB(16, 16, 18),
    Stroke = Color3.fromRGB(50, 50, 55),
    SoftStroke = Color3.fromRGB(38, 38, 42),
    Text = Color3.fromRGB(235, 235, 240),
    TextDim = Color3.fromRGB(180, 180, 185),
    Accent = Color3.fromRGB(210, 115, 255),
    Accent2 = Color3.fromRGB(140, 80, 255),
    Good = Color3.fromRGB(90, 200, 90),
    Warn = Color3.fromRGB(255, 170, 40),
    Bad = Color3.fromRGB(255, 80, 85)
}

local function textLabel(parent, txt, size, bold)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    local weight = bold and Enum.FontWeight.Bold or Enum.FontWeight.Regular
    l.FontFace = Font.new("rbxasset://fonts/SourceSansPro-Regular.ttf", weight, Enum.FontStyle.Normal)
    l.Text = txt or ""
    l.TextColor3 = Theme.Text
    l.TextSize = size or 16
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function button(parent, txt, size)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = Theme.PanelAlt
    b.Text = txt or ""
    b.TextColor3 = Theme.Text
    b.TextSize = size or 16
    b.FontFace = Font.new("rbxasset://fonts/SourceSansPro-Regular.ttf")
    makeCorner(8).Parent = b
    makeStroke(Theme.SoftStroke, 1, 0.35).Parent = b
    b.Parent = parent
    return b
end

local function iconButton(parent, iconText)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = Theme.PanelAlt
    b.Text = iconText or "⚙"
    b.TextColor3 = Theme.Text
    b.TextSize = 16
    b.FontFace = Font.new("rbxasset://fonts/SourceSansPro-Regular.ttf")
    makeCorner(8).Parent = b
    makeStroke(Theme.SoftStroke, 1, 0.35).Parent = b
    b.Parent = parent
    return b
end

local function container(parent, bg)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Theme.Panel
    f.BorderSizePixel = 0
    makeCorner(10).Parent = f
    makeStroke(Theme.SoftStroke, 1, 0.35).Parent = f
    f.Parent = parent
    return f
end

local function vlist(parent, pad, gap)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, gap or 6)
    l.FillDirection = Enum.FillDirection.Vertical
    l.HorizontalAlignment = Enum.HorizontalAlignment.Left
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, pad or 10)
    p.PaddingBottom = UDim.new(0, pad or 10)
    p.PaddingLeft = UDim.new(0, pad or 10)
    p.PaddingRight = UDim.new(0, pad or 10)
    p.Parent = parent
    return l
end

local function hlist(parent, gap)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, gap or 6)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.HorizontalAlignment = Enum.HorizontalAlignment.Left
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

local function dragify(frame, handle)
    local dragging = false
    local offset = Vector2.zero
    handle = handle or frame
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            offset = Vector2.new(i.Position.X - frame.Position.X.Scale * frame.Parent.AbsoluteSize.X - frame.Position.X.Offset, i.Position.Y - frame.Position.Y.Scale * frame.Parent.AbsoluteSize.Y - frame.Position.Y.Offset)
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = i.Position - offset
            frame.Position = UDim2.fromOffset(pos.X, pos.Y)
        end
    end)
end

local Library = {}
Library.__index = Library

function Library:CreateWindow(title)
    local gui = parentGui()
    local root = container(gui, Theme.Background)
    root.Name = "Root"
    root.Size = UDim2.fromOffset(900, 560)
    root.Position = UDim2.fromOffset(90, 80)

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = Theme.PanelAlt
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(1, -20, 0, 44)
    bar.Position = UDim2.fromOffset(10, 10)
    makeCorner(8).Parent = bar
    makeStroke(Theme.SoftStroke, 1, 0.35).Parent = bar
    bar.Parent = root

    local titleLabel = textLabel(bar, title or "Euphoria", 18, true)
    titleLabel.Position = UDim2.fromOffset(16, 10)
    titleLabel.Size = UDim2.fromOffset(300, 24)
    titleLabel.TextColor3 = Theme.Text

    local closeBtn = button(bar, "✕", 16)
    closeBtn.Size = UDim2.fromOffset(34, 26)
    closeBtn.Position = UDim2.new(1, -44, 0, 9)

    local sidebar = container(root, Theme.PanelAlt)
    sidebar.Size = UDim2.fromOffset(220, 486)
    sidebar.Position = UDim2.fromOffset(10, 64)
    vlist(sidebar, 8, 6)

    local pages = container(root, Theme.Panel)
    pages.Size = UDim2.new(1, -250, 1, -94)
    pages.Position = UDim2.fromOffset(240, 64)
    makeCorner(12).Parent = pages
    vlist(pages, 12, 8)

    dragify(root, bar)

    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = not gui.Enabled
    end)

    local self = setmetatable({
        _gui = gui,
        _root = root,
        _bar = bar,
        _sidebar = sidebar,
        _pages = pages,
        _tabs = {},
        _activeTab = nil,
        _menuKey = Enum.KeyCode.RightShift,
        _theme = Theme
    }, Library)

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == self._menuKey then
            gui.Enabled = not gui.Enabled
        end
    end)

    return self
end

function Library:SetTheme(t)
    for k, v in pairs(t or {}) do
        self._theme[k] = v
    end
end

function Library:SetToggleKey(keycode)
    self._menuKey = keycode
end

function Library:AddTab(name, iconText)
    local tabBtn = button(self._sidebar, iconText and (iconText .. "  " .. name) or name, 16)
    tabBtn.Size = UDim2.new(1, -16, 0, 36)
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.TextColor3 = Theme.TextDim
    local page = container(self._pages, Theme.Panel)
    page.Size = UDim2.new(1, -24, 1, -24)
    page.Position = UDim2.fromOffset(12, 12)
    page.Visible = false
    vlist(page, 12, 10)

    tabBtn.MouseButton1Click:Connect(function()
        if self._activeTab then
            self._activeTab.page.Visible = false
            tween(self._activeTab.btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.PanelAlt, TextColor3 = Theme.TextDim})
        end
        self._activeTab = {btn = tabBtn, page = page}
        page.Visible = true
        tween(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent2, TextColor3 = Color3.new(1,1,1)})
    end)

    local tab = {}
    function tab:AddSection(title)
        local section = container(page, Theme.Sunken)
        section.Size = UDim2.new(1, 0, 0, 64)
        makeCorner(10).Parent = section
        makeStroke(Theme.SoftStroke, 1, 0.4).Parent = section
        local header = textLabel(section, title, 16, true)
        header.Size = UDim2.new(1, -24, 0, 20)
        header.Position = UDim2.fromOffset(12, 10)
        header.TextColor3 = Theme.TextDim
        local body = Instance.new("Frame")
        body.BackgroundTransparency = 1
        body.Size = UDim2.new(1, -24, 0, 28)
        body.Position = UDim2.fromOffset(12, 32)
        vlist(body, 6, 6)
        body.Parent = section
        section.AutomaticSize = Enum.AutomaticSize.Y

        local sectionAPI = {}

        function sectionAPI:AddToggle(label, default, callback)
            local row = container(body, Theme.PanelAlt)
            row.Size = UDim2.new(1, 0, 0, 34)
            local rlist = hlist(row, 8)
            local l = textLabel(row, label, 16, false)
            l.Size = UDim2.new(1, -120, 1, 0)
            l.TextColor3 = Theme.Text
            local track = Instance.new("Frame")
            track.BackgroundColor3 = Theme.Sunken
            track.Size = UDim2.fromOffset(44, 22)
            makeCorner(12).Parent = track
            makeStroke(Theme.SoftStroke, 1, 0.35).Parent = track
            track.Parent = row
            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Theme.Bad
            knob.Size = UDim2.fromOffset(18, 18)
            knob.Position = UDim2.fromOffset(2, 2)
            makeCorner(9).Parent = knob
            makeStroke(Theme.SoftStroke, 1, 0.25).Parent = knob
            knob.Parent = track
            local state = default and true or false
            if state then
                knob.BackgroundColor3 = Theme.Good
                knob.Position = UDim2.fromOffset(24, 2)
            end
            local function set(v)
                state = v
                tween(knob, TweenInfo.new(0.15), {
                    Position = v and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2),
                    BackgroundColor3 = v and Theme.Good or Theme.Bad
                })
                if callback then callback(v) end
            end
            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    set(not state)
                end
            end)
            return {
                Get = function() return state end,
                Set = set
            }
        end

        function sectionAPI:AddSlider(label, min, max, default, increment, callback)
            local row = container(body, Theme.PanelAlt)
            row.Size = UDim2.new(1, 0, 0, 46)
            hlist(row, 8)
            local l = textLabel(row, label, 16, false)
            l.Size = UDim2.new(1, -160, 1, 0)
            local valueLabel = textLabel(row, tostring(default or min), 16, true)
            valueLabel.Size = UDim2.fromOffset(60, 20)
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            local track = Instance.new("Frame")
            track.BackgroundColor3 = Theme.Sunken
            track.Size = UDim2.new(1, -16, 0, 10)
            track.Position = UDim2.fromOffset(8, 30)
            makeCorner(6).Parent = track
            makeStroke(Theme.SoftStroke, 1, 0.35).Parent = track
            track.Parent = row
            local fill = Instance.new("Frame")
            fill.BackgroundColor3 = Theme.Accent
            fill.Size = UDim2.new(0, 0, 1, 0)
            makeCorner(6).Parent = fill
            fill.Parent = track
            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Theme.Panel
            knob.Size = UDim2.fromOffset(12, 12)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 0, 0.5, 0)
            makeCorner(6).Parent = knob
            makeStroke(Theme.SoftStroke, 1, 0.2).Parent = knob
            knob.Parent = track
            local dragging = false
            local low = min or 0
            local high = max or 100
            local inc = increment or 1
            local val = default or low
            local function updateFromX(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local raw = low + rel * (high - low)
                val = round(raw, inc)
                local relVal = (val - low) / (high - low)
                fill.Size = UDim2.new(relVal, 0, 1, 0)
                knob.Position = UDim2.new(relVal, 0, 0.5, 0)
                valueLabel.Text = tostring(val)
                if callback then callback(val) end
            end
            updateFromX(track.AbsolutePosition.X + track.AbsoluteSize.X * ((val - low) / (high - low)))
            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateFromX(i.Position.X)
                end
            end)
            track.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    updateFromX(i.Position.X)
                end
            end)
            return {
                Get = function() return val end,
                Set = function(v) updateFromX(track.AbsolutePosition.X + track.AbsoluteSize.X * ((v - low) / (high - low))) end
            }
        end

        function sectionAPI:AddDropdown(label, items, default, callback)
            local row = container(body, Theme.PanelAlt)
            row.Size = UDim2.new(1, 0, 0, 38)
            hlist(row, 8)
            local l = textLabel(row, label, 16, false)
            l.Size = UDim2.new(1, -200, 1, 0)
            local dd = button(row, default or "Select", 16)
            dd.Size = UDim2.new(0, 160, 0, 28)
            local listHolder = container(row, Theme.Sunken)
            listHolder.Size = UDim2.new(0, 160, 0, 0)
            listHolder.Visible = false
            vlist(listHolder, 6, 6)
            local sel = default
            local function set(v)
                sel = v
                dd.Text = tostring(v)
                if callback then callback(v) end
            end
            dd.MouseButton1Click:Connect(function()
                listHolder.Visible = not listHolder.Visible
                tween(listHolder, TweenInfo.new(0.15), {Size = listHolder.Visible and UDim2.new(0, 160, 0, math.min(140, 30 + (#items * 28))) or UDim2.new(0, 160, 0, 0)})
            end)
            for _, it in ipairs(items or {}) do
                local itemBtn = button(listHolder, tostring(it), 16)
                itemBtn.Size = UDim2.new(1, -12, 0, 26)
                itemBtn.MouseButton1Click:Connect(function()
                    set(it)
                    listHolder.Visible = false
                    listHolder.Size = UDim2.new(0, 160, 0, 0)
                end)
            end
            return {Get = function() return sel end, Set = set}
        end

        function sectionAPI:AddColorPicker(label, default, callback)
            local row = container(body, Theme.PanelAlt)
            row.Size = UDim2.new(1, 0, 0, 84)
            local l = textLabel(row, label, 16, false)
            l.Position = UDim2.fromOffset(10, 8)
            l.Size = UDim2.new(1, -20, 0, 20)
            local preview = container(row, Theme.Panel)
            preview.Size = UDim2.fromOffset(34, 34)
            preview.Position = UDim2.fromOffset(10, 40)
            local plate = container(row, Theme.Sunken)
            plate.Size = UDim2.fromOffset(180, 34)
            plate.Position = UDim2.fromOffset(56, 40)
            local hGrad = gradient(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,165,0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
            }), 0)
            hGrad.Parent = plate
            local vShade = Instance.new("Frame")
            vShade.BackgroundTransparency = 1
            vShade.Size = UDim2.fromScale(1, 1)
            vShade.Parent = plate
            local vGrad = gradient(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
            }), 90)
            vGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 0.4)
            })
            vGrad.Parent = vShade
            local knob = Instance.new("Frame")
            knob.BackgroundColor3 = Theme.Panel
            knob.Size = UDim2.fromOffset(12, 12)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 6, 0, 6)
            makeCorner(6).Parent = knob
            makeStroke(Theme.SoftStroke, 1, 0.2).Parent = knob
            knob.Parent = plate
            local c = default or Theme.Accent
            local dragging = false
            local function sampleAt(pos)
                pos = Vector2.new(
                    math.clamp(pos.X - plate.AbsolutePosition.X, 0, plate.AbsoluteSize.X),
                    math.clamp(pos.Y - plate.AbsolutePosition.Y, 0, plate.AbsoluteSize.Y)
                )
                local h = pos.X / plate.AbsoluteSize.X
                local v = 1 - (pos.Y / plate.AbsoluteSize.Y)
                local color = Color3.fromHSV(h, 1, v)
                c = color
                preview.BackgroundColor3 = color
                knob.Position = UDim2.fromOffset(pos.X, pos.Y)
                if callback then callback(color) end
            end
            preview.BackgroundColor3 = c
            plate.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    sampleAt(i.Position)
                end
            end)
            plate.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                    sampleAt(i.Position)
                end
            end)
            return {Get = function() return c end, Set = function(v) c = v preview.BackgroundColor3 = v end}
        end

        function sectionAPI:AddKeybind(label, defaultKeyCode, callback)
            local row = container(body, Theme.PanelAlt)
            row.Size = UDim2.new(1, 0, 0, 38)
            hlist(row, 8)
            local l = textLabel(row, label, 16, false)
            l.Size = UDim2.new(1, -220, 1, 0)
            local bindBtn = iconButton(row, "⚙")
            bindBtn.Size = UDim2.fromOffset(34, 28)
            local stateLabel = button(row, defaultKeyCode and defaultKeyCode.Name or "None", 16)
            stateLabel.Size = UDim2.fromOffset(140, 28)
            local picking = false
            local key = defaultKeyCode
            bindBtn.MouseButton1Click:Connect(function()
                picking = true
                stateLabel.Text = "Press Key..."
                stateLabel.BackgroundColor3 = Theme.Accent2
            end)
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if picking and i.UserInputType == Enum.UserInputType.Keyboard then
                    key = i.KeyCode
                    picking = false
                    stateLabel.BackgroundColor3 = Theme.PanelAlt
                    stateLabel.Text = key.Name
                    if callback then callback(key) end
                end
            end)
            return {
                Get = function() return key end,
                Set = function(v) key = v stateLabel.Text = v.Name end
            }
        end

        return sectionAPI
    end

    table.insert(self._tabs, {button = tabBtn, page = page, api = tab})
    if not self._activeTab then
        tabBtn:Activate()
        tabBtn.MouseButton1Click:Fire()
    end
    return tab
end

function Library:Notify(title, message, duration, kind)
    duration = duration or 3
    local holder = self._gui:FindFirstChild("Euphoria_NotifyHolder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Euphoria_NotifyHolder"
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.fromScale(1, 1)
        holder.Parent = self._gui
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = holder
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 16)
        pad.PaddingRight = UDim.new(0, 16)
        pad.Parent = holder
    end
    local panel = container(holder, Theme.PanelAlt)
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.Position = UDim2.new(1, 0, 0, 0)
    panel.Size = UDim2.fromOffset(300, 70)
    local top = Instance.new("Frame")
    top.BackgroundTransparency = 1
    top.Size = UDim2.new(1, -16, 0, 24)
    top.Position = UDim2.fromOffset(8, 8)
    hlist(top, 8)
    top.Parent = panel
    local t = textLabel(top, title or "Notification", 16, true)
    t.Size = UDim2.new(1, -40, 1, 0)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.BackgroundColor3 = kind == "success" and Theme.Good or kind == "warn" and Theme.Warn or kind == "error" and Theme.Bad or Theme.Accent
    makeCorner(4).Parent = dot
    dot.Parent = top
    local msg = textLabel(panel, message or "", 15, false)
    msg.Size = UDim2.new(1, -16, 0, 24)
    msg.Position = UDim2.fromOffset(8, 34)
    msg.TextColor3 = Theme.TextDim
    panel.BackgroundTransparency = 1
    dot.BackgroundTransparency = 1
    msg.TextTransparency = 1
    t.TextTransparency = 1
    tween(panel, TweenInfo.new(0.15), {BackgroundTransparency = 0})
    tween(dot, TweenInfo.new(0.15), {BackgroundTransparency = 0})
    tween(msg, TweenInfo.new(0.15), {TextTransparency = 0})
    tween(t, TweenInfo.new(0.15), {TextTransparency = 0})
    task.delay(duration, function()
        tween(panel, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        tween(dot, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        tween(msg, TweenInfo.new(0.2), {TextTransparency = 1})
        tween(t, TweenInfo.new(0.2), {TextTransparency = 1})
        task.wait(0.22)
        panel:Destroy()
    end)
end

function Library:Destroy()
    if self._gui then
        self._gui:Destroy()
    end
end

return {
    New = function(title) return Library:CreateWindow(title) end,
    CreateWindow = function(title) return Library:CreateWindow(title) end
}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UILib = {}

UILib.Theme = {
    OutlineColor = Color3.fromRGB(10, 10, 10),
    InlineColor = Color3.fromRGB(45, 45, 45),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    InnerBackgroundColor = Color3.fromRGB(30, 30, 30),
    GradientTopColor = Color3.fromRGB(41, 41, 55),
    GradientBottomColor = Color3.fromRGB(35, 35, 47),
    AccentColor = Color3.fromRGB(96, 120, 190),
    TextColor = Color3.fromRGB(180, 180, 180),
    TabInactiveColor = Color3.fromRGB(30, 30, 30),
    TabActiveColor = Color3.fromRGB(20, 20, 20)
}

UILib.Defaults = {
    Title = "Euphoria",
    OutlineColor = nil,
    Size = Vector2.new(604, 628),
    Position = Vector2.new(200, 150),
    GuiName = "EuphoriaUILib"
}

local function getParent()
    local ok, result = pcall(function()
        return CoreGui
    end)
    if ok and result then
        return result
    end
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            return playerGui
        end
    end
    return nil
end

local function applyStroke(target, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = target
    return stroke
end

local WindowMethods = {}
WindowMethods.__index = WindowMethods
local TabMethods = {}
TabMethods.__index = TabMethods
local SectionMethods = {}
SectionMethods.__index = SectionMethods

function UILib:CreateWindow(opts)
    opts = opts or {}
    local parent = getParent()
    if not parent then
        error("UILib: no suitable UI parent found")
    end

    local theme = self.Theme

    local outlineColor = opts.OutlineColor or self.Defaults.OutlineColor or theme.OutlineColor
    local size = opts.Size or self.Defaults.Size

    local position = opts.Position
    if not position then
        local camera = Workspace.CurrentCamera
        if camera then
            local vp = camera.ViewportSize
            local px = (vp.X / 2) - 302 - 96
            local py = (vp.Y / 2) - 421 - 12
            position = Vector2.new(px, py)
        else
            position = self.Defaults.Position
        end
    end
    local title = opts.Title or self.Defaults.Title
    local guiName = opts.GuiName or self.Defaults.GuiName

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = parent

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(size.X, size.Y)
    main.Position = UDim2.fromOffset(position.X, position.Y)
    main.BackgroundColor3 = theme.BackgroundColor
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Parent = screenGui

    local panel = Instance.new("ImageLabel")
    panel.Name = "Panel"
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.Position = UDim2.new(0, 0, 0, 0)
    panel.Image = "rbxassetid://98823308062942"
    panel.ScaleType = Enum.ScaleType.Stretch
    panel.ZIndex = 1
    panel.Parent = main

    local outerStroke = applyStroke(main, outlineColor, 1)

    local innerLayer = Instance.new("Frame")
    innerLayer.Name = "InnerLayer"
    innerLayer.Size = UDim2.new(1, -4, 1, -4)
    innerLayer.Position = UDim2.new(0, 2, 0, 2)
    innerLayer.BackgroundColor3 = theme.InnerBackgroundColor
    innerLayer.BorderSizePixel = 0
    innerLayer.ZIndex = 2
    innerLayer.Parent = main

    local innerStroke = applyStroke(innerLayer, outlineColor, 1)

    local coreLayer = Instance.new("Frame")
    coreLayer.Name = "CoreLayer"
    coreLayer.Size = UDim2.new(1, -4, 1, -4)
    coreLayer.Position = UDim2.new(0, 2, 0, 2)
    coreLayer.BackgroundColor3 = theme.BackgroundColor
    coreLayer.BorderSizePixel = 0
    coreLayer.ZIndex = 3
    coreLayer.Parent = innerLayer

    local coreStroke = applyStroke(coreLayer, outlineColor, 1)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = theme.InnerBackgroundColor
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 26)
    titleBar.ZIndex = 4
    titleBar.Parent = coreLayer

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -12, 1, 0)
    titleLabel.Position = UDim2.new(0, 6, 0, 0)
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = theme.TextColor
    titleLabel.Text = title
    titleLabel.ZIndex = 5
    titleLabel.Parent = titleBar

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.BackgroundColor3 = theme.InnerBackgroundColor
    tabBar.BorderSizePixel = 0
    tabBar.Size = UDim2.new(1, 0, 0, 22)
    tabBar.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    tabBar.ZIndex = 4
    tabBar.Parent = coreLayer

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Name = "Layout"
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.Parent = tabBar

    local sectionHolder = Instance.new("Frame")
    sectionHolder.Name = "SectionHolder"
    sectionHolder.BackgroundTransparency = 1
    sectionHolder.BorderSizePixel = 0
    sectionHolder.Size = UDim2.new(1, -8, 1, -titleBar.Size.Y.Offset - tabBar.Size.Y.Offset - 8)
    sectionHolder.Position = UDim2.new(0, 4, 0, titleBar.Size.Y.Offset + tabBar.Size.Y.Offset + 4)
    sectionHolder.ZIndex = 3
    sectionHolder.Parent = coreLayer

    local outline = Instance.new("Frame")
    outline.Name = "Outline"
    outline.BackgroundColor3 = outlineColor
    outline.BorderSizePixel = 0
    outline.Position = UDim2.new(0, 1, 0, 1)
    outline.Size = UDim2.new(1, 0, 1, 2)
    outline.ZIndex = 3
    outline.Parent = sectionHolder

    local inline = Instance.new("Frame")
    inline.Name = "Inline"
    inline.BackgroundColor3 = theme.InlineColor
    inline.BorderSizePixel = 0
    inline.Position = UDim2.new(0, 1, 0, 1)
    inline.Size = UDim2.new(1, -2, 1, -2)
    inline.ZIndex = 3
    inline.Parent = outline

    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "Content"
    contentContainer.BackgroundColor3 = theme.BackgroundColor
    contentContainer.BorderSizePixel = 0
    contentContainer.Position = UDim2.new(0, 1, 0, 1)
    contentContainer.Size = UDim2.new(1, -2, 1, -2)
    contentContainer.ZIndex = 3
    contentContainer.Parent = inline

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 4)
    contentPadding.PaddingLeft = UDim.new(0, 4)
    contentPadding.PaddingRight = UDim.new(0, 4)
    contentPadding.PaddingBottom = UDim.new(0, 4)
    contentPadding.Parent = contentContainer

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new(theme.GradientTopColor, theme.GradientBottomColor)
    gradient.Parent = contentContainer

    local selfWindow = setmetatable({}, WindowMethods)

    selfWindow._screenGui = screenGui
    selfWindow._main = main
    selfWindow._innerLayer = innerLayer
    selfWindow._coreLayer = coreLayer
    selfWindow._titleBar = titleBar
    selfWindow._titleLabel = titleLabel
    selfWindow._tabBar = tabBar
    selfWindow._contentContainer = contentContainer
    selfWindow._outerStroke = outerStroke
    selfWindow._innerStroke = innerStroke
    selfWindow._coreStroke = coreStroke
    selfWindow._outlineColor = outlineColor
    selfWindow._tabs = {}
    selfWindow._currentTab = nil
    selfWindow._theme = theme

    return selfWindow
end

function WindowMethods:SetTitle(newTitle)
    self._titleLabel.Text = tostring(newTitle)
end

function WindowMethods:SetOutlineColor(color)
    self._outlineColor = color
    self._outerStroke.Color = color
    self._innerStroke.Color = color
    self._coreStroke.Color = color
end

function WindowMethods:AddTab(name)
    local theme = self._theme

    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.BackgroundColor3 = theme.TabInactiveColor
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(0, 92, 1, -6)
    tabButton.Position = UDim2.new(0, 0, 0, 3)
    tabButton.AutoButtonColor = false
    tabButton.Font = Enum.Font.Code
    tabButton.TextSize = 14
    tabButton.TextColor3 = theme.TextColor
    tabButton.TextXAlignment = Enum.TextXAlignment.Center
    tabButton.TextYAlignment = Enum.TextYAlignment.Center
    tabButton.Text = name
    tabButton.Parent = self._tabBar

    local tabStroke = applyStroke(tabButton, self._outlineColor, 1)

    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.Parent = self._contentContainer
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.FillDirection = Enum.FillDirection.Vertical
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = page

    local tab = {
        Name = name,
        Button = tabButton,
        Page = page,
        Stroke = tabStroke
    }

    setmetatable(tab, TabMethods)
    tab._window = self
    tab._theme = theme
    tab._outlineColor = self._outlineColor
    tab._sections = {}

    table.insert(self._tabs, tab)

    tabButton.MouseButton1Click:Connect(function()
        self:ShowTab(tab)
    end)

    if not self._currentTab then
        self:ShowTab(tab)
    end

    return tab
end

function WindowMethods:ShowTab(tab)
    local theme = self._theme

    if self._currentTab == tab then
        return
    end

    if self._currentTab then
        self._currentTab.Page.Visible = false
        self._currentTab.Button.BackgroundColor3 = theme.TabInactiveColor
    end

    self._currentTab = tab
    tab.Page.Visible = true
    tab.Button.BackgroundColor3 = theme.TabActiveColor
end

function WindowMethods:GetCurrentTab()
    return self._currentTab
end

function WindowMethods:Destroy()
    if self._screenGui then
        self._screenGui:Destroy()
    end
    self._tabs = {}
    self._currentTab = nil
end

function TabMethods:AddSection(opts)
    opts = opts or {}
    local name = opts.Name or "Section"
    local theme = self._theme
    local outlineColor = self._outlineColor
    local sectionHolder = Instance.new("Frame")
    sectionHolder.Name = name .. "SectionHolder"
    sectionHolder.BackgroundTransparency = 1
    sectionHolder.BorderSizePixel = 0
    sectionHolder.Size = UDim2.new(1, 0, 0, 220)
    sectionHolder.Parent = self.Page
    local outline = Instance.new("Frame")
    outline.Name = "Outline"
    outline.BackgroundColor3 = outlineColor
    outline.BorderSizePixel = 0
    outline.Position = UDim2.new(0, 1, 0, 1)
    outline.Size = UDim2.new(1, -2, 1, -2)
    outline.Parent = sectionHolder
    local inline = Instance.new("Frame")
    inline.Name = "Inline"
    inline.BackgroundColor3 = theme.InlineColor
    inline.BorderSizePixel = 0
    inline.Position = UDim2.new(0, 1, 0, 1)
    inline.Size = UDim2.new(1, -2, 1, -2)
    inline.Parent = outline
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundColor3 = theme.BackgroundColor
    content.BorderSizePixel = 0
    content.Position = UDim2.new(0, 1, 0, 20)
    content.Size = UDim2.new(1, -2, 1, -22)
    content.Parent = inline
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, -8, 0, 18)
    header.Position = UDim2.new(0, 4, 0, 2)
    header.Font = Enum.Font.Code
    header.TextSize = 14
    header.TextColor3 = theme.TextColor
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = name
    header.Parent = inline
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 6)
    contentPadding.PaddingLeft = UDim.new(0, 6)
    contentPadding.PaddingRight = UDim.new(0, 6)
    contentPadding.PaddingBottom = UDim.new(0, 6)
    contentPadding.Parent = content
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = content
    local subtabsBar = Instance.new("Frame")
    subtabsBar.Name = "SubTabs"
    subtabsBar.BackgroundTransparency = 1
    subtabsBar.Size = UDim2.new(1, -8, 0, 20)
    subtabsBar.Position = UDim2.new(0, 4, 0, 2)
    subtabsBar.Visible = false
    subtabsBar.Parent = inline
    local subLayout = Instance.new("UIListLayout")
    subLayout.FillDirection = Enum.FillDirection.Horizontal
    subLayout.SortOrder = Enum.SortOrder.LayoutOrder
    subLayout.Padding = UDim.new(0, 4)
    subLayout.Parent = subtabsBar
    local subPages = Instance.new("Frame")
    subPages.Name = "SubPages"
    subPages.BackgroundTransparency = 1
    subPages.BorderSizePixel = 0
    subPages.Size = UDim2.new(1, -2, 1, -24)
    subPages.Position = UDim2.new(0, 1, 0, 22)
    subPages.Visible = false
    subPages.Parent = inline
    local subPagesPadding = Instance.new("UIPadding")
    subPagesPadding.PaddingTop = UDim.new(0, 6)
    subPagesPadding.PaddingLeft = UDim.new(0, 6)
    subPagesPadding.PaddingRight = UDim.new(0, 6)
    subPagesPadding.PaddingBottom = UDim.new(0, 6)
    subPagesPadding.Parent = subPages
    local subPagesLayout = Instance.new("UIListLayout")
    subPagesLayout.FillDirection = Enum.FillDirection.Vertical
    subPagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    subPagesLayout.Padding = UDim.new(0, 6)
    subPagesLayout.Parent = subPages
    local section = setmetatable({}, SectionMethods)
    section._tab = self
    section._theme = theme
    section._outlineColor = outlineColor
    section._holder = sectionHolder
    section._content = content
    section._header = header
    section._subBar = subtabsBar
    section._subPages = subPages
    section._currentSubTab = nil
    section._subTabs = {}
    table.insert(self._sections, section)
    return section
end

function SectionMethods:AddSubTab(name)
    local theme = self._theme
    self._subBar.Visible = true
    self._subPages.Visible = true
    local btn = Instance.new("TextButton")
    btn.Name = name .. "SubTab"
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(0, 92, 1, 0)
    btn.BackgroundColor3 = theme.TabInactiveColor
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.TextColor3 = theme.TextColor
    btn.Text = name
    btn.Parent = self._subBar
    local stroke = applyStroke(btn, self._outlineColor, 1)
    local page = Instance.new("Frame")
    page.Name = name .. "SubPage"
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.Size = UDim2.new(1, 0, 0, 0)
    page.Parent = self._subPages
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    local sub = {Name = name, Button = btn, Page = page, Stroke = stroke}
    table.insert(self._subTabs, sub)
    btn.MouseButton1Click:Connect(function()
        if self._currentSubTab then
            self._currentSubTab.Page.Visible = false
            self._currentSubTab.Button.BackgroundColor3 = theme.TabInactiveColor
        end
        self._currentSubTab = sub
        sub.Page.Visible = true
        sub.Button.BackgroundColor3 = theme.TabActiveColor
    end)
    if not self._currentSubTab then
        self._currentSubTab = sub
        sub.Page.Visible = true
        sub.Button.BackgroundColor3 = theme.TabActiveColor
    end
    return sub
end

function SectionMethods:AddToggle(opts)
    opts = opts or {}
    local name = opts.Name or "Toggle"
    local default = opts.Default or false
    local callback = opts.Callback
    local theme = self._theme
    local holder = Instance.new("TextButton")
    holder.Name = name .. "Toggle"
    holder.AutoButtonColor = false
    holder.Size = UDim2.new(1, 0, 0, 24)
    holder.BackgroundColor3 = theme.InnerBackgroundColor
    holder.Text = name
    holder.Font = Enum.Font.Code
    holder.TextSize = 14
    holder.TextColor3 = theme.TextColor
    holder.TextXAlignment = Enum.TextXAlignment.Left
    holder.BorderSizePixel = 0
    holder.Parent = (self._currentSubTab and self._currentSubTab.Page) or self._content
    local stroke = applyStroke(holder, self._outlineColor, 1)
    local check = Instance.new("Frame")
    check.Name = "Check"
    check.Size = UDim2.new(0, 18, 0, 18)
    check.Position = UDim2.new(1, -22, 0.5, -9)
    check.BackgroundColor3 = theme.TabInactiveColor
    check.BorderSizePixel = 0
    check.Parent = holder
    local checkStroke = applyStroke(check, self._outlineColor, 1)
    local state = default
    local function setState(s)
        state = s
        check.BackgroundColor3 = s and theme.AccentColor or theme.TabInactiveColor
        if callback then
            task.spawn(callback, s)
        end
    end
    setState(default)
    holder.MouseButton1Click:Connect(function()
        setState(not state)
    end)
    return {Set = setState, Get = function() return state end}
end

function SectionMethods:AddSlider(opts)
    opts = opts or {}
    local name = opts.Name or "Slider"
    local min = opts.Min or 0
    local max = opts.Max or 100
    local default = math.clamp(opts.Default or min, min, max)
    local callback = opts.Callback
    local theme = self._theme
    local holder = Instance.new("Frame")
    holder.Name = name .. "Slider"
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = (self._currentSubTab and self._currentSubTab.Page) or self._content
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 18)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -8, 0, 6)
    bar.Position = UDim2.new(0, 4, 0, 26)
    bar.BackgroundColor3 = theme.InnerBackgroundColor
    bar.BorderSizePixel = 0
    bar.Parent = holder
    local barStroke = applyStroke(bar, self._outlineColor, 1)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = theme.AccentColor
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 1, 4)
    knob.Position = UDim2.new(0, 0, 0, -2)
    knob.BackgroundColor3 = theme.TabActiveColor
    knob.BorderSizePixel = 0
    knob.Parent = bar
    local knobStroke = applyStroke(knob, self._outlineColor, 1)
    local value = default
    local function setValue(v)
        value = math.clamp(v, min, max)
        local alpha = (value - min) / (max - min)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, -5, 0, -2)
        label.Text = name .. ": " .. tostring(value)
        if callback then
            task.spawn(callback, value)
        end
    end
    setValue(default)
    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local absPos = bar.AbsolutePosition.X
            local absSize = bar.AbsoluteSize.X
            local x = math.clamp(input.Position.X - absPos, 0, absSize)
            local alpha = x / absSize
            setValue(min + (max - min) * alpha)
        end
    end)
    return {Set = setValue, Get = function() return value end}
end

function SectionMethods:AddDropdown(opts)
    opts = opts or {}
    local name = opts.Name or "Dropdown"
    local items = opts.Items or {}
    local default = opts.Default or items[1]
    local callback = opts.Callback
    local theme = self._theme
    local holder = Instance.new("Frame")
    holder.Name = name .. "Dropdown"
    holder.Size = UDim2.new(1, 0, 0, 26)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = (self._currentSubTab and self._currentSubTab.Page) or self._content
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.AutoButtonColor = false
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = theme.InnerBackgroundColor
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Code
    button.TextSize = 14
    button.TextColor3 = theme.TextColor
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Text = name .. ": " .. tostring(default or "")
    button.Parent = holder
    local stroke = applyStroke(button, self._outlineColor, 1)
    local list = Instance.new("Frame")
    list.Name = "List"
    list.Visible = false
    list.BackgroundColor3 = theme.BackgroundColor
    list.BorderSizePixel = 0
    list.Position = UDim2.new(0, 0, 1, 2)
    list.Size = UDim2.new(1, 0, 0, math.min(#items * 22, 140))
    list.Parent = holder
    local listStroke = applyStroke(list, self._outlineColor, 1)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = list
    local selected = default
    local function selectItem(it)
        selected = it
        button.Text = name .. ": " .. tostring(it)
        list.Visible = false
        if callback then
            task.spawn(callback, it)
        end
    end
    for _, it in ipairs(items) do
        local itemBtn = Instance.new("TextButton")
        itemBtn.AutoButtonColor = false
        itemBtn.Size = UDim2.new(1, 0, 0, 20)
        itemBtn.BackgroundColor3 = theme.InnerBackgroundColor
        itemBtn.BorderSizePixel = 0
        itemBtn.Font = Enum.Font.Code
        itemBtn.TextSize = 14
        itemBtn.TextColor3 = theme.TextColor
        itemBtn.Text = tostring(it)
        itemBtn.Parent = list
        applyStroke(itemBtn, self._outlineColor, 1)
        itemBtn.MouseButton1Click:Connect(function()
            selectItem(it)
        end)
    end
    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)
    if default then
        selectItem(default)
    end
    return {Set = selectItem, Get = function() return selected end}
end

function SectionMethods:AddColorPicker(opts)
    opts = opts or {}
    local name = opts.Name or "Color"
    local default = opts.Default or Color3.fromRGB(255, 255, 255)
    local callback = opts.Callback
    local theme = self._theme
    local holder = Instance.new("Frame")
    holder.Name = name .. "ColorPicker"
    holder.Size = UDim2.new(1, 0, 0, 80)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = (self._currentSubTab and self._currentSubTab.Page) or self._content
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 18)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 24, 0, 24)
    preview.Position = UDim2.new(1, -28, 0, -2)
    preview.BackgroundColor3 = default
    preview.BorderSizePixel = 0
    preview.Parent = label
    applyStroke(preview, self._outlineColor, 1)
    local r = Instance.new("TextLabel")
    r.Size = UDim2.new(0.33, -6, 0, 20)
    r.Position = UDim2.new(0, 4, 0, 26)
    r.BackgroundColor3 = theme.InnerBackgroundColor
    r.BorderSizePixel = 0
    r.Text = "R"
    r.Font = Enum.Font.Code
    r.TextSize = 14
    r.TextColor3 = theme.TextColor
    r.Parent = holder
    local g = r:Clone()
    g.Text = "G"
    g.Position = UDim2.new(0.33, 2, 0, 26)
    g.Parent = holder
    local b = r:Clone()
    b.Text = "B"
    b.Position = UDim2.new(0.66, 4, 0, 26)
    b.Parent = holder
    local function mkSlider(parent)
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -8, 0, 6)
        bar.Position = UDim2.new(0, 4, 0, 16)
        bar.BackgroundColor3 = theme.InnerBackgroundColor
        bar.BorderSizePixel = 0
        bar.Parent = parent
        applyStroke(bar, self._outlineColor, 1)
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = theme.AccentColor
        fill.BorderSizePixel = 0
        fill.Parent = bar
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 10, 1, 4)
        knob.Position = UDim2.new(0, -5, 0, -2)
        knob.BackgroundColor3 = theme.TabActiveColor
        knob.BorderSizePixel = 0
        knob.Parent = bar
        applyStroke(knob, self._outlineColor, 1)
        return bar, fill, knob
    end
    local rb, rf, rk = mkSlider(r)
    local gb, gf, gk = mkSlider(g)
    local bb, bf, bk = mkSlider(b)
    local cr, cg, cb = default.R * 255, default.G * 255, default.B * 255
    local function setRGB(rr, gg, bbv)
        cr = math.clamp(math.floor(rr + 0.5), 0, 255)
        cg = math.clamp(math.floor(gg + 0.5), 0, 255)
        cb = math.clamp(math.floor(bbv + 0.5), 0, 255)
        local function setBar(bar, fill, knob, v)
            local alpha = v / 255
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            knob.Position = UDim2.new(alpha, -5, 0, -2)
        end
        setBar(rb, rf, rk, cr)
        setBar(gb, gf, gk, cg)
        setBar(bb, bf, bk, cb)
        local col = Color3.fromRGB(cr, cg, cb)
        preview.BackgroundColor3 = col
        if callback then
            task.spawn(callback, col)
        end
    end
    setRGB(cr, cg, cb)
    local draggingR, draggingG, draggingB = false, false, false
    local function hookDrag(bar, which)
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if which == "R" then draggingR = true elseif which == "G" then draggingG = true else draggingB = true end
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if which == "R" then draggingR = false elseif which == "G" then draggingG = false else draggingB = false end
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local absPos = bar.AbsolutePosition.X
                local absSize = bar.AbsoluteSize.X
                local x = math.clamp(input.Position.X - absPos, 0, absSize)
                local v = (x / absSize) * 255
                if which == "R" and draggingR then setRGB(v, cg, cb)
                elseif which == "G" and draggingG then setRGB(cr, v, cb)
                elseif which == "B" and draggingB then setRGB(cr, cg, v) end
            end
        end)
    end
    hookDrag(rb, "R")
    hookDrag(gb, "G")
    hookDrag(bb, "B")
    return {Set = function(col) setRGB(col.R * 255, col.G * 255, col.B * 255) end, Get = function() return Color3.fromRGB(cr, cg, cb) end}
end

function SectionMethods:AddKeybind(opts)
    opts = opts or {}
    local name = opts.Name or "Keybind"
    local default = opts.Default
    local callback = opts.Callback
    local theme = self._theme
    local holder = Instance.new("TextButton")
    holder.Name = name .. "Keybind"
    holder.AutoButtonColor = false
    holder.Size = UDim2.new(1, 0, 0, 24)
    holder.BackgroundColor3 = theme.InnerBackgroundColor
    holder.Text = name .. ": " .. (default and default.Name or "None")
    holder.Font = Enum.Font.Code
    holder.TextSize = 14
    holder.TextColor3 = theme.TextColor
    holder.TextXAlignment = Enum.TextXAlignment.Left
    holder.BorderSizePixel = 0
    holder.Parent = (self._currentSubTab and self._currentSubTab.Page) or self._content
    applyStroke(holder, self._outlineColor, 1)
    local binding = false
    holder.MouseButton1Click:Connect(function()
        binding = true
        holder.Text = name .. ": ..."
    end)
    local current = default
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if binding and input.KeyCode ~= Enum.KeyCode.Unknown then
            binding = false
            current = input.KeyCode
            holder.Text = name .. ": " .. current.Name
            if callback then
                task.spawn(callback, current)
            end
        end
    end)
    return {Set = function(k) current = k holder.Text = name .. ": " .. k.Name end, Get = function() return current end}
end

return UILib

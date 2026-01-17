local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

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
    tabButton.Size = UDim2.new(0, 80, 1, -6)
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

    local tab = {
        Name = name,
        Button = tabButton,
        Page = page,
        Stroke = tabStroke
    }

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

return UILib

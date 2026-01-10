-- CustomUILib.lua

local CustomUILib = {}
CustomUILib.__index = CustomUILib

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- Default theme
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(50, 50, 50),
    Hover = Color3.fromRGB(40, 40, 40),
    Tooltip = Color3.fromRGB(20, 20, 20)
}

-- Animation helper
local function Animate(instance, props, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(instance, tweenInfo, props):Play()
end

-- Tooltip helper
local function AddTooltip(element, text)
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(0, 200, 0, 30)
    tooltip.BackgroundColor3 = Theme.Tooltip
    tooltip.TextColor3 = Theme.Text
    tooltip.Text = text
    tooltip.Visible = false
    tooltip.Parent = element

    element.MouseEnter:Connect(function()
        tooltip.Visible = true
        Animate(tooltip, {Transparency = 0})
    end)
    element.MouseLeave:Connect(function()
        Animate(tooltip, {Transparency = 1}, 0.1)
        tooltip.Visible = false
    end)
end

-- Create window
function CustomUILib:CreateWindow(title, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.IgnoreGuiInset = true

    local window = Instance.new("Frame")
    window.Size = size or UDim2.new(0, 400, 0, 300)
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Theme.Background
    window.BorderColor3 = Theme.Border
    window.BorderSizePixel = 1
    window.Active = true
    window.Draggable = true
    window.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Theme.Accent
    titleLabel.Text = title or "Custom UI"
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.Parent = window

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Text
    closeButton.Parent = titleLabel
    closeButton.MouseButton1Click:Connect(function()
        Animate(window, {Transparency = 1}, 0.3)
        wait(0.3)
        screenGui:Destroy()
    end)

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -60)
    tabContainer.Position = UDim2.new(0, 0, 0, 60)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = window

    local tabButtonContainer = Instance.new("Frame")
    tabButtonContainer.Size = UDim2.new(1, 0, 0, 30)
    tabButtonContainer.Position = UDim2.new(0, 0, 0, 30)
    tabButtonContainer.BackgroundTransparency = 1
    tabButtonContainer.Parent = window

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Parent = tabButtonContainer

    local self = setmetatable({
        Window = window,
        TabContainer = tabContainer,
        TabButtonContainer = tabButtonContainer,
        Tabs = {},
        ScreenGui = screenGui,
        Config = {}  -- For saving states
    }, CustomUILib)

    window.Transparency = 1
    Animate(window, {Transparency = 0}, 0.3)

    return self
end

-- Add tab
function CustomUILib:AddTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Theme.Hover
    tabButton.Text = name
    tabButton.TextColor3 = Theme.Text
    tabButton.Parent = self.TabButtonContainer

    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.ScrollBarThickness = 5
    tabFrame.Parent = self.TabContainer

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabFrame
    tabLayout.Changed:Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)

    tabButton.MouseEnter:Connect(function()
        if not tabFrame.Visible then Animate(tabButton, {BackgroundColor3 = Theme.Accent}) end
    end)
    tabButton.MouseLeave:Connect(function()
        if not tabFrame.Visible then Animate(tabButton, {BackgroundColor3 = Theme.Hover}) end
    end)

    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Frame.Visible = false
            Animate(tab.Button, {BackgroundColor3 = Theme.Hover})
        end
        tabFrame.Visible = true
        Animate(tabButton, {BackgroundColor3 = Theme.Accent})
    end)

    table.insert(self.Tabs, {Button = tabButton, Frame = tabFrame})

    if #self.Tabs == 1 then tabButton:MouseButton1Click() end  -- Auto-select first tab

    return tabFrame  -- For chaining
end

-- Add section to tab
function CustomUILib:AddSection(tabFrame, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.95, 0, 0, 0)
    section.BackgroundColor3 = Theme.Border
    section.Parent = tabFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.Parent = section

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.Parent = section

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -30)
    content.Position = UDim2.new(0, 5, 0, 25)
    content.BackgroundTransparency = 1
    content.Parent = section

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = content
    layout.Changed:Connect(function()
        section.Size = UDim2.new(0.95, 0, 0, layout.AbsoluteContentSize.Y + 35)
    end)

    return content  -- For chaining
end

-- Add toggle
function CustomUILib:AddToggle(section, text, default, callback, tooltip)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Parent = toggleFrame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.BackgroundColor3 = default and Theme.Accent or Theme.Hover
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Theme.Text
    toggle.Parent = toggleFrame

    if tooltip then AddTooltip(toggleFrame, tooltip) end

    local state = default
    self.Config[text] = state
    toggle.MouseButton1Click:Connect(function()
        state = not state
        self.Config[text] = state
        Animate(toggle, {BackgroundColor3 = state and Theme.Accent or Theme.Hover})
        toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)

    return toggle  -- For chaining or reference
end

-- Add slider
function CustomUILib:AddSlider(section, text, min, max, default, callback, tooltip)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 30)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = text .. ": " .. default
    label.TextColor3 = Theme.Text
    label.Parent = sliderFrame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.4, 0, 0, 5)
    sliderBar.Position = UDim2.new(0.6, 0, 0.5, -2.5)
    sliderBar.BackgroundColor3 = Theme.Hover
    sliderBar.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.Parent = sliderBar

    local value = default
    self.Config[text] = value

    if tooltip then AddTooltip(sliderFrame, tooltip) end

    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            value = math.round(min + (max - min) * relativeX)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            label.Text = text .. ": " .. value
            self.Config[text] = value
            if callback then callback(value) end
        end
    end)

    return sliderBar
end

-- Add button
function CustomUILib:AddButton(section, text, callback, tooltip)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Theme.Accent
    button.Text = text
    button.TextColor3 = Theme.Text
    button.Parent = section

    if tooltip then AddTooltip(button, tooltip) end

    button.MouseButton1Click:Connect(function()
        Animate(button, {BackgroundColor3 = Theme.Hover}, 0.1)
        wait(0.1)
        Animate(button, {BackgroundColor3 = Theme.Accent}, 0.1)
        if callback then callback() end
    end)

    return button
end

-- Add dropdown
function CustomUILib:AddDropdown(section, text, options, default, callback, tooltip)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Parent = dropdownFrame

    local selectedButton = Instance.new("TextButton")
    selectedButton.Size = UDim2.new(0.4, 0, 1, 0)
    selectedButton.Position = UDim2.new(0.6, 0, 0, 0)
    selectedButton.BackgroundColor3 = Theme.Hover
    selectedButton.Text = default
    selectedButton.TextColor3 = Theme.Text
    selectedButton.Parent = dropdownFrame

    local optionList = Instance.new("Frame")
    optionList.Size = UDim2.new(0.4, 0, 0, #options * 25)
    optionList.Position = UDim2.new(0.6, 0, 1, 0)
    optionList.BackgroundColor3 = Theme.Background
    optionList.Visible = false
    optionList.Parent = dropdownFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = optionList

    for _, opt in ipairs(options) do
        local optButton = Instance.new("TextButton")
        optButton.Size = UDim2.new(1, 0, 0, 25)
        optButton.BackgroundColor3 = Theme.Hover
        optButton.Text = opt
        optButton.TextColor3 = Theme.Text
        optButton.Parent = optionList
        optButton.MouseButton1Click:Connect(function()
            selectedButton.Text = opt
            optionList.Visible = false
            self.Config[text] = opt
            if callback then callback(opt) end
        end)
    end

    if tooltip then AddTooltip(dropdownFrame, tooltip) end

    selectedButton.MouseButton1Click:Connect(function()
        optionList.Visible = not optionList.Visible
    end)

    self.Config[text] = default

    return selectedButton
end

-- Add label
function CustomUILib:AddLabel(section, text, tooltip)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Parent = section

    if tooltip then AddTooltip(label, tooltip) end

    return label
end

-- Add color picker (basic: clicks open a simple hue slider)
function CustomUILib:AddColorPicker(section, text, default, callback, tooltip)
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Size = UDim2.new(1, 0, 0, 30)
    pickerFrame.BackgroundTransparency = 1
    pickerFrame.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Parent = pickerFrame

    local colorButton = Instance.new("Frame")
    colorButton.Size = UDim2.new(0, 40, 0, 20)
    colorButton.Position = UDim2.new(1, -40, 0.5, -10)
    colorButton.BackgroundColor3 = default
    colorButton.Parent = pickerFrame

    -- Simple picker panel (expands on click)
    local pickerPanel = Instance.new("Frame")
    pickerPanel.Size = UDim2.new(1, 0, 0, 100)
    pickerPanel.BackgroundColor3 = Theme.Background
    pickerPanel.Visible = false
    pickerPanel.Parent = pickerFrame

    -- Add a hue slider (simplified)
    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(1, -10, 0, 20)
    hueBar.Position = UDim2.new(0, 5, 0, 5)
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  -- Gradient would be better, but simple
    hueBar.Parent = pickerPanel
    -- Use ImageLabel with a gradient texture if you want fancy, but keeping basic

    local color = default
    self.Config[text] = color

    if tooltip then AddTooltip(pickerFrame, tooltip) end

    colorButton.MouseButton1Click:Connect(function()
        pickerPanel.Visible = not pickerPanel.Visible
    end)

    local dragging = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            color = Color3.fromHSV(relativeX, 1, 1)  -- Basic hue picker
            colorButton.BackgroundColor3 = color
            self.Config[text] = color
            if callback then callback(color) end
        end
    end)

    return colorButton
end

-- Set theme (updates all, but simplified— in full impl, track elements)
function CustomUILib:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        Theme[key] = value
    end
    -- You'd need to loop through all UI elements to apply, but for now, assume manual refresh
end

-- Save config (returns JSON string)
function CustomUILib:SaveConfig()
    return game:GetService("HttpService"):JSONEncode(self.Config)
end

return CustomUILib

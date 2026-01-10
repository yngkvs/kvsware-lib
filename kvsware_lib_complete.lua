return Dropdown
end

-- Color Picker Element
function EulenLib.Section:AddColorPicker(name, default, callback)
    local ColorPicker = {
        Name = name,
        Value = default or Color3.fromRGB(255, 255, 255),
        Callback = callback or function() end,
        Flag = name,
        Open = false
    }
    
    self.Tab.Library.Flags[name] = ColorPicker
    
    local PickerFrame = Instance.new("Frame")
    PickerFrame.Name = name
    PickerFrame.Size = UDim2.new(1, 0, 0, 30)
    PickerFrame.BackgroundTransparency = 1
    PickerFrame.ClipsDescendants = false
    PickerFrame.ZIndex = 5
    PickerFrame.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -95, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = PickerFrame
    
    -- Color buttons container
    local ColorButtonsFrame = Instance.new("Frame")
    ColorButtonsFrame.Size = UDim2.new(0, 90, 0, 20)
    ColorButtonsFrame.Position = UDim2.new(1, -90, 0.5, -10)
    ColorButtonsFrame.BackgroundTransparency = 1
    ColorButtonsFrame.Parent = PickerFrame
    
    -- Create 3 color indicator circles
    for i = 1, 3 do
        local ColorCircle = Instance.new("TextButton")
        ColorCircle.Size = UDim2.new(0, 20, 0, 20)
        ColorCircle.Position = UDim2.new(0, (i-1) * 25, 0, 0)
        ColorCircle.BackgroundColor3 = i == 1 and ColorPicker.Value or (i == 2 and Theme.Cyan or Theme.Success)
        ColorCircle.BorderSizePixel = 0
        ColorCircle.Text = ""
        ColorCircle.Parent = ColorButtonsFrame
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ColorCircle
        
        if i == 1 then
            ColorCircle.MouseButton1Click:Connect(function()
                ColorPicker:Toggle()
            end)
        end
    end
    
    -- Color Picker Popup
    local ColorPopup = Instance.new("Frame")
    ColorPopup.Size = UDim2.new(0, 0, 0, 0)
    ColorPopup.Position = UDim2.new(0, 0, 1, 5)
    ColorPopup.BackgroundColor3 = Theme.ElementBg
    ColorPopup.BorderSizePixel = 0
    ColorPopup.Visible = false
    ColorPopup.ZIndex = 15
    ColorPopup.Parent = PickerFrame
    
    local PopupCorner = Instance.new("UICorner")
    PopupCorner.CornerRadius = UDim.new(0, 6)
    PopupCorner.Parent = ColorPopup
    
    -- Saturation/Value Picker
    local SVPicker = Instance.new("ImageButton")
    SVPicker.Size = UDim2.new(1, -20, 0, 150)
    SVPicker.Position = UDim2.new(0, 10, 0, 10)
    SVPicker.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    SVPicker.BorderSizePixel = 0
    SVPicker.Image = "rbxassetid://4155801252"
    SVPicker.ZIndex = 16
    SVPicker.Parent = ColorPopup
    
    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 4)
    SVCorner.Parent = SVPicker
    
    -- Hue Slider
    local HueSlider = Instance.new("ImageButton")
    HueSlider.Size = UDim2.new(1, -20, 0, 15)
    HueSlider.Position = UDim2.new(0, 10, 0, 170)
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.BorderSizePixel = 0
    HueSlider.Image = "rbxassetid://3641079629"
    HueSlider.ImageColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.ScaleType = Enum.ScaleType.Crop
    HueSlider.ZIndex = 16
    HueSlider.Parent = ColorPopup
    
    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(1, 0)
    HueCorner.Parent = HueSlider
    
    -- RGB Input
    local RGBFrame = Instance.new("Frame")
    RGBFrame.Size = UDim2.new(1, -20, 0, 25)
    RGBFrame.Position = UDim2.new(0, 10, 0, 195)
    RGBFrame.BackgroundColor3 = Theme.Divider
    RGBFrame.BorderSizePixel = 0
    RGBFrame.ZIndex = 16
    RGBFrame.Parent = ColorPopup
    
    local RGBCorner = Instance.new("UICorner")
    RGBCorner.CornerRadius = UDim.new(0, 4)
    RGBCorner.Parent = RGBFrame
    
    local RGBLabel = Instance.new("TextLabel")
    RGBLabel.Size = UDim2.new(0, 30, 1, 0)
    RGBLabel.Position = UDim2.new(0, 5, 0, 0)
    RGBLabel.BackgroundTransparency = 1
    RGBLabel.Text = "RGB:"
    RGBLabel.Font = Enum.Font.Gotham
    RGBLabel.TextSize = 10
    RGBLabel.TextColor3 = Theme.TextDim
    RGBLabel.TextXAlignment = Enum.TextXAlignment.Left
    RGBLabel.ZIndex = 17
    RGBLabel.Parent = RGBFrame
    
    local RGBInput = Instance.new("TextBox")
    RGBInput.Size = UDim2.new(1, -40, 1, -4)
    RGBInput.Position = UDim2.new(0, 35, 0, 2)
    RGBInput.BackgroundTransparency = 1
    RGBInput.Text = string.format("%d, %d, %d", ColorPicker.Value.R * 255, ColorPicker.Value.G * 255, ColorPicker.Value.B * 255)
    RGBInput.Font = Enum.Font.Gotham
    RGBInput.TextSize = 10
    RGBInput.TextColor3 = Theme.Text
    RGBInput.TextXAlignment = Enum.TextXAlignment.Left
    RGBInput.PlaceholderText = "255, 255, 255"
    RGBInput.ZIndex = 17
    RGBInput.Parent = RGBFrame
    
    local hue, sat, val = ColorPicker.Value:ToHSV()
    
    function ColorPicker:SetValue(color)
        self.Value = color
        ColorButtonsFrame:GetChildren()[1].BackgroundColor3 = color
        RGBInput.Text = string.format("%d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
        pcall(self.Callback, color)
    end
    
    function ColorPicker:Toggle()
        self.Open = not self.Open
        if self.Open then
            ColorPopup.Visible = true
            CreateTween(ColorPopup, {Size = UDim2.new(1, 0, 0, 230)})
            CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 240)})
        else
            CreateTween(ColorPopup, {Size = UDim2.new(1, 0, 0, 0)})
            CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 30)})
            task.wait(0.2)
            ColorPopup.Visible = false
        end
    end
    
    -- SV Picker Logic
    local svDragging = false
    SVPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relPos = mousePos - SVPicker.AbsolutePosition
            sat = math.clamp(relPos.X / SVPicker.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp(relPos.Y / SVPicker.AbsoluteSize.Y, 0, 1)
            local color = Color3.fromHSV(hue, sat, val)
            ColorPicker:SetValue(color)
        end
    end)
    
    -- Hue Slider Logic
    local hueDragging = false
    HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relPos = mousePos.X - HueSlider.AbsolutePosition.X
            hue = math.clamp(relPos / HueSlider.AbsoluteSize.X, 0, 1)
            SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            local color = Color3.fromHSV(hue, sat, val)
            ColorPicker:SetValue(color)
        end
    end)
    
    -- RGB Input Logic
    RGBInput.FocusLost:Connect(function()
        local r, g, b = RGBInput.Text:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
            if r and g and b then
                local color = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
                ColorPicker:SetValue(color)
                hue, sat, val = color:ToHSV()
                SVPicker.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
        end
    end)
    
    return ColorPicker
end

-- Button Element
function EulenLib.Section:AddButton(name, callback)
    local Button = {
        Name = name,
        Callback = callback or function() end
    }
    
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = name
    ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
    ButtonFrame.BackgroundColor3 = Theme.Primary
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = name
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.TextSize = 12
    ButtonFrame.TextColor3 = Theme.Text
    ButtonFrame.Parent = self.Container
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Secondary})
        task.wait(0.1)
        CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Primary})
        pcall(callback)
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Secondary})
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Primary})
    end)
    
    return Button
end

-- Label Element
function EulenLib.Section:AddLabel(text)
    local Label = {
        Text = text
    }
    
    local LabelFrame = Instance.new("TextLabel")
    LabelFrame.Name = "Label"
    LabelFrame.Size = UDim2.new(1, 0, 0, 25)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Text = text
    LabelFrame.Font = Enum.Font.Gotham
    LabelFrame.TextSize = 12
    LabelFrame.TextColor3 = Theme.TextDim
    LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
    LabelFrame.TextWrapped = true
    LabelFrame.Parent = self.Container
    
    function Label:SetText(newText)
        self.Text = newText
        LabelFrame.Text = newText
    end
    
    return Label
end

-- Textbox Element
function EulenLib.Section:AddTextbox(name, default, placeholder, callback)
    local Textbox = {
        Name = name,
        Value = default or "",
        Callback = callback or function() end,
        Flag = name
    }
    
    self.Tab.Library.Flags[name] = Textbox
    
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = name
    TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
    TextboxFrame.BackgroundTransparency = 1
    TextboxFrame.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TextboxFrame
    
    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, 0, 0, 35)
    Input.Position = UDim2.new(0, 0, 0, 25)
    Input.BackgroundColor3 = Theme.Divider
    Input.BorderSizePixel = 0
    Input.Text = default or ""
    Input.PlaceholderText = placeholder or ""
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 11
    Input.TextColor3 = Theme.Text
    Input.PlaceholderColor3 = Theme.TextDim
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.ClearTextOnFocus = false
    Input.Parent = TextboxFrame
    
    local InputPadding = Instance.new("UIPadding")
    InputPadding.PaddingLeft = UDim.new(0, 10)
    InputPadding.PaddingRight = UDim.new(0, 10)
    InputPadding.Parent = Input
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = Input
    
    function Textbox:SetValue(val)
        self.Value = val
        Input.Text = val
        pcall(self.Callback, val)
    end
    
    Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            Textbox:SetValue(Input.Text)
        end
    end)
    
    Input.Focused:Connect(function()
        CreateTween(Input, {BackgroundColor3 = Theme.Hover})
    end)
    
    Input.FocusLost:Connect(function()
        CreateTween(Input, {BackgroundColor3 = Theme.Divider})
    end)
    
    return Textbox
end

-- Keybind Element
function EulenLib.Section:AddKeybind(name, default, callback)
    local Keybind = {
        Name = name,
        Value = default or Enum.KeyCode.E,
        Callback = callback or function() end,
        Flag = name,
        Listening = false
    }
    
    self.Tab.Library.Flags[name] = Keybind
    
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = name
    KeybindFrame.Size = UDim2.new(1, 0, 0, 30)
    KeybindFrame.BackgroundTransparency = 1
    KeybindFrame.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = KeybindFrame
    
    local KeybindButton = Instance.new("TextButton")
    KeybindButton.Size = UDim2.new(0, 70, 0, 25)
    KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    KeybindButton.BackgroundColor3 = Theme.Divider
    KeybindButton.BorderSizePixel = 0
    KeybindButton.Text = Keybind.Value.Name
    KeybindButton.Font = Enum.Font.Gotham
    KeybindButton.TextSize = 10
    KeybindButton.TextColor3 = Theme.Text
    KeybindButton.Parent = KeybindFrame
    
    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 4)
    KeybindCorner.Parent = KeybindButton
    
    function Keybind:SetValue(key)
        self.Value = key
        KeybindButton.Text = key.Name
    end
    
    KeybindButton.MouseButton1Click:Connect(function()
        if not Keybind.Listening then
            Keybind.Listening = true
            KeybindButton.Text = "..."
            CreateTween(KeybindButton, {BackgroundColor3 = Theme.Primary})
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if Keybind.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybind:SetValue(input.KeyCode)
                Keybind.Listening = false
                CreateTween(KeybindButton, {BackgroundColor3 = Theme.Divider})
            end
        elseif input.KeyCode == Keybind.Value and not gameProcessed then
            pcall(Keybind.Callback)
        end
    end)
    
    KeybindButton.MouseEnter:Connect(function()
        if not Keybind.Listening then
            CreateTween(KeybindButton, {BackgroundColor3 = Theme.Hover})
        end
    end)
    
    KeybindButton.MouseLeave:Connect(function()
        if not Keybind.Listening then
            CreateTween(KeybindButton, {BackgroundColor3 = Theme.Divider})
        end
    end)
    
    return Keybind
end

-- Multi Dropdown Element
function EulenLib.Section:AddMultiDropdown(name, options, defaults, callback)
    local MultiDropdown = {
        Name = name,
        Options = options or {},
        Values = defaults or {},
        Callback = callback or function() end,
        Flag = name,
        Open = false
    }
    
    self.Tab.Library.Flags[name] = MultiDropdown
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.ClipsDescendants = false
    DropdownFrame.ZIndex = 5
    DropdownFrame.Parent = self.Container
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.BackgroundColor3 = Theme.Divider
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = ""
    DropdownButton.ZIndex = 6
    DropdownButton.Parent = DropdownFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = DropdownButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7
    Label.Parent = DropdownButton
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 100, 1, 0)
    ValueLabel.Position = UDim2.new(1, -120, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = #MultiDropdown.Values > 0 and table.concat(MultiDropdown.Values, ", ") or "None"
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 11
    ValueLabel.TextColor3 = Theme.TextDim
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ValueLabel.ZIndex = 7
    ValueLabel.Parent = DropdownButton
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.Gotham
    Arrow.TextSize = 10
    Arrow.TextColor3 = Theme.TextDim
    Arrow.ZIndex = 7
    Arrow.Parent = DropdownButton
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
    OptionsFrame.BackgroundColor3 = Theme.ElementBg
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 10
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsList = Instance.new("ScrollingFrame")
    OptionsList.Size = UDim2.new(1, -10, 1, -10)
    OptionsList.Position = UDim2.new(0, 5, 0, 5)
    OptionsList.BackgroundTransparency = 1
    OptionsList.BorderSizePixel = 0
    OptionsList.ScrollBarThickness = 4
    OptionsList.ScrollBarImageColor3 = Theme.Primary
    OptionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsList.ZIndex = 11
    OptionsList.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 2)
    OptionsLayout.Parent = OptionsList
    
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsList.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
    end)
    
    function MultiDropdown:Refresh(newOptions)
        self.Options = newOptions
        for _, child in ipairs(OptionsList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        for _, option in ipairs(self.Options) do
            local OptionFrame = Instance.new("Frame")
            OptionFrame.Size = UDim2.new(1, 0, 0, 25)
            OptionFrame.BackgroundColor3 = Theme.Divider
            OptionFrame.BorderSizePixel = 0
            OptionFrame.ZIndex = 12
            OptionFrame.Parent = OptionsList
            
            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptionFrame
            
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, -30, 1, 0)
            OptionButton.Position = UDim2.new(0, 25, 0, 0)
            OptionButton.BackgroundTransparency = 1
            OptionButton.Text = option
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 11
            OptionButton.TextColor3 = Theme.Text
            OptionButton.TextXAlignment = Enum.TextXAlignment.Left
            OptionButton.ZIndex = 13
            OptionButton.Parent = OptionFrame
            
            local Checkbox = Instance.new("Frame")
            Checkbox.Size = UDim2.new(0, 16, 0, 16)
            Checkbox.Position = UDim2.new(0, 5, 0.5, -8)
            Checkbox.BackgroundColor3 = table.find(self.Values, option) and Theme.Primary or Theme.SidebarBg
            Checkbox.BorderSizePixel = 0
            Checkbox.ZIndex = 13
            Checkbox.Parent = OptionFrame
            
            local CheckCorner = Instance.new("UICorner")
            CheckCorner.CornerRadius = UDim.new(0, 3)
            CheckCorner.Parent = Checkbox
            
            local Checkmark = Instance.new("TextLabel")
            Checkmark.Size = UDim2.new(1, 0, 1, 0)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Text = table.find(self.Values, option) and "✓" or ""
            Checkmark.Font = Enum.Font.GothamBold
            Checkmark.TextSize = 12
            Checkmark.TextColor3 = Theme.Text
            Checkmark.ZIndex = 14
            Checkmark.Parent = Checkbox
            
            OptionButton.MouseButton1Click:Connect(function()
                MultiDropdown:Toggle(option, Checkbox, Checkmark)
            end)
            
            OptionFrame.MouseEnter:Connect(function()
                CreateTween(OptionFrame, {BackgroundColor3 = Theme.Hover})
            end)
            
            OptionFrame.MouseLeave:Connect(function()
                CreateTween(OptionFrame, {BackgroundColor3 = Theme.Divider})
            end)
        end
    end
    
    function MultiDropdown:Toggle(option, checkbox, checkmark)
        local index = table.find(self.Values, option)
        if index then
            table.remove(self.Values, index)
            CreateTween(checkbox, {BackgroundColor3 = Theme.SidebarBg})
            checkmark.Text = ""
        else
            table.insert(self.Values, option)
            CreateTween(checkbox, {BackgroundColor3 = Theme.Primary})
            checkmark.Text = "✓"
        end
        
        ValueLabel.Text = #self.Values > 0 and table.concat(self.Values, ", ") or "None"
        pcall(self.Callback, self.Values)
    end
    
    function MultiDropdown:ToggleDropdown()
        self.Open = not self.Open
        if self.Open then
            OptionsFrame.Visible = true
            local height = math.min(#self.Options * 27 + 10, 150)
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + height)})
            CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, height)})
            CreateTween(Arrow, {Rotation = 180})
        else
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)})
            CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)})
            CreateTween(Arrow, {Rotation = 0})
            task.wait(0.2)
            OptionsFrame.Visible = false
        end
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        MultiDropdown:ToggleDropdown()
    end)
    
    DropdownButton.MouseEnter:Connect(function()
        CreateTween(DropdownButton, {BackgroundColor3 = Theme.Hover})
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        CreateTween(DropdownButton, {BackgroundColor3 = Theme.Divider})
    end)
    
    MultiDropdown:Refresh(options)
    
    return MultiDropdown
end

-- Divider Element
function EulenLib.Section:AddDivider()
    local DividerFrame = Instance.new("Frame")
    DividerFrame.Name = "Divider"
    DividerFrame.Size = UDim2.new(1, 0, 0, 1)
    DividerFrame.BackgroundColor3 = Theme.Divider
    DividerFrame.BorderSizePixel = 0
    DividerFrame.Parent = self.Container
    
    return DividerFrame
end

-- Add Section Divider/Header
function EulenLib:AddSectionHeader(name)
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "SectionHeader"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 35)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = self.Sidebar
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, -10, 1, 0)
    HeaderLabel.Position = UDim2.new(0, 5, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = name
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.TextSize = 11
    HeaderLabel.TextColor3 = Theme.TextDim
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = HeaderFrame
end

return EulenLib-- Eulen UI Library v1.0
-- A comprehensive Roblox UI library matching the Eulen menu design
-- Full implementation in one file

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local EulenLib = {}
EulenLib.__index = EulenLib

-- Theme colors matching Eulen
local Theme = {
    Background = Color3.fromRGB(20, 20, 30),
    SidebarBg = Color3.fromRGB(15, 15, 25),
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(100, 30, 180),
    Text = Color3.fromRGB(200, 200, 210),
    TextDim = Color3.fromRGB(120, 120, 130),
    Divider = Color3.fromRGB(40, 40, 50),
    ElementBg = Color3.fromRGB(25, 25, 35),
    Hover = Color3.fromRGB(35, 35, 45),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(255, 152, 0),
    Error = Color3.fromRGB(244, 67, 54),
    Cyan = Color3.fromRGB(0, 188, 212)
}

-- Utility Functions
local function CreateTween(obj, props, duration)
    duration = duration or 0.2
    local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad), props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            CreateTween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Main Library Constructor
function EulenLib:New(title)
    local Library = {
        Title = title or "Eulen",
        Tabs = {},
        CurrentTab = nil,
        Flags = {}
    }
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EulenUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Check for existing instance
    if game:GetService("CoreGui"):FindFirstChild("EulenUI") then
        game:GetService("CoreGui"):FindFirstChild("EulenUI"):Destroy()
    end
    
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 850, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -425, 0.5, -300)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Add UICorner
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Theme.SidebarBg
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Library.Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Settings Button
    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Name = "Settings"
    SettingsButton.Size = UDim2.new(0, 40, 0, 40)
    SettingsButton.Position = UDim2.new(1, -90, 0, 5)
    SettingsButton.BackgroundColor3 = Theme.ElementBg
    SettingsButton.BorderSizePixel = 0
    SettingsButton.Text = "⚙"
    SettingsButton.Font = Enum.Font.GothamBold
    SettingsButton.TextSize = 18
    SettingsButton.TextColor3 = Theme.Text
    SettingsButton.Parent = TopBar
    
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 6)
    SettingsCorner.Parent = SettingsButton
    
    SettingsButton.MouseEnter:Connect(function()
        CreateTween(SettingsButton, {BackgroundColor3 = Theme.Hover})
    end)
    
    SettingsButton.MouseLeave:Connect(function()
        CreateTween(SettingsButton, {BackgroundColor3 = Theme.ElementBg})
    end)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Theme.ElementBg
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "✕"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.TextColor3 = Theme.Text
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Error})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.ElementBg})
    end)
    
    -- Sidebar Container
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 165, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Theme.SidebarBg
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    -- Sidebar Header for Self Options
    local SidebarHeader = Instance.new("Frame")
    SidebarHeader.Name = "SelfOptionsHeader"
    SidebarHeader.Size = UDim2.new(1, 0, 0, 35)
    SidebarHeader.BackgroundTransparency = 1
    SidebarHeader.Parent = Sidebar
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
    HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = "Self Options"
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.TextSize = 11
    HeaderLabel.TextColor3 = Theme.TextDim
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = SidebarHeader
    
    -- Sidebar Sections Container
    local SidebarContent = Instance.new("ScrollingFrame")
    SidebarContent.Name = "Content"
    SidebarContent.Size = UDim2.new(1, -10, 1, -45)
    SidebarContent.Position = UDim2.new(0, 5, 0, 40)
    SidebarContent.BackgroundTransparency = 1
    SidebarContent.BorderSizePixel = 0
    SidebarContent.ScrollBarThickness = 4
    SidebarContent.ScrollBarImageColor3 = Theme.Primary
    SidebarContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarContent.Parent = Sidebar
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -165, 1, -50)
    ContentArea.Position = UDim2.new(0, 165, 0, 50)
    ContentArea.BackgroundColor3 = Theme.Background
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    Library.ScreenGui = ScreenGui
    Library.MainFrame = MainFrame
    Library.Sidebar = SidebarContent
    Library.ContentArea = ContentArea
    
    setmetatable(Library, EulenLib)
    return Library
end

-- Tab Creation
function EulenLib:AddTab(name, icon)
    local Tab = {
        Name = name,
        Icon = icon or "📁",
        Sections = {},
        Library = self
    }
    
    table.insert(self.Tabs, Tab)
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.BackgroundColor3 = Theme.ElementBg
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    -- Tab Icon
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18)
    TabIcon.Position = UDim2.new(0, 12, 0.5, -9)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = ""
    TabIcon.ImageColor3 = Theme.TextDim
    TabIcon.Parent = TabButton
    
    -- Tab Icon Text (if no image)
    local TabIconText = Instance.new("TextLabel")
    TabIconText.Size = UDim2.new(0, 18, 0, 18)
    TabIconText.Position = UDim2.new(0, 12, 0.5, -9)
    TabIconText.BackgroundTransparency = 1
    TabIconText.Text = Tab.Icon
    TabIconText.Font = Enum.Font.Gotham
    TabIconText.TextSize = 14
    TabIconText.TextColor3 = Theme.TextDim
    TabIconText.Parent = TabButton
    
    -- Tab Label
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -45, 1, 0)
    TabLabel.Position = UDim2.new(0, 40, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.TextSize = 13
    TabLabel.TextColor3 = Theme.TextDim
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    -- Tab Content Container
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Visible = false
    TabContent.Parent = self.ContentArea
    
    Tab.Button = TabButton
    Tab.Content = TabContent
    Tab.IconImage = TabIcon
    Tab.IconText = TabIconText
    Tab.Label = TabLabel
    
    -- Tab Click Handler
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Content.Visible = false
            CreateTween(t.Button, {BackgroundColor3 = Theme.ElementBg})
            CreateTween(t.Label, {TextColor3 = Theme.TextDim})
            CreateTween(t.IconText, {TextColor3 = Theme.TextDim})
            t.IconImage.ImageColor3 = Theme.TextDim
        end
        
        TabContent.Visible = true
        CreateTween(TabButton, {BackgroundColor3 = Theme.Primary})
        CreateTween(TabLabel, {TextColor3 = Theme.Text})
        CreateTween(TabIconText, {TextColor3 = Theme.Text})
        TabIcon.ImageColor3 = Theme.Text
        self.CurrentTab = Tab
    end)
    
    -- Hover effects
    TabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            CreateTween(TabButton, {BackgroundColor3 = Theme.Hover})
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            CreateTween(TabButton, {BackgroundColor3 = Theme.ElementBg})
        end
    end)
    
    -- Auto-layout sidebar
    local layout = self.Sidebar:FindFirstChildOfClass("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.Parent = self.Sidebar
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            self.Sidebar.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
    end
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        task.wait()
        TabButton.MouseButton1Click:Fire()
    end
    
    return Tab
end

-- Section Creation (Left/Right columns)
function EulenLib.Tab:AddSection(name, side)
    side = side or "left"
    
    local Section = {
        Name = name,
        Elements = {},
        Tab = self,
        Side = side
    }
    
    table.insert(self.Sections, Section)
    
    -- Find or create column container
    local ColumnContainer = self.Content:FindFirstChild(side == "left" and "LeftColumn" or "RightColumn")
    if not ColumnContainer then
        ColumnContainer = Instance.new("Frame")
        ColumnContainer.Name = side == "left" and "LeftColumn" or "RightColumn"
        ColumnContainer.Size = UDim2.new(0.48, 0, 1, 0)
        ColumnContainer.Position = side == "left" and UDim2.new(0, 10, 0, 10) or UDim2.new(0.52, 0, 0, 10)
        ColumnContainer.BackgroundTransparency = 1
        ColumnContainer.Parent = self.Content
        
        local ColumnLayout = Instance.new("UIListLayout")
        ColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColumnLayout.Padding = UDim.new(0, 10)
        ColumnLayout.Parent = ColumnContainer
    end
    
    -- Section Container
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = name
    SectionFrame.Size = UDim2.new(1, 0, 0, 0)
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    SectionFrame.BackgroundColor3 = Theme.ElementBg
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Parent = ColumnContainer
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = SectionFrame
    
    -- Section Header
    local Header = Instance.new("TextLabel")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -20, 0, 35)
    Header.Position = UDim2.new(0, 10, 0, 0)
    Header.BackgroundTransparency = 1
    Header.Text = name
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14
    Header.TextColor3 = Theme.Text
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Parent = SectionFrame
    
    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 1)
    Divider.Position = UDim2.new(0, 10, 0, 35)
    Divider.BackgroundColor3 = Theme.Divider
    Divider.BorderSizePixel = 0
    Divider.Parent = SectionFrame
    
    -- Elements Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 0, 0)
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = SectionFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Container
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 10)
    Padding.Parent = Container
    
    Section.Frame = SectionFrame
    Section.Container = Container
    
    return Section
end

-- Toggle Element
function EulenLib.Section:AddToggle(name, default, callback)
    local Toggle = {
        Name = name,
        Value = default or false,
        Callback = callback or function() end,
        Flag = name
    }
    
    self.Tab.Library.Flags[name] = Toggle
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = self.Container
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 18, 0, 18)
    ToggleButton.Position = UDim2.new(1, -18, 0.5, -9)
    ToggleButton.BackgroundColor3 = Toggle.Value and Theme.Primary or Theme.Divider
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = ToggleButton
    
    -- Checkmark
    local Checkmark = Instance.new("TextLabel")
    Checkmark.Size = UDim2.new(1, 0, 1, 0)
    Checkmark.BackgroundTransparency = 1
    Checkmark.Text = Toggle.Value and "✓" or ""
    Checkmark.Font = Enum.Font.GothamBold
    Checkmark.TextSize = 14
    Checkmark.TextColor3 = Theme.Text
    Checkmark.Parent = ToggleButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    function Toggle:SetValue(val)
        self.Value = val
        CreateTween(ToggleButton, {BackgroundColor3 = val and Theme.Primary or Theme.Divider})
        Checkmark.Text = val and "✓" or ""
        pcall(self.Callback, val)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        Toggle:SetValue(not Toggle.Value)
    end)
    
    ToggleButton.MouseEnter:Connect(function()
        if not Toggle.Value then
            CreateTween(ToggleButton, {BackgroundColor3 = Theme.Hover})
        end
    end)
    
    ToggleButton.MouseLeave:Connect(function()
        if not Toggle.Value then
            CreateTween(ToggleButton, {BackgroundColor3 = Theme.Divider})
        end
    end)
    
    return Toggle
end

-- Slider Element
function EulenLib.Section:AddSlider(name, min, max, default, increment, suffix, callback)
    local Slider = {
        Name = name,
        Min = min or 0,
        Max = max or 100,
        Value = default or min or 0,
        Increment = increment or 1,
        Suffix = suffix or "",
        Callback = callback or function() end,
        Flag = name
    }
    
    self.Tab.Library.Flags[name] = Slider
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 55, 0, 18)
    ValueLabel.Position = UDim2.new(1, -55, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Slider.Value) .. Slider.Suffix
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 11
    ValueLabel.TextColor3 = Theme.Primary
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, 0, 0, 4)
    SliderBack.Position = UDim2.new(0, 0, 1, -10)
    SliderBack.BackgroundColor3 = Theme.Divider
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = SliderFrame
    
    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local Dragging = false
    
    function Slider:SetValue(val)
        val = math.clamp(val, self.Min, self.Max)
        val = math.floor(val / self.Increment + 0.5) * self.Increment
        self.Value = val
        
        ValueLabel.Text = tostring(val) .. self.Suffix
        CreateTween(SliderFill, {Size = UDim2.new((val - self.Min) / (self.Max - self.Min), 0, 1, 0)}, 0.1)
        pcall(self.Callback, val)
    end
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            local function Update()
                local mousePos = UserInputService:GetMouseLocation().X
                local sliderPos = SliderBack.AbsolutePosition.X
                local sliderSize = SliderBack.AbsoluteSize.X
                local percentage = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                local value = Slider.Min + (Slider.Max - Slider.Min) * percentage
                Slider:SetValue(value)
            end
            Update()
            
            local connection
            connection = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBack.AbsolutePosition.X
            local sliderSize = SliderBack.AbsoluteSize.X
            local percentage = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = Slider.Min + (Slider.Max - Slider.Min) * percentage
            Slider:SetValue(value)
        end
    end)
    
    return Slider
end

-- Dropdown Element
function EulenLib.Section:AddDropdown(name, options, default, callback)
    local Dropdown = {
        Name = name,
        Options = options or {},
        Value = default or (options and options[1]) or "",
        Callback = callback or function() end,
        Flag = name,
        Open = false
    }
    
    self.Tab.Library.Flags[name] = Dropdown
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = name
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.ClipsDescendants = false
    DropdownFrame.ZIndex = 5
    DropdownFrame.Parent = self.Container
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 35)
    DropdownButton.BackgroundColor3 = Theme.Divider
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = ""
    DropdownButton.ZIndex = 6
    DropdownButton.Parent = DropdownFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = DropdownButton
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 7
    Label.Parent = DropdownButton
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 100, 1, 0)
    ValueLabel.Position = UDim2.new(1, -120, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = Dropdown.Value
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = 11
    ValueLabel.TextColor3 = Theme.TextDim
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
    ValueLabel.ZIndex = 7
    ValueLabel.Parent = DropdownButton
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.Gotham
    Arrow.TextSize = 10
    Arrow.TextColor3 = Theme.TextDim
    Arrow.ZIndex = 7
    Arrow.Parent = DropdownButton
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
    OptionsFrame.BackgroundColor3 = Theme.ElementBg
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 10
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsList = Instance.new("ScrollingFrame")
    OptionsList.Size = UDim2.new(1, -10, 1, -10)
    OptionsList.Position = UDim2.new(0, 5, 0, 5)
    OptionsList.BackgroundTransparency = 1
    OptionsList.BorderSizePixel = 0
    OptionsList.ScrollBarThickness = 4
    OptionsList.ScrollBarImageColor3 = Theme.Primary
    OptionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsList.ZIndex = 11
    OptionsList.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Padding = UDim.new(0, 2)
    OptionsLayout.Parent = OptionsList
    
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsList.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
    end)
    
    function Dropdown:Refresh(newOptions)
        self.Options = newOptions
        for _, child in ipairs(OptionsList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for _, option in ipairs(self.Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.BackgroundColor3 = Theme.Divider
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 11
            OptionButton.TextColor3 = Theme.Text
            OptionButton.ZIndex = 12
            OptionButton.Parent = OptionsList
            
            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptionButton
            
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown:SetValue(option)
                Dropdown:Toggle()
            end)
            
            OptionButton.MouseEnter:Connect(function()
                CreateTween(OptionButton, {BackgroundColor3 = Theme.Primary})
            end)
            
            OptionButton.MouseLeave:Connect(function()
                CreateTween(OptionButton, {BackgroundColor3 = Theme.Divider})
            end)
        end
    end
    
    function Dropdown:SetValue(val)
        self.Value = val
        ValueLabel.Text = val
        pcall(self.Callback, val)
    end
    
    function Dropdown:Toggle()
        self.Open = not self.Open
        if self.Open then
            OptionsFrame.Visible = true
            local height = math.min(#self.Options * 27 + 10, 150)
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + height)})
            CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, height)})
            CreateTween(Arrow, {Rotation = 180})
        else
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)})
            CreateTween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)})
            CreateTween(Arrow, {Rotation = 0})
            task.wait(0.2)
            OptionsFrame.Visible = false
        end
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        Dropdown:Toggle()
    end)
    
    DropdownButton.MouseEnter:Connect(function()
        CreateTween(DropdownButton, {BackgroundColor3 = Theme.Hover})
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        CreateTween(DropdownButton, {BackgroundColor3 = Theme.Divider})
    end)
    
    Dropdown:Refresh(options)
    
    return Dropdown
end

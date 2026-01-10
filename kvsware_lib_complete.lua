local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local Euphoria = {}

-- Utility Functions
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

function Euphoria.New(title)
	local Library = {}
	
	-- Theme Colors
	local Theme = {
		Background = Color3.fromRGB(15, 15, 15),
		Sidebar = Color3.fromRGB(20, 20, 20),
		Section = Color3.fromRGB(25, 25, 25),
		Text = Color3.fromRGB(240, 240, 240),
		TextDim = Color3.fromRGB(150, 150, 150),
		Accent = Color3.fromRGB(255, 105, 180), -- Hot Pink/Purple default
		Control = Color3.fromRGB(35, 35, 35),
		ControlHover = Color3.fromRGB(45, 45, 45),
		Outline = Color3.fromRGB(40, 40, 40)
	}

	-- Main ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "EuphoriaUI"
	if RunService:IsStudio() then
		ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	else
		ScreenGui.Parent = CoreGui
	end

	-- Main Window
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 700, 0, 450)
	MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Parent = MainFrame
	
	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 180, 1, 0)
	Sidebar.BackgroundColor3 = Theme.Sidebar
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = MainFrame
	
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 8)
	SidebarCorner.Parent = Sidebar
	
	-- Fix Sidebar Corner (so it doesn't round right side)
	local SidebarCover = Instance.new("Frame")
	SidebarCover.BorderSizePixel = 0
	SidebarCover.BackgroundColor3 = Theme.Sidebar
	SidebarCover.Size = UDim2.new(0, 10, 1, 0)
	SidebarCover.Position = UDim2.new(1, -10, 0, 0)
	SidebarCover.Parent = Sidebar
	
	-- Title
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Text = title
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.TextColor3 = Theme.Text
	TitleLabel.Size = UDim2.new(1, -20, 0, 50)
	TitleLabel.Position = UDim2.new(0, 20, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Sidebar

	-- Tab Container
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(1, 0, 1, -100) -- Leave space for bottom stuff
	TabContainer.Position = UDim2.new(0, 0, 0, 60)
	TabContainer.BackgroundTransparency = 1
	TabContainer.ScrollBarThickness = 0
	TabContainer.Parent = Sidebar
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Padding = UDim.new(0, 5)
	TabListLayout.Parent = TabContainer

	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingLeft = UDim.new(0, 10)
	TabPadding.Parent = TabContainer

	-- Content Area
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -180, 1, 0)
	ContentArea.Position = UDim2.new(0, 180, 0, 0)
	ContentArea.BackgroundTransparency = 1
	ContentArea.Parent = MainFrame
	
	-- Top Bar (Invisible, for dragging)
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = MainFrame
	MakeDraggable(TopBar, MainFrame)
	
	-- Settings Cog (Top Right)
	local SettingsButton = Instance.new("ImageButton")
	SettingsButton.Size = UDim2.new(0, 24, 0, 24)
	SettingsButton.Position = UDim2.new(1, -35, 0, 15)
	SettingsButton.BackgroundTransparency = 1
	SettingsButton.Image = "rbxassetid://3926307971" -- Cog icon
	SettingsButton.ImageRectOffset = Vector2.new(324, 124)
	SettingsButton.ImageRectSize = Vector2.new(36, 36)
	SettingsButton.ImageColor3 = Theme.Accent
	SettingsButton.Parent = ContentArea

	-- Pages Folder
	local Pages = Instance.new("Folder")
	Pages.Name = "Pages"
	Pages.Parent = ContentArea

	local Tabs = {}
	local FirstTab = true

	function Library:AddTab(name, icon)
		local Tab = {}
		
		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, -20, 0, 35)
		TabButton.BackgroundTransparency = 1
		TabButton.Text = ""
		TabButton.Parent = TabContainer
		
		local TabIcon = Instance.new("TextLabel")
		TabIcon.Size = UDim2.new(0, 30, 1, 0)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Text = icon or ""
		TabIcon.TextSize = 18
		TabIcon.TextColor3 = Theme.TextDim
		TabIcon.Parent = TabButton
		
		local TabName = Instance.new("TextLabel")
		TabName.Size = UDim2.new(1, -35, 1, 0)
		TabName.Position = UDim2.new(0, 35, 0, 0)
		TabName.BackgroundTransparency = 1
		TabName.Text = name
		TabName.Font = Enum.Font.GothamMedium
		TabName.TextSize = 14
		TabName.TextColor3 = Theme.TextDim
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.Parent = TabButton
		
		local TabIndicator = Instance.new("Frame")
		TabIndicator.Size = UDim2.new(0, 2, 0.6, 0)
		TabIndicator.Position = UDim2.new(0, 0, 0.2, 0)
		TabIndicator.BackgroundColor3 = Theme.Accent
		TabIndicator.BackgroundTransparency = 1
		TabIndicator.Parent = TabButton

		-- Page Frame
		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "Page"
		Page.Size = UDim2.new(1, -40, 1, -60)
		Page.Position = UDim2.new(0, 20, 0, 50)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 2
		Page.Visible = false
		Page.Parent = Pages
		
		-- Columns (Left and Right)
		local LeftColumn = Instance.new("Frame")
		LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
		LeftColumn.BackgroundTransparency = 1
		LeftColumn.Parent = Page
		
		local LeftList = Instance.new("UIListLayout")
		LeftList.SortOrder = Enum.SortOrder.LayoutOrder
		LeftList.Padding = UDim.new(0, 10)
		LeftList.Parent = LeftColumn
		
		local RightColumn = Instance.new("Frame")
		RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
		RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
		RightColumn.BackgroundTransparency = 1
		RightColumn.Parent = Page
		
		local RightList = Instance.new("UIListLayout")
		RightList.SortOrder = Enum.SortOrder.LayoutOrder
		RightList.Padding = UDim.new(0, 10)
		RightList.Parent = RightColumn

		-- Activate Function
		local function Activate()
			for _, t in pairs(Tabs) do
				t.Button.TabName.TextColor3 = Theme.TextDim
				t.Button.TabIcon.TextColor3 = Theme.TextDim
				t.Button.TabIndicator.BackgroundTransparency = 1
				t.Page.Visible = false
			end
			
			TabName.TextColor3 = Theme.Text
			TabIcon.TextColor3 = Theme.Text
			TabIndicator.BackgroundTransparency = 0
			Page.Visible = true
		end

		TabButton.MouseButton1Click:Connect(Activate)
		
		if FirstTab then
			FirstTab = false
			Activate()
		end
		
		table.insert(Tabs, {Button = TabButton, Page = Page})

		-- Section Handling
		function Tab:AddSection(sectionName, side)
			local Section = {}
			side = side or "Left"
			local ParentColumn = (side == "Right") and RightColumn or LeftColumn
			
			local SectionFrame = Instance.new("Frame")
			SectionFrame.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Placeholder transparency
			SectionFrame.BackgroundTransparency = 1
			SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Auto resized
			SectionFrame.Parent = ParentColumn
			
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Text = sectionName
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextSize = 12
			SectionTitle.TextColor3 = Theme.TextDim
			SectionTitle.Size = UDim2.new(1, 0, 0, 20)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = SectionFrame
			
			local Container = Instance.new("Frame")
			Container.Position = UDim2.new(0, 0, 0, 25)
			Container.Size = UDim2.new(1, 0, 0, 0)
			Container.BackgroundColor3 = Theme.Section -- Used to be transparent, now section bg? 
			-- Actually in screenshot, sections don't have backgrounds, just controls stacked.
			-- But let's give controls a container.
			Container.BackgroundTransparency = 1
			Container.Parent = SectionFrame
			
			local ContainerLayout = Instance.new("UIListLayout")
			ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContainerLayout.Padding = UDim.new(0, 5)
			ContainerLayout.Parent = Container
			
			-- Resize SectionFrame based on content
			ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Container.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y)
				SectionFrame.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 30)
			end)
			
			-- Controls
			
			function Section:AddToggle(text, default, callback)
				local Toggle = {}
				local enabled = default or false
				
				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
				ToggleFrame.BackgroundTransparency = 1
				ToggleFrame.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = Theme.Text
				Label.Size = UDim2.new(0.7, 0, 1, 0)
				Label.BackgroundTransparency = 1
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = ToggleFrame
				
				local SwitchBg = Instance.new("Frame")
				SwitchBg.Size = UDim2.new(0, 40, 0, 20)
				SwitchBg.AnchorPoint = Vector2.new(1, 0.5)
				SwitchBg.Position = UDim2.new(1, 0, 0.5, 0)
				SwitchBg.BackgroundColor3 = enabled and Theme.Accent or Theme.Control
				SwitchBg.Parent = ToggleFrame
				
				local SwitchCorner = Instance.new("UICorner")
				SwitchCorner.CornerRadius = UDim.new(1, 0)
				SwitchCorner.Parent = SwitchBg
				
				local Knob = Instance.new("Frame")
				Knob.Size = UDim2.new(0, 16, 0, 16)
				Knob.AnchorPoint = Vector2.new(0, 0.5)
				Knob.Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
				Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Knob.Parent = SwitchBg
				
				local KnobCorner = Instance.new("UICorner")
				KnobCorner.CornerRadius = UDim.new(1, 0)
				KnobCorner.Parent = Knob
				
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.BackgroundTransparency = 1
				Button.Text = ""
				Button.Parent = ToggleFrame
				
				local function Update()
					TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Theme.Accent or Theme.Control}):Play()
					TweenService:Create(Knob, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
					pcall(callback, enabled)
				end
				
				Button.MouseButton1Click:Connect(function()
					enabled = not enabled
					Update()
				end)
				
				return Toggle
			end
			
			function Section:AddSlider(text, min, max, default, increment, callback)
				local Slider = {}
				local value = default or min
				local dragging = false
				
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Size = UDim2.new(1, 0, 0, 45)
				SliderFrame.BackgroundTransparency = 1
				SliderFrame.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = Theme.Text
				Label.Size = UDim2.new(1, 0, 0, 20)
				Label.BackgroundTransparency = 1
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = SliderFrame
				
				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Text = tostring(value)
				ValueLabel.Font = Enum.Font.Gotham
				ValueLabel.TextSize = 13
				ValueLabel.TextColor3 = Theme.Text
				ValueLabel.Size = UDim2.new(1, 0, 0, 20)
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
				ValueLabel.Parent = SliderFrame
				
				local SliderBg = Instance.new("Frame")
				SliderBg.Size = UDim2.new(1, 0, 0, 6)
				SliderBg.Position = UDim2.new(0, 0, 0, 30)
				SliderBg.BackgroundColor3 = Theme.Control
				SliderBg.BorderSizePixel = 0
				SliderBg.Parent = SliderFrame
				
				local SliderCorner = Instance.new("UICorner")
				SliderCorner.CornerRadius = UDim.new(1, 0)
				SliderCorner.Parent = SliderBg
				
				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
				Fill.BackgroundColor3 = Theme.Accent
				Fill.BorderSizePixel = 0
				Fill.Parent = SliderBg
				
				local FillCorner = Instance.new("UICorner")
				FillCorner.CornerRadius = UDim.new(1, 0)
				FillCorner.Parent = Fill
				
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.BackgroundTransparency = 1
				Button.Text = ""
				Button.Parent = SliderBg -- Make clickable area the bar
				
				local function Update(input)
					local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
					local newVal = math.floor(((pos * (max - min) + min) / increment) + 0.5) * increment
					value = newVal
					Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
					ValueLabel.Text = tostring(value)
					pcall(callback, value)
				end
				
				Button.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						Update(input)
					end
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						Update(input)
					end
				end)
				
				return Slider
			end
			
			function Section:AddDropdown(text, items, default, callback)
				local Dropdown = {}
				local expanded = false
				
				local DropdownFrame = Instance.new("Frame")
				DropdownFrame.Size = UDim2.new(1, 0, 0, 50) -- Collapsed height
				DropdownFrame.BackgroundTransparency = 1
				DropdownFrame.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = Theme.Text
				Label.Size = UDim2.new(1, 0, 0, 20)
				Label.BackgroundTransparency = 1
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = DropdownFrame
				
				local Bar = Instance.new("Frame")
				Bar.Size = UDim2.new(1, 0, 0, 25)
				Bar.Position = UDim2.new(0, 0, 0, 25)
				Bar.BackgroundColor3 = Theme.Control
				Bar.Parent = DropdownFrame
				
				local BarCorner = Instance.new("UICorner")
				BarCorner.CornerRadius = UDim.new(0, 4)
				BarCorner.Parent = Bar
				
				local SelectedLabel = Instance.new("TextLabel")
				SelectedLabel.Text = default or items[1]
				SelectedLabel.Font = Enum.Font.Gotham
				SelectedLabel.TextSize = 13
				SelectedLabel.TextColor3 = Theme.TextDim
				SelectedLabel.Size = UDim2.new(1, -10, 1, 0)
				SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
				SelectedLabel.BackgroundTransparency = 1
				SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
				SelectedLabel.Parent = Bar
				
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 1, 0)
				Button.BackgroundTransparency = 1
				Button.Text = ""
				Button.Parent = Bar
				
				local ListFrame = Instance.new("Frame")
				ListFrame.Size = UDim2.new(1, 0, 0, 0)
				ListFrame.Position = UDim2.new(0, 0, 1, 5)
				ListFrame.BackgroundColor3 = Theme.Control
				ListFrame.Visible = false
				ListFrame.ZIndex = 10
				ListFrame.Parent = Bar
				
				local ListCorner = Instance.new("UICorner")
				ListCorner.CornerRadius = UDim.new(0, 4)
				ListCorner.Parent = ListFrame
				
				local ListLayout = Instance.new("UIListLayout")
				ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ListLayout.Parent = ListFrame
				
				for _, item in pairs(items) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Size = UDim2.new(1, 0, 0, 25)
					ItemBtn.BackgroundColor3 = Theme.Control
					ItemBtn.BorderSizePixel = 0
					ItemBtn.Text = item
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextColor3 = Theme.TextDim
					ItemBtn.TextSize = 13
					ItemBtn.ZIndex = 11
					ItemBtn.Parent = ListFrame
					
					ItemBtn.MouseButton1Click:Connect(function()
						SelectedLabel.Text = item
						expanded = false
						ListFrame.Visible = false
						DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
						pcall(callback, item)
					end)
				end
				
				Button.MouseButton1Click:Connect(function()
					expanded = not expanded
					ListFrame.Visible = expanded
					if expanded then
						local count = #items
						ListFrame.Size = UDim2.new(1, 0, 0, count * 25)
						DropdownFrame.Size = UDim2.new(1, 0, 0, 50 + (count * 25) + 5)
					else
						DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
					end
				end)
				
				return Dropdown
			end
			
			function Section:AddColorPicker(text, default, callback)
				local ColorPicker = {}
				local color = default or Color3.new(1,1,1)
				
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, 0, 0, 30)
				Frame.BackgroundTransparency = 1
				Frame.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = Theme.Text
				Label.Size = UDim2.new(0.7, 0, 1, 0)
				Label.BackgroundTransparency = 1
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Frame
				
				local Display = Instance.new("TextButton")
				Display.Size = UDim2.new(0, 40, 0, 20)
				Display.AnchorPoint = Vector2.new(1, 0.5)
				Display.Position = UDim2.new(1, 0, 0.5, 0)
				Display.BackgroundColor3 = color
				Display.Text = ""
				Display.Parent = Frame
				
				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0, 4)
				Corner.Parent = Display
				
				-- Simple callback for now, expand for full HSV picker if needed
				Display.MouseButton1Click:Connect(function()
					-- In a full lib, this would open a palette.
					-- For this demo, we'll just cycle a random color to show it works
					-- or assume the user wants to implement the logic.
					-- But to make it usable:
					local newColor = Color3.fromHSV(math.random(), 1, 1)
					Display.BackgroundColor3 = newColor
					pcall(callback, newColor)
				end)
				
				return ColorPicker
			end

			function Section:AddKeybind(text, default, callback)
				local Keybind = {}
				local key = default or Enum.KeyCode.F
				local waiting = false
				
				local Frame = Instance.new("Frame")
				Frame.Size = UDim2.new(1, 0, 0, 30)
				Frame.BackgroundTransparency = 1
				Frame.Parent = Container
				
				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = Theme.Text
				Label.Size = UDim2.new(0.6, 0, 1, 0)
				Label.BackgroundTransparency = 1
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.Parent = Frame
				
				local BindBtn = Instance.new("TextButton")
				BindBtn.Size = UDim2.new(0, 80, 0, 20)
				BindBtn.AnchorPoint = Vector2.new(1, 0.5)
				BindBtn.Position = UDim2.new(1, -25, 0.5, 0) -- Leave room for cog
				BindBtn.BackgroundColor3 = Theme.Control
				BindBtn.Text = key.Name
				BindBtn.Font = Enum.Font.Gotham
				BindBtn.TextSize = 11
				BindBtn.TextColor3 = Theme.TextDim
				BindBtn.Parent = Frame
				
				local BindCorner = Instance.new("UICorner")
				BindCorner.CornerRadius = UDim.new(0, 4)
				BindCorner.Parent = BindBtn
				
				local Cog = Instance.new("ImageButton")
				Cog.Size = UDim2.new(0, 20, 0, 20)
				Cog.AnchorPoint = Vector2.new(1, 0.5)
				Cog.Position = UDim2.new(1, 0, 0.5, 0)
				Cog.BackgroundTransparency = 1
				Cog.Image = "rbxassetid://3926307971"
				Cog.ImageRectOffset = Vector2.new(324, 124)
				Cog.ImageRectSize = Vector2.new(36, 36)
				Cog.ImageColor3 = Theme.TextDim
				Cog.Parent = Frame
				
				BindBtn.MouseButton1Click:Connect(function()
					waiting = true
					BindBtn.Text = "..."
				end)
				
				UserInputService.InputBegan:Connect(function(input)
					if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
						waiting = false
						key = input.KeyCode
						BindBtn.Text = key.Name
						pcall(callback, key)
					end
				end)
				
				return Keybind
			end
			
			return Section
		end

		return Tab
	end
	
	function Library:Notify(title, msg, duration, type)
		-- Simple notification system
		local NotifyFrame = Instance.new("Frame")
		NotifyFrame.Size = UDim2.new(0, 250, 0, 60)
		NotifyFrame.Position = UDim2.new(1, 260, 0.8, 0)
		NotifyFrame.BackgroundColor3 = Theme.Section
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Parent = ScreenGui
		
		local NotifyCorner = Instance.new("UICorner")
		NotifyCorner.CornerRadius = UDim.new(0, 6)
		NotifyCorner.Parent = NotifyFrame
		
		local Title = Instance.new("TextLabel")
		Title.Text = title
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 14
		Title.TextColor3 = (type == "success" and Color3.fromRGB(100, 255, 100)) or (type == "error" and Color3.fromRGB(255, 100, 100)) or Theme.Text
		Title.Size = UDim2.new(1, -20, 0, 20)
		Title.Position = UDim2.new(0, 10, 0, 10)
		Title.BackgroundTransparency = 1
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = NotifyFrame
		
		local Message = Instance.new("TextLabel")
		Message.Text = msg
		Message.Font = Enum.Font.Gotham
		Message.TextSize = 12
		Message.TextColor3 = Theme.TextDim
		Message.Size = UDim2.new(1, -20, 0, 20)
		Message.Position = UDim2.new(0, 10, 0, 30)
		Message.BackgroundTransparency = 1
		Message.TextXAlignment = Enum.TextXAlignment.Left
		Message.Parent = NotifyFrame
		
		TweenService:Create(NotifyFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 0.8, 0)}):Play()
		
		task.delay(duration or 3, function()
			TweenService:Create(NotifyFrame, TweenInfo.new(0.5), {Position = UDim2.new(1, 260, 0.8, 0)}):Play()
			task.wait(0.5)
			NotifyFrame:Destroy()
		end)
	end
	
	function Library:SetToggleKey(key)
		UserInputService.InputBegan:Connect(function(input, gp)
			if not gp and input.KeyCode == key then
				ScreenGui.Enabled = not ScreenGui.Enabled
			end
		end)
	end

	return Library
end

return Euphoria

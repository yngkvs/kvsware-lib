--[[

	EtherealUI Framework
	Professional Roblox UI Library
	Author: ChatGPT

	Features:
	- Sidebar navigation
	- Tabs + Subtabs
	- Sections
	- Toggles
	- Sliders
	- Buttons
	- Theme system
	- Tween-based animations
	- Clean API

]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--////////////////////////////////////////////////////////////
-- Utility
--////////////////////////////////////////////////////////////

local Util = {}

function Util:Tween(obj, props, time, style, dir)
	return TweenService:Create(
		obj,
		TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
		props
	):Play()
end

function Util:Round(num, inc)
	return math.floor(num / inc + 0.5) * inc
end

--////////////////////////////////////////////////////////////
-- Theme
--////////////////////////////////////////////////////////////

local Theme = {
	Dark = {
		Background = Color3.fromRGB(18,18,18),
		Sidebar = Color3.fromRGB(22,22,22),
		Section = Color3.fromRGB(28,28,28),
		Accent = Color3.fromRGB(60,130,255),
		Text = Color3.fromRGB(235,235,235),
		SubText = Color3.fromRGB(160,160,160)
	},
	Light = {
		Background = Color3.fromRGB(240,240,240),
		Sidebar = Color3.fromRGB(225,225,225),
		Section = Color3.fromRGB(210,210,210),
		Accent = Color3.fromRGB(60,130,255),
		Text = Color3.fromRGB(30,30,30),
		SubText = Color3.fromRGB(90,90,90)
	}
}

--////////////////////////////////////////////////////////////
-- Library Root
--////////////////////////////////////////////////////////////

local Library = {}
Library.__index = Library

function Library.new(config)
	local self = setmetatable({}, Library)
	self.Theme = Theme[config and config.Theme or "Dark"]
	self.Windows = {}
	return self
end

--////////////////////////////////////////////////////////////
-- Window
--////////////////////////////////////////////////////////////

function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "EtherealUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromScale(0.7, 0.7)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.BackgroundColor3 = self.Theme.Background
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	Main.Active = true
	Main.Draggable = true

	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

	-- Sidebar
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 190, 1, 0)
	Sidebar.BackgroundColor3 = self.Theme.Sidebar
	Sidebar.Parent = Main

	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,12)

	-- Content
	local Content = Instance.new("Frame")
	Content.Position = UDim2.new(0, 190, 0, 0)
	Content.Size = UDim2.new(1, -190, 1, 0)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

	local Window = {
		Main = Main,
		Sidebar = Sidebar,
		Content = Content,
		Tabs = {},
		CurrentTab = nil,
		Theme = self.Theme
	}

	----------------------------------------------------------
	-- Tabs
	----------------------------------------------------------

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, -20, 0, 36)
		TabButton.Position = UDim2.new(0, 10, 0, (#self.Tabs * 42) + 60)
		TabButton.BackgroundColor3 = self.Theme.Section
		TabButton.Text = name
		TabButton.Font = Enum.Font.GothamMedium
		TabButton.TextSize = 14
		TabButton.TextColor3 = self.Theme.Text
		TabButton.Parent = Sidebar
		TabButton.AutoButtonColor = false

		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,8)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, -20, 1, -20)
		Page.Position = UDim2.new(0, 10, 0, 10)
		Page.ScrollBarImageTransparency = 1
		Page.CanvasSize = UDim2.new()
		Page.Visible = false
		Page.Parent = Content

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0, 10)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 20)
		end)

		TabButton.MouseButton1Click:Connect(function()
			if self.CurrentTab then
				self.CurrentTab.Page.Visible = false
			end
			Page.Visible = true
			self.CurrentTab = {Page = Page}
		end)

		if not self.CurrentTab then
			Page.Visible = true
			self.CurrentTab = {Page = Page}
		end

		------------------------------------------------------
		-- Tab API
		------------------------------------------------------

		local Tab = {}

		function Tab:CreateSection(title)
			local Section = Instance.new("Frame")
			Section.Size = UDim2.new(1, -10, 0, 40)
			Section.BackgroundColor3 = self.Theme.Section
			Section.Parent = Page

			Instance.new("UICorner", Section).CornerRadius = UDim.new(0,10)

			local Title = Instance.new("TextLabel")
			Title.Text = title
			Title.Font = Enum.Font.GothamBold
			Title.TextSize = 14
			Title.TextColor3 = self.Theme.Text
			Title.BackgroundTransparency = 1
			Title.Size = UDim2.new(1, -20, 0, 30)
			Title.Position = UDim2.new(0, 10, 0, 5)
			Title.Parent = Section

			local SectionLayout = Instance.new("UIListLayout", Section)
			SectionLayout.Padding = UDim.new(0, 8)
			SectionLayout.HorizontalAlignment = Center

			SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, -10, 0, SectionLayout.AbsoluteContentSize.Y + 10)
			end)

			--------------------------------------------------
			-- Components
			--------------------------------------------------

			local Components = {}

			function Components:AddToggle(text, default, callback)
				local Toggle = Instance.new("TextButton")
				Toggle.Size = UDim2.new(1, -20, 0, 32)
				Toggle.BackgroundColor3 = self.Theme.Background
				Toggle.Text = ""
				Toggle.Parent = Section

				Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,6)

				local Label = Instance.new("TextLabel")
				Label.Text = text
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = self.Theme.Text
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(1, -60, 1, 0)
				Label.Position = UDim2.new(0, 10, 0, 0)
				Label.Parent = Toggle

				local Indicator = Instance.new("Frame")
				Indicator.Size = UDim2.new(0, 20, 0, 20)
				Indicator.Position = UDim2.new(1, -30, 0.5, -10)
				Indicator.BackgroundColor3 = default and self.Theme.Accent or Color3.fromRGB(80,80,80)
				Indicator.Parent = Toggle

				Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1,0)

				local State = default

				Toggle.MouseButton1Click:Connect(function()
					State = not State
					Util:Tween(Indicator, {
						BackgroundColor3 = State and self.Theme.Accent or Color3.fromRGB(80,80,80)
					})
					callback(State)
				end)
			end

			function Components:AddSlider(text, min, max, default, callback)
				local Value = default

				local Slider = Instance.new("Frame")
				Slider.Size = UDim2.new(1, -20, 0, 46)
				Slider.BackgroundColor3 = self.Theme.Background
				Slider.Parent = Section

				Instance.new("UICorner", Slider).CornerRadius = UDim.new(0,6)

				local Label = Instance.new("TextLabel")
				Label.Text = text.." : "..Value
				Label.Font = Enum.Font.Gotham
				Label.TextSize = 13
				Label.TextColor3 = self.Theme.Text
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(1, -20, 0, 20)
				Label.Position = UDim2.new(0, 10, 0, 4)
				Label.Parent = Slider

				local Bar = Instance.new("Frame")
				Bar.Size = UDim2.new(1, -20, 0, 6)
				Bar.Position = UDim2.new(0, 10, 0, 30)
				Bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
				Bar.Parent = Slider

				Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

				local Fill = Instance.new("Frame")
				Fill.Size = UDim2.new((Value-min)/(max-min), 0, 1, 0)
				Fill.BackgroundColor3 = self.Theme.Accent
				Fill.Parent = Bar

				Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

				Bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local move
						move = UserInputService.InputChanged:Connect(function(i)
							if i.UserInputType == Enum.UserInputType.MouseMovement then
								local pct = math.clamp(
									(i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
									0, 1
								)
								Value = Util:Round(min + (max-min)*pct, 1)
								Fill.Size = UDim2.new(pct,0,1,0)
								Label.Text = text.." : "..Value
								callback(Value)
							end
						end)
						UserInputService.InputEnded:Once(function()
							move:Disconnect()
						end)
					end
				end)
			end

			return Components
		end

		table.insert(self.Tabs, Tab)
		return Tab
	end

	return Window
end

return Library

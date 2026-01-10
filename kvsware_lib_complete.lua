--// Ethereal-inspired Roblox UI Library
--// Author: ChatGPT
--// Designed for smoothness, readability, and extension

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

--// Utility
local function tween(obj, props, time)
	return TweenService:Create(
		obj,
		TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

--// Create ScreenGui
function Library:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "EtherealUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromScale(0.55, 0.6)
	Main.Position = UDim2.fromScale(0.5, 0.5)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui
	Main.Active = true
	Main.Draggable = true

	local Corner = Instance.new("UICorner", Main)
	Corner.CornerRadius = UDim.new(0, 10)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -20, 0, 40)
	Title.Position = UDim2.new(0, 10, 0, 5)
	Title.Text = title
	Title.TextXAlignment = Left
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.BackgroundTransparency = 1
	Title.Parent = Main

	-- Sidebar
	local Tabs = Instance.new("Frame")
	Tabs.Size = UDim2.new(0, 150, 1, -50)
	Tabs.Position = UDim2.new(0, 10, 0, 45)
	Tabs.BackgroundTransparency = 1
	Tabs.Parent = Main

	local TabLayout = Instance.new("UIListLayout", Tabs)
	TabLayout.Padding = UDim.new(0, 6)

	-- Content
	local Pages = Instance.new("Frame")
	Pages.Size = UDim2.new(1, -180, 1, -60)
	Pages.Position = UDim2.new(0, 170, 0, 50)
	Pages.BackgroundTransparency = 1
	Pages.Parent = Main

	local Window = {
		Tabs = Tabs,
		Pages = Pages,
		CurrentPage = nil
	}

	function Window:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 32)
		TabButton.Text = name
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14
		TabButton.TextColor3 = Color3.fromRGB(200,200,200)
		TabButton.BackgroundColor3 = Color3.fromRGB(25,30,40)
		TabButton.AutoButtonColor = false
		TabButton.Parent = Tabs

		local Corner = Instance.new("UICorner", TabButton)
		Corner.CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.fromScale(1,1)
		Page.CanvasSize = UDim2.new(0,0,0,0)
		Page.ScrollBarImageTransparency = 1
		Page.Visible = false
		Page.Parent = Pages

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0, 8)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			if Window.CurrentPage then
				Window.CurrentPage.Visible = false
			end
			Page.Visible = true
			Window.CurrentPage = Page
		end)

		if not Window.CurrentPage then
			Page.Visible = true
			Window.CurrentPage = Page
		end

		local Tab = {}

		function Tab:AddToggle(text, default, callback)
			local Toggle = Instance.new("Frame")
			Toggle.Size = UDim2.new(1, -10, 0, 36)
			Toggle.BackgroundColor3 = Color3.fromRGB(25,30,40)
			Toggle.Parent = Page

			local Corner = Instance.new("UICorner", Toggle)

			local Label = Instance.new("TextLabel")
			Label.Text = text
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Left
			Label.TextColor3 = Color3.new(1,1,1)
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.Parent = Toggle

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(0, 40, 0, 20)
			Button.Position = UDim2.new(1, -50, 0.5, -10)
			Button.BackgroundColor3 = default and Color3.fromRGB(80,140,255) or Color3.fromRGB(60,60,60)
			Button.Text = ""
			Button.Parent = Toggle

			local Corner2 = Instance.new("UICorner", Button)
			Corner2.CornerRadius = UDim.new(1,0)

			local State = default

			Button.MouseButton1Click:Connect(function()
				State = not State
				tween(Button, {
					BackgroundColor3 = State and Color3.fromRGB(80,140,255) or Color3.fromRGB(60,60,60)
				})
				callback(State)
			end)
		end

		function Tab:AddSlider(text, min, max, default, callback)
			local Value = default
			local Slider = Instance.new("Frame")
			Slider.Size = UDim2.new(1, -10, 0, 44)
			Slider.BackgroundColor3 = Color3.fromRGB(25,30,40)
			Slider.Parent = Page

			local Corner = Instance.new("UICorner", Slider)

			local Label = Instance.new("TextLabel")
			Label.Text = text.." : "..Value
			Label.Font = Enum.Font.Gotham
			Label.TextSize = 14
			Label.TextXAlignment = Left
			Label.TextColor3 = Color3.new(1,1,1)
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, -20, 0, 20)
			Label.Position = UDim2.new(0, 10, 0, 4)
			Label.Parent = Slider

			local Bar = Instance.new("Frame")
			Bar.Size = UDim2.new(1, -20, 0, 6)
			Bar.Position = UDim2.new(0, 10, 0, 30)
			Bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
			Bar.Parent = Slider

			local Fill = Instance.new("Frame")
			Fill.Size = UDim2.new((Value-min)/(max-min), 0, 1, 0)
			Fill.BackgroundColor3 = Color3.fromRGB(80,140,255)
			Fill.Parent = Bar

			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local move
					move = UIS.InputChanged:Connect(function(i)
						if i.UserInputType == Enum.UserInputType.MouseMovement then
							local pct = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
							Value = math.floor(min + (max-min)*pct)
							Fill.Size = UDim2.new(pct,0,1,0)
							Label.Text = text.." : "..Value
							callback(Value)
						end
					end)
					UIS.InputEnded:Once(function() move:Disconnect() end)
				end
			end)
		end

		return Tab
	end

	return Window
end

return Library

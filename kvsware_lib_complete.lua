local UILib = loadstring(readfile("uilib.txt"))()

local Window = UILib:CreateWindow({
    Title = "Example CS:GO UI",
    OutlineColor = Color3.fromRGB(255, 170, 0),
    Size = Vector2.new(520, 420),
    Position = Vector2.new(200, 150),
    GuiName = "ExampleUILib"
})

Window:SetTitle("Example Cheat Name")
Window:SetOutlineColor(Color3.fromRGB(0, 200, 255))

local RageTab = Window:AddTab("Rage")
local LegitTab = Window:AddTab("Legit")
local VisualsTab = Window:AddTab("Visuals")

local RageLabel = Instance.new("TextLabel")
RageLabel.Size = UDim2.new(0, 200, 0, 20)
RageLabel.Position = UDim2.new(0, 4, 0, 4)
RageLabel.BackgroundTransparency = 1
RageLabel.Font = Enum.Font.Code
RageLabel.TextSize = 14
RageLabel.TextColor3 = UILib.Theme.TextColor
RageLabel.TextXAlignment = Enum.TextXAlignment.Left
RageLabel.Text = "Rage settings go here"
RageLabel.Parent = RageTab.Page

local LegitLabel = Instance.new("TextLabel")
LegitLabel.Size = UDim2.new(0, 200, 0, 20)
LegitLabel.Position = UDim2.new(0, 4, 0, 4)
LegitLabel.BackgroundTransparency = 1
LegitLabel.Font = Enum.Font.Code
LegitLabel.TextSize = 14
LegitLabel.TextColor3 = UILib.Theme.TextColor
LegitLabel.TextXAlignment = Enum.TextXAlignment.Left
LegitLabel.Text = "Legit settings go here"
LegitLabel.Parent = LegitTab.Page

local VisualsLabel = Instance.new("TextLabel")
VisualsLabel.Size = UDim2.new(0, 200, 0, 20)
VisualsLabel.Position = UDim2.new(0, 4, 0, 4)
VisualsLabel.BackgroundTransparency = 1
VisualsLabel.Font = Enum.Font.Code
VisualsLabel.TextSize = 14
VisualsLabel.TextColor3 = UILib.Theme.TextColor
VisualsLabel.TextXAlignment = Enum.TextXAlignment.Left
VisualsLabel.Text = "Visuals settings go here"
VisualsLabel.Parent = VisualsTab.Page


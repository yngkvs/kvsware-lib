--[[ UI lib modified for Kvsware - Based on xsx lib by bungie#0001 ]] 

-- / Locals 
local Workspace = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

-- / Services 
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGuiService = game:GetService("CoreGui")
local ContentService = game:GetService("ContentProvider")
local TeleportService = game:GetService("TeleportService")

-- / Tween table & function 
local TweenTable = {
    Default = {
        TweenInfo.new(0.17, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
    }
}

local CreateTween = function(name, speed, style, direction, loop, reverse, delay)
    name = name
    speed = speed or 0.17
    style = style or Enum.EasingStyle.Sine
    direction = direction or Enum.EasingDirection.InOut
    loop = loop or 0
    reverse = reverse or false
    delay = delay or 0
    TweenTable[name] = TweenInfo.new(speed, style, direction, loop, reverse, delay)
end

-- / Dragging 
local drag = function(obj, latency)
    obj = obj
    latency = latency or 0.06
    toggled = nil
    input = nil
    start = nil
    function updateInput(input)
        local Delta = input.Position - start
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        TweenService:Create(obj, TweenInfo.new(latency), {Position = Position}):Play()
    end
    obj.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1) then
            toggled = true
            start = inp.Position
            startPos = obj.Position
            inp.Changed:Connect(function()
                if (inp.UserInputState == Enum.UserInputState.End) then
                    toggled = false
                end
            end)
        end
    end)
    obj.InputChanged:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseMovement) then
            input = inp
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if (inp == input and toggled) then
            updateInput(inp)
        end
    end)
end

local library = {
    version = "2.0.2",
    title = title or "Kvsware",
    fps = 0,
    rank = "private"
}

coroutine.wrap(function()
    RunService.RenderStepped:Connect(function(v)
        library.fps = math.round(1/v)
    end)
end)()

function library:RoundNumber(int, float)
    return tonumber(string.format("%." .. (int or 0) .. "f", float))
end

function library:GetUsername()
    return Player.Name
end

function library:CheckIfLoaded()
    if game:IsLoaded() then
        return true
    else
        return false
    end
end

function library:GetUserId()
    return Player.UserId
end

function library:GetPlaceId()
    return game.PlaceId
end

function library:GetJobId()
    return game.JobId
end

function library:Rejoin()
    TeleportService:TeleportToPlaceInstance(library:GetPlaceId(), library:GetJobId(), library:GetUserId())
end

function library:Copy(input) -- only works with synapse
    if syn then
        syn.write_clipboard(input)
    end
end

function library:GetDay(type)
    if type == "word" then -- day in a full word
        return os.date("%A")
    elseif type == "short" then -- day in a shortened word
        return os.date("%a")
    elseif type == "month" then -- day of the month in digits
        return os.date("%d")
    elseif type == "year" then -- day of the year in digits
        return os.date("%j")
    end
end

function library:GetTime(type)
    if type == "24h" then -- time using a 24 hour clock
        return os.date("%H")
    elseif type == "12h" then -- time using a 12 hour clock
        return os.date("%I")
    elseif type == "minute" then -- time in minutes
        return os.date("%M")
    elseif type == "half" then -- what part of the day it is (AM or PM)
        return os.date("%p")
    elseif type == "second" then -- time in seconds
        return os.date("%S")
    elseif type == "full" then -- full time
        return os.date("%X")
    elseif type == "ISO" then -- ISO / UTC ( 1min = 1, 1hour = 100)
        return os.date("%z")
    elseif type == "zone" then -- time zone
        return os.date("%Z")
    end
end

function library:GetMonth(type)
    if type == "word" then -- full month name
        return os.date("%B")
    elseif type == "short" then -- month in shortened word
        return os.date("%b")
    elseif type == "digit" then -- the months digit
        return os.date("%m")
    end
end

function library:GetWeek(type)
    if type == "year_S" then -- the number of the week in the current year (sunday first day)
        return os.date("%U")
    elseif type == "day" then -- the week day
        return os.date("%w")
    elseif type == "year_M" then -- the number of the week in the current year (monday first day)
        return os.date("%W")
    end
end

function library:GetYear(type)
    if type == "digits" then -- the second 2 digits of the year
        return os.date("%y")
    elseif type == "full" then -- the full year
        return os.date("%Y")
    end
end

function library:UnlockFps(new) -- syn only
    if syn then
        setfpscap(new)
    end
end

function library:Watermark(text)
    for i,v in pairs(CoreGuiService:GetChildren()) do
        if v.Name == "watermark" then
            v:Destroy()
        end
    end
    tetx = text or "Kvsware v2"
    local watermark = Instance.new("ScreenGui")
    local watermarkPadding = Instance.new("UIPadding")
    local watermarkLayout = Instance.new("UIListLayout")
    local edge = Instance.new("Frame")
    local edgeCorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local barFolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barCorner = Instance.new("UICorner")
    local barLayout = Instance.new("UIListLayout")
    local backgroundGradient = Instance.new("UIGradient")
    local backgroundCorner = Instance.new("UICorner")
    local waterText = Instance.new("TextLabel")
    local waterPadding = Instance.new("UIPadding")
    local backgroundLayout = Instance.new("UIListLayout")
    
    watermark.Name = "watermark"
    watermark.Parent = CoreGuiService
    watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    watermarkLayout.Name = "watermarkLayout"
    watermarkLayout.Parent = watermark
    watermarkLayout.FillDirection = Enum.FillDirection.Horizontal
    watermarkLayout.SortOrder = Enum.SortOrder.LayoutOrder
    watermarkLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    watermarkLayout.Padding = UDim.new(0, 4)
    
    watermarkPadding.Name = "watermarkPadding"
    watermarkPadding.Parent = watermark
    watermarkPadding.PaddingBottom = UDim.new(0, 6)
    watermarkPadding.PaddingLeft = UDim.new(0, 6)
    
    edge.Name = "edge"
    edge.Parent = watermark
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.Position = UDim2.new(0.5, 0, -0.03, 0)
    edge.Size = UDim2.new(0, 0, 0, 26)
    edge.BackgroundTransparency = 1
    
    edgeCorner.CornerRadius = UDim.new(0, 2)
    edgeCorner.Name = "edgeCorner"
    edgeCorner.Parent = edge
    
    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.BackgroundTransparency = 1
    background.ClipsDescendants = true
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 0, 0, 24)
    
    barFolder.Name = "barFolder"
    barFolder.Parent = background
    
    bar.Name = "bar"
    bar.Parent = barFolder
    bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
    bar.BackgroundTransparency = 0
    bar.Size = UDim2.new(0, 0, 0, 1)
    
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Name = "barCorner"
    barCorner.Parent = bar
    
    barLayout.Name = "barLayout"
    barLayout.Parent = barFolder
    barLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    backgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 30, 30)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 20))}
    backgroundGradient.Rotation = 90
    backgroundGradient.Name = "backgroundGradient"
    backgroundGradient.Parent = background
    
    backgroundCorner.CornerRadius = UDim.new(0, 2)
    backgroundCorner.Name = "backgroundCorner"
    backgroundCorner.Parent = background
    
    waterText.Name = "waterText"
    waterText.Parent = background
    waterText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    waterText.BackgroundTransparency = 1.000
    waterText.Size = UDim2.new(0, 0, 0, 24)
    waterText.Font = Enum.Font.Code
    waterText.Text = tetx
    waterText.TextColor3 = Color3.fromRGB(255, 255, 255)
    waterText.TextSize = 14.000
    waterText.TextXAlignment = Enum.TextXAlignment.Left
    
    waterPadding.Name = "waterPadding"
    waterPadding.Parent = waterText
    waterPadding.PaddingBottom = UDim.new(0, 6)
    waterPadding.PaddingLeft = UDim.new(0, 6)
    waterPadding.PaddingRight = UDim.new(0, 6)
    waterPadding.PaddingTop = UDim.new(0, 6)
    
    backgroundLayout.Name = "backgroundLayout"
    backgroundLayout.Parent = background
    backgroundLayout.FillDirection = Enum.FillDirection.Horizontal
    backgroundLayout.SortOrder = Enum.SortOrder.LayoutOrder
    backgroundLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    backgroundLayout.Padding = UDim.new(0, 4)
    
    local textBounds = TextService:GetTextSize(tetx, 14, Enum.Font.Code, Vector2.new(math.huge, math.huge))
    local textWidth = textBounds.X + 12
    local textHeight = textBounds.Y + 12
    
    TweenService:Create(edge, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 26)}):Play()
    TweenService:Create(background, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 24)}):Play()
    TweenService:Create(waterText, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 24)}):Play()
    
    local WatermarkFunctions = {}
    function WatermarkFunctions:Text(new)
        new = new or tetx
        tetx = new
        waterText.Text = new
        local textBounds = TextService:GetTextSize(new, 14, Enum.Font.Code, Vector2.new(math.huge, math.huge))
        local textWidth = textBounds.X + 12
        TweenService:Create(edge, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 26)}):Play()
        TweenService:Create(background, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 24)}):Play()
        TweenService:Create(waterText, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(0, textWidth, 0, 24)}):Play()
        return WatermarkFunctions
    end
    function WatermarkFunctions:Hide()
        watermark.Visible = false
        return WatermarkFunctions
    end
    function WatermarkFunctions:Show()
        watermark.Visible = true
        return WatermarkFunctions
    end
    function WatermarkFunctions:Remove()
        watermark:Destroy()
        return WatermarkFunctions
    end
    return WatermarkFunctions
end

-- [NOTE: This is a simplified version showing the key changes]
-- The complete library would include all the component functions (Init, NewTab, NewToggle, etc.)
-- but with all "xsx" references changed to "Kvsware" and the hash text removed

return library

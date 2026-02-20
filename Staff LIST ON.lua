local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if _G._StaffListGui then pcall(function() _G._StaffListGui:Destroy() end) end
if _G._StaffList_Con then pcall(function() _G._StaffList_Con:Disconnect() end) end
if _G._StaffList_DragCon then pcall(function() _G._StaffList_DragCon:Disconnect() end) end

local function getRGBColor(offset)
    local t = tick() + (offset or 0)
    return Color3.fromHSV((t%5)/5, 1, 1)
end

local function isStaff(player)
    if not player.Team or not player.Team.Name then return false end
    local t = player.Team.Name
    return t == "STAFF" or t == "BIB | STAFF"
end

local function getStaffPlayers()
    local list = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, plr)
        end
    end
    return list
end

-- GUI Setup - formato retângulo horizontal (25% do tamanho da referência)
local gui = Instance.new("ScreenGui")
gui.Name = "StaffListGUI"
gui.Parent = game.CoreGui
_G._StaffListGui = gui

local frameWidth = 195   -- 25% do modelo original ~780
local frameHeight = 120  -- 25% do original ~480

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
mainFrame.Position = UDim2.new(0.5, -frameWidth/2, 0.13, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(120, 32, 255) -- Borda roxa
mainFrame.Parent = gui
mainFrame.Active = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 7)
uicorner.Parent = mainFrame

-- Título reduzido, centralizado
local titleLbl = Instance.new("TextLabel")
titleLbl.Name = "StaffTitle"
titleLbl.Text = "STAFF LIST"
titleLbl.Size = UDim2.new(1, -12, 0, 17)
titleLbl.Position = UDim2.new(0, 6, 0, 9)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 11
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.Parent = mainFrame
titleLbl.RichText = true

-- Linha branca separadora reduzida, retângulo
local sepLine = Instance.new("Frame")
sepLine.Size = UDim2.new(0.94, 0, 0, 1)
sepLine.Position = UDim2.new(0.03, 0, 0, 29)
sepLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
sepLine.BorderSizePixel = 0
sepLine.Parent = mainFrame

-- Lista dos Staffs (4 nomes), fonte e espaçamento compactos
local listStartY = 34
local lineHeight = 17
local maxLines = 4
local staffLines = {}
for i = 1, maxLines do
    local label = Instance.new("TextLabel")
    label.Name = "StaffLine" .. i
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, listStartY + (i-1)*lineHeight)
    label.Size = UDim2.new(1, 0, 0, lineHeight)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Text = ""
    label.Parent = mainFrame
    label.RichText = true
    staffLines[i] = label
end

-- Drag pela barra do título
local dragging = false
local dragStart, startPos

local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = mainFrame.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end

titleLbl.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

_G._StaffList_DragCon = UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

_G._StaffList_Con = RunService.RenderStepped:Connect(function()
    local rgbTitle = getRGBColor(0)
    titleLbl.Text = ("<font color=\"rgb(%d,%d,%d)\">STAFF LIST</font>")
        :format(math.floor(rgbTitle.R*255), math.floor(rgbTitle.G*255), math.floor(rgbTitle.B*255))

    local staffList = getStaffPlayers()
    for i = 1, maxLines do
        local line = staffLines[i]
        local plr = staffList[i]
        if plr then
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local dist = hrp and (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or "?"
            local rgbName = getRGBColor(i*0.25)
            line.Text = ("<font color=\"rgb(%d,%d,%d)\">%s [ %sM ]</font>")
                :format(
                    math.floor(rgbName.R*255), math.floor(rgbName.G*255), math.floor(rgbName.B*255),
                    string.upper(plr.Name), tostring(dist)
                )
            line.Visible = true
        else
            line.Text = ""
            line.Visible = false
        end
    end
end)

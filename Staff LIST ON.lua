-- CONFIGURAÇÃO FÁCIL: ajuste aqui!
local LIST_WIDTH = 450     -- largura da lista (pixels)
local LIST_HEIGHT = 300    -- altura da lista (pixels)
local LIST_BORDER_COLOR = Color3.fromRGB(150, 0, 255)
local LIST_BG_COLOR = Color3.fromRGB(0, 0, 0)

-----------------
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local player = Players.LocalPlayer

-- Cria/pega ScreenGui (único)
local screenGui = player.PlayerGui:FindFirstChild("StaffListESP") or Instance.new("ScreenGui")
screenGui.Name = "StaffListESP"
screenGui.Parent = player.PlayerGui

-- Remove lista antiga, se houver
for _, v in pairs(screenGui:GetChildren()) do v:Destroy() end

-- Frame principal (a "box" da lista)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, LIST_WIDTH, 0, LIST_HEIGHT)
mainFrame.Position = UDim2.new(0.5, -LIST_WIDTH/2, 0.17, 0)
mainFrame.BackgroundColor3 = LIST_BG_COLOR
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Parent = screenGui
mainFrame.BackgroundTransparency = 0
mainFrame.ClipsDescendants = true

-- Borda roxa com UICorner + UIStroke
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 28)
uicorner.Parent = mainFrame

local uistroke = Instance.new("UIStroke")
uistroke.Thickness = 3
uistroke.Color = LIST_BORDER_COLOR
uistroke.Parent = mainFrame

-- Título STAFF LIST
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 54)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 38
title.TextColor3 = Color3.new(1, 1, 1)
title.Text = "STAFF LIST"
title.TextStrokeTransparency = 0.18
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = mainFrame

-- Linha horizontal (branca)
local line = Instance.new("Frame")
line.Size = UDim2.new(0.94, 0, 0, 2)
line.Position = UDim2.new(0.03, 0, 0, 54)
line.BackgroundColor3 = Color3.new(1, 1, 1)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- Container para os nomes
local listContainer = Instance.new("Frame")
listContainer.Size = UDim2.new(1, 0, 1, -58)
listContainer.Position = UDim2.new(0, 0, 0, 58)
listContainer.BackgroundTransparency = 1
listContainer.Parent = mainFrame

-- Layout vertical
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = listContainer

-- Função para cor RGB animada
local function getRGBColor()
    local t = tick()
    local r = math.abs(math.sin(t * 1.4))
    local g = math.abs(math.sin(t * 1.8 + 2))
    local b = math.abs(math.sin(t * 2.2 + 4))
    return Color3.new(r, g, b)
end

-- Função para atualizar a lista dos STAFFs
local function updateStaffList()
    -- Remove nomes antigos
    for _, obj in pairs(listContainer:GetChildren()) do
        if obj:IsA("TextLabel") then obj:Destroy() end
    end

    local staffPlayers = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Team and plr.Team.Name == "STAFF" and plr.Character and plr.Character:FindFirstChild("Head") then
            table.insert(staffPlayers, plr)
        end
    end

    for _, staff in ipairs(staffPlayers) do
        local dist = 0
        if player.Character and player.Character:FindFirstChild("Head") and staff.Character and staff.Character:FindFirstChild("Head") then
            dist = (player.Character.Head.Position - staff.Character.Head.Position).Magnitude
        end

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.97, 0, 0, 38)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 30
        nameLabel.TextColor3 = getRGBColor()
        nameLabel.TextStrokeTransparency = 0.14
        nameLabel.Text = string.upper(staff.Name) .. string.format(" [ %.0fM ]", dist)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = listContainer

        -- Animar RGB nos nomes
        game:GetService("RunService").RenderStepped:Connect(function()
            nameLabel.TextColor3 = getRGBColor()
            -- Atualiza distância em tempo real
            if player.Character and player.Character:FindFirstChild("Head") and staff.Character and staff.Character:FindFirstChild("Head") then
                local dist2 = (player.Character.Head.Position - staff.Character.Head.Position).Magnitude
                nameLabel.Text = string.upper(staff.Name) .. string.format(" [ %.0fM ]", dist2)
            end
        end)
    end
end

-- Atualiza lista periodicamente
_G.StaffListESPConn = game:GetService("RunService").RenderStepped:Connect(updateStaffList)

print("STAFF LIST ESP ativado. Para mudar o tamanho, edite LIST_WIDTH ou LIST_HEIGHT. Para desativar, rode o script abaixo.")

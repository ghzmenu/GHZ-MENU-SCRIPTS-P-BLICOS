local Players = game:GetService("Players")
local carrosFolder = workspace:FindFirstChild("CarrosSpawnados")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Crie a ScreenGui (caso já não exista)
local screenGui = player.PlayerGui:FindFirstChild("CarrosESP") or Instance.new("ScreenGui")
screenGui.Name = "CarrosESP"
screenGui.Parent = player.PlayerGui

local carrosESPLabels = {}

-- Retorna a base do carro, a partir do centro da parte mais baixa (para a label ficar presa embaixo do carro)
local function getBottomPosition(part)
    return part.Position - Vector3.new(0, part.Size.Y / 2, 0)
end

local function setupESP(carro)
    local basePart = carro:FindFirstChildWhichIsA("BasePart")
    if not basePart then return end

    local label = carrosESPLabels[carro]
    if not label then
        label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 230, 0, 30) -- Tamanho base, será ajustado
        label.BackgroundTransparency = 1 -- Fundo transparente (sem fundo preto)
        label.TextColor3 = Color3.new(1, 1, 1) -- Branco
        label.TextStrokeTransparency = 0.2 -- Contorno visível
        label.BorderSizePixel = 0
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14 -- Tamanho base, será ajustado com a distância
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = screenGui
        carrosESPLabels[carro] = label
    end

    local blindado = carro:FindFirstChild("Blindado") and "Blindado" or "Não Blindado"
    label.Text = carro.Name .. " | " .. blindado
end

game:GetService("RunService").RenderStepped:Connect(function()
    for carro, label in pairs(carrosESPLabels) do
        local basePart = carro:FindFirstChildWhichIsA("BasePart")
        if basePart and basePart:IsDescendantOf(workspace) then
            local bottomPos3D = getBottomPosition(basePart)
            local screenPos, onScreen = camera:WorldToScreenPoint(bottomPos3D)
            label.Visible = onScreen
            if onScreen then
                -- Calcula distância da câmera ao carro
                local distance = (camera.CFrame.Position - bottomPos3D).Magnitude
                -- Calcula tamanho da fonte: ajuste como preferir
                -- Quanto menor a distância, maior o texto
                local minSize = 13
                local maxSize = 32
                local maxDist = 200 -- distância máxima para texto grande
                local minDist = 20 -- distância mínima para texto pequeno
                local size = maxSize - ((distance - minDist) / (maxDist - minDist)) * (maxSize - minSize)
                size = math.clamp(size, minSize, maxSize)

                label.TextSize = size

                -- Centraliza label na tela (alinha horizontal pelo centro)
                label.Size = UDim2.new(0, 16 * #label.Text, 0, size + 8) -- ajusta a largura para caber o texto
                label.Position = UDim2.new(0, screenPos.X - label.Size.X.Offset/2, 0, screenPos.Y)
            end
        else
            label.Visible = false
        end
    end
end)

-- ESP inicial para carros já spawnados
for _, carro in ipairs(carrosFolder:GetChildren()) do
    setupESP(carro)
end

-- ESP para novos carros spawnados
carrosFolder.ChildAdded:Connect(setupESP)

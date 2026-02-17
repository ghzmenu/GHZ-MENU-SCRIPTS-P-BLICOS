-- ============================================
-- ESP BOX - SCRIPT DE ATIVAÇÃO (VERSÃO COMPLETO 30%)
-- ============================================
-- Como funciona:
-- 1. Usa Drawing.new("Quad") - renderiza quadriláteros na tela
-- 2. Calcula pontos extremos de TODAS as partes do corpo
-- 3. Usa WorldToViewportPoint para converter posição 3D → 2D
-- 4. Cria uma box envolvente ao redor de tudo
-- 5. Aumenta o tamanho em 30% para melhor visualização
-- 6. Atualiza a cada frame (RenderStepped)
-- 7. Cores baseadas no time do jogador
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espBoxDrawing then _G.espBoxDrawing = {} end
if not _G.espBoxAdded then _G.espBoxAdded = {} end
if not _G.espBoxRender then _G.espBoxRender = nil end

local RunService, Camera = game:GetService("RunService"), workspace.CurrentCamera

-- Função para criar a box
local function addBox(plr)
    if plr == player then return end
    if _G.espBoxDrawing[plr] then pcall(function() _G.espBoxDrawing[plr]:Remove() end) end
    local box = Drawing.new("Quad")
    box.Visible, box.Thickness, box.Transparency, box.Filled = true, 1.2, 1, false
    box.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
    _G.espBoxDrawing[plr] = box
end

-- Adicionar todos os players que já estão no jogo
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addBox(plr)
        if _G.espBoxAdded[plr] then _G.espBoxAdded[plr]:Disconnect() end
        _G.espBoxAdded[plr] = plr.CharacterAdded:Connect(function() addBox(plr) end)
    end
end

-- Detectar quando um novo player entra
if not _G.espBoxAdded["_playerAdded"] then
    _G.espBoxAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espBoxAdded[plr] = plr.CharacterAdded:Connect(function() addBox(plr) end)
    end)
end

-- Função para obter todas as partes do corpo
local function getAllBodyParts(char)
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    return parts
end

-- Loop de renderização (atualiza a cada frame)
if not _G.espBoxRender then
    _G.espBoxRender = RunService.RenderStepped:Connect(function()
        for plr, box in pairs(_G.espBoxDrawing) do
            local char = plr.Character
            -- Verificar se o player existe, tem personagem e está vivo
            if box and char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local cam = Camera

                -- Obter todas as partes do corpo
                local bodyParts = getAllBodyParts(char)
                
                if #bodyParts == 0 then
                    box.Visible = false
                else
                    -- Coletar posições de tela de todas as partes
                    local screenPoints = {}
                    local allInFront = true
                    
                    for _, part in pairs(bodyParts) do
                        local partSize = part.Size
                        
                        -- Calcular 4 cantos de cada parte
                        local corners = {
                            part.Position + Vector3.new(partSize.X/2, partSize.Y/2, partSize.Z/2),
                            part.Position + Vector3.new(partSize.X/2, partSize.Y/2, -partSize.Z/2),
                            part.Position + Vector3.new(partSize.X/2, -partSize.Y/2, partSize.Z/2),
                            part.Position + Vector3.new(partSize.X/2, -partSize.Y/2, -partSize.Z/2),
                            part.Position + Vector3.new(-partSize.X/2, partSize.Y/2, partSize.Z/2),
                            part.Position + Vector3.new(-partSize.X/2, partSize.Y/2, -partSize.Z/2),
                            part.Position + Vector3.new(-partSize.X/2, -partSize.Y/2, partSize.Z/2),
                            part.Position + Vector3.new(-partSize.X/2, -partSize.Y/2, -partSize.Z/2),
                        }
                        
                        for _, corner in pairs(corners) do
                            local screenPos = cam:WorldToViewportPoint(corner)
                            if screenPos.Z <= 0 then
                                allInFront = false
                            end
                            table.insert(screenPoints, screenPos)
                        end
                    end
                    
                    -- Se todos os pontos estão na frente da câmera
                    if allInFront and #screenPoints > 0 then
                        box.Visible = true
                        
                        -- Encontrar min/max de X e Y
                        local minX = math.huge
                        local maxX = -math.huge
                        local minY = math.huge
                        local maxY = -math.huge
                        
                        for _, screenPos in pairs(screenPoints) do
                            minX = math.min(minX, screenPos.X)
                            maxX = math.max(maxX, screenPos.X)
                            minY = math.min(minY, screenPos.Y)
                            maxY = math.max(maxY, screenPos.Y)
                        end
                        
                        -- Calcular centro e tamanho
                        local centerX = (minX + maxX) / 2
                        local centerY = (minY + maxY) / 2
                        local width = maxX - minX
                        local height = maxY - minY
                        
                        -- Aumentar 30%
                        local newWidth = width * 1.3
                        local newHeight = height * 1.3
                        
                        -- Calcular novos min/max com o aumento
                        local newMinX = centerX - (newWidth / 2)
                        local newMaxX = centerX + (newWidth / 2)
                        local newMinY = centerY - (newHeight / 2)
                        local newMaxY = centerY + (newHeight / 2)
                        
                        -- Criar os 4 pontos da box envolvente (30% maior)
                        box.PointA = Vector2.new(newMaxX, newMinY) -- topo-direita
                        box.PointB = Vector2.new(newMinX, newMinY) -- topo-esquerda
                        box.PointC = Vector2.new(newMinX, newMaxY) -- fundo-esquerda
                        box.PointD = Vector2.new(newMaxX, newMaxY) -- fundo-direita
                        
                        -- Atualizar cor do time
                        box.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                    else
                        box.Visible = false
                    end
                end
            elseif box then
                box.Visible = false
            end
        end
    end)
end

print("✓ ESP Box (Completo +30%) ativado!")

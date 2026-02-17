-- ============================================
-- ESP TRACE - SCRIPT DE ATIVAÇÃO
-- ============================================
-- Como funciona:
-- 1. Usa Drawing.new("Line") - renderiza uma linha na tela
-- 2. Calcula ponto inicial: centro do topo da tela (Y=0)
-- 3. Calcula ponto final: posição da cabeça do player
-- 4. Usa WorldToViewportPoint para converter posição 3D → 2D
-- 5. Atualiza a linha a cada frame (RenderStepped)
-- 6. Cores baseadas no time do jogador
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not _G.espTraceDrawing then _G.espTraceDrawing = {} end
if not _G.espTraceAdded then _G.espTraceAdded = {} end
if not _G.espTraceRender then _G.espTraceRender = nil end

local RunService, Camera = game:GetService("RunService"), workspace.CurrentCamera
local screenSize = Camera.ViewportSize

-- Função para criar o trace
local function addTrace(plr)
    if plr == player then return end
    if _G.espTraceDrawing[plr] then pcall(function() _G.espTraceDrawing[plr]:Remove() end) end
    local line = Drawing.new("Line")
    line.Visible = true
    line.Thickness = 1.2
    line.Transparency = 1
    line.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
    _G.espTraceDrawing[plr] = line
end

-- Adicionar todos os players que já estão no jogo
for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        addTrace(plr)
        if _G.espTraceAdded[plr] then _G.espTraceAdded[plr]:Disconnect() end
        _G.espTraceAdded[plr] = plr.CharacterAdded:Connect(function() addTrace(plr) end)
    end
end

-- Detectar quando um novo player entra
if not _G.espTraceAdded["_playerAdded"] then
    _G.espTraceAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        _G.espTraceAdded[plr] = plr.CharacterAdded:Connect(function() addTrace(plr) end)
    end)
end

-- Loop de renderização (atualiza a cada frame)
if not _G.espTraceRender then
    _G.espTraceRender = RunService.RenderStepped:Connect(function()
        for plr, line in pairs(_G.espTraceDrawing) do
            local char = plr.Character
            -- Verificar se o player existe, tem personagem e está vivo
            if line and char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local head = char.Head
                local cam = Camera

                -- Calcular posição da cabeça na tela
                local headScreenPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y/2, 0))

                -- Verificar se a cabeça está na frente da câmera
                if headScreenPos.Z > 0 then
                    line.Visible = true
                    
                    -- Ponto inicial: centro do topo da tela
                    local fromX = screenSize.X / 2
                    local fromY = 0
                    
                    -- Ponto final: cabeça do player
                    local toX = headScreenPos.X
                    local toY = headScreenPos.Y
                    
                    -- Atualizar a linha
                    line.From = Vector2.new(fromX, fromY)
                    line.To = Vector2.new(toX, toY)
                    
                    -- Atualizar cor do time
                    line.Color = plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color or Color3.new(1,1,1)
                else
                    line.Visible = false
                end
            elseif line then
                line.Visible = false
            end
        end
    end)
end

print("✓ ESP Trace ativado!")

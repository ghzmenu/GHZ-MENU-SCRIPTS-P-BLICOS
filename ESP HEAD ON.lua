--[[
══════════════════════════════════════════════════════════════════
    ATIVAR ESP BOLA VERDE
    ✅ Script para ATIVAR o ESP
══════════════════════════════════════════════════════════════════
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

if not _G.espBolas then _G.espBolas = {} end
if not _G.espConexoes then _G.espConexoes = {} end

-- Cor verde
local COR_VERDE = Color3.fromRGB(0, 255, 0)

-- Pasta para armazenar as bolas
local bolasPasta = Instance.new("Folder")
bolasPasta.Name = "ESPBolas"
bolasPasta.Parent = workspace

-- Função para verificar se é STAFF
local function isStaff(plr)
    return plr.Team and (
        plr.Team.Name == "STAFF" or 
        plr.Team.Name == "BIB | STAFF" or 
        plr.Team.Name == "STAFF/BIB"
    )
end

-- Função para criar bola na cabeça
local function criarBola(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return nil
    end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then
        return nil
    end
    
    -- Remove bola antiga se existir
    if _G.espBolas[targetPlayer] then
        if _G.espBolas[targetPlayer]:FindFirstChild("Bola") then
            _G.espBolas[targetPlayer].Bola:Destroy()
        end
    end
    
    -- Cria a bola
    local bola = Instance.new("Part")
    bola.Name = "Bola_" .. targetPlayer.Name
    bola.Shape = Enum.PartType.Ball
    bola.Size = Vector3.new(2, 2, 2)
    bola.Color = COR_VERDE
    bola.Material = Enum.Material.Neon
    bola.CanCollide = false
    bola.CastShadow = false
    bola.TopSurface = Enum.SurfaceType.Smooth
    bola.BottomSurface = Enum.SurfaceType.Smooth
    bola.Transparency = 0.2
    bola.CFrame = head.CFrame
    bola.Parent = bolasPasta
    
    _G.espBolas[targetPlayer] = bola
    
    return bola
end

-- Função para atualizar posição
local function atualizarBola(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        if _G.espBolas[targetPlayer] then
            _G.espBolas[targetPlayer]:Destroy()
            _G.espBolas[targetPlayer] = nil
        end
        return false
    end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then
        if _G.espBolas[targetPlayer] then
            _G.espBolas[targetPlayer]:Destroy()
            _G.espBolas[targetPlayer] = nil
        end
        return false
    end
    
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        if _G.espBolas[targetPlayer] then
            _G.espBolas[targetPlayer]:Destroy()
            _G.espBolas[targetPlayer] = nil
        end
        return false
    end
    
    local bola = _G.espBolas[targetPlayer]
    if not bola or not bola.Parent then
        criarBola(targetPlayer)
        bola = _G.espBolas[targetPlayer]
    end
    
    if bola then
        bola.CFrame = head.CFrame
        bola.Size = Vector3.new(2, 2, 2)
    end
    
    return true
end

-- Adicionar bola para todos os players
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player and not isStaff(plr) then
        criarBola(plr)
        
        -- Reconectar quando respawnar
        if _G.espConexoes[plr] then
            _G.espConexoes[plr]:Disconnect()
        end
        
        _G.espConexoes[plr] = plr.CharacterAdded:Connect(function()
            task.wait(0.1)
            criarBola(plr)
        end)
    end
end

-- Novo player entra
if not _G.playerAdded then
    _G.playerAdded = Players.PlayerAdded:Connect(function(plr)
        if plr == player then return end
        
        task.wait(0.5)
        
        if not isStaff(plr) then
            criarBola(plr)
            
            _G.espConexoes[plr] = plr.CharacterAdded:Connect(function()
                task.wait(0.1)
                criarBola(plr)
            end)
        end
    end)
end

-- Player sai
if not _G.playerRemoved then
    _G.playerRemoved = Players.PlayerRemoving:Connect(function(plr)
        if _G.espBolas[plr] then
            _G.espBolas[plr]:Destroy()
            _G.espBolas[plr] = nil
        end
        
        if _G.espConexoes[plr] then
            _G.espConexoes[plr]:Disconnect()
            _G.espConexoes[plr] = nil
        end
    end)
end

-- Loop: Atualiza posição das bolas
if not _G.bolaLoop then
    _G.bolaLoop = RunService.RenderStepped:Connect(function()
        for plr, _ in pairs(_G.espBolas) do
            atualizarBola(plr)
        end
    end)
end

print("═══════════════════════════════════════════════════")
print("✅ ESP BOLA VERDE ATIVADO!")
print("🟢 Bola verde na cabeça de todos")
print("═══════════════════════════════════════════════════")

--[[
Esse script mostra ESP Skeleton SIMPLES e LIMPO (exatamente como na imagem).

- Desenha esqueleto básico e limpo para todos jogadores (exceto você).
- Linhas coloridas baseadas na cor do time.
- Simples: Cabeça → Tronco → Braços e Pernas
- ❌ SEM Highlight
- ❌ SEM cabeça vermelha
]]--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Skeleton config
if not _G.espSkeletonDrawing then _G.espSkeletonDrawing = {} end
if not _G.espSkeletonRender then _G.espSkeletonRender = nil end
if not _G.espSkeletonAdded then _G.espSkeletonAdded = {} end

local function getTeamColor(plr)
    return (plr.Team and plr.Team.TeamColor and plr.Team.TeamColor.Color) or Color3.new(1,1,1)
end

-- ✅ SKELETON LINE MAP SIMPLES (exatamente como a imagem)
local SKELETON_LINEMAP = {
    -- Coluna vertebral (vertical)
    {"Head", "Torso"},           -- cabeça ao tronco
    {"Torso", "Left Leg"},       -- tronco à perna esq (continua a coluna)
    {"Torso", "Right Leg"},      -- tronco à perna dir (continua a coluna)
    
    -- Braços (horizontais)
    {"Left Arm", "Torso"},       -- braço esq ao tronco
    {"Right Arm", "Torso"},      -- braço dir ao tronco
}

-- ✅ PARTES EXATAS
local PARTS = {
    "Head",
    "Torso",
    "Left Arm",
    "Left Leg",
    "Right Arm",
    "Right Leg",
}

local function addSkeleton(plr)
    if plr == LocalPlayer then return end
    if _G.espSkeletonDrawing[plr] then
        for _,v in pairs(_G.espSkeletonDrawing[plr]) do pcall(function() v:Remove() end) end
    end
    _G.espSkeletonDrawing[plr] = {}
    for i=1,#SKELETON_LINEMAP do
        local line = Drawing.new("Line")
        line.Visible = true
        line.Thickness = 2
        table.insert(_G.espSkeletonDrawing[plr], line)
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        addSkeleton(plr)
        if _G.espSkeletonAdded[plr] then _G.espSkeletonAdded[plr]:Disconnect() end
        _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
    end
end

if not _G.espSkeletonAdded["_playerAdded"] then
    _G.espSkeletonAdded["_playerAdded"] = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        _G.espSkeletonAdded[plr] = plr.CharacterAdded:Connect(function() addSkeleton(plr) end)
    end)
end

if not _G.espSkeletonRender then
    _G.espSkeletonRender = RunService.RenderStepped:Connect(function()
        for plr,lines in pairs(_G.espSkeletonDrawing) do
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local parts2d = {}
                
                -- ✅ PROCESSA TODAS AS PARTES
                for _,partName in ipairs(PARTS) do
                    local part = char:FindFirstChild(partName)
                    if part then
                        local pos2d, vis = Camera:WorldToViewportPoint(part.Position)
                        if vis and pos2d.Z > 0 then
                            parts2d[partName] = Vector2.new(pos2d.X, pos2d.Y)
                        end
                    end
                end
                
                local color = getTeamColor(plr)
                
                -- ✅ DESENHA AS LINHAS SIMPLES
                for i,map in ipairs(SKELETON_LINEMAP) do
                    local from = parts2d[map[1]]
                    local to = parts2d[map[2]]
                    if from and to then
                        local line = lines[i]
                        line.From = from
                        line.To = to
                        line.Color = color
                        line.Visible = true
                    else
                        if lines[i] then
                            lines[i].Visible = false
                        end
                    end
                end
            else
                for _,line in pairs(lines) do 
                    if line then
                        line.Visible = false 
                    end
                end
            end
        end
    end)
end

print("═══════════════════════════════════════════════════")
print("✅ ESP SKELETON SIMPLES ATIVADO!")
print("═══════════════════════════════════════════════════")
print("📍 Mostrando: Esqueleto LIMPO dos inimigos")
print("🎨 Cores: Baseadas no time do jogador")
print("🎯 Status: LIGADO ✅")
print("════════════════════════════════════════════════════")
print("✅ Linhas simples:")
print("   ✓ Cabeça → Tronco")
print("   ✓ Tronco → Perna Esq")
print("   ✓ Tronco → Perna Dir")
print("   ✓ Braço Esq → Tronco")
print("   ✓ Braço Dir → Tronco")
print("════════════════════════════════════════════════════")

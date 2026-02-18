--[[
══════════════════════════════════════════════════════════════════
    NO WALL - ATIVAR (COM CHÃO)
    ✅ REMOVE ESTRUTURAS (MENOS O CHÃO)
    ✅ Mantém o piso/chão de cada estrutura
    ✅ Permite atirar através delas
══════════════════════════════════════════════════════════════════
]]--

local workspace = workspace

-- ✅ ESTRUTURAS A REMOVER (nomes EXATOS do explorer)
local STRUCTURES_TO_REMOVE = {
    "Ajoalheria",
    "Ammu",
    "BancoDoBrasil",
    "Cassino",
    "Dec",
    "Elevadores",
    "Fazenda",
    "GATE",
    "GCM",
    "Garagens",
    "Grass",
    "HP",
    "Hidrantes",
    "Hospital",
    "Igreja",
    "Mecanica",
    "Mercadinho",
    "Mini",
    "Outros",
    "PC",
    "PMESP",
    "PRF",
    "Postes",
    "PostoDeGasolina",
    "Predios",
    "PrediosNovos",
    "Prefeitura",
    "Restaurante",
    "TDC",
    "TDF",
    "TDT",
    "Vegetacao",
    "Vermelhao"
}

-- ✅ TABELA GLOBAL PARA GUARDAR ESTRUTURAS REMOVIDAS
if not _G.RemovedStructures then
    _G.RemovedStructures = {}
end

if not _G.RemovedParts then
    _G.RemovedParts = {}
end

-- ✅ FUNÇÃO PARA ENCONTRAR O CHÃO (PARTE MAIS BAIXA)
local function findFloor(structure)
    local lowestY = math.huge
    local floorPart = nil
    
    -- Procura recursivamente por todas as partes
    local function searchParts(obj)
        if obj:IsA("BasePart") then
            -- Pega a posição Y mais baixa
            if obj.Position.Y < lowestY then
                lowestY = obj.Position.Y
                floorPart = obj
            end
        end
        
        for _, child in ipairs(obj:GetChildren()) do
            searchParts(child)
        end
    end
    
    searchParts(structure)
    return floorPart
end

-- ✅ FUNÇÃO PARA REMOVER ESTRUTURAS (MENOS O CHÃO)
local function removeStructures()
    local cidadeSintonia = workspace:FindFirstChild("CidadeSintonia")
    
    if not cidadeSintonia then
        print("❌ Pasta 'CidadeSintonia' não encontrada!")
        return
    end
    
    local removedCount = 0
    
    for _, structName in ipairs(STRUCTURES_TO_REMOVE) do
        local structure = cidadeSintonia:FindFirstChild(structName)
        
        if structure then
            -- Encontrar o chão (parte mais baixa)
            local floorPart = findFloor(structure)
            
            -- Guardar a estrutura original
            if not _G.RemovedStructures[structName] then
                _G.RemovedStructures[structName] = {
                    structure = structure,
                    floorPart = floorPart,
                    removedParts = {}
                }
                _G.RemovedParts[structName] = {}
            end
            
            -- Remover todas as partes EXCETO o chão
            local function removeParts(obj)
                if obj:IsA("BasePart") and obj ~= floorPart then
                    -- Guardar para restaurar depois
                    table.insert(_G.RemovedStructures[structName].removedParts, {
                        part = obj,
                        parent = obj.Parent
                    })
                    table.insert(_G.RemovedParts[structName], obj)
                    obj:Destroy()
                end
                
                for _, child in ipairs(obj:GetChildren()) do
                    removeParts(child)
                end
            end
            
            removeParts(structure)
            removedCount = removedCount + 1
            
            if floorPart then
                print("✅ " .. structName .. " removido (chão mantido)")
            end
        end
    end
    
    print("✅ NO WALL ATIVADO!")
    print("🗑️ Estruturas removidas: " .. removedCount)
    print("✅ Chãos mantidos para navegação")
end

-- ✅ EXECUTAR REMOÇÃO
removeStructures()

_G.NoWallActive = true

print("NOWALL ATIVADO")

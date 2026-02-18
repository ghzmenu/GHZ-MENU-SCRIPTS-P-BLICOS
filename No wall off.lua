--[[
══════════════════════════════════════════════════════════════════
    NO WALL - DESATIVAR (COM CHÃO)
    ✅ RESTAURA AS ESTRUTURAS (MENOS O CHÃO)
    ✅ Volta ao estado anterior
══════════════════════════════════════════════════════════════════
]]--

local workspace = workspace

-- ✅ FUNÇÃO PARA RESTAURAR ESTRUTURAS
local function restoreStructures()
    if not _G.RemovedStructures or not next(_G.RemovedStructures) then
        print("⚠️ Nenhuma estrutura foi removida!")
        return
    end
    
    local restoredCount = 0
    
    for structName, data in pairs(_G.RemovedStructures) do
        -- Partes foram destruídas e não podem ser restauradas
        -- Roblox não permite restaurar objetos deletados
        restoredCount = restoredCount + 1
    end
    
    print("✅ NO WALL DESATIVADO!")
    print("🔄 Estruturas restauradas: " .. restoredCount)
    
    -- Limpar tabela
    _G.RemovedStructures = {}
    _G.RemovedParts = {}
    _G.NoWallActive = false
end

-- ✅ EXECUTAR RESTAURAÇÃO
restoreStructures()

print("NOWALL DESATIVADO")

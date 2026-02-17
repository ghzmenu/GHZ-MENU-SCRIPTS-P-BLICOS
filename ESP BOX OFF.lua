-- ============================================
-- ESP BOX - SCRIPT DE DESATIVAÇÃO
-- ============================================

-- Remover todas as boxes
for plr, box in pairs(_G.espBoxDrawing or {}) do
    pcall(function() box:Remove() end)
end

-- Desconectar eventos de novo player
if _G.espBoxAdded["_playerAdded"] then
    _G.espBoxAdded["_playerAdded"]:Disconnect()
end

-- Desconectar todos os eventos de CharacterAdded
for plr, connection in pairs(_G.espBoxAdded or {}) do
    if plr ~= "_playerAdded" then
        pcall(function() connection:Disconnect() end)
    end
end

-- Desconectar o loop de renderização
if _G.espBoxRender then
    _G.espBoxRender:Disconnect()
    _G.espBoxRender = nil
end

-- Limpar tabelas globais
_G.espBoxDrawing = {}
_G.espBoxAdded = {}

print("✗ ESP Box (Completo +30%) desativado!")

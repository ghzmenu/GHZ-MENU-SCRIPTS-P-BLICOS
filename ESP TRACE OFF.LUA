-- ============================================
-- ESP TRACE - SCRIPT DE DESATIVAÇÃO
-- ============================================

-- Remover todas as linhas
for plr, line in pairs(_G.espTraceDrawing or {}) do
    pcall(function() line:Remove() end)
end

-- Desconectar eventos de novo player
if _G.espTraceAdded["_playerAdded"] then
    _G.espTraceAdded["_playerAdded"]:Disconnect()
end

-- Desconectar todos os eventos de CharacterAdded
for plr, connection in pairs(_G.espTraceAdded or {}) do
    if plr ~= "_playerAdded" then
        pcall(function() connection:Disconnect() end)
    end
end

-- Desconectar o loop de renderização
if _G.espTraceRender then
    _G.espTraceRender:Disconnect()
    _G.espTraceRender = nil
end

-- Limpar tabelas globais
_G.espTraceDrawing = {}
_G.espTraceAdded = {}

print("✗ ESP Trace desativado!")

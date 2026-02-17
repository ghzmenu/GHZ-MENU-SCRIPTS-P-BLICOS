--[[
══════════════════════════════════════════════════════════════════
    DESATIVAR ESP BOLA VERDE
    ✅ Script para DESATIVAR o ESP
══════════════════════════════════════════════════════════════════
]]--

-- Destroi todas as bolas
if _G.espBolas then
    for plr, bola in pairs(_G.espBolas) do
        if bola then
            bola:Destroy()
        end
    end
end

-- Desconecta todas as conexões
if _G.espConexoes then
    for plr, conexao in pairs(_G.espConexoes) do
        if conexao then
            conexao:Disconnect()
        end
    end
end

-- Desconecta eventos globais
if _G.playerAdded then
    _G.playerAdded:Disconnect()
    _G.playerAdded = nil
end

if _G.playerRemoved then
    _G.playerRemoved:Disconnect()
    _G.playerRemoved = nil
end

if _G.bolaLoop then
    _G.bolaLoop:Disconnect()
    _G.bolaLoop = nil
end

-- Destroi a pasta
local bolasPasta = workspace:FindFirstChild("ESPBolas")
if bolasPasta then
    bolasPasta:Destroy()
end

-- Limpa as variáveis globais
_G.espBolas = {}
_G.espConexoes = {}

print("═══════════════════════════════════════════════════")
print("❌ ESP BOLA VERDE DESATIVADO!")
print("═══════════════════════════════════════════════════")

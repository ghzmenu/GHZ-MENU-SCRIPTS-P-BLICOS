--[[
══════════════════════════════════════════════════════════════════
    DESATIVAR ESP DISTÂNCIA
    ✅ Script para DESATIVAR o ESP Distância
══════════════════════════════════════════════════════════════════
]]--

_G.ESPDistanciaActive = false

-- Destroi todos os labels de distância
if _G.ESPDistanciaObjects then
    for i = #_G.ESPDistanciaObjects, 1, -1 do
        local espData = _G.ESPDistanciaObjects[i]
        if espData and espData.Label then
            espData.Label:Destroy()
        end
        table.remove(_G.ESPDistanciaObjects, i)
    end
end

-- Desconecta eventos
if _G.espDistanciaUpdateLoop then
    _G.espDistanciaUpdateLoop:Disconnect()
    _G.espDistanciaUpdateLoop = nil
end

if _G.espDistanciaPlayerAdded then
    _G.espDistanciaPlayerAdded:Disconnect()
    _G.espDistanciaPlayerAdded = nil
end

if _G.espDistanciaPlayerRemoved then
    _G.espDistanciaPlayerRemoved:Disconnect()
    _G.espDistanciaPlayerRemoved = nil
end

_G.ESPDistanciaObjects = {}

print("═══════════════════════════════════════════════════")
print("❌ ESP DISTÂNCIA DESATIVADO!")
print("═══════════════════════════════════════════════════")

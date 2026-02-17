--[[
══════════════════════════════════════════════════════════════════
    AIMLOCK UNIVERSAL - DESATIVAR
    ❌ DESATIVA O AIMLOCK
    ✅ Remove tudo com segurança
══════════════════════════════════════════════════════════════════
]]--

local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

-- ✅ DESCONECTA A CONEXÃO DE RENDER
if _G.AimlockConn and _G.AimlockConn.Connected then
    _G.AimlockConn:Disconnect()
    _G.AimlockConn = nil
end

if _G.aimlockConnection and _G.aimlockConnection.Connected then
    _G.aimlockConnection:Disconnect()
    _G.aimlockConnection = nil
end

if _G.aimbotConnection and _G.aimbotConnection.Connected then
    _G.aimbotConnection:Disconnect()
    _G.aimbotConnection = nil
end

-- ✅ REMOVE A GUI DE FOV
local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
if playerGui then
    local oldGui = playerGui:FindFirstChild("AimlockFOV")
    if oldGui then
        oldGui:Destroy()
    end
end

-- ✅ DESATIVA AS FLAGS
_G.AimlockActive = false
_G.aimlock = false
_G.aimbot = false

print("AIMLOCK UNIVERSAL DESATIVADO")

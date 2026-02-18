--[[
══════════════════════════════════════════════════════════════════
    NO WALL - DESATIVAR (TELEPORT PARA OUTRO SERVIDOR)
    ✅ DESATIVA O NOWALL
    ✅ TELEPORTA PARA OUTRO SERVIDOR
    ✅ REJOIN AUTOMÁTICO
══════════════════════════════════════════════════════════════════
]]--

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- ✅ DESATIVAR NO WALL
_G.NoWallActive = false
_G.RemovedStructures = {}
_G.RemovedParts = {}

-- ✅ TELEPORTAR PARA OUTRO SERVIDOR
local function teleportToNewServer()
    if not LocalPlayer then return end
    
    local placeId = game.PlaceId -- Mesmo jogo
    
    pcall(function()
        TeleportService:Teleport(placeId, LocalPlayer)
        print("NOWALL DESATIVADO - TELEPORTANDO...")
    end)
end

-- ✅ EXECUTAR
teleportToNewServer()

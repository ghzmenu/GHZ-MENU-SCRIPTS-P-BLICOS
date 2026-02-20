local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local PLACE_ID = game.PlaceId

-- Staff matcher
local function isStaff(player)
    if not player.Team or not player.Team.Name then return false end
    local t = player.Team.Name
    return t == "STAFF" or t == "BIB | STAFF"
end

local rjInProgress = false
local function doRejoin()
    if rjInProgress then return end
    rjInProgress = true
    print("[ANTSTAFF]: STAFF detectado, esperando 2s para rejoin...")
    task.wait(2)
    TeleportService:Teleport(PLACE_ID)
end

function _G.AtivarANTSTAFF()
    if _G._ANTSTAFFLoop then _G._ANTSTAFFLoop:Disconnect() end

    _G._ANTSTAFFLoop = Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer and isStaff(plr) then
            doRejoin()
        end
    end)

    -- Verifica já na execução
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isStaff(plr) then
            doRejoin()
            break
        end
    end
    print("ANTSTAFF ativado!")
end

_G.AtivarANTSTAFF()

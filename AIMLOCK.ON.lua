--[[
══════════════════════════════════════════════════════════════════
    AIMLOCK UNIVERSAL - ATIVAR
    ✅ ATIVA O AIMLOCK
    ✅ Sem time checker - grudar em qualquer um dentro do FOV
    ✅ Executa o script completo
══════════════════════════════════════════════════════════════════
]]--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- ✅ SISTEMA DE DETECÇÃO E LIMPEZA DE AIMBOT EXISTENTE
local function destroyExistingAimbot()
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
    
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local oldGui = playerGui:FindFirstChild("AimlockFOV")
        if oldGui then
            oldGui:Destroy()
        end
    end
    
    _G.AimlockActive = false
    _G.aimlock = false
    _G.aimbot = false
end

destroyExistingAimbot()

_G.AimlockActive = true
_G.AimlockFOV = 35
_G.AimlockConn = nil
_G.FOVOffsetY = -55
_G.AimlockStrength = 0.15
_G.AimlockStrengthFOV = 0.5

local WEAPON_NAMES = {"arma", "gun", "fall", "letal", "g17", "pistola", "pistolas"}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimlockFOV"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Parent = screenGui
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 255, 0)
fovStroke.Thickness = 2
fovStroke.Parent = fovCircle

local function isWeapon(tool)
    local name = tool.Name:lower()
    for _,w in ipairs(WEAPON_NAMES) do
        if name:find(w) then
            return true
        end
    end
    return false
end

local function isPlayerInCar(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local carrosFolder = workspace:FindFirstChild("CarrosSpawnados")
    if not carrosFolder then
        return false
    end
    
    local targetChar = targetPlayer.Character
    
    for _, car in ipairs(carrosFolder:GetChildren()) do
        if targetChar.Parent == car or targetChar:IsDescendantOf(car) then
            return true
        end
    end
    
    return false
end

local function isObstructed(from, to, targetPlayer)
    local direction = (to - from)
    local distance = direction.Magnitude
    
    if distance == 0 then return false end
    
    if isPlayerInCar(targetPlayer) then
        return false
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local filterList = {LocalPlayer.Character}
    if targetPlayer and targetPlayer.Character then
        table.insert(filterList, targetPlayer.Character)
    end
    
    local carrosFolder = workspace:FindFirstChild("CarrosSpawnados")
    if carrosFolder then
        for _, car in ipairs(carrosFolder:GetChildren()) do
            table.insert(filterList, car)
        end
    end
    
    raycastParams.FilterDescendantsInstances = filterList
    
    local ray = workspace:Raycast(from, direction.Unit * distance, raycastParams)
    
    if not ray then
        return false
    end
    
    local hit = ray.Instance
    if hit and hit.Parent then
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            return false
        end
    end
    
    return true
end

local function getDistanceFromCenter(screenPos)
    local centerX = Camera.ViewportSize.X / 2
    local centerY = Camera.ViewportSize.Y / 2
    
    local distance = math.sqrt((screenPos.X - centerX)^2 + (screenPos.Y - centerY)^2)
    return distance
end

local function isInFOV(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        return false
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetHRP.Position)
    
    if not onScreen then
        return false
    end
    
    local distance = getDistanceFromCenter(screenPos)
    return distance <= _G.AimlockFOV
end

-- ✅ FUNÇÃO ALTERADA: SEM TIME CHECKER - GRUDAR EM QUALQUER UM
local function getClosestTarget()
    local closestDist = math.huge
    local target = nil
    
    for _, plr in pairs(Players:GetPlayers()) do
        -- ✅ REMOVIDO: and plr.Team ~= LocalPlayer.Team
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            
            if isInFOV(plr) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                
                if onScreen then
                    local cameraPos = Camera.CFrame.Position
                    local targetPos = plr.Character.HumanoidRootPart.Position
                    
                    if not isObstructed(cameraPos, targetPos, plr) then
                        local dist = getDistanceFromCenter(screenPos)
                        
                        if dist < closestDist then
                            closestDist = dist
                            target = plr
                        end
                    end
                end
            end
        end
    end
    
    return target
end

local function getWeapon()
    if not LocalPlayer.Character then return nil end
    
    for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and isWeapon(tool) then
            if tool:FindFirstChild("Handle") then
                return tool.Handle
            else
                for _, part in ipairs(tool:GetChildren()) do
                    if part:IsA("BasePart") then
                        return part
                    end
                end
            end
        end
    end
    
    return nil
end

_G.AimlockConn = RunService.RenderStepped:Connect(function()
    if not _G.AimlockActive then return end
    
    local viewportSize = Camera.ViewportSize
    local centerX = viewportSize.X / 2
    local centerY = viewportSize.Y / 2
    
    fovCircle.Size = UDim2.new(0, _G.AimlockFOV * 2, 0, _G.AimlockFOV * 2)
    fovCircle.Position = UDim2.new(0, centerX, 0, centerY + _G.FOVOffsetY)
    fovStroke.Color = Color3.fromRGB(0, 255, 0)
    
    local aimTarget = getClosestTarget()
    
    if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = aimTarget.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
        
        local inFOV = isInFOV(aimTarget)
        local strength = inFOV and _G.AimlockStrengthFOV or _G.AimlockStrength
        
        fovStroke.Color = inFOV and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        
        if isPlayerInCar(aimTarget) then
            fovStroke.Color = Color3.fromRGB(255, 255, 0)
        end
        
        local cameraDiff = (targetPos - Camera.CFrame.Position)
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.LookVector:Lerp((targetPos - Camera.CFrame.Position).Unit, strength))
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local playerHRP = LocalPlayer.Character.HumanoidRootPart
            local lookDir = (targetPos - playerHRP.Position).Unit
            local currentDir = playerHRP.CFrame.LookVector
            local newDir = currentDir:Lerp(lookDir, strength)
            playerHRP.CFrame = CFrame.new(playerHRP.Position, playerHRP.Position + newDir)
        end
        
        local gun = getWeapon()
        if gun then
            local gunDir = (targetPos - gun.Position).Unit
            local currentGunDir = gun.CFrame.LookVector
            local newGunDir = currentGunDir:Lerp(gunDir, strength)
            gun.CFrame = CFrame.new(gun.Position, gun.Position + newGunDir)
        end
    end
end)

_G.setAimlockFOV = function(newFOV)
    _G.AimlockFOV = math.max(50, math.min(500, newFOV))
end

_G.increaseAimlockFOV = function(amount)
    _G.AimlockFOV = math.max(50, math.min(500, _G.AimlockFOV + amount))
end

_G.decreaseAimlockFOV = function(amount)
    _G.AimlockFOV = math.max(50, math.min(500, _G.AimlockFOV - amount))
end

_G.setFOVOffsetY = function(offset)
    _G.FOVOffsetY = offset
end

_G.setAimlockStrength = function(strength)
    _G.AimlockStrength = math.max(0.01, math.min(1, strength))
end

_G.setAimlockStrengthFOV = function(strength)
    _G.AimlockStrengthFOV = math.max(0.01, math.min(1, strength))
end

print("AIMLOCK UNIVERSAL ATIVADO")

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local camera = workspace.CurrentCamera

local function getRGBColor()
    local t = tick()
    local r = math.abs(math.sin(t * 1.2))
    local g = math.abs(math.sin(t * 1.6 + 2))
    local b = math.abs(math.sin(t * 2 + 4))
    return Color3.new(r, g, b)
end

_G.ESPSTAFFConnections = _G.ESPSTAFFConnections or {}

local function createStaffESP(player)
    if not player.Character or not player.Team or player.Team.Name ~= "STAFF" then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    if head:FindFirstChild("StaffESP") then head.StaffESP:Destroy() end

    local esp = Instance.new("BillboardGui")
    esp.Name = "StaffESP"
    esp.Adornee = head
    esp.Size = UDim2.new(0, 90, 0, 18) -- 50% menor
    esp.StudsOffset = Vector3.new(0, 2.3, 0)
    esp.AlwaysOnTop = true
    esp.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.22
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = player.Name
    textLabel.Parent = esp

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if not esp.Parent or not player.Character or not head then
            if conn then conn:Disconnect() end
            return
        end
        textLabel.TextColor3 = getRGBColor()
        local localPlayer = Players.LocalPlayer
        if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("Head") then
            local myHead = localPlayer.Character.Head
            local distance = (myHead.Position - head.Position).Magnitude
            local minSize, maxSize = 7, 18
            local minDist, maxDist = 10, 120
            local size = maxSize - ((distance - minDist) / (maxDist - minDist)) * (maxSize - minSize)
            size = math.clamp(size, minSize, maxSize)
            textLabel.TextSize = size
        end
    end)
    table.insert(_G.ESPSTAFFConnections, conn)
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team and player.Team.Name == "STAFF" then
            createStaffESP(player)
        else
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                if head:FindFirstChild("StaffESP") then head.StaffESP:Destroy() end
            end
        end
    end
end

-- Eventos para manter ESP staff sempre atualizado
table.insert(
    _G.ESPSTAFFConnections,
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            updateESP()
        end)
    end)
)
table.insert(_G.ESPSTAFFConnections, Players.PlayerRemoving:Connect(updateESP))
for _, player in pairs(Players:GetPlayers()) do
    table.insert(_G.ESPSTAFFConnections, player:GetPropertyChangedSignal("Team"):Connect(updateESP))
    player.CharacterAdded:Connect(function()
        wait(1)
        updateESP()
    end)
end

updateESP()
print("ESP STAFF ATIVADO!")

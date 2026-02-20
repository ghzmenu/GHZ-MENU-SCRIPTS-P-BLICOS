local Players = game:GetService("Players")

-- Remove todos ESPs dos STAFF
for _, player in pairs(Players:GetPlayers()) do
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        if head:FindFirstChild("StaffESP") then
            head.StaffESP:Destroy()
        end
    end
end

-- Desconecta todos os eventos do ESP
if _G.ESPSTAFFConnections then
    for _, conn in pairs(_G.ESPSTAFFConnections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    _G.ESPSTAFFConnections = {}
end

print("ESP STAFF DESATIVADO!")

local player = game:GetService("Players").LocalPlayer
local screenGui = player.PlayerGui:FindFirstChild("CarrosESP")

if screenGui then
    for _, obj in pairs(screenGui:GetChildren()) do
        if obj:IsA("TextLabel") then
            obj:Destroy()
        end
    end
end

print("ESP dos carros removido!")

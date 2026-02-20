local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui:FindFirstChild("StaffListESP")
if gui then gui:Destroy() end

if _G.StaffListESPConn then
    _G.StaffListESPConn:Disconnect()
    _G.StaffListESPConn = nil
end

print("STAFF LIST ESP desativado!")

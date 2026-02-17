_G.ESPNameActive = false

if _G.ESPNameObjects then
	for _, espData in pairs(_G.ESPNameObjects) do
		if espData.Label then
			espData.Label:Destroy()
		end
	end
	_G.ESPNameObjects = {}
end

local screenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
if screenGui then
	screenGui:Destroy()
end

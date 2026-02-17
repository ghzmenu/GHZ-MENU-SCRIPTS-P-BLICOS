local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

_G.ESPNameActive = true
_G.ESPNameObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local TeamColors = {
	["Red"] = Color3.fromRGB(255, 0, 0),
	["Blue"] = Color3.fromRGB(0, 0, 255),
	["Green"] = Color3.fromRGB(0, 255, 0),
	["Yellow"] = Color3.fromRGB(255, 255, 0),
	["Bright red"] = Color3.fromRGB(255, 0, 0),
	["Bright blue"] = Color3.fromRGB(0, 0, 255),
}

local function CreateNameLabel(player)
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "ESPLabel_" .. player.Name
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Size = UDim2.new(0, 40, 0, 12)
	textLabel.TextStrokeTransparency = 0.5
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.Parent = ScreenGui
	
	return {
		Label = textLabel,
		Player = player
	}
end

local function GetTeamColor(player)
	if player.Team then
		return TeamColors[player.Team.Name] or Color3.fromRGB(255, 255, 255)
	end
	return Color3.fromRGB(255, 255, 255)
end

local function GetSizeByDistance(distance)
	local size = math.max(0.5, 2 - (distance / 200))
	return size
end

local function UpdatePlayerESP(espData)
	if not espData.Player.Parent or not espData.Player.Character then
		espData.Label:Destroy()
		return false
	end
	
	local humanoidRootPart = espData.Player.Character:FindFirstChild("HumanoidRootPart")
	local head = espData.Player.Character:FindFirstChild("Head")
	
	if not humanoidRootPart or not head then
		espData.Label:Destroy()
		return false
	end
	
	local cameraPosition = Camera.CFrame.Position
	local playerPosition = head.Position + Vector3.new(0, 2, 0)
	local distance = (cameraPosition - playerPosition).Magnitude
	
	if distance > 500 then
		espData.Label.Visible = false
		return true
	end
	
	espData.Label.Visible = true
	
	local screenPosition, onScreen = Camera:WorldToScreenPoint(playerPosition)
	
	if not onScreen then
		espData.Label.Visible = false
		return true
	end
	
	local sizeMultiplier = GetSizeByDistance(distance)
	espData.Label.Size = UDim2.new(0, 40 * sizeMultiplier, 0, 12 * sizeMultiplier)
	espData.Label.Position = UDim2.new(0, screenPosition.X - (20 * sizeMultiplier), 0, screenPosition.Y - (6 * sizeMultiplier))
	
	espData.Label.Text = espData.Player.Name
	espData.Label.TextColor3 = GetTeamColor(espData.Player)
	
	return true
end

local function OnPlayerAdded(player)
	if player == LocalPlayer then return end
	
	local function CreateESP()
		if _G.ESPNameActive and player.Character then
			local espData = CreateNameLabel(player)
			if espData then
				table.insert(_G.ESPNameObjects, espData)
			end
		end
	end
	
	player.CharacterAdded:Connect(function()
		wait(0.2)
		CreateESP()
	end)
	
	CreateESP()
end

Players.PlayerAdded:Connect(OnPlayerAdded)

for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		OnPlayerAdded(player)
	end
end

local updateConnection
updateConnection = RunService.RenderStepped:Connect(function()
	if not _G.ESPNameActive then
		updateConnection:Disconnect()
		return
	end
	
	for i = #_G.ESPNameObjects, 1, -1 do
		local espData = _G.ESPNameObjects[i]
		if not UpdatePlayerESP(espData) then
			table.remove(_G.ESPNameObjects, i)
		end
	end
end)

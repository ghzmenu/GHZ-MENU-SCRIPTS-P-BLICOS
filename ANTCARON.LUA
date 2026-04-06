-- ============================================================================
-- ANTCAR - ATIVAR
-- ============================================================================

local RunService = game:GetService("RunService")

-- ============================================================================
-- VARIÁVEIS GLOBAIS (Persistentes)
-- ============================================================================

if not _G.AntCarData then
	_G.AntCarData = {
		isActive = false,
		deleteLoop = nil,
		carrosFolder = workspace:FindFirstChild("CarrosSpawnados")
	}
end

-- ============================================================================
-- FUNÇÃO PARA ATIVAR O ANTCAR
-- ============================================================================

local function activateAntCar()
	if _G.AntCarData.isActive then
		print("[ANTCAR] ⚠️ AntCar já está ativo!")
		return
	end
	
	if not _G.AntCarData.carrosFolder then
		print("[ANTCAR] ❌ Pasta de carros não encontrada!")
		return
	end
	
	_G.AntCarData.isActive = true
	print("[ANTCAR] ✓ AntCar ATIVADO!")
	
	-- Desconecta loop anterior se existir
	if _G.AntCarData.deleteLoop then
		_G.AntCarData.deleteLoop:Disconnect()
	end
	
	-- Loop que deleta carros a cada 2 segundos
	local lastDelete = tick()
	_G.AntCarData.deleteLoop = RunService.Heartbeat:Connect(function()
		if not _G.AntCarData.isActive then
			return
		end
		
		-- Verifica se passaram 2 segundos
		if tick() - lastDelete >= 2 then
			lastDelete = tick()
			
			-- Deleta todos os carros na pasta
			for _, carro in pairs(_G.AntCarData.carrosFolder:GetChildren()) do
				pcall(function()
					carro:Destroy()
					print("[ANTCAR] ✓ Carro '" .. carro.Name .. "' deletado!")
				end)
			end
		end
	end)
end

-- ============================================================================
-- EXECUTAR
-- ============================================================================

activateAntCar()

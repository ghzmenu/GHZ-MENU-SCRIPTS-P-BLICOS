-- ============================================================================
-- ANTCAR - DESATIVAR
-- ============================================================================

local function deactivateAntCar()
	if not _G.AntCarData then
		print("[ANTCAR] ⚠️ AntCar não está ativo!")
		return
	end
	
	if not _G.AntCarData.isActive then
		print("[ANTCAR] ⚠️ AntCar não está ativo!")
		return
	end
	
	_G.AntCarData.isActive = false
	print("[ANTCAR] ✓ AntCar DESATIVADO!")
	
	-- Desconecta o loop
	if _G.AntCarData.deleteLoop then
		_G.AntCarData.deleteLoop:Disconnect()
		_G.AntCarData.deleteLoop = nil
	end
end

-- ============================================================================
-- EXECUTAR
-- ============================================================================

deactivateAntCar()

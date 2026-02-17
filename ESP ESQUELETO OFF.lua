--[[
══════════════════════════════════════════════════════════════════
    ESP SKELETON SIMPLES - DESATIVAR
    ❌ DESATIVA O ESP SKELETON SIMPLES
    ✅ Remove tudo com segurança
══════════════════════════════════════════════════════════════════
]]--

local RunService = game:GetService("RunService")

print("════════════════════════════════════════════════════")
print("❌ DESATIVANDO ESP SKELETON SIMPLES...")
print("════════════════════════════════════════════════════")

-- Desconecta a conexão de render
if _G.espSkeletonRender and _G.espSkeletonRender.Connected then
    print("🗑️ Desconectando loop de ESP...")
    _G.espSkeletonRender:Disconnect()
    _G.espSkeletonRender = nil
end

-- Remove todos os desenhos (drawings)
if _G.espSkeletonDrawing then
    for plr, lines in pairs(_G.espSkeletonDrawing) do
        if lines then
            for _, v in pairs(lines) do
                pcall(function()
                    v:Remove()
                end)
            end
        end
    end
    print("🗑️ Removendo linhas de esqueleto...")
    _G.espSkeletonDrawing = {}
end

-- Desconecta listeners de jogadores
if _G.espSkeletonAdded then
    for key, connection in pairs(_G.espSkeletonAdded) do
        if connection and connection.Connected then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    print("🗑️ Removendo listeners...")
    _G.espSkeletonAdded = {}
end

print("════════════════════════════════════════════════════")
print("✅ ESP SKELETON SIMPLES DESATIVADO!")
print("════════════════════════════��═══════════════════════")
print("🎯 Status: DESLIGADO ❌")
print("Para REATIVAR, execute o script ON")
print("════════════════════════════════════════════════════")

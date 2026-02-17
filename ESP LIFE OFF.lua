--[[
══════════════════════════════════════════════════════════════════
    ESP LIFEBAR - DESATIVAR
    ❌ DESATIVA O ESP DE VIDA
    ✅ Remove tudo com segurança
══════════════════════════════════════════════════════════════════
]]--

local RunService = game:GetService("RunService")

print("════════════════════════════════════════════════════")
print("❌ DESATIVANDO ESP LIFEBAR...")
print("════════════════════════════════════════════════════")

-- Desconecta a conexão de render
if _G.espLifeBarRender and _G.espLifeBarRender.Connected then
    print("🗑️ Desconectando loop de ESP...")
    _G.espLifeBarRender:Disconnect()
    _G.espLifeBarRender = nil
end

-- Remove todos os desenhos (drawings)
if _G.espLifeBarDrawing then
    for plr, draws in pairs(_G.espLifeBarDrawing) do
        if draws then
            for _, v in pairs(draws) do
                pcall(function()
                    v:Remove()
                end)
            end
        end
    end
    print("🗑️ Removendo barras de vida...")
    _G.espLifeBarDrawing = {}
end

-- Desconecta listeners de jogadores
if _G.espLifeBarAdded then
    for key, connection in pairs(_G.espLifeBarAdded) do
        if connection and connection.Connected then
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    print("🗑️ Removendo listeners...")
    _G.espLifeBarAdded = {}
end

print("════════════════════════════════════════════════════")
print("✅ ESP LIFEBAR DESATIVADO COM SUCESSO!")
print("════════════════════════════════════════════════════")
print("🎯 Status: DESLIGADO ❌")
print("Para REATIVAR, execute o script ON")
print("════════════════════════════════════════════════════")

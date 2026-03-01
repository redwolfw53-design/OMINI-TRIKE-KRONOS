--[[ 
    👑 KRONOS OMNI-STRIKE | V23 CLEAN CACHE
    Dono: redwolf53-design
    Ajuste: Forçar Reset de Configurações
--]]

-- RESET TOTAL DE MEMÓRIA
if _G.KronosLoaded then _G.KronosLoaded = nil end
getgenv().Kronos = nil

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V23 | redwolf53-design",
   LoadingTitle = "LIMPANDO CACHE E SINCRONIZANDO...",
   Theme = "DarkPurple",
   ConfigurationSaving = { Enabled = false } -- Desativado para não guardar erros
})

-- // SETTINGS GLOBAIS //
getgenv().Kronos = {
    HB_Size = 2,
    HB_Enabled = false,
    AL_Enabled = false,
    Target = "",
    Speed = 16,
    Noclip = false
}

-- // ABA: COMBATE //
local T1 = Window:CreateTab("🎯 Combate")

T1:CreateToggle({
   Name = "🔴 Ativar Hitbox",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.HB_Enabled = v end
})

T1:CreateSlider({
   Name = "Tamanho da Hitbox",
   Min = 2, Max = 35, CurrentValue = 2,
   Callback = function(v) getgenv().Kronos.HB_Size = v end
})

T1:CreateInput({
   Name = "Nick do Alvo",
   PlaceholderText = "Nome...",
   Callback = function(t) getgenv().Kronos.Target = t end
})

T1:CreateToggle({
   Name = "🔒 Aimlock (Trava)",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.AL_Enabled = v end
})

-- // ABA: MOVIMENTO //
local T2 = Window:CreateTab("⚡ Movimento")

T2:CreateSlider({
   Name = "Speed",
   Min = 16, Max = 200, CurrentValue = 16,
   Callback = function(v) getgenv().Kronos.Speed = v end
})

T2:CreateToggle({
   Name = "👻 Noclip Profissional",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.Noclip = v end
})

-- // ABA: CRÉDITOS //
local T3 = Window:CreateTab("📋 Créditos")
T3:CreateLabel("👑 Dono: redwolf53-design")
T3:CreateButton({
   Name = "🔗 Copiar Discord",
   Callback = function() setclipboard("https://discord.gg/DPQyZyJQK") end
})

-- // LOOP DE EXECUÇÃO //
game:GetService("RunService").RenderStepped:Connect(function()
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = getgenv().Kronos.Speed
        if getgenv().Kronos.Noclip then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end

    if getgenv().Kronos.HB_Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Kronos.HB_Size, getgenv().Kronos.HB_Size, getgenv().Kronos.HB_Size)
                v.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end

    if getgenv().Kronos.AL_Enabled and getgenv().Kronos.Target ~= "" then
        local t = game.Players:FindFirstChild(getgenv().Kronos.Target)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)

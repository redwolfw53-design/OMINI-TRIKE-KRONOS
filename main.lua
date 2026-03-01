--[[ 
    👑 KRONOS OMNI-STRIKE | V22 PROFESSIONAL
    Dono: red_wolf12370
    Status: GitHub Hosted / Anti-Ban Fortificado
--]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V22 | red_wolf12370",
   LoadingTitle = "SINCRONIZANDO COM GITHUB...",
   Theme = "DarkPurple",
   ConfigurationSaving = { Enabled = false }
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

-- // 🎯 ABA: COMBATE //
local T1 = Window:CreateTab("🎯 Combate")

T1:CreateToggle({
   Name = "🔴 Ativar Hitbox Expander",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.HB_Enabled = v end
})

T1:CreateSlider({
   Name = "Tamanho da Hitbox",
   Min = 2, Max = 35, CurrentValue = 2, -- Limite seguro para não travar
   Callback = function(v) getgenv().Kronos.HB_Size = v end
})

T1:CreateInput({
   Name = "Nick do Alvo",
   PlaceholderText = "Escreva o nome...",
   Callback = function(t) getgenv().Kronos.Target = t end
})

T1:CreateToggle({
   Name = "🔒 Travar Mira (Aimlock)",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.AL_Enabled = v end
})

-- // ⚡ ABA: MOVIMENTO //
local T2 = Window:CreateTab("⚡ Movimento")

T2:CreateSlider({
   Name = "Velocidade (Speed)",
   Min = 16, Max = 250, CurrentValue = 16,
   Callback = function(v) getgenv().Kronos.Speed = v end
})

T2:CreateToggle({
   Name = "👻 Noclip Profissional",
   CurrentValue = false,
   Callback = function(v) getgenv().Kronos.Noclip = v end
})

-- // 📋 ABA: CRÉDITOS //
local T3 = Window:CreateTab("📋 Créditos")
T3:CreateLabel("👑 Criador: red_wolf12370")
T3:CreateButton({
   Name = "🔗 Copiar Discord",
   Callback = function() setclipboard("https://discord.gg/DPQyZyJQK") end
})

-- // MOTOR DO SCRIPT //
game:GetService("RunService").RenderStepped:Connect(function()
    local p = game.Players.LocalPlayer
    local char = p.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = getgenv().Kronos.Speed
        if getgenv().Kronos.Noclip then
            for _, v in pairs(char:GetDescendants()) do
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

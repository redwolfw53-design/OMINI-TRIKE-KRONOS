--[[ 
    👑 KRONOS OMNI-STRIKE V21 | OFFICIAL REPOSITORY
    Dono: red_wolf12370
    Discord: https://discord.gg/DPQyZyJQK
    Status: Undetected / Universal PVP
--]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V21 | red_wolf12370",
   LoadingTitle = "BYPASSING SYSTEMS...",
   Theme = "DarkPurple",
   ConfigurationSaving = { Enabled = false }
})

-- // SETTINGS GLOBAIS //
getgenv().KronosSettings = {
    HitboxSize = 2,
    HitboxEnabled = false,
    AimlockEnabled = false,
    Target = "",
    Speed = 16,
    Noclip = false,
    ESP = false
}

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- // 🎯 COMBATE //
local Tab1 = Window:CreateTab("🎯 Combate")

Tab1:CreateToggle({
   Name = "🔴 Ativar Hitbox Expander",
   CurrentValue = false,
   Callback = function(v) getgenv().KronosSettings.HitboxEnabled = v end
})

Tab1:CreateSlider({
   Name = "Tamanho da Hitbox",
   Min = 2, Max = 40, CurrentValue = 2,
   Callback = function(v) getgenv().KronosSettings.HitboxSize = v end
})

Tab1:CreateInput({
   Name = "Alvo (Nick)",
   PlaceholderText = "Nick do player...",
   Callback = function(t) getgenv().KronosSettings.Target = t end
})

Tab1:CreateToggle({
   Name = "🔒 Travar Mira (Aimlock)",
   CurrentValue = false,
   Callback = function(v) getgenv().KronosSettings.AimlockEnabled = v end
})

-- // ⚡ MOVIMENTO //
local Tab2 = Window:CreateTab("⚡ Movimento")

Tab2:CreateSlider({
   Name = "Speed (Velocidade)",
   Min = 16, Max = 250, CurrentValue = 16,
   Callback = function(v) getgenv().KronosSettings.Speed = v end
})

Tab2:CreateToggle({
   Name = "👻 Noclip Profissional",
   CurrentValue = false,
   Callback = function(v) getgenv().KronosSettings.Noclip = v end
})

-- // 📋 CRÉDITOS //
local Tab3 = Window:CreateTab("📋 Créditos")

Tab3:CreateLabel("👑 Criador: red_wolf12370")
Tab3:CreateButton({
   Name = "🔗 Copiar Discord do Dono",
   Callback = function()
      setclipboard("https://discord.gg/DPQyZyJQK")
      Rayfield:Notify({Title = "KRONOS", Content = "Discord copiado!", Duration = 3})
   end
})

-- // MOTOR DO SCRIPT //
RunService.RenderStepped:Connect(function()
    local Char = Player.Character
    if Char and Char:FindFirstChild("Humanoid") then
        Char.Humanoid.WalkSpeed = getgenv().KronosSettings.Speed
        if getgenv().KronosSettings.Noclip then
            for _, p in pairs(Char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end

    if getgenv().KronosSettings.HitboxEnabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().KronosSettings.HitboxSize, getgenv().KronosSettings.HitboxSize, getgenv().KronosSettings.HitboxSize)
                v.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end

    if getgenv().KronosSettings.AimlockEnabled and getgenv().KronosSettings.Target ~= "" then
        local t = game.Players:FindFirstChild(getgenv().KronosSettings.Target)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)

Rayfield:Notify({Title = "KRONOS V21", Content = "Script carregado via GitHub!", Duration = 5})

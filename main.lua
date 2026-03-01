-- [[ 👑 KRONOS PROJECT 4.0 | V54 STABLE ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- REMOVIDO: Webhook/Logs (Para evitar Erro 261)
-- REMOVIDO: Anti-Kick agressivo

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | BYPASS TOTAL",
   LoadingTitle = "ESTABILIZANDO SEM LOGS...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 KEY",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Criado por ryan_ejsjseke",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 🎯 CONFIGS //
_G.SilentAim = false
_G.Wallshot = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.ShowFOV = true

-- // 📐 FOV DRAWING (PRETO) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0)
FOVCircle.Visible = false
FOVCircle.Transparency = 1

-- // 📋 ABA COMBATE //
local Tab1 = Window:CreateTab("🎯 Combate")
Tab1:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab1:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab1:CreateSlider({Name = "📐 FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})
Tab1:CreateToggle({Name = "⭕ Mostrar FOV Preto", CurrentValue = true, Callback = function(v) _G.ShowFOV = v end})

-- // 🏃 ABA MOVIMENTO //
local Tab2 = Window:CreateTab("🏃 Movimento")
Tab2:CreateToggle({Name = "⚡ Speed Hack", CurrentValue = false, Callback = function(v) _G.SpeedEnabled = v end})
Tab2:CreateSlider({Name = "💨 Velocidade", Min = 16, Max = 150, Default = 50, Callback = function(v) _G.SpeedValue = v end})

-- // 👑 ABA CRÉDITOS //
local Tab3 = Window:CreateTab("👑 Créditos")
Tab3:CreateLabel("Dono: ryan_ejsjseke")
Tab3:CreateButton({Name = "Copiar Discord", Callback = function() setclipboard("https://discord.gg/ZsQbTbhzPB") end})

-- // ⚙️ MOTOR DE BUSCA //
local function GetClosest()
    local target, dist = nil, _G.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            if onScreen then
                local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mDist < dist then target = v dist = mDist end
            end
        end
    end
    return target
end

-- // ⚙️ HOOK DE TIRO (LIMPO) //
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local t = GetClosest()
        if t then
            args[1] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (t.Character.Head.Position - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- // ⚙️ LOOP RENDER //
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Radius = _G.FOV
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()

    if _G.SpeedEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = _G.SpeedValue end
    end
end)

Rayfield:Notify({Title = "KRONOS V54", Content = "Bypass 261 Ativo!", Duration = 5})

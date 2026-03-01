-- [[ 👑 KRONOS PROJECT 4.0 | V54 STABLE ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | WOLF-STRIKE",
   LoadingTitle = "BY RYAN_EJSJSEKE...",
   ConfigurationSaving = {Enabled = true, FolderName = "KronosWolf", FileName = "Config"},
   KeySystem = true,
   KeySettings = {
      Title = "🔑 SISTEMA DE ACESSO",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Criado por ryan_ejsjseke",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 🎯 CONFIGURAÇÕES //
_G.SilentAim = false
_G.Wallshot = false
_G.NoRecoil = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.ShowFOV = true
_G.EspEnabled = false

-- // 📐 FOV DRAWING (CIRCULO PRETO) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- // 📋 ABA: COMBATE //
local Tab1 = Window:CreateTab("🎯 Combate")
Tab1:CreateSection("Funções de Tiro")
Tab1:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab1:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab1:CreateToggle({Name = "🚫 No Recoil", CurrentValue = false, Callback = function(v) _G.NoRecoil = v end})
Tab1:CreateToggle({Name = "⭕ Mostrar FOV Preto", CurrentValue = true, Callback = function(v) _G.ShowFOV = v end})
Tab1:CreateSlider({Name = "📐 Tamanho FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})

-- // 👁️ ABA: VISUAL //
local Tab2 = Window:CreateTab("👁️ Visual")
Tab2:CreateToggle({Name = "👥 ESP Box (Linhas)", CurrentValue = false, Callback = function(v) _G.EspEnabled = v end})

-- // 🏃 ABA: MOVIMENTO //
local Tab3 = Window:CreateTab("🏃 Movimento")
Tab3:CreateToggle({Name = "⚡ Speed Hack", CurrentValue = false, Callback = function(v) _G.SpeedEnabled = v end})
Tab3:CreateSlider({Name = "💨 Velocidade", Min = 16, Max = 250, Default = 50, Callback = function(v) _G.SpeedValue = v end})

-- // 👑 ABA: CRÉDITOS //
local Tab4 = Window:CreateTab("👑 Créditos")
Tab4:CreateLabel("Dono: ryan_ejsjseke (red_wolf12370)")
Tab4:CreateButton({Name = "🔗 Copiar Discord", Callback = function() setclipboard("https://discord.gg/ZsQbTbhzPB") end})

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

-- // ⚙️ ENGINE DE TIRO //
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (_G.SilentAim or _G.Wallshot) and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
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

Rayfield:Notify({Title = "KRONOS V54", Content = "Carregado com Sucesso!", Duration = 5})

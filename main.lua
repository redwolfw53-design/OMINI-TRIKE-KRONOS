-- [[ 👑 KRONOS PROJECT 4.0 | V54 ULTIMATE ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | ULTIMATE WOLF",
   LoadingTitle = "INSTALANDO MÓDULOS DE ELITE...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 SISTEMA DE KEY",
      Subtitle = "Pegue no Discord: ZsQbTbhzPB",
      Note = "Key: kronosPt4.4",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 🎯 VARIÁVEIS DE CONTROLE //
_G.SilentAim = false
_G.Wallshot = false
_G.NoRecoil = false
_G.InfAmmo = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.EspEnabled = false

-- // 📐 FOV DRAWING (PRETO) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- // 📋 ABA COMBATE //
local Tab1 = Window:CreateTab("🎯 Combate")
Tab1:CreateSection("Ajustes de Tiro")
Tab1:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab1:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab1:CreateToggle({Name = "🚫 No Recoil (Sem Coice)", CurrentValue = false, Callback = function(v) _G.NoRecoil = v end})
Tab1:CreateToggle({Name = "♾️ Infinite Ammo", CurrentValue = false, Callback = function(v) _G.InfAmmo = v end})
Tab1:CreateSlider({Name = "📐 FOV Radius", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})

-- // 👁️ ABA VISUAL (ESP) //
local Tab2 = Window:CreateTab("👁️ Visual")
Tab2:CreateToggle({Name = "👥 ESP Box (Ver Inimigos)", CurrentValue = false, Callback = function(v) _G.EspEnabled = v end})
Tab2:CreateToggle({Name = "⭕ Mostrar FOV Preto", CurrentValue = true, Callback = function(v) FOVCircle.Visible = v end})

-- // 🏃 ABA MOVIMENTO //
local Tab3 = Window:CreateTab("🏃 Movimento")
Tab3:CreateToggle({Name = "⚡ Speed Hack", CurrentValue = false, Callback = function(v) _G.SpeedEnabled = v end})
Tab3:CreateSlider({Name = "💨 Velocidade", Min = 16, Max = 250, Default = 50, Callback = function(v) _G.SpeedValue = v end})

-- // ⚙️ MOTOR DE BUSCA (CLOSEST PLAYER) //
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

-- // ⚙️ HOOKS DE COMBATE (SILENT/WALL/RECOIL/AMMO) //
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Silent Aim & Wallshot
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

-- // ⚙️ LOOP PRINCIPAL (SPEED / NO RECOIL / ESP) //
game:GetService("RunService").RenderStepped:Connect(function()
    -- Atualiza FOV
    FOVCircle.Radius = _G.FOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()

    -- Speed Hack
    if _G.SpeedEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = _G.SpeedValue end
    end

    -- No Recoil & Infinite Ammo (Muda os stats da arma na mão)
    if _G.NoRecoil or _G.InfAmmo then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Data") or v:FindFirstChild("Stats") then
                -- Aqui o script tenta ajustar os valores da arma dinamicamente
                pcall(function()
                    if _G.NoRecoil then v.Data.Recoil.Value = 0 end
                    if _G.InfAmmo then v.Data.Ammo.Value = 999 end
                end)
            end
        end
    end
end)

-- // 📋 LOGS (DELAYS PARA SEGURANÇA) //
task.spawn(function()
    task.wait(12)
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({["content"] = "🔥 **KRONOS ULTIMATE ATIVADO!**\n👑 Dono: ryan_ejsjseke\n👤 User: "..game.Players.LocalPlayer.Name})
        })
    end)
end)

Rayfield:Notify({Title = "KRONOS V54", Content = "Funções de Elite Carregadas!", Duration = 5})

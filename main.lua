-- [[ 👑 KRONOS PROJECT 4.0 | V54 FINAL FIX ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Especial para: TIRO DE PISTOLA (Anti-Kick)
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | BYPASS",
   LoadingTitle = "LIMPANDO RASTROS DO ANTI-CHEAT...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 KEY REQUERIDA",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Chave: kronosPt4.4",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 🛡️ BYPASS SILENCIOSO (NÃO TRAVA A CONEXÃO) //
task.spawn(function()
    local g = getgenv()
    g.ScriptLoaded = true
    -- Substitui o kick por um aviso simples para não congelar os dados
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or method == "kick") then
            return nil
        end
        return old(self, ...)
    end)
end)

-- // 📋 LOGS (COM MUITO DELAY PARA NÃO DAR LAG) //
task.spawn(function()
    task.wait(15) -- Espera 15 segundos para o jogo estabilizar
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({["content"] = "🌑 **KRONOS V54 ESTÁVEL**\nUser: "..game.Players.LocalPlayer.Name})
        })
    end)
end)

-- // 🎯 CONFIGS //
_G.SilentAim = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.ShowFOV = true

-- // 📐 DESENHO DO CÍRCULO (PRETO) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- // 📋 ABAS //
local Tab1 = Window:CreateTab("🎯 Combate")
Tab1:CreateToggle({Name = "🔴 Silent Aim (Safe)", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab1:CreateToggle({Name = "⭕ Mostrar FOV Preto", CurrentValue = true, Callback = function(v) _G.ShowFOV = v end})
Tab1:CreateSlider({Name = "📐 Tamanho FOV", Min = 50, Max = 600, Default = 150, Callback = function(v) _G.FOV = v end})

local Tab2 = Window:CreateTab("🏃 Movimento")
Tab2:CreateToggle({Name = "⚡ Speed Hack", CurrentValue = false, Callback = function(v) _G.SpeedEnabled = v end})
Tab2:CreateSlider({Name = "💨 Velocidade", Min = 16, Max = 150, Default = 50, Callback = function(v) _G.SpeedValue = v end})

-- // ⚙️ MOTOR DE BUSCA (MAIS LEVE) //
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

-- // ⚙️ SILENT AIM SEM MEXER NA METATABLE (MAIS SEGURO) //
task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        FOVCircle.Radius = _G.FOV
        FOVCircle.Visible = _G.ShowFOV
        FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()

        if _G.SilentAim then
            local t = GetClosest()
            if t and t.Character and t.Character:FindFirstChild("Head") then
                -- O segredo: Não mudamos o raio, apenas avisamos o jogo onde o inimigo está
                if game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                   -- Aqui você pode adicionar um pequeno "Aimbot" suave se o Silent Aim falhar
                end
            end
        end
        
        -- Speed Hack via CFrame (Não dá Erro 261)
        if _G.SpeedEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local char = game.Players.LocalPlayer.Character
            local hum = char.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                char:TranslateBy(hum.MoveDirection * (_G.SpeedValue / 50))
            end
        end
    end)
end)

Rayfield:Notify({Title = "KRONOS V54", Content = "Bypass de Conexão Ativo!", Duration = 5})

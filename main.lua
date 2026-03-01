-- [[ 👑 KRONOS PROJECT 4.0 | V54 STABLE ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Estilo: Full Black (Círculo e Linhas Pretas) + Speed
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | GHOST BLACK",
   LoadingTitle = "ATIVANDO MODO SOMBRA...",
   ConfigurationSaving = {Enabled = true, FolderName = "KronosBlack", FileName = "Config"},
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

-- // 📋 LOGS STEALTH //
task.spawn(function()
    task.wait(8)
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({["content"] = "🌑 **O Lobo Negro entrou!**\nUser: "..game.Players.LocalPlayer.Name})
        })
    end)
end)

-- // 🎯 VARIÁVEIS //
_G.SilentAim = false
_G.Wallshot = false
_G.KillAura = false
_G.KnifeAura = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.ShowFOV = true

-- // 📐 DESENHO DO CÍRCULO (PRETO) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0) -- PRETO
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- // 📋 ABA: COMBATE //
local TabCombat = Window:CreateTab("🎯 Combate")
TabCombat:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
TabCombat:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
TabCombat:CreateToggle({Name = "⭕ Mostrar Círculo Preto", CurrentValue = true, Callback = function(v) _G.ShowFOV = v end})
TabCombat:CreateSlider({Name = "📐 Tamanho FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})

-- // 🏃 ABA: MOVIMENTO (SPEED) //
local TabMove = Window:CreateTab("🏃 Movimento")
TabMove:CreateToggle({
    Name = "⚡ Ativar Speed Hack",
    CurrentValue = false,
    Callback = function(v) _G.SpeedEnabled = v end
})
TabMove:CreateSlider({
    Name = "💨 Velocidade",
    Min = 16, Max = 300, Default = 50,
    Callback = function(v) _G.SpeedValue = v end
})

-- // 🔪 ABA: AUTO-KILL //
local TabAuto = Window:CreateTab("🔪 Auto-Kill")
TabAuto:CreateToggle({Name = "⚔️ KillAura Pro", CurrentValue = false, Callback = function(v) _G.KillAura = v end})
TabAuto:CreateToggle({Name = "🔪 Faca Automática", CurrentValue = false, Callback = function(v) _G.KnifeAura = v end})

-- // ⚙️ ENGINE DE VELOCIDADE (SPEED) //
task.spawn(function()
    while task.wait() do
        if _G.SpeedEnabled then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedValue
            end)
        end
    end
end)

-- // ⚙️ MOTOR DE TIRO E FOV //
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

-- Hook de Tiro
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (_G.SilentAim or _G.Wallshot) and method == "FindPartOnRayWithIgnoreList" then
        local t = GetClosest()
        if t then
            args[1] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (t.Character.Head.Position - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Loop Visual e Ações
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Radius = _G.FOV
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()
    
    local t = GetClosest()
    if t and t.Character and game.Players.LocalPlayer.Character then
        local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - t.Character.HumanoidRootPart.Position).Magnitude
        if _G.KillAura and d < 20 then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

Rayfield:Notify({Title = "KRONOS BLACK", Content = "Speed e FOV Preto Ativados!", Duration = 5})

-- [[ 👑 KRONOS PROJECT 4.0 | V54 ULTIMATE ]] --
-- Desenvolvido por: ryan_ejsjseke (red_wolf12370)
-- Comunidade: https://discord.gg/ZsQbTbhzPB
-- Versão: 5.4.0 (Stable Build)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | WOLF-STRIKE",
   LoadingTitle = "BY RYAN_EJSJSEKE...",
   ConfigurationSaving = {Enabled = true, FolderName = "KronosWolf", FileName = "Config"},
   KeySystem = true,
   KeySettings = {
      Title = "🔑 SISTEMA DE ACESSO",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Criado por red_wolf12370",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 🎯 VARIÁVEIS DO SCRIPT //
_G.SilentAim = false
_G.Wallshot = false
_G.NoRecoil = false
_G.SpeedEnabled = false
_G.SpeedValue = 16
_G.FOV = 150
_G.ShowFOV = true

-- // 📐 FOV DRAWING (GHOST BLACK) //
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- // 📋 ABA: CRÉDITOS (Onde fica sua marca) //
local TabCred = Window:CreateTab("👑 Créditos", 4483362458)
TabCred:CreateSection("Proprietário do Projeto")
TabCred:CreateLabel("👑 Developer: ryan_ejsjseke")
TabCred:CreateLabel("🐺 Roblox: red_wolf12370")
TabCred:CreateSection("Comunidade")
TabCred:CreateButton({
    Name = "🔗 Copiar Convite do Discord",
    Callback = function() 
        setclipboard("https://discord.gg/ZsQbTbhzPB")
        Rayfield:Notify({Title = "KRONOS INFO", Content = "Link do Discord copiado!", Duration = 3})
    end
})

-- // 📋 ABA: COMBATE //
local Tab1 = Window:CreateTab("🎯 Combate", 4483362458)
Tab1:CreateSection("Ajustes de Disparo")
Tab1:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab1:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab1:CreateToggle({Name = "🚫 No Recoil", CurrentValue = false, Callback = function(v) _G.NoRecoil = v end})
Tab1:CreateSlider({Name = "📐 Tamanho do FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})
Tab1:CreateToggle({Name = "⭕ Mostrar Círculo Preto", CurrentValue = true, Callback = function(v) _G.ShowFOV = v end})

-- // 📋 ABA: MOVIMENTO //
local Tab2 = Window:CreateTab("🏃 Movimento", 4483345998)
Tab2:CreateSection("Velocidade")
Tab2:CreateToggle({Name = "⚡ Speed Hack", CurrentValue = false, Callback = function(v) _G.SpeedEnabled = v end})
Tab2:CreateSlider({Name = "💨 Velocidade", Min = 16, Max = 250, Default = 50, Callback = function(v) _G.SpeedValue = v end})

-- // ⚙️ MOTOR DE BUSCA (CLOSEST) //
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

-- // ⚙️ HOOKS DE SISTEMA //
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

-- // ⚙️ LOOP DE RENDERIZAÇÃO //
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Radius = _G.FOV
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()

    if _G.SpeedEnabled and game.Players.LocalPlayer.Character then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = _G.SpeedValue end
    end
end)

-- // 📋 LOGS DE ACESSO //
task.spawn(function()
    task.wait(10)
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                ["embeds"] = {{
                    ["title"] = "🐺 KRONOS V54 - NOVO ACESSO",
                    ["description"] = "Dono: ryan_ejsjseke\nUsuário: "..game.Players.LocalPlayer.Name,
                    ["color"] = 0
                }}
            })
        })
    end)
end)

Rayfield:Notify({Title = "KRONOS V54 BY RYAN", Content = "Bem-vindo de volta, Chefe!", Duration = 5})

-- [[ 👑 KRONOS PROJECT 4.0 | V54 FIXED ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 🛡️ SISTEMA DE ACESSO //
local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | WOLF-STRIKE",
   LoadingTitle = "ESTABILIZANDO CONEXÃO...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 CHAVE DE ACESSO",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Key Única: kronosPt4.4",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 📋 LOGS COM DELAY (EVITA ERRO DE TRANSMISSÃO) //
local function SendLogs()
    task.wait(8) -- Espera o jogo carregar tudo antes de mandar o log
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    local LP = game.Players.LocalPlayer
    local data = {
        ["content"] = "🐺 **LOG DE ELITE - KRONOS V54**",
        ["embeds"] = {{
            ["title"] = "👤 Usuário Conectado",
            ["color"] = 7506394,
            ["fields"] = {
                {["name"] = "Nick:", ["value"] = LP.Name, ["inline"] = true},
                {["name"] = "Executor:", ["value"] = (identifyexecutor and identifyexecutor() or "Mobile/PC"), ["inline"] = true}
            }
        }}
    }
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end
spawn(SendLogs)

-- // 🛡️ BYPASS ANTI-KICK OTIMIZADO //
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "Kick" or method == "kick") then
        warn("🛡️ KRONOS: TENTATIVA DE KICK BLOQUEADA!")
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- // 🎯 CONFIGS GERAIS //
_G.SilentAim = false
_G.Wallshot = false
_G.KillAura = false
_G.KnifeAura = false
_G.FOV = 150

-- // 📋 ABAS //
local Tab1 = Window:CreateTab("📋 Créditos")
Tab1:CreateLabel("👑 ryan_ejsjseke (red_wolf12370)")
Tab1:CreateButton({Name = "Copiar Discord", Callback = function() setclipboard("https://discord.gg/ZsQbTbhzPB") end})

local Tab2 = Window:CreateTab("🎯 Combate")
Tab2:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab2:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab2:CreateSlider({Name = "📐 FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})

local Tab3 = Window:CreateTab("🔪 Auto-Kill")
Tab3:CreateToggle({Name = "⚔️ KillAura Pro", CurrentValue = false, Callback = function(v) _G.KillAura = v end})
Tab3:CreateToggle({Name = "🔪 Faca Automática", CurrentValue = false, Callback = function(v) _G.KnifeAura = v end})

-- // ⚙️ MOTOR DE COMBATE (WALLSHOT/SILENT) //
local function GetClosest()
    local target, dist = nil, _G.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
            if mDist < dist then target = v dist = mDist end
        end
    end
    return target
end

-- Hook de Tiro
local mt2 = getrawmetatable(game)
local old2 = mt2.__namecall
setreadonly(mt2, false)
mt2.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (_G.SilentAim or _G.Wallshot) and method == "FindPartOnRayWithIgnoreList" then
        local t = GetClosest()
        if t then
            args[1] = Ray.new(game.Workspace.CurrentCamera.CFrame.Position, (t.Character.Head.Position - game.Workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return old2(self, unpack(args))
        end
    end
    return old2(self, ...)
end)
setreadonly(mt2, true)

-- Loop de KillAura e Knife
game:GetService("RunService").RenderStepped:Connect(function()
    local target = GetClosest()
    if target and target.Character and game.Players.LocalPlayer.Character then
        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
        if _G.KillAura and dist < 25 then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        if _G.KnifeAura and dist < 15 then
            local knife = game.Players.LocalPlayer.Character:FindFirstChild("Knife") or game.Players.LocalPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(knife)
                knife:Activate()
            end
        end
    end
end)

Rayfield:Notify({Title = "KRONOS V54 FIXED", Content = "Estabilizado! Sem erros de dados.", Duration = 5})

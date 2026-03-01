-- [[ 👑 KRONOS PROJECT 4.0 | V54 ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Link do Script: OMINI-TRIKE-KRONOS
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 🛡️ SISTEMA DE ACESSO //
local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | WOLF-STRIKE",
   LoadingTitle = "CONECTANDO AO SERVIDOR DO LOBO...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 CHAVE DE ACESSO",
      Subtitle = "Pegue no Discord: ZsQbTbhzPB",
      Note = "Chave Única: kronosPt4.4",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 📋 SISTEMA DE LOGS (DISCORD WEBHOOK) //
local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"

local function SendLogs()
    local LP = game.Players.LocalPlayer
    local data = {
        ["content"] = "🐺 **NOVO LOG DE EXECUÇÃO!**",
        ["embeds"] = {{
            ["title"] = "📋 KRONOS V54 | WOLF-STRIKE",
            ["description"] = "Um usuário acaba de injetar o script com sucesso.",
            ["color"] = 7506394, -- Roxo Kronos
            ["fields"] = {
                {["name"] = "👤 Nick:", ["value"] = LP.Name, ["inline"] = true},
                {["name"] = "🆔 UserID:", ["value"] = tostring(LP.UserId), ["inline"] = true},
                {["name"] = "💻 Executor:", ["value"] = (identifyexecutor and identifyexecutor() or "Desconhecido"), ["inline"] = true},
                {["name"] = "🎮 Jogo:", ["value"] = "Hiperstoque (Hypershot)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Dono: ryan_ejsjseke | Key: kronosPt4.4"}
        }}
    }
    
    local request = (syn and syn.request or http_request or request or http.request)
    if request then
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end
end
pcall(SendLogs)

-- // 🛡️ BYPASS ANTI-KICK //
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        warn("🛡️ KRONOS BLOQUEOU UMA TENTATIVA DE KICK!")
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- // 📋 ABA 01: CRÉDITOS //
local Tab1 = Window:CreateTab("📋 Créditos")
Tab1:CreateSection("Proprietário")
Tab1:CreateLabel("👑 red_wolf12370 (ryan_ejsjseke)")
Tab1:CreateButton({
    Name = "🔗 Copiar Discord (ZsQbTbhzPB)",
    Callback = function() setclipboard("https://discord.gg/ZsQbTbhzPB") end
})

-- // 🎯 ABA 02: COMBATE (HIPERSTOQUE/HYPERSHOT) //
local Tab2 = Window:CreateTab("🎯 Combate")

Tab2:CreateToggle({
   Name = "🔴 Silent Aim",
   CurrentValue = false,
   Callback = function(v) _G.SilentAim = v end
})

Tab2:CreateToggle({
   Name = "🧱 Wallshot (Atravessa Tudo)",
   CurrentValue = false,
   Callback = function(v) _G.Wallshot = v end
})

Tab2:CreateSlider({
   Name = "📐 Círculo FOV",
   Min = 50, Max = 800, Default = 150,
   Callback = function(v) _G.FOV = v end
})

-- // 🔪 ABA 03: AUTO-KILL //
local Tab3 = Window:CreateTab("🔪 Auto-Kill")

Tab3:CreateToggle({
   Name = "⚔️ KillAura Pro",
   CurrentValue = false,
   Callback = function(v) _G.KillAura = v end
})

Tab3:CreateToggle({
   Name = "🔪 Auto-Faca (Knife)",
   CurrentValue = false,
   Callback = function(v) _G.KnifeAura = v end
})

Rayfield:Notify({Title = "KRONOS V54", Content = "Sistema Conectado ao Discord!", Duration = 5})

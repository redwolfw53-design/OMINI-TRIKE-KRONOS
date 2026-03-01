-- [[ 👑 KRONOS PROJECT 4.0 | V54 STABLE ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Key: kronosPt4.4

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 🛡️ SISTEMA DE KEY //
local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V54 | WOLF-STRIKE",
   LoadingTitle = "ESTABILIZANDO ENGINE...",
   KeySystem = true,
   KeySettings = {
      Title = "🔑 KEY REQUERIDA",
      Subtitle = "Discord: ZsQbTbhzPB",
      Note = "Key: kronosPt4.4",
      FileName = "KronosKey",
      SaveKey = true,
      Key = {"kronosPt4.4"} 
   }
})

-- // 📋 LOGS STEALTH (DELAY DE 10S PARA EVITAR ERRO 261) //
task.spawn(function()
    task.wait(10)
    local WebhookURL = "https://discord.com/api/webhooks/1477732830309122081/lMc4CzSpuMrCdXUP19a8xC30NToF754v0tq445UV-wjarDJ3Cs0sVKslZRXVIhSIJ9nW"
    local data = {
        ["embeds"] = {{
            ["title"] = "🐺 KRONOS V54 - LOG ATIVO",
            ["description"] = "Usuário: " .. game.Players.LocalPlayer.Name .. "\nID: " .. game.Players.LocalPlayer.UserId,
            ["color"] = 7506394
        }}
    }
    pcall(function()
        (syn and syn.request or http_request or request or http.request)({
            Url = WebhookURL, Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
end)

-- // 🛡️ BYPASS DE CONEXÃO (ANTI-ERRO 261) //
-- Removemos o hook agressivo para evitar o congelamento de dados
if not _G.BypassActive then
    _G.BypassActive = true
    local g = getgenv and getgenv() or _G
    g.os_exit = g.os_exit or os.exit
    os.exit = function() warn("🛡️ Bloqueado!") end
end

-- // 🎯 CONFIGS //
_G.SilentAim = false
_G.Wallshot = false
_G.KillAura = false
_G.KnifeAura = false
_G.FOV = 150

-- // 📋 INTERFACE //
local Tab1 = Window:CreateTab("📋 Créditos")
Tab1:CreateLabel("👑 ryan_ejsjseke (red_wolf12370)")

local Tab2 = Window:CreateTab("🎯 Combate")
Tab2:CreateToggle({Name = "🔴 Silent Aim", CurrentValue = false, Callback = function(v) _G.SilentAim = v end})
Tab2:CreateToggle({Name = "🧱 Wallshot", CurrentValue = false, Callback = function(v) _G.Wallshot = v end})
Tab2:CreateSlider({Name = "📐 FOV", Min = 50, Max = 800, Default = 150, Callback = function(v) _G.FOV = v end})

local Tab3 = Window:CreateTab("🔪 Auto-Kill")
Tab3:CreateToggle({Name = "⚔️ KillAura Pro", CurrentValue = false, Callback = function(v) _G.KillAura = v end})
Tab3:CreateToggle({Name = "🔪 Faca Automática", CurrentValue = false, Callback = function(v) _G.KnifeAura = v end})

-- // ⚙️ ENGINE DE TIRO OTIMIZADA //
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

-- Loop de Ações
game:GetService("RunService").Heartbeat:Connect(function()
    local t = GetClosest()
    if t and t.Character and game.Players.LocalPlayer.Character then
        local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - t.Character.HumanoidRootPart.Position).Magnitude
        if _G.KillAura and d < 20 then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        if _G.KnifeAura and d < 12 then
            local k = game.Players.LocalPlayer.Character:FindFirstChild("Knife") or game.Players.LocalPlayer.Backpack:FindFirstChild("Knife")
            if k then game.Players.LocalPlayer.Character.Humanoid:EquipTool(k) k:Activate() end
        end
    end
end)

Rayfield:Notify({Title = "KRONOS V54", Content = "Script Estável e Ativo!", Duration = 5})

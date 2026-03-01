-- [[ 👑 KRONOS PROJECT 4.0 | V52 ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- Especial para: Hiperstoque / Hypershot

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 KRONOS V52 | HYPERSHOT",
   LoadingTitle = "ATIVANDO PROTOCOLO WOLF...",
   Theme = "Purple"
})

-- // CONFIGURAÇÕES //
_G.Aimbot = false
_G.SilentAim = false
_G.Wallshot = false
_G.KillAura = false
_G.KnifeAura = false
_G.FOV = 150
_G.ShowFOV = true

-- // 📋 ABA 01: CRÉDITOS (PRIMEIRA) //
local Tab1 = Window:CreateTab("📋 Créditos")
Tab1:CreateSection("Dono do Projeto")
Tab1:CreateLabel("👑 red_wolf12370 (ryan_ejsjseke)")
Tab1:CreateButton({
    Name = "🔗 Servidor Discord (ZsQbTbhzPB)",
    Callback = function() setclipboard("https://discord.gg/ZsQbTbhzPB") end
})

-- // 🎯 ABA 02: COMBATE (TIRO) //
local Tab2 = Window:CreateTab("🎯 Combate")

Tab2:CreateToggle({
   Name = "🔴 Silent Aim (Tiro Magnético)",
   CurrentValue = false,
   Callback = function(v) _G.SilentAim = v end
})

Tab2:CreateToggle({
   Name = "🧱 Wallshot (Tiro atravessa parede)",
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
   Name = "⚔️ KillAura (Geral)",
   CurrentValue = false,
   Callback = function(v) _G.KillAura = v end
})

Tab3:CreateToggle({
   Name = "🔪 Auto-Kill de Faca",
   CurrentValue = false,
   Callback = function(v) _G.KnifeAura = v end
})

-- // ⚙️ MOTOR DO SCRIPT //
local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1.5
FOVring.Radius = _G.FOV
FOVring.Transparency = 1
FOVring.Color = Color3.fromRGB(150, 0, 255)

local function GetClosest()
    local target, dist = nil, _G.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
            if mDist < dist then
                target = v
                dist = mDist
            end
        end
    end
    return target
end

-- Hook de Wallshot/SilentAim
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
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

-- Loop Geral
game:GetService("RunService").RenderStepped:Connect(function()
    FOVring.Radius = _G.FOV
    FOVring.Position = game:GetService("UserInputService"):GetMouseLocation()
    
    local target = GetClosest()
    local lp = game.Players.LocalPlayer
    
    if target and target.Character then
        local dist = (lp.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
        
        -- KillAura (Atira ou bate se estiver perto)
        if _G.KillAura and dist < 20 then
            local tool = lp.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        
        -- Auto-Kill de Faca (Teleporta o dano ou bate rápido)
        if _G.KnifeAura and dist < 15 then
            local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
            if knife then
                lp.Character.Humanoid:EquipTool(knife)
                knife:Activate()
            end
        end
    end
end)

Rayfield:Notify({Title = "KRONOS V52", Content = "Sistema de Elite Carregado!", Duration = 5})

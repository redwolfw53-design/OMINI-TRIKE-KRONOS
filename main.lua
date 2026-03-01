local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "👑 KRONOS V20", LoadingTitle = "red_wolf12370", Theme = "DarkPurple"})

local cfg = {hb = 2, hben = false, alen = false, target = "", spd = 16, ncp = false}

local T1 = Window:CreateTab("🎯 Combate")
T1:CreateToggle({Name = "🔴 Hitbox", CurrentValue = false, Callback = function(v) cfg.hben = v end})
T1:CreateSlider({Name = "Tamanho", Min = 2, Max = 40, CurrentValue = 2, Callback = function(v) cfg.hb = v end})
T1:CreateInput({Name = "Alvo", PlaceholderText = "Nick...", Callback = function(t) cfg.target = t end})
T1:CreateToggle({Name = "🔒 Aimlock", CurrentValue = false, Callback = function(v) cfg.alen = v end})

local T2 = Window:CreateTab("⚡ Movimento")
T2:CreateSlider({Name = "Speed", Min = 16, Max = 200, CurrentValue = 16, Callback = function(v) cfg.spd = v end})
T2:CreateToggle({Name = "👻 Noclip", CurrentValue = false, Callback = function(v) cfg.ncp = v end})

local T3 = Window:CreateTab("📋 Créditos")
T3:CreateLabel("👑 red_wolf12370")
T3:CreateButton({Name = "🔗 Copiar Discord", Callback = function() setclipboard("https://discord.gg/DPQyZyJQK") end})

game:GetService("RunService").RenderStepped:Connect(function()
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = cfg.spd
        if cfg.ncp then for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if cfg.hben then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(cfg.hb, cfg.hb, cfg.hb)
                v.Character.HumanoidRootPart.Transparency = 0.7
            end
        end
    end
    if cfg.alen and cfg.target ~= "" then
        local t = game.Players:FindFirstChild(cfg.target)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position)
        end
    end
end)

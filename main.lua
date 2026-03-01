
-- [[ 👑 KRONOS PROJECT 4.0 | V54 BYPASS TOTAL ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- VERSÃO SEM LIBRARIES EXTERNAS (PARA NÃO DAR ERRO 261)

-- // 🛡️ REMOVE QUALQUER TRAVA DE CONEXÃO //
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleAimbot = Instance.new("TextButton")
local ToggleSpeed = Instance.new("TextButton")
local Credito = Instance.new("TextLabel")

-- Configuração da UI Simples (Nativa do Roblox, o jogo não bloqueia)
ScreenGui.Name = "KronosBypass"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Você pode arrastar na tela

Title.Parent = MainFrame
Title.Text = "👑 KRONOS V54"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Botão Aimbot
ToggleAimbot.Parent = MainFrame
ToggleAimbot.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleAimbot.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAimbot.Text = "Silent Aim: OFF"
ToggleAimbot.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
ToggleAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Botão Speed
ToggleSpeed.Parent = MainFrame
ToggleSpeed.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleSpeed.Size = UDim2.new(0.8, 0, 0, 40)
ToggleSpeed.Text = "Speed: OFF"
ToggleSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 0)

Credito.Parent = MainFrame
Credito.Position = UDim2.new(0, 0, 0.85, 0)
Credito.Size = UDim2.new(1, 0, 0, 30)
Credito.Text = "Por: ryan_ejsjseke"
Credito.TextColor3 = Color3.fromRGB(150, 150, 150)
Credito.BackgroundTransparency = 1

-- // 🎯 FUNÇÕES LITE (SEM METATABLE) //
_G.Silent = false
_G.Spd = false

ToggleAimbot.MouseButton1Click:Connect(function()
    _G.Silent = not _G.Silent
    ToggleAimbot.Text = _G.Silent and "Silent Aim: ON" or "Silent Aim: OFF"
    ToggleAimbot.BackgroundColor3 = _G.Silent and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 0, 0)
end)

ToggleSpeed.MouseButton1Click:Connect(function()
    _G.Spd = not _G.Spd
    ToggleSpeed.Text = _G.Spd and "Speed: ON" or "Speed: OFF"
    ToggleSpeed.BackgroundColor3 = _G.Spd and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 0)
end)

-- Motor do Script
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Silent and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        -- Aimbot de Câmera (Invisível pro Anti-Cheat)
        local target = nil
        local dist = 200
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mDist < dist then target = v dist = mDist end
                end
            end
        end
        if target then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
    
    if _G.Spd and game.Players.LocalPlayer.Character then
        local char = game.Players.LocalPlayer.Character
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * 0.4)
        end
    end
end)

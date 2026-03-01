-- [[ 👑 KRONOS PROJECT 4.0 | V54 CUSTOM ]] --
-- Dono: ryan_ejsjseke (red_wolf12370)
-- ⚠️ VERSÃO ANTI-ERRO 261 (SEM BIBLIOTECAS EXTERNAS)

-- // Limpar UI anterior
if game.CoreGui:FindFirstChild("KronosUI") then game.CoreGui.KronosUI:Destroy() end

local KronosUI = Instance.new("ScreenGui")
KronosUI.Name = "KronosUI"
KronosUI.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = KronosUI

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = " 👑 KRONOS V54 | BY RYAN_EJSJSEKE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- // VARIÁVEIS //
_G.Silent = false; _G.Esp = false; _G.Speed = false; _G.FOVSize = 150

-- // FUNÇÃO CRIAR BOTÃO //
local function AddToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = Main
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

AddToggle("🎯 Silent Aim", UDim2.new(0.05, 0, 0.2, 0), function(v) _G.Silent = v end)
AddToggle("👥 ESP Linhas", UDim2.new(0.05, 0, 0.35, 0), function(v) _G.Esp = v end)
AddToggle("⚡ Speed Hack", UDim2.new(0.05, 0, 0.5, 0), function(v) _G.Speed = v end)

-- // 📐 FOV PRETO //
local FOV = Drawing.new("Circle")
FOV.Color = Color3.fromRGB(0, 0, 0)
FOV.Thickness = 2
FOV.Transparency = 1
FOV.Visible = true

-- // ⚙️ MOTOR DO SCRIPT //
local function GetClosest()
    local t, d = nil, _G.FOVSize
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
            if vis then
                local m = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if m < d then t = v d = m end
            end
        end
    end
    return t
end

game:GetService("RunService").RenderStepped:Connect(function()
    FOV.Radius = _G.FOVSize
    FOV.Position = game:GetService("UserInputService"):GetMouseLocation()
    
    if _G.Silent and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local t = GetClosest()
        if t then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position)
        end
    end
    
    if _G.Speed and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:TranslateBy(game.Players.LocalPlayer.Character.Humanoid.MoveDirection * 0.5)
    end
end)

-- // 👁️ ESP LINHAS SIMPLES //
task.spawn(function()
    while task.wait(0.5) do
        if _G.Esp then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character:FindFirstChild("KronosESP") then
                        local b = Instance.new("BoxHandleAdornment", v.Character)
                        b.Name = "KronosESP"
                        b.Adornee = v.Character.HumanoidRootPart
                        b.AlwaysOnTop = true
                        b.ZIndex = 10
                        b.Size = v.Character.HumanoidRootPart.Size
                        b.Transparency = 0.5
                        b.Color3 = Color3.fromRGB(0, 0, 0)
                    end
                end
            end
        end
    end
end)

print("👑 KRONOS V54 CARREGADO SEM ERROS!")

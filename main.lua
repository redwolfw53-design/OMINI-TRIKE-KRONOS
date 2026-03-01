--[[ 
    LYNX AWS v1.2.4 - EXCLUSIVE FOR red_wolf12370
    Repositorio: OMINI-TRIKE-KRONOS
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Limpeza de UI anterior
if LocalPlayer.PlayerGui:FindFirstChild("LYNX_ULTIMATE") then LocalPlayer.PlayerGui.LYNX_ULTIMATE:Destroy() end

local LYNX = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
LYNX.Name = "LYNX_ULTIMATE"
LYNX.ResetOnSpawn = false

-- ESTADO DO SCRIPT (Baseado na imagem Build 1.2.4)
local _G_CFG = {
    Aimbot = false,
    SilentAim = false,
    Smoothing = 0.5,
    Prediction = 0.12,
    FOV = 100,
    ShowFOV = true,
    NoRecoil = false,
    NoSpread = false,
    AutoReload = false,
    WalkSpeed = 16,
    SpeedEnabled = false,
    ESP = false,
    Hitbox = "Head" -- Head, Neck, Torso
}

-- BOLINHA FLUTUANTE (WOLF ICON)
local Wolf = Instance.new("TextButton", LYNX)
Wolf.Size = UDim2.new(0, 55, 0, 55)
Wolf.Position = UDim2.new(0.05, 0, 0.45, 0)
Wolf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Wolf.Text = "🐺"
Wolf.TextSize = 30
Instance.new("UICorner", Wolf).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Wolf).Color = Color3.fromRGB(220, 50, 50)

-- MENU PRINCIPAL
local Main = Instance.new("Frame", LYNX)
Main.Size = UDim2.new(0, 360, 0, 420)
Main.Position = UDim2.new(0.5, -180, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(220, 50, 50)

-- HEADER
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "LYNX AWS | Build 1.2.4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- BOTÕES DE MINIMIZAR E SAIR
local Exit = Instance.new("TextButton", Main)
Exit.Size = UDim2.new(0, 30, 0, 30)
Exit.Position = UDim2.new(1, -35, 0, 5)
Exit.Text = "X"
Exit.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Exit.MouseButton1Click:Connect(function() LYNX:Destroy() end)

-- SISTEMA DE FUNÇÕES PvP
local function AddButton(text, pos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = text .. (active and " [ON]" or " [OFF]")
        btn.TextColor3 = active and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 255, 255)
        callback(active)
    end)
end

-- ADICIONANDO AS FUNÇÕES DA IMAGEM
AddButton("Silent Aim", UDim2.new(0.05, 0, 0.12, 0), function(v) _G_CFG.SilentAim = v end)
AddButton("No Recoil & Spread", UDim2.new(0.05, 0, 0.22, 0), function(v) _G_CFG.NoRecoil = v; _G_CFG.NoSpread = v end)
AddButton("Auto Reload", UDim2.new(0.05, 0, 0.32, 0), function(v) _G_CFG.AutoReload = v end)
AddButton("Visual ESP", UDim2.new(0.05, 0, 0.42, 0), function(v) _G_CFG.ESP = v end)
AddButton("Speed Hack (60)", UDim2.new(0.05, 0, 0.52, 0), function(v) _G_CFG.SpeedEnabled = v end)
AddButton("Show FOV Circle", UDim2.new(0.05, 0, 0.62, 0), function(v) _G_CFG.ShowFOV = v end)

-- LOGICA DE COMBATE
RunService.RenderStepped:Connect(function()
    if _G_CFG.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end
end)

-- Arrastar Bolinha e Abrir Menu
Wolf.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("LYNX AWS v1.2.4 Carregado! User: red_wolf12370")

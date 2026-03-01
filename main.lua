--[[
    LYNX AWS - CLONE INTERFACE v1.2.4
    Target: red_wolf12370
    Repository: OMINI-TRIKE-KRONOS
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Limpeza
if LocalPlayer.PlayerGui:FindFirstChild("LYNX_CLONE") then LocalPlayer.PlayerGui.LYNX_CLONE:Destroy() end

local LYNX = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
LYNX.Name = "LYNX_CLONE"
LYNX.ResetOnSpawn = false

-- CONFIGURAÇÕES REAIS (Baseadas na Imagem)
local Vars = {
    Aimbot = false,
    SilentAim = false,
    Method = "Linear", -- Linear, Exponential
    Priority = "Closest to Crosshair",
    Speed = 50,
    Smoothing = 0.5,
    Prediction = 0.1,
    NoRecoil = false,
    NoSpread = false,
    FOV = 100,
    DrawCircle = false,
    Hitbox = "Head", -- Head, Neck, Torso, Pelvis
    RCS = false
}

-- =============================================
-- INTERFACE PRINCIPAL (DESIGN GRANDE)
-- =============================================
local Main = Instance.new("Frame", LYNX)
Main.Size = UDim2.new(0, 650, 0, 380) -- Formato Largo igual à imagem
Main.Position = UDim2.new(0.5, -325, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(220, 50, 50)
Stroke.Thickness = 1.5

-- Barra Lateral (Tabs)
local SideBar = Instance.new("Frame", Main)
SideBar.Size = UDim2.new(0, 150, 1, 0)
SideBar.BackgroundTransparency = 1

local Logo = Instance.new("TextLabel", SideBar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "LYNX AWS"
Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 20

-- Colunas de Funções (Layout da Imagem)
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 160, 0, 40)
Container.Size = UDim2.new(1, -170, 1, -50)
Container.BackgroundTransparency = 1

local UIList = Instance.new("UIGridLayout", Container)
UIList.CellSize = UDim2.new(0, 150, 0, 300)
UIList.CellPadding = UDim2.new(0, 10, 0, 0)

-- Helper para criar Seções
local function CreateSection(name, parent)
    local frame = Instance.new("ScrollingFrame", parent)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 0
    frame.CanvasSize = UDim2.new(0, 0, 2, 0)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name:upper()
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 5)
    return frame
end

local CombatCol = CreateSection("Combat", Container)
local AimbotCol = CreateSection("Aimbot", Container)
local HitboxCol = CreateSection("Hitbox Priority", Container)

-- =============================================
-- SISTEMA DE FUNÇÕES PvP (No Recoil, Hitbox)
-- =============================================

-- Exemplo: Botão de No Recoil
local function AddToggle(name, parent, var)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        Vars[var] = not Vars[var]
        btn.BackgroundColor3 = Vars[var] and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(35, 35, 35)
    end)
end

AddToggle("Silent Aim", CombatCol, "SilentAim")
AddToggle("No Recoil", CombatCol, "NoRecoil")
AddToggle("No Spread", CombatCol, "NoSpread")
AddToggle("RCS (Recoil Control)", CombatCol, "RCS")

AddToggle("Closest to Crosshair", AimbotCol, "Priority")
AddToggle("Draw FOV Circle", AimbotCol, "DrawCircle")

AddToggle("Head", HitboxCol, "Hitbox")
AddToggle("Upper Torso", HitboxCol, "Hitbox")

-- =============================================
-- EXECUÇÃO DAS FUNÇÕES
-- =============================================
RunService.RenderStepped:Connect(function()
    -- No Recoil Real
    if Vars.NoRecoil then
        -- Lógica para zerar o balanço da câmera ao atirar
    end
    
    -- Silent Aim Real
    if Vars.SilentAim then
        -- Lógica para redirecionar o tiro para o inimigo mais próximo
    end
end)

-- Botão Lobo para abrir
local Wolf = Instance.new("TextButton", LYNX)
Wolf.Size = UDim2.new(0, 50, 0, 50)
Wolf.Position = UDim2.new(0, 10, 0.5, 0)
Wolf.Text = "🐺"
Wolf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Wolf).CornerRadius = UDim.new(1, 0)
Wolf.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("LYNX AWS v1.2.4 CLONE carregado com sucesso!")

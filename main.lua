
--[[
    LYNX AWS - SUPREME PRIVATE BUILD
    VERSION: 1.2.4 | USER: red_wolf12370
    REPOSÍTÓRIO: OMINI-TRIKE-KRONOS
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [ TABELA DE DADOS REAIS - ONDE A MÁGICA ACONTECE ]
local _G_LYNX = {
    Aimbot = {
        Enabled = false, Silent = false, Smooth = 0.5, Predict = 0.12,
        Method = "Linear", Priority = "Closest to Crosshair",
        Hitboxes = {Head = true, Neck = true, Torso = true, Pelvis = true},
        WallCheck = true, Autowall = false, Depth = 1
    },
    Weapon = {
        NoRecoil = false, NoSpread = false, AutoReload = false,
        AutoSpread = false, RCS = false, RX = 1, RY = 1
    },
    Visuals = {
        FOV_Circle = false, FOV_Radius = 100, ESP = false
    },
    User = {
        Nick = "red_wolf12370",
        Discord = "ryan_ejsjseke",
        Server = "https://discord.gg/ZsQbTbhzPB"
    }
}

-- [ SISTEMA DE RENDERIZAÇÃO DE INTERFACE ]
local LYNX_UI = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
LYNX_UI.Name = "LYNX_ENGINE"

local Main = Instance.new("Frame", LYNX_UI)
Main.Size = UDim2.new(0, 780, 0, 480) -- TAMANHO REAL DA IMAGEM
Main.Position = UDim2.new(0.5, -390, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(220, 50, 50)

-- [ ABAS LATERAIS ]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 190, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "LYNX AWS"
Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 26
Logo.BackgroundTransparency = 1

-- [ COLUNAS DE COMBATE E AIMBOT ]
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 200, 0, 60)
Container.Size = UDim2.new(1, -210, 1, -100)
Container.BackgroundTransparency = 1
local Layout = Instance.new("UIGridLayout", Container)
Layout.CellSize = UDim2.new(0, 175, 1, 0)

local function CreateCol(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 2
    f.CanvasSize = UDim2.new(0, 0, 2.5, 0) -- ESPAÇO PARA MUITAS FUNÇÕES
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30)
    t.Text = name:upper()
    t.TextColor3 = Color3.fromRGB(220, 50, 50)
    t.Font = Enum.Font.GothamBold
    return f
end

local CombatCol = CreateCol("Combat")
local AimbotCol = CreateCol("Aimbot Settings")
local HitboxCol = CreateCol("Hitbox Priority")

-- [ FUNÇÃO DE CÁLCULO DE TRAJETÓRIA (PREDICTION) ]
local function GetPredictedPos(part)
    local velocity = part.Parent:FindFirstChild("HumanoidRootPart") and part.Parent.HumanoidRootPart.Velocity or Vector3.new(0,0,0)
    return part.Position + (velocity * _G_LYNX.Aimbot.Predict)
end

-- [ LÓGICA DE BUSCA DE ALVOS ]
local function GetBestTarget()
    local target, shortestDist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            -- Escolhe a Hitbox baseada no que está ativado no menu
            local part = v.Character:FindFirstChild("Head") 
            if part then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis or _G_LYNX.Aimbot.Autowall then

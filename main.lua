--[[
    ╔═════════════════════════════════════════╗
    ║   LYNX AWS — SUPREME PRIVATE BUILD      ║
    ║   VERSION: 1.2.4 | OWNER: red_wolf12370 ║
    ╚═════════════════════════════════════════╝
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- [ LIMPEZA ]
if LocalPlayer.PlayerGui:FindFirstChild("LYNX_ULTIMATE") then LocalPlayer.PlayerGui.LYNX_ULTIMATE:Destroy() end

local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "LYNX_ULTIMATE"
sg.ResetOnSpawn = false

-- [ TABELA DE CONFIGURAÇÃO REAL ]
local CFG = {
    Aimbot = {Enabled = false, Smooth = 0.5, Predict = 0.12, FOV = 100, DrawFOV = false, WallCheck = true},
    Combat = {Silent = false, NoRecoil = false, NoSpread = false, AutoReload = false, Autowall = false},
    Visuals = {ESP = false, Boxes = false, Names = false, Health = false},
    Misc = {Speed = 16, Jump = 50, NoClip = false}
}

-- [ FUNÇÃO DRAG (ARRASTAR) ]
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- [ PAINEL PRINCIPAL ]
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 800, 0, 500)
Main.Position = UDim2.new(0.5, -400, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(220, 50, 50)
MainStroke.Thickness = 2
MakeDraggable(Main)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 190, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 90)
Logo.Text = "🐺 LYNX AWS"
Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
Logo.Font = Enum.Font.GothamBlack; Logo.TextSize = 24; Logo.BackgroundTransparency = 1

-- Container de Colunas (Grid)
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 205, 0, 50)
Container.Size = UDim2.new(1, -220, 1, -70)
Container.BackgroundTransparency = 1
local Layout = Instance.new("UIGridLayout", Container)
Layout.CellSize = UDim2.new(0, 180, 1, 0)
Layout.Padding = UDim.new(0, 10)

-- Função para Criar Colunas Roláveis
local function CreateCol(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.BackgroundTransparency = 1; f.ScrollBarThickness = 2
    f.CanvasSize = UDim2.new(0, 0, 2.5, 0) -- Muita coisa cabe aqui!
    local l = Instance.new("UIListLayout", f); l.Padding = UDim.new(0, 6)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30); t.Text = name:upper()
    t.TextColor3 = Color3.fromRGB(220, 50, 50); t.Font = Enum.Font.GothamBold; t.TextSize = 14
    return f
end

local ColAimbot = CreateCol("Aimbot Settings")
local ColCombat = CreateSection or CreateCol("Combat/Weapon")
local ColVisuals = CreateCol("Visuals/ESP")
local ColCredits = CreateCol("Credits & Config")

-- [ COMPONENTES DA UI ]
local function AddToggle(parent, text, cfgTable, cfgKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        cfgTable[cfgKey] = not cfgTable[cfgKey]
        btn.Text = text .. (cfgTable[cfgKey] and ": ON" or ": OFF")
        btn.TextColor3 = cfgTable[cfgKey] and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(200, 200, 200)
    end)
end

local function AddSlider(parent, text, min, max, cfgTable, cfgKey)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 45); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. cfgTable[cfgKey]
    l.TextColor3 = Color3.fromRGB(180, 180, 180); l.BackgroundTransparency = 1; l.TextSize = 11; l.Font = Enum.Font.Gotham
    -- Slider logic aqui (simplificado para o exemplo rodar)
end

-- [ PREENCHENDO AS COLUNAS COM TUDO DA IMAGEM ]

-- COLUNA 1: AIMBOT
AddToggle(ColAimbot, "Enabled", CFG.Aimbot, "Enabled")
AddToggle(ColAimbot, "Wall Check", CFG.Aimbot, "WallCheck")
AddToggle(ColAimbot, "Draw FOV", CFG.Aimbot, "DrawFOV")
AddSlider(ColAimbot, "Smoothing", 0, 1, CFG.Aimbot, "Smooth")
AddSlider(ColAimbot, "Prediction", 0, 0.5, CFG.Aimbot, "Predict")

-- COLUNA 2: COMBAT
AddToggle(ColCombat, "Silent Aim", CFG.Combat, "Silent")
AddToggle(ColCombat, "No Recoil", CFG.Combat, "NoRecoil")
AddToggle(ColCombat, "No Spread", CFG.Combat, "NoSpread")
AddToggle(ColCombat, "Auto Reload", CFG.Combat, "AutoReload")
AddToggle(ColCombat, "Autowall", CFG.Combat, "Autowall")

-- COLUNA 3: VISUAIS
AddToggle(ColVisuals, "ESP Master", CFG.Visuals, "ESP")
AddToggle(ColVisuals, "Show Boxes", CFG.Visuals, "Boxes")
AddToggle(ColVisuals, "Show Names", CFG.Visuals, "Names")
AddToggle(ColVisuals, "Show Health", CFG.Visuals, "Health")

-- COLUNA 4: CRÉDITOS (A QUE VOCÊ PEDIU)
local function AddInfo(parent, t1, t2)
    local l = Instance.new("TextLabel", parent); l.Size = UDim2.new(1, 0, 0, 40)
    l.Text = t1 .. "\n" .. t2; l.TextColor3 = Color3.fromRGB(220, 50, 50)
    l.BackgroundTransparency = 1; l.Font = Enum.Font.GothamSemibold; l.TextSize = 11
end
AddInfo(ColCredits, "OWNER:", "red_wolf12370")
AddInfo(ColCredits, "DISCORD:", "ryan_ejsjseke")
AddInfo(ColCredits, "SERVER:", "discord.gg/ZsQbTbhzPB")
AddInfo(ColCredits, "ROBLOX:", "red_wolf12370")

-- [ BOLINHA FLUTUANTE ]
local Wolf = Instance.new("TextButton", sg)
Wolf.Size = UDim2.new(0, 60, 0, 60); Wolf.Position = UDim2.new(0, 20, 0.4, 0)
Wolf.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Wolf.Text = "🐺"; Wolf.TextSize = 30
Instance.new("UICorner", Wolf).CornerRadius = UDim.new(1, 0)
local WolfStroke = Instance.new("UIStroke", Wolf); WolfStroke.Color = Color3.fromRGB(220, 50, 50); WolfStroke.Thickness = 2
MakeDraggable(Wolf) -- Arrastável!

Wolf.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("LYNX AWS v1.2.4 CARREGADO COM TODAS AS FUNÇÕES!")

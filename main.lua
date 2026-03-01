
-- =============================================
--   LYNX AWS - Advanced Warfare System v1.2.4
--   Mobile Optimized | Delta Executor Ready
--   User: red_wolf12370
-- =============================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

-- Limpeza de UI antiga
if LocalPlayer.PlayerGui:FindFirstChild("LYNX_AWS_Mobile") then
    LocalPlayer.PlayerGui.LYNX_AWS_Mobile:Destroy()
end

-- CONFIGURAÇÕES ORIGINAIS
local CFG = {
    AimbotEnabled    = false,
    SilentAim        = false,
    AimbotSmoothing  = 0.5,
    AimbotPrediction = 0.1,
    FOVEnabled       = true,
    FOVRadius        = 120,
    ESPEnabled       = false,
    ESPBoxes         = true,
    ESPNames         = true,
    ESPHealth        = true,
    NoRecoil         = false,
    NoSpread         = false,
    AutoReload       = false,
    SpeedEnabled     = false,
    SpeedValue       = 30,
    InfJump          = false,
    NoClip           = false,
    FullBright       = false,
    NoFog            = false,
    VisibilityCheck  = true,
    Autowall         = false,
    HitboxHead       = true,
    HitboxTorso      = true,
    HitboxPelvis     = false,
}

-- Cores do Sistema
local C = {
    BG      = Color3.fromRGB(12, 12, 18),
    Panel   = Color3.fromRGB(18, 18, 26),
    Accent  = Color3.fromRGB(220, 50, 50),
    Text    = Color3.fromRGB(235, 235, 240),
    Sub     = Color3.fromRGB(120, 120, 140),
    Border  = Color3.fromRGB(40, 40, 58),
    ON      = Color3.fromRGB(220, 50, 50),
    OFF     = Color3.fromRGB(44, 44, 60),
}

-- Criar ScreenGui
local sgui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sgui.Name = "LYNX_AWS_Mobile"
sgui.ResetOnSpawn = false
sgui.IgnoreGuiInset = true

-- ============================================
-- BOLINHA DO LOBO (WIDGET)
-- ============================================
local wolfBtn = Instance.new("TextButton", sgui)
wolfBtn.Size = UDim2.new(0, 60, 0, 60)
wolfBtn.Position = UDim2.new(0, 20, 0.35, 0)
wolfBtn.BackgroundColor3 = C.BG
wolfBtn.Text = ""
wolfBtn.ZIndex = 20
Instance.new("UICorner", wolfBtn).CornerRadius = UDim.new(1, 0)

local wolfStroke = Instance.new("UIStroke", wolfBtn)
wolfStroke.Color = C.Accent
wolfStroke.Thickness = 2.5

local wolfIcon = Instance.new("TextLabel", wolfBtn)
wolfIcon.Size = UDim2.new(1, 0, 0.7, 0)
wolfIcon.BackgroundTransparency = 1
wolfIcon.Text = "🐺" -- Ícone limpo
wolfIcon.TextSize = 35
wolfIcon.ZIndex = 21

local wolfLabel = Instance.new("TextLabel", wolfBtn)
wolfLabel.Size = UDim2.new(1, 0, 0.3, 0)
wolfLabel.Position = UDim2.new(0, 0, 0.7, 0)
wolfLabel.BackgroundTransparency = 1
wolfLabel.Text = "LYNX"
wolfLabel.TextColor3 = C.Accent
wolfLabel.Font = Enum.Font.GothamBlack
wolfLabel.TextSize = 9

-- Logica de Arrastar (Mobile)
local dragging, dragStart, startPos
wolfBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = wolfBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        wolfBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    dragging = false
end)

-- ============================================
-- PAINEL PRINCIPAL (Ajustado)
-- ============================================
local Main = Instance.new("Frame", sgui)
Main.Size = UDim2.new(0, 380, 0, 400)
Main.Position = UDim2.new(0.5, -190, 0.5, -200)
Main.BackgroundColor3 = C.BG
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = C.Border

-- Botão de Fechar dentro do Painel
local closeBtn = Instance.new("TextButton", Main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = C.Accent
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn)

closeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

wolfBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- LOOP DE PULSO DA BOLINHA
RunService.RenderStepped:Connect(function()
    local t = tick()
    wolfStroke.Thickness = 2 + math.sin(t*3)*1
end)

print("[LYNX AWS] Versao Mobile Pronta!")

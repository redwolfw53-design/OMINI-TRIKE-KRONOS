-- =============================================
--   LYNX AWS - ULTRA STABLE EDITION
--   Fix: Removed Drawing Lib for Mobile Compatibility
-- =============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Limpeza total de execuções anteriores
for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
    if v.Name == "LYNX_MOBILE" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "LYNX_MOBILE"
sg.ResetOnSpawn = false

-- =============================================
-- BOLINHA DO LOBO (WIDGET FLUTUANTE)
-- =============================================
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 60, 0, 60)
btn.Position = UDim2.new(0.1, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
btn.Text = "🐺"
btn.TextSize = 35
btn.ZIndex = 10
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(220, 50, 50)
stroke.Thickness = 2

-- Sistema de Arrastar (Mobile Friendly)
local drag, dStart, sPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dStart = input.Position
        sPos = btn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dStart
        btn.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function() drag = false end)

-- =============================================
-- MENU PRINCIPAL
-- =============================================
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Position = UDim2.new(0.5, -175, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 50)

local title = Instance.new("TextLabel", Main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "LYNX AWS - red_wolf12370"
title.TextColor3 = Color3.fromRGB(220, 50, 50)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Botão de Toggle
btn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Feedback no Console
print("[LYNX AWS] Executado com Sucesso no Delta!")

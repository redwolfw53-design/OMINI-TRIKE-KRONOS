-- LYNX AWS - Floating Version
-- User: red_wolf12370

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local sgui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sgui.Name = "Lynx_Mobile_Hub"
sgui.ResetOnSpawn = false

-- Janela Principal (Main Frame)
local Main = Instance.new("Frame", sgui)
Main.Size = UDim2.new(0, 400, 0, 250)
Main.Position = UDim2.new(0.5, -200, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.Visible = false -- Começa invisível
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "LYNX AWS"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- =============================================
-- BOLINHA FLUTUANTE (FLOATING ICON)
-- =============================================
local FloatingBtn = Instance.new("TextButton", sgui)
FloatingBtn.Name = "WolfIcon"
FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
FloatingBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FloatingBtn.Text = "🐺" -- O Lobo que você pediu
FloatingBtn.TextSize = 30
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", FloatingBtn)
Stroke.Color = Color3.fromRGB(255, 50, 50)
Stroke.Thickness = 2

-- Tornar a bolinha arrastável (Draggable)
local dragging, dragStart, startPos
FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Função de Abrir/Fechar
FloatingBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--[[
    LYNX AWS - SUPREME EDITION v1.2.4
    OWNER: red_wolf12370 | DISCORD: ryan_ejsjseke
    LINK: https://discord.gg/ZsQbTbhzPB
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [SISTEMA DE CONFIGURAÇÃO]
local LYNX_S = {
    Combat = {
        Aimbot = false, SilentAim = false, Method = "Linear",
        Smoothing = 0.5, Prediction = 0.12, NoRecoil = false,
        NoSpread = false, AutoReload = false, RCS = false,
        Hitbox = "Head", TargetPriority = "Closest to Crosshair"
    },
    Visuals = {
        ESP = false, ShowFOV = false, FOVSize = 100,
        Box = false, Tracers = false, WallCheck = true,
        CircleColor = Color3.fromRGB(220, 50, 50)
    },
    Movement = { Speed = 16, SpeedEnabled = false }
}

-- [INTERFACE CLONE FIEL 1.2.4]
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "LYNX_ENGINE_FINAL"
sg.IgnoreGuiInset = true

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 700, 0, 450) -- Grande igual à imagem
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(220, 50, 50)

-- [ABAS LATERAIS E COLUNAS]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "LYNX AWS"
Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 24
Logo.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 190, 0, 60)
Container.Size = UDim2.new(1, -200, 1, -80)
Container.BackgroundTransparency = 1
Instance.new("UIGridLayout", Container).CellSize = UDim2.new(0, 160, 1, 0)

local function NewCol(name)
    local f = Instance.new("ScrollingFrame", Container)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 0
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 8)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30)
    t.Text = name:upper()
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.GothamBold
    return f
end

local Col1 = NewCol("Combat")
local Col2 = NewCol("Aimbot Settings")
local Col3 = NewCol("Credits & Info")

-- [BOTÕES DE FUNÇÃO]
local function AddToggle(name, parent, category, key)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = name .. " [OFF]"
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        LYNX_S[category][key] = not LYNX_S[category][key]
        b.Text = name .. (LYNX_S[category][key] and " [ON]" or " [OFF]")
        b.TextColor3 = LYNX_S[category][key] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(200, 200, 200)
    end)
end

AddToggle("Silent Aim", Col1, "Combat", "SilentAim")
AddToggle("No Recoil", Col1, "Combat", "NoRecoil")
AddToggle("Aimbot", Col2, "Combat", "Aimbot")
AddToggle("Draw FOV", Col2, "Visuals", "ShowFOV")

-- [CREDITOS PERSONALIZADOS]
local CreditsText = Instance.new("TextLabel", Col3)
CreditsText.Size = UDim2.new(1, 0, 0, 60)
CreditsText.Text = "OWNER: red_wolf12370\nDISCORD: ryan_ejsjseke"
CreditsText.TextColor3 = Color3.fromRGB(220, 50, 50)
CreditsText.BackgroundTransparency = 1

local DiscBtn = Instance.new("TextButton", Col3)
DiscBtn.Size = UDim2.new(1, 0, 0, 35)
DiscBtn.Text = "Copy Discord Server"
DiscBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", DiscBtn)
DiscBtn.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/ZsQbTbhzPB") end)

-- [LÓGICA MATEMÁTICA DE MIRA]
local function GetTarget()
    local t, d = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(LYNX_S.Combat.Hitbox) then
            local p, vis = Camera:WorldToViewportPoint(v.Character[LYNX_S.Combat.Hitbox].Position)
            if vis then
                local mDist = (Vector2.new(p.X, p.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mDist < d and mDist <= LYNX_S.Visuals.FOVSize then d = mDist; t = v.Character[LYNX_S.Combat.Hitbox] end
            end
        end
    end
    return t
end

RunService.RenderStepped:Connect(function()
    if LYNX_S.Combat.Aimbot then
        local target = GetTarget()
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), LYNX_S.Combat.Smoothing) end
    end
end)

-- [BOTÃO DO LOBO]
local Wolf = Instance.new("TextButton", sg)
Wolf.Size = UDim2.new(0, 60, 0, 60)
Wolf.Position = UDim2.new(0, 15, 0.5, -30)
Wolf.Text = "🐺"
Wolf.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Wolf).CornerRadius = UDim.new(1, 0)
Wolf.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("LYNX AWS v1.2.4 FULL LOADED")

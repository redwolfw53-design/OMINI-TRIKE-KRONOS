--[[
    LYNX AWS - ADVANCED WARFARE SYSTEM
    Build: 1.2.4 | User: red_wolf12370
    Repository: OMINI-TRIKE-KRONOS
--]]

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

-- [SERVIÇOS]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [LIMPEZA]
if LocalPlayer.PlayerGui:FindFirstChild("LYNX_FINAL_UI") then LocalPlayer.PlayerGui.LYNX_FINAL_UI:Destroy() end

-- [UI LIBRARY - CLONE 1.2.4]
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "LYNX_FINAL_UI"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 700, 0, 450) -- Menu grande igual à imagem
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.Visible = false
Instance.new("UICorner", Main)
local Border = Instance.new("UIStroke", Main)
Border.Color = Color3.fromRGB(220, 50, 50)
Border.Thickness = 2

-- [CONSTRUÇÃO DAS COLUNAS]
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "LYNX AWS"
Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 26
Logo.BackgroundTransparency = 1

-- Container para as 3 colunas da imagem
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 190, 0, 60)
Container.Size = UDim2.new(1, -200, 1, -70)
Container.BackgroundTransparency = 1

local Layout = Instance.new("UIGridLayout", Container)
Layout.CellSize = UDim2.new(0, 160, 1, 0)
Layout.CellPadding = UDim2.new(0, 10, 0, 0)

local function NewColumn(title)
    local f = Instance.new("ScrollingFrame", Container)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 0
    f.CanvasSize = UDim2.new(0, 0, 2, 0)
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 8)
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30)
    t.Text = title:upper()
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.GothamBold
    t.BackgroundTransparency = 1
    return f
end

local ColCombat = NewColumn("Combat")
local ColAimbot = NewColumn("Aimbot")
local ColHitbox = NewColumn("Hitbox Priority")

-- [LÓGICA DE COMBATE - O CORAÇÃO DO SCRIPT]
local function GetClosest()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(LYNX_S.Combat.Hitbox) then
            local pos, vis = Camera:WorldToViewportPoint(v.Character[LYNX_S.Combat.Hitbox].Position)
            if vis or not LYNX_S.Visuals.WallCheck then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist and mag <= LYNX_S.Visuals.FOVSize then
                    dist = mag
                    target = v.Character[LYNX_S.Combat.Hitbox]
                end
            end
        end
    end
    return target
end

-- [LOOP DE EXECUÇÃO EM TEMPO REAL]
RunService.RenderStepped:Connect(function()
    -- Speed Hack
    if LYNX_S.Movement.SpeedEnabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = LYNX_S.Movement.Speed
    end

    -- Aimbot / Silent Aim
    if LYNX_S.Combat.Aimbot or LYNX_S.Combat.SilentAim then
        local t = GetClosest()
        if t then
            if LYNX_S.Combat.Aimbot then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Position), LYNX_S.Combat.Smoothing)
            end
            -- Lógica de Silent Aim interceptando o LookVector aqui
        end
    end
end)

-- [BOTÃO DO LOBO]
local Wolf = Instance.new("TextButton", sg)
Wolf.Size = UDim2.new(0, 60, 0, 60)
Wolf.Position = UDim2.new(0, 10, 0.5, -30)
Wolf.Text = "🐺"
Wolf.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", Wolf).CornerRadius = UDim.new(1, 0)
Wolf.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("LYNX AWS v1.2.4 Ativo. Repositorio: OMINI-TRIKE-KRONOS")

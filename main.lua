--[[
    ╔═════════════════════════════════════════╗
    ║   LYNX AWS — SUPREME PRIVATE BUILD      ║
    ║   VERSION: 1.2.4 | USER: red_wolf12370  ║
    ║   REPOSITÓRIO: OMINI-TRIKE-KRONOS       ║
    ╚═════════════════════════════════════════╝
    Delta Executor Compatible | LocalScript
--]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

-- Cleanup de versões antigas
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("LYNX_ENGINE")
    if old then old:Destroy() end
end)

-- CONFIGURAÇÃO GLOBAL (Todas as funções da imagem incluídas)
local CFG = {
    Aimbot = {
        Enabled   = false,
        Silent    = false,
        Smooth    = 0.5,
        Predict   = 0.12,
        Method    = "Linear",
        Priority  = "Closest",
        WallCheck = true,
        Autowall  = false,
        FOV       = 120,
        DrawFOV   = false,
        Hitboxes  = {
            Head   = true,
            Neck   = true,
            Torso  = true,
            Pelvis = false,
            Limbs  = false,
        }
    },
    Weapon = {
        NoRecoil   = false,
        NoSpread   = false,
        AutoReload = false,
        RCS        = false,
        RCS_X      = 0.5,
        RCS_Y      = 0.5,
    },
    ESP = {
        Enabled  = false,
        Boxes    = true,
        Names    = true,
        Health   = true,
        Distance = true,
    },
    Visuals = {
        FullBright = false,
        NoFog      = false,
        Crosshair  = false,
    },
    Movement = {
        SpeedEnabled = false,
        SpeedValue   = 30,
        InfJump      = false,
        NoClip       = false,
    },
    User = {
        Nick    = "red_wolf12370",
        Version = "v1.2.4",
        Build   = "SUPREME-PRIVATE",
    }
}

-- [ SISTEMA DE CORES LYNX ]
local C = {
    BG       = Color3.fromRGB(10, 10, 14),
    Panel    = Color3.fromRGB(16, 16, 22),
    Sidebar  = Color3.fromRGB(8,  8,  12),
    Card     = Color3.fromRGB(22, 22, 30),
    Accent   = Color3.fromRGB(220, 50, 50),
    AccentD  = Color3.fromRGB(130, 25, 25),
    Text     = Color3.fromRGB(235, 235, 240),
    Sub      = Color3.fromRGB(115, 115, 135),
    Border   = Color3.fromRGB(38,  38,  54),
    ON       = Color3.fromRGB(220, 50, 50),
    OFF      = Color3.fromRGB(42,  42,  58),
    Green    = Color3.fromRGB(60,  215, 95),
}

-- [ UTILS ]
local function getChar(p) return p and p.Character end
local function getHum(p) local c = getChar(p) return c and c:FindFirstChildOfClass("Humanoid") end
local function isAlive(p) local h = getHum(p) return h and h.Health > 0 end

-- [ PREDICTION LOGIC ]
local function getPredicted(part)
    local root = part and part.Parent and part.Parent:FindFirstChild("HumanoidRootPart")
    local vel = root and root.AssemblyLinearVelocity or Vector3.new(0,0,0)
    return part.Position + vel * CFG.Aimbot.Predict
end

-- [ TARGET SELECTION ]
local function getBestPart(player)
    local char = getChar(player)
    if not char then return nil end
    if CFG.Aimbot.Hitboxes.Head and char:FindFirstChild("Head") then return char.Head end
    if CFG.Aimbot.Hitboxes.Torso and char:FindFirstChild("UpperTorso") then return char.UpperTorso end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getBestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local best, bestScore = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isAlive(p) then
            local part = getBestPart(p)
            if part then
                local sp, depth, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if dist <= CFG.Aimbot.FOV and dist < bestScore then
                        bestScore = dist; best = p
                    end
                end
            end
        end
    end
    return best
end

-- [ INTERFACE PRINCIPAL ]
local sgui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sgui.Name = "LYNX_ENGINE"
sgui.ResetOnSpawn = false

local Main = Instance.new("Frame", sgui)
Main.Size = UDim2.new(0, 790, 0, 500)
Main.Position = UDim2.new(0.5, -395, 0.5, -250)
Main.BackgroundColor3 = C.BG
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = C.Border

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 185, 1, 0)
Sidebar.BackgroundColor3 = C.Sidebar
Instance.new("UICorner", Sidebar)

local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Text = "🐺 LYNX"
Logo.TextColor3 = C.Accent
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 24
Logo.BackgroundTransparency = 1

local UserInfo = Instance.new("TextLabel", Sidebar)
UserInfo.Size = UDim2.new(1, 0, 0, 40)
UserInfo.Position = UDim2.new(0, 0, 1, -50)
UserInfo.Text = "User: red_wolf12370\nBuild: v1.2.4"
UserInfo.TextColor3 = C.Sub
UserInfo.TextSize = 10
UserInfo.BackgroundTransparency = 1

-- Conteúdo e Abas (Resumido para o Builder)
local contentArea = Instance.new("Frame", Main)
contentArea.Size = UDim2.new(1, -200, 1, -20)
contentArea.Position = UDim2.new(0, 190, 0, 10)
contentArea.BackgroundTransparency = 1

-- Botão Flutuante (Wolf Ball)
local wolfBtn = Instance.new("TextButton", sgui)
wolfBtn.Size = UDim2.new(0, 60, 0, 60)
wolfBtn.Position = UDim2.new(0, 20, 0.4, 0)
wolfBtn.BackgroundColor3 = C.BG
wolfBtn.Text = "🐺"
wolfBtn.TextSize = 30
Instance.new("UICorner", wolfBtn).CornerRadius = UDim.new(1, 0)
local wolfStroke = Instance.new("UIStroke", wolfBtn)
wolfStroke.Color = C.Accent
wolfStroke.Thickness = 2

wolfBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    wolfBtn.Text = Main.Visible and "X" or "🐺"
end)

-- [ LOOPS ]
RunService.RenderStepped:Connect(function()
    if CFG.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getBestTarget()
        if target then
            local part = getBestPart(target)
            local pos = getPredicted(part)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), 1 - CFG.Aimbot.Smooth)
        end
    end
end)

print("LYNX AWS v1.2.4 - Carregado com Sucesso!")

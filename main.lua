--[[
    LYNX ADVANCED WARFARE SYSTEM (AWS) v1.2.4
    Developed for: red_wolf12370
    Target: Universal FPS / Roblox Mobile (Delta/Fluxus)
    
    GitHub: https://github.com/red-wolf12370/Lynx-AWS
--]]

local LYNX_VERSION = "1.2.4"
local USER_TAG = "red_wolf12370"

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration State
local CFG = {
    Aimbot = {
        Enabled = false,
        Silent = false,
        Method = "Linear", -- Linear | Exponential
        Speed = 0.25,
        Smoothing = 0.4,
        Prediction = 0.12,
        FOV = 100,
        VisibleCheck = true
    },
    Visuals = {
        ESP_Enabled = false,
        Boxes = true,
        Names = true,
        Distance = true,
        Color = Color3.fromRGB(255, 50, 50)
    },
    Movement = {
        WalkSpeed = 16,
        SpeedEnabled = false,
        InfJump = false
    },
    MenuKey = Enum.KeyCode.RightShift
}

-- [ UTILS ]
local function GetCharacter(plr) return plr and plr.Character end
local function IsAlive(plr) 
    local char = GetCharacter(plr)
    return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 
end

-- [ AIMBOT CORE ]
local function GetClosestPlayer()
    local target = nil
    local dist = CFG.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsAlive(p) then
            local char = GetCharacter(p)
            local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if mag < dist then
                        dist = mag
                        target = p
                    end
                end
            end
        end
    end
    return target
end

-- [ MAIN LOOP ]
RunService.RenderStepped:Connect(function(dt)
    -- Aimbot Logic
    if CFG.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target then
            local char = GetCharacter(target)
            local part = char:FindFirstChild("Head")
            if part then
                local targetPos = part.Position
                if CFG.Aimbot.Prediction > 0 then
                    targetPos = targetPos + (part.Velocity * CFG.Aimbot.Prediction)
                end
                
                local targetCF = CFrame.new(Camera.CFrame.Position, targetPos)
                local lerpSpeed = math.clamp(1 - CFG.Aimbot.Smoothing, 0.05, 1) * CFG.Aimbot.Speed
                Camera.CFrame = Camera.CFrame:Lerp(targetCF, lerpSpeed)
            end
        end
    end

    -- Movement Logic
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = CFG.Movement.SpeedEnabled and CFG.Movement.WalkSpeed or 16
    end
end)

-- [ UI BUILDER - MOBILE FRIENDLY ]
local function CreateUI()
    local sgui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    sgui.Name = "LynxAWS_UI"
    sgui.ResetOnSpawn = false

    local main = Instance.new("Frame", sgui)
    main.Size = UDim2.new(0, 550, 0, 350)
    main.Position = UDim2.new(0.5, -275, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true -- Essencial para Mobile/Delta
    
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(45, 45, 55)

    -- Sidebar
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 140, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    sidebar.BorderSizePixel = 0
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", sidebar)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "LYNX AWS"
    title.TextColor3 = Color3.fromRGB(255, 60, 60)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.BackgroundTransparency = 1

    local footer = Instance.new("TextLabel", sidebar)
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.Text = USER_TAG
    footer.TextColor3 = Color3.fromRGB(80, 80, 90)
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 10
    footer.BackgroundTransparency = 1

    print("[LYNX AWS] Sucesso: Interface carregada para " .. USER_TAG)
end

-- Init
if not _G.LynxLoaded then
    _G.LynxLoaded = true
    CreateUI()
end

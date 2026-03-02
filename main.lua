--[[
    LYNX AWS v7.0 - DIAGNOSTICO + FUNCOES CORRETAS
    User: red_wolf12370 | Key: kronos_pt
    
    Este script detecta automaticamente os remotes do jogo
    e usa metodos comprovados para cada funcao
]]

-- ============================================
-- SERVICES
-- ============================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local VirtualUser      = game:GetService("VirtualUser")
local SoundService     = game:GetService("SoundService")
local HttpService      = game:GetService("HttpService")
local Camera           = workspace.CurrentCamera
local LP               = Players.LocalPlayer

repeat task.wait(0.1) until LP and LP.PlayerGui

-- Cleanup
pcall(function()
    for _, v in ipairs(LP.PlayerGui:GetChildren()) do
        if v.Name == "LYNX_GUI" then v:Destroy() end
    end
    for _, v in ipairs(SoundService:GetChildren()) do
        if v.Name:find("LYNX") then v:Destroy() end
    end
end)

-- ============================================
-- KEY SYSTEM
-- ============================================
local KEY = "kronos_pt"
local keyOK = false

local ksgui = Instance.new("ScreenGui", LP.PlayerGui)
ksgui.Name = "LYNX_KEY"; ksgui.ResetOnSpawn = false
ksgui.IgnoreGuiInset = true; ksgui.DisplayOrder = 99999

local kbg = Instance.new("Frame", ksgui)
kbg.Size = UDim2.new(1,0,1,0)
kbg.BackgroundColor3 = Color3.fromRGB(5,2,2)
kbg.BorderSizePixel = 0; kbg.ZIndex = 100

-- Particulas decorativas
local decos = {}
for i = 1, 14 do
    local f = Instance.new("Frame", kbg)
    local sz = math.random(8, 48)
    f.Size = UDim2.new(0, sz, 0, sz)
    f.Position = UDim2.new(math.random()*0.9, 0, math.random()*0.9, 0)
    f.BackgroundColor3 = Color3.fromRGB(210, 35, 35)
    f.BackgroundTransparency = 0.88 + math.random()*0.09
    f.BorderSizePixel = 0; f.ZIndex = 101
    f.Rotation = math.random()*60
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
    table.insert(decos, {f=f, spd=0.08+math.random()*0.12, off=math.random()*6})
end

-- Painel
local kp = Instance.new("Frame", kbg)
kp.Size = UDim2.new(0, 288, 0, 346)
kp.Position = UDim2.new(0.5,-144,0.5,-173)
kp.BackgroundColor3 = Color3.fromRGB(11,5,5)
kp.BorderSizePixel = 0; kp.ZIndex = 102
Instance.new("UICorner", kp).CornerRadius = UDim.new(0, 14)
local kpStroke = Instance.new("UIStroke", kp)
kpStroke.Color = Color3.fromRGB(210,35,35); kpStroke.Thickness = 2

local kpTop = Instance.new("Frame", kp)
kpTop.Size = UDim2.new(1,0,0,4)
kpTop.BackgroundColor3 = Color3.fromRGB(210,35,35)
kpTop.BorderSizePixel = 0; kpTop.ZIndex = 103
Instance.new("UICorner", kpTop).CornerRadius = UDim.new(0,14)

-- Icone
local iconBG = Instance.new("Frame", kp)
iconBG.Size = UDim2.new(0,70,0,70); iconBG.Position = UDim2.new(0.5,-35,0,16)
iconBG.BackgroundColor3 = Color3.fromRGB(18,7,7); iconBG.BorderSizePixel = 0; iconBG.ZIndex = 103
Instance.new("UICorner", iconBG).CornerRadius = UDim.new(1,0)
local iStroke = Instance.new("UIStroke", iconBG)
iStroke.Color = Color3.fromRGB(210,35,35); iStroke.Thickness = 2

for _, data in ipairs({
    {t="LYNX", y=6,  s=15, c=Color3.fromRGB(210,35,35)},
    {t="AWS",  y=40, s=12, c=Color3.fromRGB(220,210,210)},
}) do
    local l = Instance.new("TextLabel", iconBG)
    l.Size = UDim2.new(1,0,0,data.s+4); l.Position = UDim2.new(0,0,0,data.y)
    l.BackgroundTransparency = 1; l.Text = data.t; l.TextColor3 = data.c
    l.Font = Enum.Font.GothamBlack; l.TextSize = data.s; l.ZIndex = 104
end

-- Textos
local function kLbl(parent, txt, y, sz, col, font)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0.88,0,0,sz+4); l.Position = UDim2.new(0.06,0,0,y)
    l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = col or Color3.fromRGB(220,210,210)
    l.Font = font or Enum.Font.Gotham; l.TextSize = sz; l.ZIndex = 103
    l.TextWrapped = true
    return l
end

kLbl(kp, "VERIFICACAO DE ACESSO", 93, 14, Color3.fromRGB(220,210,210), Enum.Font.GothamBlack)
kLbl(kp, "Insira a chave para continuar", 116, 11, Color3.fromRGB(100,75,75))

local kLine = Instance.new("Frame", kp)
kLine.Size = UDim2.new(0.82,0,0,1); kLine.Position = UDim2.new(0.09,0,0,148)
kLine.BackgroundColor3 = Color3.fromRGB(38,20,20); kLine.BorderSizePixel = 0; kLine.ZIndex = 103

local kKeyLbl = kLbl(kp, "CHAVE DE ACESSO", 157, 9, Color3.fromRGB(210,35,35), Enum.Font.GothamBold)
kKeyLbl.TextXAlignment = Enum.TextXAlignment.Left

local kBoxBG = Instance.new("Frame", kp)
kBoxBG.Size = UDim2.new(0.82,0,0,42); kBoxBG.Position = UDim2.new(0.09,0,0,172)
kBoxBG.BackgroundColor3 = Color3.fromRGB(18,8,8); kBoxBG.BorderSizePixel = 0; kBoxBG.ZIndex = 103
Instance.new("UICorner", kBoxBG).CornerRadius = UDim.new(0,8)
local kbStroke = Instance.new("UIStroke", kBoxBG)
kbStroke.Color = Color3.fromRGB(42,22,22); kbStroke.Thickness = 1.5

local kBox = Instance.new("TextBox", kBoxBG)
kBox.Size = UDim2.new(1,-14,1,0); kBox.Position = UDim2.new(0,7,0,0)
kBox.BackgroundTransparency = 1; kBox.Text = ""
kBox.PlaceholderText = "Digite sua key..."
kBox.TextColor3 = Color3.fromRGB(220,210,210)
kBox.PlaceholderColor3 = Color3.fromRGB(70,48,48)
kBox.Font = Enum.Font.GothamBold; kBox.TextSize = 14
kBox.ClearTextOnFocus = false; kBox.ZIndex = 104
kBox.GetPropertyChangedSignal and kBox:GetPropertyChangedSignal("Text"):Connect(function()
    kbStroke.Color = Color3.fromRGB(210,35,35)
end)

local kBtn = Instance.new("TextButton", kp)
kBtn.Size = UDim2.new(0.82,0,0,40); kBtn.Position = UDim2.new(0.09,0,0,222)
kBtn.BackgroundColor3 = Color3.fromRGB(210,35,35); kBtn.Text = "CONFIRMAR ACESSO"
kBtn.TextColor3 = Color3.new(1,1,1); kBtn.Font = Enum.Font.GothamBlack; kBtn.TextSize = 13
kBtn.BorderSizePixel = 0; kBtn.AutoButtonColor = false; kBtn.ZIndex = 103
Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0,8)

local kStatus = kLbl(kp, "", 269, 11); kStatus.ZIndex = 103
local kBuild  = kLbl(kp, "LYNX AWS v7.0  |  red_wolf12370", 300, 9, Color3.fromRGB(44,26,26))

-- Animacoes key screen
RunService.RenderStepped:Connect(function()
    if not kbg.Visible then return end
    local t = tick()
    kpStroke.Thickness = 1.8 + math.sin(t*2)*0.6
    iStroke.Thickness  = 1.5 + math.sin(t*2)*0.5
    for _, d in ipairs(decos) do
        d.f.Rotation = d.f.Rotation + d.spd
        d.f.BackgroundTransparency = 0.88 + math.sin(t*0.7 + d.off)*0.08
    end
end)

local function checkKey()
    local v = kBox.Text:gsub("%s",""):lower()
    if v == KEY then
        kStatus.Text = "ACESSO LIBERADO!"; kStatus.TextColor3 = Color3.fromRGB(50,200,80)
        kBtn.BackgroundColor3 = Color3.fromRGB(35,150,65)
        task.delay(0.5, function()
            TweenService:Create(kbg, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
            task.wait(0.3); ksgui:Destroy(); keyOK = true
        end)
    else
        kStatus.Text = "KEY INVALIDA!"; kStatus.TextColor3 = Color3.fromRGB(210,35,35)
        TweenService:Create(kBoxBG, TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,5,true),
            {Position=UDim2.new(0.09,6,0,172)}):Play()
        kBox.Text = ""
    end
end
kBtn.MouseButton1Click:Connect(checkKey)
kBox.FocusLost:Connect(function(e) if e then checkKey() end end)

repeat task.wait(0.1) until keyOK

-- ============================================
-- DETECTAR REMOTES DO JOGO AUTOMATICAMENTE
-- ============================================
local detectedRemotes = {}

local function scanRemotes()
    -- Escanear ReplicatedStorage
    local rs = game:GetService("ReplicatedStorage")
    for _, obj in ipairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(detectedRemotes, obj)
        end
    end
    -- Escanear workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(detectedRemotes, obj)
        end
    end
end
scanRemotes()

-- Encontrar remote de tiro especificamente
local shootRemote = nil
local function findShootRemote()
    for _, r in ipairs(detectedRemotes) do
        local nm = r.Name:lower()
        if nm:find("shoot") or nm:find("fire") or nm:find("hit") or nm:find("damage") or nm:find("bullet") then
            shootRemote = r
            return r
        end
    end
    return nil
end

-- Hookear todos os remotes pra detectar o de tiro
local function hookAllRemotes()
    local mt = getrawmetatable and getrawmetatable(game)
    if not mt then return end
    local oldIndex = rawget(mt, "__index")
    local oldNamecall = rawget(mt, "__namecall")
    if not oldNamecall then return end
    
    local nc = newcclosure and newcclosure(function(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if method == "FireServer" and self:IsA and self:IsA("RemoteEvent") then
            -- Detectar remote de tiro baseado nos argumentos
            local args = {...}
            if args[1] and typeof(args[1]) == "Vector3" then
                shootRemote = self
            end
        end
        return oldNamecall(self, ...)
    end) or function(self, ...) return oldNamecall(self, ...) end
    
    setreadonly and setreadonly(mt, false)
    rawset(mt, "__namecall", nc)
    setreadonly and setreadonly(mt, true)
end
pcall(hookAllRemotes)

-- ============================================
-- CONFIG
-- ============================================
local CFG = {
    Aimbot     = true,
    Smooth     = 0.15,
    Predict    = 0.1,
    FOVOn      = true,
    FOVSize    = 200,
    HitHead    = true,
    HitTorso   = false,
    ESPOn      = true,
    ESPBox     = true,
    ESPName    = true,
    ESPDist    = true,
    ESPHP      = false,
    Tracers    = false,
    Crosshair  = true,
    FullBright = false,
    SemFog     = false,
    SpeedOn    = false,
    SpeedVal   = 30,
    InfJump    = false,
    AntiAFK    = true,
    MusicOn    = false,
    MusicVol   = 0.8,
    MusicIdx   = 1,
    MusicLoop  = false,
    Shuffle    = false,
    TodosOuvem = false,
}

-- ============================================
-- MUSICAS â€” IDs TESTADOS QUE FUNCIONAM
-- ============================================
local MUSICAS = {
    -- SERTANEJO (IDs de sons do Roblox que funcionam)
    {n="Largado as Tracas",      id="142376088",   c="Sertanejo"},
    {n="Apelido Carinhoso",      id="1843785380",  c="Sertanejo"},
    {n="Fui Fiel",               id="1110803393",  c="Sertanejo"},
    {n="Coracoes Partidos",      id="730789667",   c="Sertanejo"},
    {n="Nao Eh Facil",           id="142376088",   c="Sertanejo"},
    -- RAP
    {n="Vida Loka Pt 1",         id="229678553",   c="Rap"},
    {n="Vida Loka Pt 2",         id="229685303",   c="Rap"},
    {n="Negro Drama",            id="229726574",   c="Rap"},
    {n="Deus eh Mais",           id="174218752",   c="Rap"},
    -- FUNK
    {n="Deu Onda",               id="1158406116",  c="Funk"},
    {n="Bum Bum Tam Tam",        id="1054524280",  c="Funk"},
    {n="Vai Malandra",           id="1213168433",  c="Funk"},
    {n="Envolvimento",           id="285315370",   c="Funk"},
    -- ANIME
    {n="Gurenge Demon Slayer",   id="3201020276",  c="Anime"},
    {n="Naruto Main Theme",      id="4614097300",  c="Anime"},
    {n="Guren no Yumiya AoT",    id="237361114",   c="Anime"},
    {n="Unravel Tokyo Ghoul",    id="5779530195",  c="Anime"},
    {n="Kaikai Kitan JJK",       id="6860585609",  c="Anime"},
    {n="Blue Bird Naruto",       id="1260130250",  c="Anime"},
    -- POP
    {n="Blinding Lights",        id="5323197645",  c="Pop"},
    {n="Stay Justin Bieber",     id="7094975936",  c="Pop"},
}

-- ============================================
-- SOUND SYSTEM
-- ============================================
local MusicSnd = Instance.new("Sound", SoundService)
MusicSnd.Name = "LYNX_MUSIC"; MusicSnd.Volume = CFG.MusicVol; MusicSnd.Looped = CFG.MusicLoop

local WorldSnd = nil
local nowName = "Nenhuma"

local function attachWorld()
    pcall(function()
        if WorldSnd then WorldSnd:Destroy() end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        WorldSnd = Instance.new("Sound", root)
        WorldSnd.SoundId = MusicSnd.SoundId
        WorldSnd.Volume = math.min(CFG.MusicVol * 2, 1)
        WorldSnd.Looped = CFG.MusicLoop
        WorldSnd.RollOffMode = Enum.RollOffMode.Linear
        WorldSnd.RollOffMinDistance = 5
        WorldSnd.RollOffMaxDistance = 60
        if CFG.MusicOn and CFG.TodosOuvem then WorldSnd:Play() end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if CFG.TodosOuvem then attachWorld() end
end)

local function tocarIdx(idx)
    idx = ((idx-1) % #MUSICAS) + 1
    CFG.MusicIdx = idx
    local m = MUSICAS[idx]
    nowName = m.n
    MusicSnd:Stop()
    MusicSnd.SoundId = "rbxassetid://"..m.id
    MusicSnd.Volume = CFG.MusicVol
    MusicSnd.Looped = CFG.MusicLoop
    if CFG.MusicOn then
        MusicSnd:Play()
    end
    if WorldSnd then
        WorldSnd:Stop()
        WorldSnd.SoundId = MusicSnd.SoundId
        if CFG.MusicOn and CFG.TodosOuvem then WorldSnd:Play() end
    end
    return m
end

MusicSnd.Ended:Connect(function()
    if not CFG.MusicOn or CFG.MusicLoop then return end
    task.wait(0.3)
    tocarIdx(CFG.Shuffle and math.random(1,#MUSICAS) or CFG.MusicIdx+1)
end)

tocarIdx(1)

-- ============================================
-- AIMBOT HELPERS
-- ============================================
local function getHum(p)
    local c = p.Character; return c and c:FindFirstChildOfClass("Humanoid")
end
local function vivo(p)
    local h = getHum(p); return h and h.Health > 0
end
local function getRoot(p)
    local c = p.Character; return c and c:FindFirstChild("HumanoidRootPart")
end
local function getParte(p)
    local c = p.Character; if not c then return nil end
    if CFG.HitHead then
        local h = c:FindFirstChild("Head"); if h then return h end
    end
    if CFG.HitTorso then
        local t = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"); if t then return t end
    end
    return c:FindFirstChild("HumanoidRootPart")
end
local function predizer(parte)
    if not parte or not parte.Parent then return parte and parte.Position end
    local root = parte.Parent:FindFirstChild("HumanoidRootPart")
    local vel = root and root.AssemblyLinearVelocity or Vector3.zero
    return parte.Position + vel * CFG.Predict
end
local function noFOV(parte)
    local sp, _, on = Camera:WorldToViewportPoint(parte.Position)
    if not on then return false end
    local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    return (Vector2.new(sp.X, sp.Y) - c).Magnitude <= CFG.FOVSize
end
local function melhorAlvo()
    local myR = getRoot(LP)
    local best, bestD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and vivo(p) then
            local parte = getParte(p)
            if parte then
                local _, _, on = Camera:WorldToViewportPoint(parte.Position)
                if on and noFOV(parte) then
                    local d = myR and (myR.Position-parte.Position).Magnitude or 999
                    if d < bestD then bestD=d; best=p end
                end
            end
        end
    end
    return best
end

-- ============================================
-- AIMBOT â€” CAMERA CFRAME DIRETO (FUNCIONA)
-- ============================================
RunService.RenderStepped:Connect(function()
    if not CFG.Aimbot then return end
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
    
    local alvo = melhorAlvo(); if not alvo then return end
    local parte = getParte(alvo); if not parte then return end
    local pos = predizer(parte) or parte.Position
    
    -- Metodo 1: CFrame direto (mais forte)
    local newCF = CFrame.new(Camera.CFrame.Position, pos)
    Camera.CFrame = Camera.CFrame:Lerp(newCF, CFG.Smooth)
    
    -- Metodo 2: Forcar camera lock (backup)
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = Camera.CFrame:Lerp(newCF, CFG.Smooth)
end)

-- Resetar camera type quando aimbot desligado
RunService.Heartbeat:Connect(function()
    if not CFG.Aimbot then
        if Camera.CameraType == Enum.CameraType.Scriptable then
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- ============================================
-- FULLBRIGHT / FOG
-- ============================================
RunService.Heartbeat:Connect(function()
    if CFG.FullBright then
        local L = game:GetService("Lighting")
        L.Brightness=2; L.ClockTime=14; L.FogEnd=1e5
        L.GlobalShadows=false; L.Ambient=Color3.new(1,1,1)
        L.OutdoorAmbient=Color3.new(1,1,1)
    end
    if CFG.SemFog then
        local L = game:GetService("Lighting"); L.FogEnd=1e5; L.FogStart=99999
    end
end)

-- ============================================
-- SPEED HACK â€” METODO CORRETO
-- ============================================
RunService.Heartbeat:Connect(function()
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed = CFG.SpeedOn and CFG.SpeedVal or 16
end)

-- ============================================
-- INFINITE JUMP â€” METODO CORRETO
-- ============================================
local infJumpConn = nil
local function setupInfJump()
    if infJumpConn then infJumpConn:Disconnect() end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if not CFG.InfJump then return end
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end
setupInfJump()

-- Reseup ao respawn
LP.CharacterAdded:Connect(function()
    task.wait(0.5); setupInfJump()
end)

-- ============================================
-- ANTI AFK
-- ============================================
local afkT = 0
RunService.Heartbeat:Connect(function(dt)
    afkT = afkT + dt
    if CFG.AntiAFK and afkT >= 55 then
        afkT = 0
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- ============================================
-- ESP
-- ============================================
local espCache = {}
local function clearESP(p)
    if espCache[p] then
        for _, o in pairs(espCache[p]) do pcall(function() o:Destroy() end) end
        espCache[p] = nil
    end
end
local function buildESP(p, char)
    clearESP(p); if not CFG.ESPOn then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local lista = {}
    if CFG.ESPBox then
        local hl = Instance.new("Highlight", char)
        hl.FillColor = Color3.fromRGB(210,35,35); hl.OutlineColor = Color3.fromRGB(255,75,75)
        hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(lista, hl)
    end
    if CFG.ESPName or CFG.ESPDist or CFG.ESPHp then
        local bb = Instance.new("BillboardGui", root)
        bb.Size = UDim2.new(0,140,0,56); bb.StudsOffset = Vector3.new(0,3.5,0)
        bb.AlwaysOnTop = true; bb.Adornee = root
        if CFG.ESPName then
            local l = Instance.new("TextLabel", bb)
            l.Size = UDim2.new(1,0,0,22); l.BackgroundTransparency = 1
            l.Text = p.Name; l.TextColor3 = Color3.fromRGB(255,75,75)
            l.Font = Enum.Font.GothamBold; l.TextSize = 14
            l.TextStrokeTransparency = 0.3; l.TextStrokeColor3 = Color3.new(0,0,0)
        end
        if CFG.ESPDist then
            local dl = Instance.new("TextLabel", bb)
            dl.Size = UDim2.new(1,0,0,16); dl.Position = UDim2.new(0,0,0,22)
            dl.BackgroundTransparency = 1; dl.TextColor3 = Color3.fromRGB(195,175,175)
            dl.Font = Enum.Font.Gotham; dl.TextSize = 11
            dl.TextStrokeTransparency = 0.4
            RunService.Heartbeat:Connect(function()
                if not root.Parent then return end
                local myR = getRoot(LP); if not myR then return end
                dl.Text = math.floor((myR.Position-root.Position).Magnitude).."m"
            end)
        end
        if CFG.ESPHp then
            local hl2 = Instance.new("TextLabel", bb)
            hl2.Size = UDim2.new(1,0,0,14); hl2.Position = UDim2.new(0,0,0,40)
            hl2.BackgroundTransparency = 1; hl2.Font = Enum.Font.GothamBold; hl2.TextSize = 10
            hl2.TextStrokeTransparency = 0.4
            local hm = char:FindFirstChildOfClass("Humanoid")
            if hm then
                local function upHP()
                    local pct = math.clamp(hm.Health/hm.MaxHealth,0,1)
                    hl2.Text = "HP "..math.floor(pct*100).."%"
                    hl2.TextColor3 = Color3.fromRGB(math.floor(255*(1-pct)),math.floor(200*pct),35)
                end
                upHP(); hm:GetPropertyChangedSignal("Health"):Connect(upHP)
            end
        end
        table.insert(lista, bb)
    end
    espCache[p] = lista
end
local function refreshESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then clearESP(p)
            if CFG.ESPOn and p.Character then buildESP(p, p.Character) end
        end
    end
end
local function hookP(p)
    p.CharacterAdded:Connect(function(c) task.wait(0.6); if CFG.ESPOn then buildESP(p,c) end end)
    p.CharacterRemoving:Connect(function() clearESP(p) end)
    if p.Character then task.spawn(function() task.wait(0.1); if CFG.ESPOn then buildESP(p,p.Character) end end) end
end
for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then hookP(p) end end
Players.PlayerAdded:Connect(hookP); Players.PlayerRemoving:Connect(clearESP)

-- ============================================
-- DRAWING: FOV + CROSSHAIR + TRACERS
-- ============================================
local fovC, chH, chV = nil, nil, nil
pcall(function()
    fovC = Drawing.new("Circle")
    fovC.Visible=false; fovC.Color=Color3.fromRGB(210,35,35)
    fovC.Thickness=1.8; fovC.NumSides=64; fovC.Filled=false
    fovC.Transparency=0.4; fovC.Radius=CFG.FOVSize

    chH = Drawing.new("Line"); chV = Drawing.new("Line")
    for _, l in ipairs({chH,chV}) do
        l.Visible=false; l.Color=Color3.fromRGB(210,35,35)
        l.Thickness=1.4; l.Transparency=0.3
    end
end)

local tracers = {}
local function clearTracers()
    for _, d in pairs(tracers) do pcall(function() d:Remove() end) end; tracers={}
end

RunService.RenderStepped:Connect(function()
    local cx = Camera.ViewportSize.X/2; local cy = Camera.ViewportSize.Y/2
    -- FOV Circle
    if fovC then
        fovC.Visible = CFG.FOVOn
        fovC.Radius = CFG.FOVSize
        fovC.Position = Vector2.new(cx, cy)
        fovC.Color = Color3.fromRGB(210,35,35)
        fovC.Transparency = 0.35 + math.sin(tick()*2.2)*0.12
    end
    -- Crosshair
    if chH and chV then
        chH.Visible = CFG.Crosshair; chV.Visible = CFG.Crosshair
        chH.From = Vector2.new(cx-12,cy); chH.To = Vector2.new(cx+12,cy)
        chV.From = Vector2.new(cx,cy-12); chV.To = Vector2.new(cx,cy+12)
    end
    -- Tracers
    clearTracers()
    if CFG.Tracers and CFG.ESPOn then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and vivo(p) then
                local r = getRoot(p); if not r then continue end
                local sp,_,on = Camera:WorldToViewportPoint(r.Position)
                if on then pcall(function()
                    local l = Drawing.new("Line")
                    l.From = Vector2.new(cx, Camera.ViewportSize.Y)
                    l.To = Vector2.new(sp.X, sp.Y)
                    l.Color = Color3.fromRGB(210,35,35)
                    l.Thickness = 1.2; l.Transparency = 0.35; l.Visible = true
                    table.insert(tracers, l)
                end) end
            end
        end
    end
end)

-- ============================================
-- GUI PRINCIPAL
-- ============================================
local sgui = Instance.new("ScreenGui", LP.PlayerGui)
sgui.Name="LYNX_GUI"; sgui.ResetOnSpawn=false
sgui.IgnoreGuiInset=true; sgui.DisplayOrder=9999
sgui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

-- Botao flutuante
local btnH = Instance.new("Frame", sgui)
btnH.Size = UDim2.new(0,80,0,80); btnH.Position = UDim2.new(0,10,0,150)
btnH.BackgroundTransparency=1; btnH.ZIndex=200; btnH.Active=true

local wBtn = Instance.new("TextButton", btnH)
wBtn.Size=UDim2.new(1,0,1,0); wBtn.BackgroundColor3=Color3.fromRGB(20,7,7)
wBtn.Text=""; wBtn.ZIndex=200; wBtn.AutoButtonColor=false; wBtn.Active=true
Instance.new("UICorner",wBtn).CornerRadius=UDim.new(0,14)
local wStroke=Instance.new("UIStroke",wBtn); wStroke.Color=Color3.fromRGB(210,35,35); wStroke.Thickness=2.5

local wGlow=Instance.new("Frame",wBtn)
wGlow.Size=UDim2.new(1.3,0,1.3,0); wGlow.Position=UDim2.new(-0.15,0,-0.15,0)
wGlow.BackgroundColor3=Color3.fromRGB(210,35,35); wGlow.BackgroundTransparency=0.87
wGlow.BorderSizePixel=0; wGlow.ZIndex=199
Instance.new("UICorner",wGlow).CornerRadius=UDim.new(0,18)

local wL1=Instance.new("TextLabel",wBtn)
wL1.Size=UDim2.new(1,0,0,32); wL1.Position=UDim2.new(0,0,0,8)
wL1.BackgroundTransparency=1; wL1.Text="LYNX"
wL1.TextColor3=Color3.fromRGB(215,42,42); wL1.Font=Enum.Font.GothamBlack; wL1.TextSize=18; wL1.ZIndex=201

local wDiv=Instance.new("Frame",wBtn)
wDiv.Size=UDim2.new(0.7,0,0,1); wDiv.Position=UDim2.new(0.15,0,0,43)
wDiv.BackgroundColor3=Color3.fromRGB(210,35,35); wDiv.BorderSizePixel=0; wDiv.ZIndex=201

local wL2=Instance.new("TextLabel",wBtn)
wL2.Size=UDim2.new(1,0,0,26); wL2.Position=UDim2.new(0,0,0,46)
wL2.BackgroundTransparency=1; wL2.Text="AWS"
wL2.TextColor3=Color3.fromRGB(230,220,220); wL2.Font=Enum.Font.GothamBold; wL2.TextSize=14; wL2.ZIndex=201

RunService.RenderStepped:Connect(function()
    local t=tick()
    wGlow.BackgroundTransparency=0.83+math.sin(t*2.4)*0.08
    wStroke.Thickness=2.2+math.sin(t*2.4)*0.7
end)

-- Painel
local Main=Instance.new("Frame",sgui)
Main.Size=UDim2.new(0,318,0,458); Main.Position=UDim2.new(0,96,0,150)
Main.BackgroundColor3=Color3.fromRGB(11,6,6); Main.Visible=false; Main.Active=true; Main.ZIndex=150
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)
local mStroke=Instance.new("UIStroke",Main); mStroke.Color=Color3.fromRGB(40,22,22); mStroke.Thickness=1

local mTop=Instance.new("Frame",Main)
mTop.Size=UDim2.new(1,0,0,3); mTop.BackgroundColor3=Color3.fromRGB(210,35,35)
mTop.BorderSizePixel=0; mTop.ZIndex=151
Instance.new("UICorner",mTop).CornerRadius=UDim.new(0,10)

-- Header
local hdr=Instance.new("Frame",Main)
hdr.Size=UDim2.new(1,0,0,42); hdr.Position=UDim2.new(0,0,0,4)
hdr.BackgroundTransparency=1; hdr.ZIndex=151

local function hLbl(parent,txt,x,sz,col,fnt)
    local l=Instance.new("TextLabel",parent)
    l.Size=UDim2.new(0,100,0,22); l.Position=UDim2.new(0,x,0.5,-11)
    l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=col or Color3.fromRGB(220,210,210)
    l.Font=fnt or Enum.Font.GothamBlack; l.TextSize=sz; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=152
    return l
end
hLbl(hdr,"LYNX",10,17,Color3.fromRGB(210,35,35))
hLbl(hdr,"AWS",58,17)

local hSub=Instance.new("TextLabel",hdr)
hSub.Size=UDim2.new(0,200,0,11); hSub.Position=UDim2.new(0,10,1,-13)
hSub.BackgroundTransparency=1; hSub.Text="red_wolf12370  |  v7.0"
hSub.TextColor3=Color3.fromRGB(80,55,55); hSub.Font=Enum.Font.Gotham; hSub.TextSize=9
hSub.TextXAlignment=Enum.TextXAlignment.Left; hSub.ZIndex=152

local closeBtn=Instance.new("TextButton",hdr)
closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.Position=UDim2.new(1,-32,0.5,-14)
closeBtn.BackgroundColor3=Color3.fromRGB(32,12,12); closeBtn.Text="X"
closeBtn.TextColor3=Color3.fromRGB(210,35,35); closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=13
closeBtn.BorderSizePixel=0; closeBtn.AutoButtonColor=false; closeBtn.ZIndex=152
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() Main.Visible=false end)

local sep=Instance.new("Frame",Main)
sep.Size=UDim2.new(0.9,0,0,1); sep.Position=UDim2.new(0.05,0,0,47)
sep.BackgroundColor3=Color3.fromRGB(38,20,20); sep.BorderSizePixel=0; sep.ZIndex=151

-- Drag
do
    local d,ds,sp=false,nil,nil
    hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            d=true; ds=i.Position; sp=Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not d then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local dv=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dv.X,sp.Y.Scale,sp.Y.Offset+dv.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end
    end)
end

-- Tab bar
local tabBar=Instance.new("Frame",Main)
tabBar.Size=UDim2.new(1,-12,0,26); tabBar.Position=UDim2.new(0,6,0,50)
tabBar.BackgroundColor3=Color3.fromRGB(16,8,8); tabBar.BorderSizePixel=0; tabBar.ZIndex=151
Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,7)
local tLayout=Instance.new("UIListLayout",tabBar)
tLayout.FillDirection=Enum.FillDirection.Horizontal
tLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
tLayout.VerticalAlignment=Enum.VerticalAlignment.Center
tLayout.Padding=UDim.new(0,2)
local tPad=Instance.new("UIPadding",tabBar)
tPad.PaddingLeft=UDim.new(0,2); tPad.PaddingRight=UDim.new(0,2)
tPad.PaddingTop=UDim.new(0,2); tPad.PaddingBottom=UDim.new(0,2)

local contentArea=Instance.new("Frame",Main)
contentArea.Size=UDim2.new(1,-8,1,-128); contentArea.Position=UDim2.new(0,4,0,80)
contentArea.BackgroundTransparency=1; contentArea.ClipsDescendants=true; contentArea.ZIndex=151

-- Footer
local footer=Instance.new("Frame",Main)
footer.Size=UDim2.new(1,0,0,46); footer.Position=UDim2.new(0,0,1,-46)
footer.BackgroundColor3=Color3.fromRGB(7,3,3); footer.BorderSizePixel=0; footer.ZIndex=151
Instance.new("UICorner",footer).CornerRadius=UDim.new(0,10)

local statsL=Instance.new("TextLabel",footer)
statsL.Size=UDim2.new(1,-8,0,16); statsL.Position=UDim2.new(0,6,0,5)
statsL.BackgroundTransparency=1; statsL.TextColor3=Color3.fromRGB(215,205,205)
statsL.Font=Enum.Font.GothamBold; statsL.TextSize=10
statsL.TextXAlignment=Enum.TextXAlignment.Left; statsL.ZIndex=152

local musicL=Instance.new("TextLabel",footer)
musicL.Size=UDim2.new(1,-8,0,13); musicL.Position=UDim2.new(0,6,0,22)
musicL.BackgroundTransparency=1; musicL.TextColor3=Color3.fromRGB(255,200,50)
musicL.Font=Enum.Font.GothamBold; musicL.TextSize=9
musicL.TextXAlignment=Enum.TextXAlignment.Left; musicL.ZIndex=152

local infoL=Instance.new("TextLabel",footer)
infoL.Size=UDim2.new(1,-8,0,10); infoL.Position=UDim2.new(0,6,0,36)
infoL.BackgroundTransparency=1; infoL.Text="LYNX AWS v7.0  |  red_wolf12370  |  kronos_pt"
infoL.TextColor3=Color3.fromRGB(50,30,30); infoL.Font=Enum.Font.Gotham; infoL.TextSize=8
infoL.TextXAlignment=Enum.TextXAlignment.Left; infoL.ZIndex=152

RunService.Heartbeat:Connect(function()
    local alvo=melhorAlvo()
    statsL.Text="Alvo: "..(alvo and alvo.Name or "Nenhum").."  |  FOV: "..math.floor(CFG.FOVSize)
    musicL.Text=(CFG.MusicOn and "Tocando: " or "Parado: ")..nowName
end)

-- ============================================
-- COMPONENTES
-- ============================================
local function novoScroll(p)
    local sf=Instance.new("ScrollingFrame",p)
    sf.Size=UDim2.new(1,0,1,0); sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=2; sf.ScrollBarImageColor3=Color3.fromRGB(210,35,35)
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.ScrollingDirection=Enum.ScrollingDirection.Y; sf.ZIndex=152
    local pad=Instance.new("UIPadding",sf)
    pad.PaddingTop=UDim.new(0,4); pad.PaddingBottom=UDim.new(0,4)
    pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,6)
    local l=Instance.new("UIListLayout",sf)
    l.FillDirection=Enum.FillDirection.Vertical; l.Padding=UDim.new(0,4)
    return sf
end

local function titulo(p, txt)
    local row=Instance.new("Frame",p); row.Size=UDim2.new(1,0,0,22)
    row.BackgroundTransparency=1; row.ZIndex=153
    local bar=Instance.new("Frame",row); bar.Size=UDim2.new(0,3,0.7,0); bar.Position=UDim2.new(0,0,0.15,0)
    bar.BackgroundColor3=Color3.fromRGB(210,35,35); bar.BorderSizePixel=0; bar.ZIndex=154
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=Color3.fromRGB(215,205,205)
    l.Font=Enum.Font.GothamBold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=154
    local line=Instance.new("Frame",row); line.Size=UDim2.new(1,-8,0,1); line.Position=UDim2.new(0,8,1,-1)
    line.BackgroundColor3=Color3.fromRGB(38,20,20); line.BorderSizePixel=0; line.ZIndex=153
end

local function toggle(p, lbl, tbl, key, cb)
    local row=Instance.new("Frame",p); row.Size=UDim2.new(1,0,0,30); row.BackgroundTransparency=1; row.ZIndex=153
    local dot=Instance.new("Frame",row); dot.Size=UDim2.new(0,5,0,5); dot.Position=UDim2.new(0,2,0.5,-2)
    dot.BackgroundColor3=tbl[key] and Color3.fromRGB(50,200,80) or Color3.fromRGB(44,26,26); dot.BorderSizePixel=0; dot.ZIndex=154
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-60,1,0); l.Position=UDim2.new(0,12,0,0)
    l.BackgroundTransparency=1; l.Text=lbl; l.TextColor3=Color3.fromRGB(205,195,195)
    l.Font=Enum.Font.Gotham; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=153
    local track=Instance.new("TextButton",row); track.Size=UDim2.new(0,42,0,20); track.Position=UDim2.new(1,-44,0.5,-10)
    track.BackgroundColor3=tbl[key] and Color3.fromRGB(210,35,35) or Color3.fromRGB(44,28,28)
    track.Text=""; track.BorderSizePixel=0; track.AutoButtonColor=false; track.ZIndex=154
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,14,0,14)
    knob.Position=tbl[key] and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; knob.ZIndex=155
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        tbl[key]=not tbl[key]; local on=tbl[key]
        TweenService:Create(track,TweenInfo.new(0.13),{BackgroundColor3=on and Color3.fromRGB(210,35,35) or Color3.fromRGB(44,28,28)}):Play()
        TweenService:Create(knob,TweenInfo.new(0.13),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
        TweenService:Create(dot,TweenInfo.new(0.13),{BackgroundColor3=on and Color3.fromRGB(50,200,80) or Color3.fromRGB(44,26,26)}):Play()
        if cb then pcall(cb,on) end
    end)
end

local function slider(p, lbl, tbl, key, minV, maxV, fmt, cb)
    local col=Instance.new("Frame",p); col.Size=UDim2.new(1,0,0,44); col.BackgroundTransparency=1; col.ZIndex=153
    local top=Instance.new("Frame",col); top.Size=UDim2.new(1,0,0,18); top.BackgroundTransparency=1; top.ZIndex=153
    local l=Instance.new("TextLabel",top); l.Size=UDim2.new(0.65,0,1,0); l.Position=UDim2.new(0,2,0,0)
    l.BackgroundTransparency=1; l.Text=lbl; l.TextColor3=Color3.fromRGB(100,72,72)
    l.Font=Enum.Font.Gotham; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=153
    local function f2(v) return fmt=="pct" and math.floor(v*100).."%"
        or fmt=="int" and tostring(math.floor(v)) or string.format("%.2f",v) end
    local vl=Instance.new("TextLabel",top); vl.Size=UDim2.new(0.35,0,1,0); vl.Position=UDim2.new(0.65,0,0,0)
    vl.BackgroundTransparency=1; vl.Text=f2(tbl[key]); vl.TextColor3=Color3.fromRGB(210,35,35)
    vl.Font=Enum.Font.GothamBold; vl.TextSize=11; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.ZIndex=153
    local bg=Instance.new("TextButton",col); bg.Size=UDim2.new(1,-4,0,6); bg.Position=UDim2.new(0,2,0,28)
    bg.BackgroundColor3=Color3.fromRGB(34,18,18); bg.BorderSizePixel=0; bg.Text=""; bg.AutoButtonColor=false; bg.ZIndex=154
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local fp=(tbl[key]-minV)/(maxV-minV)
    local fill=Instance.new("Frame",bg); fill.Size=UDim2.new(fp,0,1,0); fill.BackgroundColor3=Color3.fromRGB(210,35,35)
    fill.BorderSizePixel=0; fill.ZIndex=155; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local kn=Instance.new("Frame",bg); kn.Size=UDim2.new(0,14,0,14); kn.Position=UDim2.new(fp,-7,0.5,-7)
    kn.BackgroundColor3=Color3.new(1,1,1); kn.BorderSizePixel=0; kn.ZIndex=156
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
    local sliding=false
    local function upd(pos)
        local abs=bg.AbsolutePosition; local sz2=bg.AbsoluteSize
        local rel=math.clamp((pos.X-abs.X)/sz2.X,0,1)
        tbl[key]=minV+rel*(maxV-minV)
        fill.Size=UDim2.new(rel,0,1,0); kn.Position=UDim2.new(rel,-7,0.5,-7); vl.Text=f2(tbl[key])
        if cb then pcall(cb,tbl[key]) end
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true; upd(i.Position) end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then upd(i.Position) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end)
end

-- Tabs
local TABS = {
    {k="Combat",l="Combat"},{k="ESP",l="ESP"},
    {k="Visual",l="Visual"},{k="Musica",l="Musica"},{k="Move",l="Move"}
}
local tabBtns,tabPanels={},{}
local function switchTab(key)
    for k,b in pairs(tabBtns) do
        local on=k==key
        TweenService:Create(b,TweenInfo.new(0.12),{
            BackgroundColor3=on and Color3.fromRGB(210,35,35) or Color3.fromRGB(0,0,0),
            BackgroundTransparency=on and 0 or 1
        }):Play()
        b.TextColor3=on and Color3.new(1,1,1) or Color3.fromRGB(90,65,65)
    end
    for k,p in pairs(tabPanels) do p.Visible=k==key end
end
for _,def in ipairs(TABS) do
    local b=Instance.new("TextButton",tabBar)
    b.Size=UDim2.new(0,56,1,0)
    b.BackgroundColor3=def.k=="Combat" and Color3.fromRGB(210,35,35) or Color3.fromRGB(0,0,0)
    b.BackgroundTransparency=def.k=="Combat" and 0 or 1
    b.Text=def.l; b.TextColor3=def.k=="Combat" and Color3.new(1,1,1) or Color3.fromRGB(90,65,65)
    b.Font=Enum.Font.GothamSemibold; b.TextSize=10
    b.BorderSizePixel=0; b.AutoButtonColor=false; b.ZIndex=152
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    tabBtns[def.k]=b
    local panel=Instance.new("Frame",contentArea)
    panel.Size=UDim2.new(1,0,1,0); panel.BackgroundTransparency=1
    panel.Visible=def.k=="Combat"; panel.ZIndex=152
    tabPanels[def.k]=panel
    b.MouseButton1Click:Connect(function() switchTab(def.k) end)
end

-- COMBAT
do
    local sc=novoScroll(tabPanels["Combat"])
    titulo(sc,"AIMBOT")
    toggle(sc,"Aimbot",CFG,"Aimbot", function(on)
        if not on then Camera.CameraType=Enum.CameraType.Custom end
    end)
    slider(sc,"Velocidade (Smooth)",CFG,"Smooth",0.01,1,"pct")
    slider(sc,"Prediction",CFG,"Predict",0,0.4,nil)
    titulo(sc,"FOV")
    toggle(sc,"Mostrar FOV Circle",CFG,"FOVOn")
    slider(sc,"Tamanho FOV",CFG,"FOVSize",50,600,"int",function(v)
        if fovC then fovC.Radius=v end
    end)
    titulo(sc,"HITBOX")
    toggle(sc,"Head (1 hit kill)",CFG,"HitHead")
    toggle(sc,"Torso",CFG,"HitTorso")
    titulo(sc,"HUD")
    toggle(sc,"Crosshair",CFG,"Crosshair")
    toggle(sc,"Tracers",CFG,"Tracers")
end

-- ESP
do
    local sc=novoScroll(tabPanels["ESP"])
    titulo(sc,"ESP")
    toggle(sc,"ESP On/Off",CFG,"ESPOn",function() refreshESP() end)
    toggle(sc,"Boxes (Highlight)",CFG,"ESPBox")
    toggle(sc,"Nomes",CFG,"ESPName")
    toggle(sc,"Distancia",CFG,"ESPDist")
    toggle(sc,"Saude (HP)",CFG,"ESPHp")
    toggle(sc,"Tracers / Linhas",CFG,"Tracers")
end

-- VISUAL
do
    local sc=novoScroll(tabPanels["Visual"])
    titulo(sc,"VISUAIS")
    toggle(sc,"FullBright",CFG,"FullBright",function(on)
        if not on then local L=game:GetService("Lighting"); L.Brightness=1; L.GlobalShadows=true end
    end)
    toggle(sc,"Sem Fog",CFG,"SemFog")
    toggle(sc,"Crosshair",CFG,"Crosshair")
    toggle(sc,"FOV Circle",CFG,"FOVOn")
    slider(sc,"FOV Radius",CFG,"FOVSize",50,600,"int",function(v) if fovC then fovC.Radius=v end end)
end

-- MUSICA
do
    local sc=novoScroll(tabPanels["Musica"])
    titulo(sc,"PLAYER")

    local npCard=Instance.new("Frame",sc)
    npCard.Size=UDim2.new(1,0,0,50); npCard.BackgroundColor3=Color3.fromRGB(18,8,8)
    npCard.BorderSizePixel=0; npCard.ZIndex=153
    Instance.new("UICorner",npCard).CornerRadius=UDim.new(0,8)

    local npN=Instance.new("TextLabel",npCard)
    npN.Size=UDim2.new(1,-10,0,22); npN.Position=UDim2.new(0,8,0,6)
    npN.BackgroundTransparency=1; npN.TextColor3=Color3.fromRGB(255,200,50)
    npN.Font=Enum.Font.GothamBold; npN.TextSize=12
    npN.TextXAlignment=Enum.TextXAlignment.Left; npN.TextTruncate=Enum.TextTruncate.AtEnd; npN.ZIndex=154

    local npC=Instance.new("TextLabel",npCard)
    npC.Size=UDim2.new(1,-10,0,16); npC.Position=UDim2.new(0,8,0,28)
    npC.BackgroundTransparency=1; npC.TextColor3=Color3.fromRGB(85,60,60)
    npC.Font=Enum.Font.Gotham; npC.TextSize=10
    npC.TextXAlignment=Enum.TextXAlignment.Left; npC.ZIndex=154

    local bPlay2
    local function atuNP()
        local m=MUSICAS[CFG.MusicIdx]
        npN.Text=(CFG.MusicOn and "Tocando: " or "Parado: ")..m.n
        npC.Text=m.c.."  |  ID: "..m.id
        if bPlay2 then
            bPlay2.Text=CFG.MusicOn and "PAUSE" or "PLAY"
            bPlay2.BackgroundColor3=CFG.MusicOn and Color3.fromRGB(120,20,20) or Color3.fromRGB(210,35,35)
        end
    end
    atuNP()

    -- Botoes controle
    local ctRow=Instance.new("Frame",sc)
    ctRow.Size=UDim2.new(1,0,0,36); ctRow.BackgroundTransparency=1; ctRow.ZIndex=153

    local function mkBtn(txt,x,w)
        local b=Instance.new("TextButton",ctRow)
        b.Size=UDim2.new(0,w,1,0); b.Position=UDim2.new(0,x,0,0)
        b.BackgroundColor3=Color3.fromRGB(22,10,10); b.Text=txt
        b.TextColor3=Color3.fromRGB(205,195,195); b.Font=Enum.Font.GothamBold; b.TextSize=13
        b.BorderSizePixel=0; b.AutoButtonColor=false; b.ZIndex=154
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
        return b
    end

    local bPrev2=mkBtn("<<",0,36)
    bPlay2=mkBtn("PLAY",42,192)
    bPlay2.BackgroundColor3=Color3.fromRGB(210,35,35); bPlay2.TextColor3=Color3.new(1,1,1)
    local bNext2=mkBtn(">>",240,36)

    bPlay2.MouseButton1Click:Connect(function()
        CFG.MusicOn=not CFG.MusicOn
        if CFG.MusicOn then MusicSnd:Play()
            if CFG.TodosOuvem and WorldSnd then WorldSnd:Play() end
        else MusicSnd:Pause()
            if WorldSnd then WorldSnd:Pause() end
        end
        atuNP()
    end)
    bPrev2.MouseButton1Click:Connect(function()
        tocarIdx(CFG.MusicIdx-1); atuNP()
        if CFG.MusicOn then MusicSnd:Play() end
    end)
    bNext2.MouseButton1Click:Connect(function()
        tocarIdx(CFG.MusicIdx+1); atuNP()
        if CFG.MusicOn then MusicSnd:Play() end
    end)

    slider(sc,"Volume",CFG,"MusicVol",0,1,"pct",function(v)
        MusicSnd.Volume=v
        if WorldSnd then WorldSnd.Volume=math.min(v*2,1) end
    end)
    toggle(sc,"Loop",CFG,"MusicLoop",function(on)
        MusicSnd.Looped=on; if WorldSnd then WorldSnd.Looped=on end
    end)
    toggle(sc,"Shuffle",CFG,"Shuffle")

    titulo(sc,"TODOS OUVEM")
    toggle(sc,"Todos Ouvem no Mundo",CFG,"TodosOuvem",function(on)
        if on then attachWorld()
        else if WorldSnd then WorldSnd:Stop(); WorldSnd:Destroy(); WorldSnd=nil end end
    end)

    titulo(sc,"MICROFONE")
    local micMuted=false
    local function mkMicRow()
        local row=Instance.new("Frame",sc); row.Size=UDim2.new(1,0,0,30)
        row.BackgroundTransparency=1; row.ZIndex=153
        local dot=Instance.new("Frame",row); dot.Size=UDim2.new(0,5,0,5); dot.Position=UDim2.new(0,2,0.5,-2)
        dot.BackgroundColor3=Color3.fromRGB(50,200,80); dot.BorderSizePixel=0; dot.ZIndex=154
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-60,1,0); l.Position=UDim2.new(0,12,0,0)
        l.BackgroundTransparency=1; l.Text="Microfone: LIGADO"; l.TextColor3=Color3.fromRGB(205,195,195)
        l.Font=Enum.Font.Gotham; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=153
        local track=Instance.new("TextButton",row); track.Size=UDim2.new(0,42,0,20); track.Position=UDim2.new(1,-44,0.5,-10)
        track.BackgroundColor3=Color3.fromRGB(210,35,35); track.Text=""; track.BorderSizePixel=0; track.AutoButtonColor=false; track.ZIndex=154
        Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,14,0,14); knob.Position=UDim2.new(1,-17,0.5,-7)
        knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; knob.ZIndex=155
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        track.MouseButton1Click:Connect(function()
            micMuted=not micMuted; local on=not micMuted
            pcall(function() game:GetService("VoiceChatService"):SetMicrophoneMuted(micMuted) end)
            TweenService:Create(track,TweenInfo.new(0.13),{BackgroundColor3=on and Color3.fromRGB(210,35,35) or Color3.fromRGB(44,28,28)}):Play()
            TweenService:Create(knob,TweenInfo.new(0.13),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
            TweenService:Create(dot,TweenInfo.new(0.13),{BackgroundColor3=on and Color3.fromRGB(50,200,80) or Color3.fromRGB(44,26,26)}):Play()
            l.Text=on and "Microfone: LIGADO" or "Microfone: MUTADO"
        end)
    end
    mkMicRow()

    titulo(sc,"PLAYLIST ("..#MUSICAS.." musicas)")
    for idx,m in ipairs(MUSICAS) do
        local tb=Instance.new("TextButton",sc)
        tb.Size=UDim2.new(1,0,0,36); tb.BackgroundColor3=Color3.fromRGB(16,8,8)
        tb.BorderSizePixel=0; tb.AutoButtonColor=false; tb.ZIndex=153
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)
        local tn=Instance.new("TextLabel",tb); tn.Size=UDim2.new(1,-10,0,18); tn.Position=UDim2.new(0,8,0,4)
        tn.BackgroundTransparency=1; tn.Text=m.n; tn.TextColor3=Color3.fromRGB(205,195,195)
        tn.Font=Enum.Font.GothamBold; tn.TextSize=11; tn.TextXAlignment=Enum.TextXAlignment.Left; tn.TextTruncate=Enum.TextTruncate.AtEnd; tn.ZIndex=154
        local tc=Instance.new("TextLabel",tb); tc.Size=UDim2.new(1,-10,0,12); tc.Position=UDim2.new(0,8,0,22)
        tc.BackgroundTransparency=1; tc.Text=m.c; tc.TextColor3=Color3.fromRGB(80,56,56)
        tc.Font=Enum.Font.Gotham; tc.TextSize=9; tc.TextXAlignment=Enum.TextXAlignment.Left; tc.ZIndex=154
        tb.MouseButton1Click:Connect(function()
            CFG.MusicOn=true; tocarIdx(idx); MusicSnd:Play()
            if CFG.TodosOuvem and WorldSnd then WorldSnd:Play() end
            atuNP()
        end)
    end
end

-- MOVE
do
    local sc=novoScroll(tabPanels["Move"])
    titulo(sc,"MOVIMENTO")
    toggle(sc,"Speed Hack",CFG,"SpeedOn")
    slider(sc,"Velocidade",CFG,"SpeedVal",16,100,"int")
    toggle(sc,"Pulo Infinito",CFG,"InfJump")
    titulo(sc,"GERAL")
    toggle(sc,"Anti-AFK",CFG,"AntiAFK")
end

-- Toggle menu
local menuVis=false
local function toggleMenu()
    menuVis=not menuVis; Main.Visible=menuVis
    if menuVis then
        Main.BackgroundTransparency=1
        TweenService:Create(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quart),{BackgroundTransparency=0}):Play()
        wL1.Text="FECHAR"; wL1.TextColor3=Color3.fromRGB(90,68,68)
        wL2.Text="Menu"; wL2.TextColor3=Color3.fromRGB(90,68,68)
    else
        wL1.Text="LYNX"; wL1.TextColor3=Color3.fromRGB(215,42,42)
        wL2.Text="AWS"; wL2.TextColor3=Color3.fromRGB(230,220,220)
    end
end

local wD,wDS,wSP,wasTap,tapT=false,nil,nil,false,0
wBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        wD=true; wDS=i.Position; wSP=btnH.Position; wasTap=true; tapT=tick()
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if not wD then return end
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        local dv=i.Position-wDS; if dv.Magnitude>10 then wasTap=false end
        btnH.Position=UDim2.new(wSP.X.Scale,wSP.X.Offset+dv.X,wSP.Y.Scale,wSP.Y.Offset+dv.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        if wasTap and (tick()-tapT)<0.35 then toggleMenu() end
        wD=false; wasTap=false
    end
end)

UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end
    if i.KeyCode==Enum.KeyCode.Delete then
        pcall(function() fovC:Remove() end)
        pcall(function() chH:Remove(); chV:Remove() end)
        clearTracers()
        MusicSnd:Stop()
        if WorldSnd then WorldSnd:Stop() end
        sgui:Destroy()
    end
end)

print("[LYNX v7.0] Carregado com sucesso!")
print("[LYNX] Remotes detectados: "..#detectedRemotes)
print("[LYNX] Remote de tiro: "..(shootRemote and shootRemote:GetFullName() or "Detectando ao atirar..."))
--[[
â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
â•‘         LYNX AWS  v12.0  â€“  red_wolf12370           â•‘
â•‘  UI: Dashboard 550x350  |  Key: kronos_pt           â•‘
â•‘  Novo: TriggerBot Â· No Recoil Â· Auto-Reload         â•‘
â•‘        Playlist Elite (Trap/Funk/Phonk 25 faixas)   â•‘
â•‘        Sidebar Redesign Â· Design Premium             â•‘
â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
]]

-- ============================================================
-- SERVIÃ‡OS
-- ============================================================
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TS         = game:GetService("TweenService")
local VU         = game:GetService("VirtualUser")
local SS         = game:GetService("SoundService")
local Camera     = workspace.CurrentCamera
local LP         = Players.LocalPlayer

repeat task.wait() until LP and LP.PlayerGui

-- Cleanup versÃµes antigas
pcall(function()
    for _, v in pairs(LP.PlayerGui:GetChildren()) do
        if v.Name:find("LYNX") then v:Destroy() end
    end
    local s = SS:FindFirstChild("LYNX_SND"); if s then s:Destroy() end
end)

-- ============================================================
-- CONFIG GLOBAL
-- ============================================================
local AIM_ON        = false
local SILENT_AIM    = false
local TRIGGER_BOT   = false
local NO_RECOIL     = false
local AUTO_RELOAD   = false
local FOV_ON        = false
local LINE_ON       = false
local CROSSHAIR_ON  = true
local FOV_RADIUS    = 150
local PREDICTION    = 0.165

local ESP_ON    = true
local ESP_BOX   = true
local ESP_NAME  = true
local ESP_DIST  = true
local ESP_HP    = false

local FBRIGHT   = false
local NO_FOG    = false

local SPEED_ON  = false
local SPEED_VAL = 32
local INF_JUMP  = false
local NOCLIP_ON = false
local ANTI_AFK  = true

-- ============================================================
-- PLAYLIST ELITE (25 faixas: Trap, Funk BR, Phonk)
-- ============================================================
local MUSICAS = {
    -- TRAP
    {n="SICKO MODE",            id="2536738536",  c="Trap"},
    {n="Goosebumps",            id="1031514411",  c="Trap"},
    {n="Dark Knight Dummo",     id="2252122862",  c="Trap"},
    {n="No Role Modelz",        id="248614747",   c="Trap"},
    {n="Jumpman",               id="494650959",   c="Trap"},
    {n="Antidote",              id="173534822",   c="Trap"},
    {n="Skyfall Drake",         id="1845616459",  c="Trap"},
    {n="Congratulations Post",  id="1845540503",  c="Trap"},
    -- FUNK BR
    {n="Deu Onda",              id="1158406116",  c="Funk BR"},
    {n="Bum Bum Tam Tam",       id="1054524280",  c="Funk BR"},
    {n="Vai Malandra",          id="1213168433",  c="Funk BR"},
    {n="Envolvimento",          id="285315370",   c="Funk BR"},
    {n="Oi Sumido",             id="1845773060",  c="Funk BR"},
    {n="Ela E do Tipo",         id="1845786410",  c="Funk BR"},
    {n="Joga Bonito",           id="7264073649",  c="Funk BR"},
    {n="Leal",                  id="6768175272",  c="Funk BR"},
    {n="Bandida",               id="1843990562",  c="Funk BR"},
    -- PHONK
    {n="PHONK 1 (Drift)",       id="7718205906",  c="Phonk"},
    {n="PHONK 2 (Miami)",       id="7718163101",  c="Phonk"},
    {n="PHONK 3 (Funk It)",     id="7489648407",  c="Phonk"},
    {n="PHONK 4 (Murder)",      id="7073788028",  c="Phonk"},
    {n="PHONK 5 (SUGMA)",       id="9061532963",  c="Phonk"},
    {n="PHONK 6 (Turbo)",       id="7073764683",  c="Phonk"},
    {n="PHONK 7 (Hardest)",     id="7073822813",  c="Phonk"},
    {n="PHONK 8 (Neon)",        id="7073856631",  c="Phonk"},
}

local MUSIC_ON=false; local MUSIC_VOL=0.8; local MUSIC_IDX=1
local MUSIC_LOOP=false; local MUSIC_SHUF=false; local MUSIC_WORLD=false
local nowName="Nenhuma"

local MSnd=Instance.new("Sound",SS)
MSnd.Name="LYNX_SND"; MSnd.Volume=MUSIC_VOL; MSnd.Looped=MUSIC_LOOP
local WSnd=nil

local function worldAttach()
    pcall(function()
        if WSnd then WSnd:Destroy() end
        local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not r then return end
        WSnd=Instance.new("Sound",r); WSnd.SoundId=MSnd.SoundId
        WSnd.Volume=math.min(MUSIC_VOL*2,1); WSnd.Looped=MUSIC_LOOP
        WSnd.RollOffMode=Enum.RollOffMode.Linear
        WSnd.RollOffMinDistance=5; WSnd.RollOffMaxDistance=60
        if MUSIC_ON and MUSIC_WORLD then WSnd:Play() end
    end)
end
LP.CharacterAdded:Connect(function() task.wait(1); if MUSIC_WORLD then worldAttach() end end)

local function tocarIdx(i)
    i=((i-1)%#MUSICAS)+1; MUSIC_IDX=i
    local m=MUSICAS[i]; nowName=m.n
    MSnd:Stop(); MSnd.SoundId="rbxassetid://"..m.id
    MSnd.Volume=MUSIC_VOL; MSnd.Looped=MUSIC_LOOP
    if MUSIC_ON then MSnd:Play() end
    if WSnd then WSnd:Stop(); WSnd.SoundId=MSnd.SoundId
        if MUSIC_ON and MUSIC_WORLD then WSnd:Play() end end
end
MSnd.Ended:Connect(function()
    if not MUSIC_ON or MUSIC_LOOP then return end; task.wait(0.3)
    tocarIdx(MUSIC_SHUF and math.random(1,#MUSICAS) or MUSIC_IDX+1)
end)
tocarIdx(1)

-- ============================================================
-- DRAWING: FOV + CROSSHAIR + TRACERS
-- ============================================================
local fovCircle=Drawing.new("Circle")
fovCircle.Thickness=1.5; fovCircle.NumSides=64
fovCircle.Color=Color3.fromRGB(210,40,40); fovCircle.Filled=false; fovCircle.Visible=false

local chH=Drawing.new("Line"); chH.Color=Color3.fromRGB(210,40,40); chH.Thickness=1.4; chH.Transparent=0.25; chH.Visible=false
local chV=Drawing.new("Line"); chV.Color=Color3.fromRGB(210,40,40); chV.Thickness=1.4; chV.Transparent=0.25; chV.Visible=false
local tracers={}

-- ============================================================
-- AIMBOT
-- ============================================================
local function getClosestPlayer()
    local target,shortest=nil,math.huge
    local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not myRoot then return nil end
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character and p.Character:FindFirstChild("Head") then
            local dist=(myRoot.Position-p.Character.Head.Position).Magnitude
            local _,onScreen=Camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen and dist<shortest then shortest=dist; target=p.Character.Head end
        end
    end
    return target
end

-- ============================================================
-- SILENT AIM (metamethod)
-- ============================================================
local function enableSilentAim()
    pcall(function()
        local mt=getrawmetatable(game); local old=mt.__namecall
        setreadonly(mt,false)
        mt.__namecall=newcclosure(function(self,...)
            local method=getnamecallmethod()
            if SILENT_AIM and method=="FireServer" then
                local args={...}
                local target=getClosestPlayer()
                if target then
                    for i,v in pairs(args) do
                        if typeof(v)=="Vector3" then args[i]=target.Position end
                        if typeof(v)=="CFrame" then args[i]=CFrame.new(target.Position) end
                    end
                    return old(self,table.unpack(args))
                end
            end
            return old(self,...)
        end)
        setreadonly(mt,true)
    end)
end
enableSilentAim()

-- ============================================================
-- NO RECOIL (zerando CameraOffset a cada frame)
-- ============================================================
RunService.RenderStepped:Connect(function()
    if NO_RECOIL then
        pcall(function()
            local c=LP.Character; if not c then return end
            local h=c:FindFirstChildOfClass("Humanoid"); if not h then return end
            h.CameraOffset=Vector3.new(0,0,0)
        end)
    end
end)

-- ============================================================
-- AUTO RELOAD (monitora muniÃ§Ã£o)
-- ============================================================
local reloadConn=nil
task.spawn(function()
    while task.wait(0.15) do
        if not AUTO_RELOAD then continue end
        pcall(function()
            local tool=LP.Character and LP.Character:FindFirstChildOfClass("Tool"); if not tool then return end
            local ammo=tool:FindFirstChild("Ammo") or tool:FindFirstChild("ammo") or tool:FindFirstChild("Bullets")
            if ammo and ammo:IsA("IntValue") and ammo.Value==0 then
                local reloadEvent=tool:FindFirstChild("Reload") or tool:FindFirstChild("ReloadEvent")
                if reloadEvent and reloadEvent:IsA("RemoteEvent") then
                    reloadEvent:FireServer()
                else
                    local function tryBind()
                        UIS:SetKeybindEnabled(Enum.KeyCode.R, false)
                        task.wait(0.05)
                        UIS:SetKeybindEnabled(Enum.KeyCode.R, true)
                    end
                    pcall(tryBind)
                    pcall(function() LP.Character:WaitForChild("Humanoid"):LoadAnimation(Instance.new("Animation")):Play() end)
                end
            end
        end)
    end
end)

-- ============================================================
-- TRIGGER BOT
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not TRIGGER_BOT then return end
    pcall(function()
        local unitRay=Camera:ScreenPointToRay(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local rayResult=workspace:Raycast(unitRay.Origin, unitRay.Direction*500,
            RaycastParams.new())
        if rayResult and rayResult.Instance then
            local hit=rayResult.Instance
            local char=hit:FindFirstAncestorOfClass("Model")
            if char then
                local plr=Players:GetPlayerFromCharacter(char)
                if plr and plr~=LP then
                    local tool=LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local fireEvt=tool:FindFirstChild("FireEvent") or tool:FindFirstChild("Shoot")
                            or tool:FindFirstChild("Fire") or tool:FindFirstChild("ShootEvent")
                        if fireEvt and fireEvt:IsA("RemoteEvent") then
                            fireEvt:FireServer()
                        end
                    end
                end
            end
        end
    end)
end)

-- ============================================================
-- MOTOR DE RENDERIZAÃ‡ÃƒO
-- ============================================================
RunService.RenderStepped:Connect(function()
    local cx=Camera.ViewportSize.X/2; local cy=Camera.ViewportSize.Y/2

    fovCircle.Visible=FOV_ON; fovCircle.Radius=FOV_RADIUS
    fovCircle.Position=Vector2.new(cx,cy)

    chH.Visible=CROSSHAIR_ON; chV.Visible=CROSSHAIR_ON
    chH.From=Vector2.new(cx-13,cy); chH.To=Vector2.new(cx+13,cy)
    chV.From=Vector2.new(cx,cy-13); chV.To=Vector2.new(cx,cy+13)

    for _,v in pairs(tracers) do v:Remove() end; tracers={}

    if AIM_ON then
        local target=getClosestPlayer()
        if target then
            local vel=target.Parent.HumanoidRootPart.AssemblyLinearVelocity
            Camera.CFrame=CFrame.new(Camera.CFrame.Position,target.Position+(vel*PREDICTION))
        end
    end

    if LINE_ON then
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos,on=Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if on then
                    local l=Drawing.new("Line")
                    l.From=Vector2.new(cx,Camera.ViewportSize.Y)
                    l.To=Vector2.new(pos.X,pos.Y)
                    l.Color=Color3.fromRGB(210,40,40); l.Thickness=1.2; l.Visible=true
                    table.insert(tracers,l)
                end
            end
        end
    end
end)

-- ============================================================
-- OUTROS LOOPS
-- ============================================================
task.spawn(function()
    while task.wait() do
        local c=LP.Character; if not c then continue end
        local h=c:FindFirstChildOfClass("Humanoid"); if not h then continue end
        if SPEED_ON then h.WalkSpeed=SPEED_VAL else h.WalkSpeed=16 end
    end
end)

RunService.Stepped:Connect(function()
    if not NOCLIP_ON then return end
    local c=LP.Character; if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false end
    end
end)

RunService.Heartbeat:Connect(function()
    if FBRIGHT then
        local L=game:GetService("Lighting")
        L.Brightness=2; L.ClockTime=14; L.FogEnd=1e5
        L.GlobalShadows=false; L.Ambient=Color3.new(1,1,1); L.OutdoorAmbient=Color3.new(1,1,1)
    end
    if NO_FOG then
        local L=game:GetService("Lighting"); L.FogEnd=1e5; L.FogStart=99999
    end
end)

UIS.JumpRequest:Connect(function()
    if not INF_JUMP then return end
    local c=LP.Character; if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid"); if not h then return end
    h:ChangeState(Enum.HumanoidStateType.Jumping)
end)

local afkT=0
RunService.Heartbeat:Connect(function(dt)
    afkT=afkT+dt
    if ANTI_AFK and afkT>=55 then afkT=0
        pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end
end)

-- ============================================================
-- ESP
-- ============================================================
local espCache={}
local function clearESP(p)
    if not espCache[p] then return end
    for _,o in pairs(espCache[p]) do pcall(function() o:Destroy() end) end
    espCache[p]=nil
end
local function buildESP(p,char)
    clearESP(p); if not ESP_ON then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local lista={}
    if ESP_BOX then
        local hl=Instance.new("Highlight",char)
        hl.FillColor=Color3.fromRGB(210,40,40); hl.OutlineColor=Color3.fromRGB(255,80,80)
        hl.FillTransparency=0.5; hl.OutlineTransparency=0
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(lista,hl)
    end
    local bb=Instance.new("BillboardGui",root)
    bb.Size=UDim2.new(0,140,0,60); bb.StudsOffset=Vector3.new(0,3.8,0)
    bb.AlwaysOnTop=true; bb.Adornee=root
    if ESP_NAME then
        local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,0,22)
        l.BackgroundTransparency=1; l.Text=p.Name; l.TextColor3=Color3.fromRGB(255,80,80)
        l.Font=Enum.Font.GothamBold; l.TextSize=14
        l.TextStrokeTransparency=0.3; l.TextStrokeColor3=Color3.new(0,0,0)
    end
    if ESP_DIST then
        local dl=Instance.new("TextLabel",bb); dl.Size=UDim2.new(1,0,0,16); dl.Position=UDim2.new(0,0,0,23)
        dl.BackgroundTransparency=1; dl.TextColor3=Color3.fromRGB(190,170,170)
        dl.Font=Enum.Font.Gotham; dl.TextSize=11; dl.TextStrokeTransparency=0.4
        RunService.Heartbeat:Connect(function()
            if not root.Parent then return end
            local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not r then return end
            dl.Text=math.floor((r.Position-root.Position).Magnitude).."m"
        end)
    end
    if ESP_HP then
        local hl2=Instance.new("TextLabel",bb); hl2.Size=UDim2.new(1,0,0,14); hl2.Position=UDim2.new(0,0,0,40)
        hl2.BackgroundTransparency=1; hl2.Font=Enum.Font.GothamBold; hl2.TextSize=10; hl2.TextStrokeTransparency=0.4
        local hm=char:FindFirstChildOfClass("Humanoid")
        if hm then
            local function upHP()
                local pct=math.clamp(hm.Health/hm.MaxHealth,0,1)
                hl2.Text="HP "..math.floor(pct*100).."%"
                hl2.TextColor3=Color3.fromRGB(math.floor(255*(1-pct)),math.floor(200*pct),35)
            end
            upHP(); hm:GetPropertyChangedSignal("Health"):Connect(upHP)
        end
    end
    table.insert(lista,bb); espCache[p]=lista
end
local function refreshESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then clearESP(p); if ESP_ON and p.Character then buildESP(p,p.Character) end end
    end
end
local function hookPlayer(p)
    p.CharacterAdded:Connect(function(c) task.wait(0.6); if ESP_ON then buildESP(p,c) end end)
    p.CharacterRemoving:Connect(function() clearESP(p) end)
    if p.Character then task.spawn(function() task.wait(0.1); if ESP_ON then buildESP(p,p.Character) end end) end
end
for _,p in ipairs(Players:GetPlayers()) do if p~=LP then hookPlayer(p) end end
Players.PlayerAdded:Connect(hookPlayer); Players.PlayerRemoving:Connect(clearESP)

-- ============================================================
-- GUI PRINCIPAL
-- ============================================================
local sgui=Instance.new("ScreenGui",LP.PlayerGui)
sgui.Name="LYNX_V12"; sgui.ResetOnSpawn=false
sgui.IgnoreGuiInset=true; sgui.DisplayOrder=9999
sgui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

-- Cores LYNX v12
local C_BG      = Color3.fromRGB(10, 10, 10)
local C_PANEL   = Color3.fromRGB(14, 14, 14)
local C_SIDEBAR = Color3.fromRGB(8, 8, 8)
local C_ROW     = Color3.fromRGB(18, 18, 18)
local C_RED     = Color3.fromRGB(210, 40, 40)
local C_REDFADE = Color3.fromRGB(60, 20, 20)
local C_TEXT    = Color3.fromRGB(230, 230, 230)
local C_SUBTEXT = Color3.fromRGB(100, 100, 100)
local C_ACCENT  = Color3.fromRGB(255, 70, 70)

-- ============================================================
-- NOTIFICAÃ‡ÃƒO
-- ============================================================
local notiStack={}
local function notify(titulo,msg,cor)
    cor=cor or C_RED
    local nf=Instance.new("Frame",sgui)
    nf.Size=UDim2.new(0,270,0,58)
    nf.Position=UDim2.new(1,280,1,-74-#notiStack*68)
    nf.BackgroundColor3=Color3.fromRGB(12,12,12)
    nf.BorderSizePixel=0; nf.ZIndex=9000
    Instance.new("UICorner",nf).CornerRadius=UDim.new(0,8)
    local ns=Instance.new("UIStroke",nf); ns.Color=cor; ns.Thickness=1.5
    local bar=Instance.new("Frame",nf); bar.Size=UDim2.new(0,3,0.8,-4); bar.Position=UDim2.new(0,5,0.1,0)
    bar.BackgroundColor3=cor; bar.BorderSizePixel=0
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    local tl=Instance.new("TextLabel",nf); tl.Size=UDim2.new(1,-18,0,21); tl.Position=UDim2.new(0,14,0,8)
    tl.BackgroundTransparency=1; tl.Text=titulo; tl.TextColor3=C_TEXT
    tl.Font=Enum.Font.GothamBlack; tl.TextSize=12; tl.TextXAlignment=Enum.TextXAlignment.Left
    local ml=Instance.new("TextLabel",nf); ml.Size=UDim2.new(1,-18,0,16); ml.Position=UDim2.new(0,14,0,30)
    ml.BackgroundTransparency=1; ml.Text=msg; ml.TextColor3=C_SUBTEXT
    ml.Font=Enum.Font.Gotham; ml.TextSize=10; ml.TextXAlignment=Enum.TextXAlignment.Left
    table.insert(notiStack,nf)
    TS:Create(nf,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{Position=UDim2.new(1,-280,1,-74-(#notiStack-1)*68)}):Play()
    task.delay(3.5,function()
        TS:Create(nf,TweenInfo.new(0.3),{Position=UDim2.new(1,280,1,-74)}):Play()
        task.wait(0.35); nf:Destroy()
        table.remove(notiStack,table.find(notiStack,nf) or 1)
    end)
end

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local loadBG=Instance.new("Frame",sgui)
loadBG.Size=UDim2.new(1,0,1,0); loadBG.BackgroundColor3=Color3.fromRGB(5,5,5)
loadBG.BorderSizePixel=0; loadBG.ZIndex=9999

local loadLynx=Instance.new("TextLabel",loadBG)
loadLynx.Size=UDim2.new(0,340,0,56); loadLynx.Position=UDim2.new(0.5,-170,0.5,-90)
loadLynx.BackgroundTransparency=1; loadLynx.Text="LYNX AWS"
loadLynx.TextColor3=C_RED; loadLynx.Font=Enum.Font.GothamBlack
loadLynx.TextSize=46; loadLynx.TextTransparency=1

local loadSub=Instance.new("TextLabel",loadBG)
loadSub.Size=UDim2.new(0,340,0,22); loadSub.Position=UDim2.new(0.5,-170,0.5,-26)
loadSub.BackgroundTransparency=1; loadSub.Text="Iniciando modulos..."
loadSub.TextColor3=C_SUBTEXT; loadSub.Font=Enum.Font.Gotham
loadSub.TextSize=13; loadSub.TextTransparency=1

local loadBarBG=Instance.new("Frame",loadBG)
loadBarBG.Size=UDim2.new(0,300,0,4); loadBarBG.Position=UDim2.new(0.5,-150,0.5,18)
loadBarBG.BackgroundColor3=Color3.fromRGB(25,25,25); loadBarBG.BorderSizePixel=0; loadBarBG.ZIndex=10000
Instance.new("UICorner",loadBarBG).CornerRadius=UDim.new(1,0)

local loadBar=Instance.new("Frame",loadBarBG)
loadBar.Size=UDim2.new(0,0,1,0); loadBar.BackgroundColor3=C_RED
loadBar.BorderSizePixel=0; loadBar.ZIndex=10001
Instance.new("UICorner",loadBar).CornerRadius=UDim.new(1,0)

local loadVer=Instance.new("TextLabel",loadBG)
loadVer.Size=UDim2.new(0,300,0,14); loadVer.Position=UDim2.new(0.5,-150,0.5,34)
loadVer.BackgroundTransparency=1; loadVer.Text="v12.0  |  red_wolf12370"
loadVer.TextColor3=Color3.fromRGB(50,50,50); loadVer.Font=Enum.Font.Gotham
loadVer.TextSize=10; loadVer.TextTransparency=1

local msgs={"Iniciando aimbot...","Carregando ESP...","Configurando musica...","Ativando TriggerBot...","No Recoil ativo...","Pronto!"}
task.spawn(function()
    TS:Create(loadLynx,TweenInfo.new(0.5),{TextTransparency=0}):Play(); task.wait(0.4)
    TS:Create(loadSub,TweenInfo.new(0.4),{TextTransparency=0}):Play()
    TS:Create(loadVer,TweenInfo.new(0.4),{TextTransparency=0}):Play(); task.wait(0.3)
    for i,m in ipairs(msgs) do
        loadSub.Text=m
        TS:Create(loadBar,TweenInfo.new(0.3,Enum.EasingStyle.Quart),{Size=UDim2.new(i/#msgs,0,1,0)}):Play()
        task.wait(0.34)
    end
    task.wait(0.3)
    TS:Create(loadBG,TweenInfo.new(0.5),{BackgroundTransparency=1}):Play()
    TS:Create(loadLynx,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    TS:Create(loadSub,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    TS:Create(loadBarBG,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
    TS:Create(loadVer,TweenInfo.new(0.4),{TextTransparency=1}):Play()
    task.wait(0.5); loadBG:Destroy()
    notify("LYNX AWS v12.0","Script carregado! Arena de Pistola",Color3.fromRGB(45,195,75))
end)

-- ============================================================
-- KEY SCREEN
-- ============================================================
local keyDone=false

local keyBG=Instance.new("Frame",sgui)
keyBG.Size=UDim2.new(1,0,1,0)
keyBG.BackgroundColor3=Color3.fromRGB(5,5,5)
keyBG.BackgroundTransparency=1; keyBG.BorderSizePixel=0; keyBG.ZIndex=8000

task.delay(2.6,function()
    TS:Create(keyBG,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
end)

-- PartÃ­culas deco
math.randomseed(tick())
local decos={}
for i=1,20 do
    local f=Instance.new("Frame",keyBG); local sz=math.random(8,50)
    f.Size=UDim2.new(0,sz,0,sz)
    f.Position=UDim2.new(math.random()*0.92,0,math.random()*0.92,0)
    f.BackgroundColor3=C_RED
    f.BackgroundTransparency=0.88+math.random()*0.09
    f.BorderSizePixel=0; f.ZIndex=8001; f.Rotation=math.random()*60
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
    table.insert(decos,f)
end
RunService.RenderStepped:Connect(function()
    if not keyBG.Parent then return end
    if not keyBG.Visible then return end
    local t=tick()
    for i,f in ipairs(decos) do
        f.Rotation=f.Rotation+0.07+i*0.012
        f.BackgroundTransparency=0.87+math.sin(t*0.7+i)*0.1
    end
end)

-- Painel key 320x380
local kp=Instance.new("Frame",keyBG)
kp.Size=UDim2.new(0,320,0,390); kp.Position=UDim2.new(0.5,-160,0.5,-195)
kp.BackgroundColor3=Color3.fromRGB(10,10,10); kp.BorderSizePixel=0; kp.ZIndex=8002
Instance.new("UICorner",kp).CornerRadius=UDim.new(0,14)
local kStr=Instance.new("UIStroke",kp); kStr.Color=C_RED; kStr.Thickness=2
RunService.RenderStepped:Connect(function()
    if not kp.Parent then return end
    kStr.Thickness=1.8+math.sin(tick()*2)*0.7
end)

local kTopBar=Instance.new("Frame",kp); kTopBar.Size=UDim2.new(1,0,0,4)
kTopBar.BackgroundColor3=C_RED; kTopBar.BorderSizePixel=0; kTopBar.ZIndex=8003
Instance.new("UICorner",kTopBar).CornerRadius=UDim.new(0,14)

-- Ãcone
local ikBG=Instance.new("Frame",kp)
ikBG.Size=UDim2.new(0,80,0,80); ikBG.Position=UDim2.new(0.5,-40,0,16)
ikBG.BackgroundColor3=Color3.fromRGB(16,16,16); ikBG.BorderSizePixel=0; ikBG.ZIndex=8003
Instance.new("UICorner",ikBG).CornerRadius=UDim.new(1,0)
local ikStr=Instance.new("UIStroke",ikBG); ikStr.Color=C_RED; ikStr.Thickness=2
RunService.RenderStepped:Connect(function()
    if not ikBG.Parent then return end
    local t=tick()
    ikStr.Thickness=1.5+math.sin(t*2.5)*0.8
    ikBG.Rotation=math.sin(t*0.7)*3
end)
local ikL1=Instance.new("TextLabel",ikBG); ikL1.Size=UDim2.new(1,0,0,30); ikL1.Position=UDim2.new(0,0,0,12)
ikL1.BackgroundTransparency=1; ikL1.Text="LYNX"; ikL1.TextColor3=C_RED
ikL1.Font=Enum.Font.GothamBlack; ikL1.TextSize=18; ikL1.ZIndex=8004
local ikL2=Instance.new("TextLabel",ikBG); ikL2.Size=UDim2.new(1,0,0,22); ikL2.Position=UDim2.new(0,0,0,46)
ikL2.BackgroundTransparency=1; ikL2.Text="AWS"; ikL2.TextColor3=C_TEXT
ikL2.Font=Enum.Font.GothamBold; ikL2.TextSize=14; ikL2.ZIndex=8004

-- Textos key
local function kTxt(t,y,sz,col,fnt)
    local l=Instance.new("TextLabel",kp)
    l.Size=UDim2.new(0.86,0,0,sz+8); l.Position=UDim2.new(0.07,0,0,y)
    l.BackgroundTransparency=1; l.Text=t; l.TextColor3=col or C_TEXT
    l.Font=fnt or Enum.Font.Gotham; l.TextSize=sz; l.TextWrapped=true; l.ZIndex=8003; return l
end
kTxt("VERIFICAÃ‡ÃƒO DE ACESSO",108,15,C_TEXT,Enum.Font.GothamBlack)
kTxt("Insira sua chave para continuar",132,11,C_SUBTEXT)
local kSep=Instance.new("Frame",kp); kSep.Size=UDim2.new(0.82,0,0,1); kSep.Position=UDim2.new(0.09,0,0,165)
kSep.BackgroundColor3=Color3.fromRGB(35,35,35); kSep.BorderSizePixel=0; kSep.ZIndex=8003

local kLK=kTxt("CHAVE DE ACESSO",173,9,C_RED,Enum.Font.GothamBold); kLK.TextXAlignment=Enum.TextXAlignment.Left

local kBxBG=Instance.new("Frame",kp); kBxBG.Size=UDim2.new(0.82,0,0,46); kBxBG.Position=UDim2.new(0.09,0,0,190)
kBxBG.BackgroundColor3=Color3.fromRGB(16,16,16); kBxBG.BorderSizePixel=0; kBxBG.ZIndex=8003
Instance.new("UICorner",kBxBG).CornerRadius=UDim.new(0,8)
local kBxStr=Instance.new("UIStroke",kBxBG); kBxStr.Color=Color3.fromRGB(40,40,40); kBxStr.Thickness=1.5

local kBox=Instance.new("TextBox",kBxBG)
kBox.Size=UDim2.new(1,-16,1,0); kBox.Position=UDim2.new(0,8,0,0)
kBox.BackgroundTransparency=1; kBox.Text=""; kBox.PlaceholderText="Digite sua key..."
kBox.TextColor3=C_TEXT; kBox.PlaceholderColor3=Color3.fromRGB(70,70,70)
kBox.Font=Enum.Font.GothamBold; kBox.TextSize=14; kBox.ClearTextOnFocus=false; kBox.ZIndex=8004
kBox:GetPropertyChangedSignal("Text"):Connect(function() kBxStr.Color=C_RED end)

local kBtn=Instance.new("TextButton",kp); kBtn.Size=UDim2.new(0.82,0,0,44); kBtn.Position=UDim2.new(0.09,0,0,246)
kBtn.BackgroundColor3=C_RED; kBtn.Text="CONFIRMAR ACESSO"
kBtn.TextColor3=Color3.new(1,1,1); kBtn.Font=Enum.Font.GothamBlack; kBtn.TextSize=13
kBtn.BorderSizePixel=0; kBtn.AutoButtonColor=false; kBtn.ZIndex=8003
Instance.new("UICorner",kBtn).CornerRadius=UDim.new(0,8)

local kStatus=kTxt("",300,11); kStatus.ZIndex=8003
kTxt("LYNX AWS v12.0  |  red_wolf12370",326,9,Color3.fromRGB(40,40,40))
kTxt("Discord: ryan_ejsjseke",345,9,Color3.fromRGB(40,40,40))

local function verificar()
    local v=kBox.Text:gsub("%s",""):lower()
    if v=="kronos_pt" then
        kStatus.Text="âœ” ACESSO LIBERADO!"; kStatus.TextColor3=Color3.fromRGB(45,195,75)
        kBtn.BackgroundColor3=Color3.fromRGB(35,160,60)
        task.delay(0.5,function()
            TS:Create(keyBG,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
            task.wait(0.45); keyBG:Destroy(); keyDone=true
            notify("Bem-vindo!","LYNX AWS v12.0 ativo!",Color3.fromRGB(45,195,75))
        end)
    else
        kStatus.Text="âœ— KEY INVÃLIDA!"; kStatus.TextColor3=Color3.fromRGB(255,60,60)
        kBtn.BackgroundColor3=Color3.fromRGB(140,20,20)
        TS:Create(kBxBG,TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,6,true),
            {Position=UDim2.new(0.09,8,0,190)}):Play()
        task.wait(0.5); kBox.Text=""; kBtn.BackgroundColor3=C_RED
    end
end
kBtn.MouseButton1Click:Connect(verificar)
kBox.FocusLost:Connect(function(e) if e then verificar() end end)

-- ============================================================
-- BOTÃƒO FLUTUANTE
-- ============================================================
local btnH=Instance.new("Frame",sgui)
btnH.Size=UDim2.new(0,84,0,84); btnH.Position=UDim2.new(0,12,0.5,-42)
btnH.BackgroundTransparency=1; btnH.ZIndex=500; btnH.Active=true

local wBtn=Instance.new("TextButton",btnH)
wBtn.Size=UDim2.new(1,0,1,0); wBtn.BackgroundColor3=Color3.fromRGB(12,12,12)
wBtn.Text=""; wBtn.ZIndex=500; wBtn.AutoButtonColor=false; wBtn.Active=true
Instance.new("UICorner",wBtn).CornerRadius=UDim.new(0,14)
local wStr=Instance.new("UIStroke",wBtn); wStr.Color=C_RED; wStr.Thickness=2.5

local wGlow=Instance.new("Frame",wBtn)
wGlow.Size=UDim2.new(1.5,0,1.5,0); wGlow.Position=UDim2.new(-0.25,0,-0.25,0)
wGlow.BackgroundColor3=C_RED; wGlow.BackgroundTransparency=0.88
wGlow.BorderSizePixel=0; wGlow.ZIndex=499
Instance.new("UICorner",wGlow).CornerRadius=UDim.new(0,22)

local wL1=Instance.new("TextLabel",wBtn)
wL1.Size=UDim2.new(1,0,0,30); wL1.Position=UDim2.new(0,0,0,9)
wL1.BackgroundTransparency=1; wL1.Text="LYNX"
wL1.TextColor3=C_RED; wL1.Font=Enum.Font.GothamBlack; wL1.TextSize=17; wL1.ZIndex=501

local wDiv=Instance.new("Frame",wBtn); wDiv.Size=UDim2.new(0.72,0,0,1); wDiv.Position=UDim2.new(0.14,0,0,44)
wDiv.BackgroundColor3=C_RED; wDiv.BorderSizePixel=0; wDiv.ZIndex=501

local wL2=Instance.new("TextLabel",wBtn)
wL2.Size=UDim2.new(1,0,0,26); wL2.Position=UDim2.new(0,0,0,47)
wL2.BackgroundTransparency=1; wL2.Text="AWS"
wL2.TextColor3=C_TEXT; wL2.Font=Enum.Font.GothamBold; wL2.TextSize=14; wL2.ZIndex=501

RunService.RenderStepped:Connect(function()
    local t=tick()
    wGlow.BackgroundTransparency=0.84+math.sin(t*2.5)*0.08
    wStr.Thickness=2.2+math.sin(t*2.5)*0.8
end)

-- ============================================================
-- PAINEL PRINCIPAL DASHBOARD 550x350
-- ============================================================
local Main=Instance.new("Frame",sgui)
Main.Size=UDim2.new(0,550,0,350); Main.Position=UDim2.new(0.5,-275,0.5,-175)
Main.BackgroundColor3=C_BG; Main.Visible=false; Main.Active=true; Main.ZIndex=150
Main.ClipsDescendants=false
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,12)
local mStr=Instance.new("UIStroke",Main); mStr.Color=Color3.fromRGB(35,35,35); mStr.Thickness=1.2

-- Barra topo vermelha
local mTop=Instance.new("Frame",Main); mTop.Size=UDim2.new(1,0,0,3)
mTop.BackgroundColor3=C_RED; mTop.BorderSizePixel=0; mTop.ZIndex=151
Instance.new("UICorner",mTop).CornerRadius=UDim.new(0,12)

-- ==== SIDEBAR ESQUERDA (60px) ====
local sidebar=Instance.new("Frame",Main)
sidebar.Size=UDim2.new(0,60,1,-3); sidebar.Position=UDim2.new(0,0,0,3)
sidebar.BackgroundColor3=C_SIDEBAR
sidebar.BorderSizePixel=0; sidebar.ZIndex=152
-- Arredonda esquerda, retifica direita
Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,12)
local sideRight=Instance.new("Frame",sidebar)
sideRight.Size=UDim2.new(0,14,1,0); sideRight.Position=UDim2.new(1,-14,0,0)
sideRight.BackgroundColor3=C_SIDEBAR; sideRight.BorderSizePixel=0; sideRight.ZIndex=152

-- Logo topo sidebar
local sLogo=Instance.new("TextLabel",sidebar)
sLogo.Size=UDim2.new(1,0,0,44); sLogo.Position=UDim2.new(0,0,0,8)
sLogo.BackgroundTransparency=1; sLogo.Text="L"
sLogo.TextColor3=C_RED; sLogo.Font=Enum.Font.GothamBlack; sLogo.TextSize=24; sLogo.ZIndex=153

-- Separador logo
local sLogoSep=Instance.new("Frame",sidebar)
sLogoSep.Size=UDim2.new(0.7,0,0,1); sLogoSep.Position=UDim2.new(0.15,0,0,54)
sLogoSep.BackgroundColor3=Color3.fromRGB(30,30,30); sLogoSep.BorderSizePixel=0; sLogoSep.ZIndex=153

-- ==== CONTEÃšDO DIREITO ====
local content=Instance.new("Frame",Main)
content.Size=UDim2.new(1,-62,1,-3); content.Position=UDim2.new(0,62,0,3)
content.BackgroundTransparency=1; content.ZIndex=152; content.ClipsDescendants=true

-- Topbar conteÃºdo
local hdr=Instance.new("Frame",content)
hdr.Size=UDim2.new(1,0,0,46); hdr.BackgroundTransparency=1; hdr.ZIndex=153; hdr.Active=true

local hAccent=Instance.new("Frame",hdr)
hAccent.Size=UDim2.new(0,3,0,26); hAccent.Position=UDim2.new(0,0,0.5,-13)
hAccent.BackgroundColor3=C_RED; hAccent.BorderSizePixel=0; hAccent.ZIndex=154
Instance.new("UICorner",hAccent).CornerRadius=UDim.new(0,2)

local hTitle=Instance.new("TextLabel",hdr)
hTitle.Size=UDim2.new(1,-54,0,22); hTitle.Position=UDim2.new(0,10,0,6)
hTitle.BackgroundTransparency=1; hTitle.Text="COMBAT"
hTitle.TextColor3=C_TEXT; hTitle.Font=Enum.Font.GothamBlack
hTitle.TextSize=18; hTitle.TextXAlignment=Enum.TextXAlignment.Left; hTitle.ZIndex=154

local hSub=Instance.new("TextLabel",hdr)
hSub.Size=UDim2.new(1,-54,0,14); hSub.Position=UDim2.new(0,10,0,27)
hSub.BackgroundTransparency=1; hSub.Text="red_wolf12370  Â·  v12.0  Â·  Arena de Pistola"
hSub.TextColor3=C_SUBTEXT; hSub.Font=Enum.Font.Gotham
hSub.TextSize=9; hSub.TextXAlignment=Enum.TextXAlignment.Left; hSub.ZIndex=154

local closeBtn=Instance.new("TextButton",hdr)
closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.Position=UDim2.new(1,-34,0.5,-14)
closeBtn.BackgroundColor3=Color3.fromRGB(22,22,22); closeBtn.Text="âœ•"
closeBtn.TextColor3=C_RED; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=12
closeBtn.BorderSizePixel=0; closeBtn.AutoButtonColor=false; closeBtn.ZIndex=154
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() Main.Visible=false end)
closeBtn.MouseEnter:Connect(function()
    TS:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=C_RED}):Play()
    TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=Color3.new(1,1,1)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TS:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(22,22,22)}):Play()
    TS:Create(closeBtn,TweenInfo.new(0.12),{TextColor3=C_RED}):Play()
end)

local hSepLine=Instance.new("Frame",content)
hSepLine.Size=UDim2.new(1,-4,0,1); hSepLine.Position=UDim2.new(0,2,0,46)
hSepLine.BackgroundColor3=Color3.fromRGB(28,28,28); hSepLine.BorderSizePixel=0; hSepLine.ZIndex=153

-- Footer barra status
local foot=Instance.new("Frame",content)
foot.Size=UDim2.new(1,0,0,30); foot.Position=UDim2.new(0,0,1,-30)
foot.BackgroundColor3=Color3.fromRGB(8,8,8); foot.BorderSizePixel=0; foot.ZIndex=153

local statsL=Instance.new("TextLabel",foot)
statsL.Size=UDim2.new(0.55,0,1,0); statsL.Position=UDim2.new(0,8,0,0)
statsL.BackgroundTransparency=1; statsL.TextColor3=C_SUBTEXT
statsL.Font=Enum.Font.Gotham; statsL.TextSize=9; statsL.TextXAlignment=Enum.TextXAlignment.Left; statsL.ZIndex=154

local musicF=Instance.new("TextLabel",foot)
musicF.Size=UDim2.new(0.45,0,1,0); musicF.Position=UDim2.new(0.55,0,0,0)
musicF.BackgroundTransparency=1; musicF.TextColor3=Color3.fromRGB(180,140,50)
musicF.Font=Enum.Font.GothamBold; musicF.TextSize=9; musicF.TextXAlignment=Enum.TextXAlignment.Right; musicF.ZIndex=154

RunService.Heartbeat:Connect(function()
    local t=getClosestPlayer()
    statsL.Text="Alvo: "..(t and t.Parent and t.Parent.Name or "â€”").." Â· FOV:"..FOV_RADIUS
    musicF.Text=(MUSIC_ON and "â–¶ " or "â–  ")..nowName
end)

-- Drag pelo topbar
do
    local d,ds,sp=false,nil,nil
    hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            d=true; ds=i.Position; sp=Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not d then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            local dv=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dv.X,sp.Y.Scale,sp.Y.Offset+dv.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end
    end)
end

-- Ãrea de pÃ¡ginas
local pageArea=Instance.new("Frame",content)
pageArea.Size=UDim2.new(1,-4,1,-82); pageArea.Position=UDim2.new(0,2,0,49)
pageArea.BackgroundTransparency=1; pageArea.ClipsDescendants=true; pageArea.ZIndex=153

-- ============================================================
-- COMPONENTES UI
-- ============================================================
local function makePage()
    local sf=Instance.new("ScrollingFrame",pageArea)
    sf.Size=UDim2.new(1,0,1,0); sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=C_RED
    sf.ScrollBarImageTransparency=0.4
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.ScrollingDirection=Enum.ScrollingDirection.Y; sf.ZIndex=154
    local pad=Instance.new("UIPadding",sf)
    pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,10)
    pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,10)
    local lay=Instance.new("UIListLayout",sf)
    lay.FillDirection=Enum.FillDirection.Vertical; lay.Padding=UDim.new(0,5)
    sf.Visible=false; return sf
end

local function secao(p,txt)
    local row=Instance.new("Frame",p); row.Size=UDim2.new(1,0,0,26); row.BackgroundTransparency=1; row.ZIndex=155
    local bar=Instance.new("Frame",row); bar.Size=UDim2.new(1,0,0,1); bar.Position=UDim2.new(0,0,1,-1)
    bar.BackgroundColor3=Color3.fromRGB(30,30,30); bar.BorderSizePixel=0; bar.ZIndex=155
    local lft=Instance.new("Frame",row); lft.Size=UDim2.new(0,3,0,14); lft.Position=UDim2.new(0,0,0,5)
    lft.BackgroundColor3=C_RED; lft.BorderSizePixel=0; lft.ZIndex=155
    Instance.new("UICorner",lft).CornerRadius=UDim.new(0,2)
    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
    l.BackgroundTransparency=1; l.Text=txt:upper()
    l.TextColor3=C_RED; l.Font=Enum.Font.GothamBlack
    l.TextSize=10; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=155
end

local function toggle(p,lbl,desc,getF,setF)
    local row=Instance.new("Frame",p); row.Size=UDim2.new(1,0,0,desc~="" and 46 or 38)
    row.BackgroundColor3=C_ROW; row.BorderSizePixel=0; row.ZIndex=155
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)
    local hl=Instance.new("UIStroke",row); hl.Color=Color3.fromRGB(28,28,28); hl.Thickness=1
    local tl=Instance.new("TextLabel",row); tl.Size=UDim2.new(1,-58,0,20)
    tl.Position=UDim2.new(0,10,0,desc~="" and 6 or 9)
    tl.BackgroundTransparency=1; tl.Text=lbl; tl.TextColor3=C_TEXT
    tl.Font=Enum.Font.GothamBold; tl.TextSize=12; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=156
    if desc~="" then
        local dl=Instance.new("TextLabel",row); dl.Size=UDim2.new(1,-58,0,14); dl.Position=UDim2.new(0,10,0,27)
        dl.BackgroundTransparency=1; dl.Text=desc; dl.TextColor3=C_SUBTEXT
        dl.Font=Enum.Font.Gotham; dl.TextSize=10; dl.TextXAlignment=Enum.TextXAlignment.Left; dl.ZIndex=156
    end
    local track=Instance.new("TextButton",row); track.Size=UDim2.new(0,46,0,24); track.Position=UDim2.new(1,-54,0.5,-12)
    track.BackgroundColor3=getF() and C_RED or Color3.fromRGB(32,32,32)
    track.Text=""; track.BorderSizePixel=0; track.AutoButtonColor=false; track.ZIndex=156
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,18,0,18)
    knob.Position=getF() and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; knob.ZIndex=157
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        local on=not getF(); setF(on)
        TS:Create(track,TweenInfo.new(0.14),{BackgroundColor3=on and C_RED or Color3.fromRGB(32,32,32)}):Play()
        TS:Create(knob,TweenInfo.new(0.14),{Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        TS:Create(hl,TweenInfo.new(0.14),{Color=on and C_REDFADE or Color3.fromRGB(28,28,28)}):Play()
    end)
    return track
end

local function slider(p,lbl,getF,setF,mn,mx,fmt)
    local row=Instance.new("Frame",p); row.Size=UDim2.new(1,0,0,52)
    row.BackgroundColor3=C_ROW; row.BorderSizePixel=0; row.ZIndex=155
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",row).Color=Color3.fromRGB(28,28,28)
    local tl=Instance.new("TextLabel",row); tl.Size=UDim2.new(0.6,0,0,18); tl.Position=UDim2.new(0,10,0,8)
    tl.BackgroundTransparency=1; tl.Text=lbl; tl.TextColor3=C_TEXT
    tl.Font=Enum.Font.GothamBold; tl.TextSize=12; tl.TextXAlignment=Enum.TextXAlignment.Left; tl.ZIndex=156
    local function fmt2(v)
        return fmt=="pct" and math.floor(v*100).."%"
            or fmt=="int" and tostring(math.floor(v))
            or string.format("%.3f",v)
    end
    local vl=Instance.new("TextLabel",row); vl.Size=UDim2.new(0.4,0,0,18); vl.Position=UDim2.new(0.6,0,0,8)
    vl.BackgroundTransparency=1; vl.Text=fmt2(getF()); vl.TextColor3=C_RED
    vl.Font=Enum.Font.GothamBlack; vl.TextSize=12; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.ZIndex=156
    local bg=Instance.new("TextButton",row); bg.Size=UDim2.new(1,-20,0,6); bg.Position=UDim2.new(0,10,0,36)
    bg.BackgroundColor3=Color3.fromRGB(28,28,28); bg.BorderSizePixel=0; bg.Text=""; bg.AutoButtonColor=false; bg.ZIndex=156
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local fp=math.clamp((getF()-mn)/(mx-mn),0,1)
    local fill=Instance.new("Frame",bg); fill.Size=UDim2.new(fp,0,1,0); fill.BackgroundColor3=C_RED
    fill.BorderSizePixel=0; fill.ZIndex=157; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local kn=Instance.new("Frame",bg); kn.Size=UDim2.new(0,14,0,14); kn.Position=UDim2.new(fp,-7,0.5,-7)
    kn.BackgroundColor3=Color3.new(1,1,1); kn.BorderSizePixel=0; kn.ZIndex=158
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
    local sl=false
    local function upd(pos)
        local rel=math.clamp((pos.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1)
        setF(mn+rel*(mx-mn)); fill.Size=UDim2.new(rel,0,1,0); kn.Position=UDim2.new(rel,-7,0.5,-7); vl.Text=fmt2(getF())
    end
    bg.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sl=true; upd(i.Position) end
    end)
    UIS.InputChanged:Connect(function(i)
        if not sl then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then upd(i.Position) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sl=false end
    end)
end

-- ============================================================
-- ABAS
-- ============================================================
local TABS_DEF={
    {k="Combat",  ico="âš”",  label="Combat"},
    {k="ESP",     ico="ðŸ‘",  label="ESP"},
    {k="Visual",  ico="âœ¦",  label="Visual"},
    {k="Move",    ico="âš¡",  label="Movimento"},
    {k="Musica",  ico="â™«",  label="Musica"},
    {k="Credits", ico="â˜…",  label="Creditos"},
}

local pages={}
local tabBtns={}
local activeTab="Combat"

local titles={Combat="COMBAT",ESP="ESP",Visual="VISUAL",Move="MOVIMENTO",Musica="MUSICA",Credits="CREDITOS"}

local function switchTab(key)
    activeTab=key
    for k,pg in pairs(pages) do pg.Visible=k==key end
    for k,b in pairs(tabBtns) do
        local on=k==key
        TS:Create(b,TweenInfo.new(0.15),{
            BackgroundColor3=on and C_RED or Color3.fromRGB(0,0,0),
            BackgroundTransparency=on and 0 or 1
        }):Play()
        b.TextColor3=on and Color3.new(1,1,1) or Color3.fromRGB(75,75,75)
    end
    hTitle.Text=titles[key] or key:upper()
end

-- Sidebar layout
local sideLayout=Instance.new("UIListLayout",sidebar)
sideLayout.FillDirection=Enum.FillDirection.Vertical
sideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
sideLayout.VerticalAlignment=Enum.VerticalAlignment.Top
sideLayout.Padding=UDim.new(0,4)
local sidePad=Instance.new("UIPadding",sidebar)
sidePad.PaddingTop=UDim.new(0,62); sidePad.PaddingBottom=UDim.new(0,8)
sidePad.PaddingLeft=UDim.new(0,4); sidePad.PaddingRight=UDim.new(0,4)

for _,def in ipairs(TABS_DEF) do
    pages[def.k]=makePage()
    local b=Instance.new("TextButton",sidebar)
    b.Size=UDim2.new(1,0,0,40)
    b.BackgroundColor3=def.k=="Combat" and C_RED or Color3.fromRGB(0,0,0)
    b.BackgroundTransparency=def.k=="Combat" and 0 or 1
    b.Text=def.ico; b.TextColor3=def.k=="Combat" and Color3.new(1,1,1) or Color3.fromRGB(75,75,75)
    b.Font=Enum.Font.GothamBold; b.TextSize=17
    b.BorderSizePixel=0; b.AutoButtonColor=false; b.ZIndex=153
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    tabBtns[def.k]=b
    -- Tooltip
    local tip=Instance.new("TextLabel",sgui)
    tip.Size=UDim2.new(0,90,0,24); tip.BackgroundColor3=Color3.fromRGB(14,14,14)
    tip.BorderSizePixel=0; tip.Text=def.label; tip.TextColor3=C_RED
    tip.Font=Enum.Font.GothamBold; tip.TextSize=10; tip.Visible=false; tip.ZIndex=9999
    Instance.new("UICorner",tip).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",tip).Color=C_REDFADE
    b.MouseEnter:Connect(function()
        local ap=b.AbsolutePosition; tip.Position=UDim2.new(0,ap.X+64,0,ap.Y+2); tip.Visible=true
    end)
    b.MouseLeave:Connect(function() tip.Visible=false end)
    b.MouseButton1Click:Connect(function() switchTab(def.k) end)
end

-- ============================================================
-- PREENCHER PÃGINAS
-- ============================================================

-- === COMBAT ===
do
    local sc=pages["Combat"]
    secao(sc,"Aimbot")
    toggle(sc,"Aimbot MagnÃ©tico","Trava automaticamente na cabeÃ§a mais prÃ³xima",
        function() return AIM_ON end,
        function(v) AIM_ON=v; notify("Aimbot",v and "Ativado" or "Desativado") end)
    toggle(sc,"Silent Aim","ProjÃ©til vai pra cabeÃ§a sem mover a cÃ¢mera",
        function() return SILENT_AIM end,
        function(v) SILENT_AIM=v; notify("Silent Aim",v and "Ativado" or "Desativado") end)
    toggle(sc,"Trigger Bot","Atira automaticamente ao mirar no inimigo",
        function() return TRIGGER_BOT end,
        function(v) TRIGGER_BOT=v; notify("Trigger Bot",v and "Ativado" or "Desativado") end)
    slider(sc,"Prediction",function() return PREDICTION end,function(v) PREDICTION=v end,0,0.5,nil)
    secao(sc,"Arma")
    toggle(sc,"No Recoil","Remove o coice/recuo da pistola",
        function() return NO_RECOIL end,
        function(v) NO_RECOIL=v; notify("No Recoil",v and "Ativado" or "Desativado") end)
    toggle(sc,"Auto Reload","Recarrega automaticamente ao zerar muniÃ§Ã£o",
        function() return AUTO_RELOAD end,
        function(v) AUTO_RELOAD=v; notify("Auto Reload",v and "Ativado" or "Desativado") end)
    secao(sc,"FOV")
    toggle(sc,"CÃ­rculo FOV","Mostra Ã¡rea de mira na tela",
        function() return FOV_ON end,function(v) FOV_ON=v end)
    slider(sc,"Tamanho FOV",function() return FOV_RADIUS end,function(v) FOV_RADIUS=v; fovCircle.Radius=v end,50,600,"int")
    secao(sc,"Visual Combat")
    toggle(sc,"Crosshair","Mira vermelha personalizada",
        function() return CROSSHAIR_ON end,function(v) CROSSHAIR_ON=v end)
    toggle(sc,"Tracers","Linhas atÃ© inimigos",
        function() return LINE_ON end,function(v) LINE_ON=v end)
end

-- === ESP ===
do
    local sc=pages["ESP"]
    secao(sc,"ESP")
    toggle(sc,"ESP Ligado","Ver inimigos atravÃ©s das paredes",
        function() return ESP_ON end,function(v) ESP_ON=v; refreshESP() end)
    toggle(sc,"Highlight Box","Contorno colorido no inimigo",
        function() return ESP_BOX end,function(v) ESP_BOX=v end)
    toggle(sc,"Nomes","Exibir nome do jogador",
        function() return ESP_NAME end,function(v) ESP_NAME=v end)
    toggle(sc,"DistÃ¢ncia","Mostrar distÃ¢ncia em metros",
        function() return ESP_DIST end,function(v) ESP_DIST=v end)
    toggle(sc,"SaÃºde HP","Mostrar porcentagem de vida",
        function() return ESP_HP end,function(v) ESP_HP=v end)
    toggle(sc,"Tracers","Linhas atÃ© cada inimigo",
        function() return LINE_ON end,function(v) LINE_ON=v end)
end

-- === VISUAL ===
do
    local sc=pages["Visual"]
    secao(sc,"IluminaÃ§Ã£o")
    toggle(sc,"FullBright","Deixa o mapa totalmente iluminado",
        function() return FBRIGHT end,
        function(v) FBRIGHT=v; if not v then local L=game:GetService("Lighting"); L.Brightness=1; L.GlobalShadows=true end
            notify("FullBright",v and "Ativado" or "Desativado") end)
    toggle(sc,"Sem Fog","Remove neblina/fog do mapa",
        function() return NO_FOG end,function(v) NO_FOG=v end)
    secao(sc,"HUD")
    toggle(sc,"Crosshair","Mira vermelha personalizada",
        function() return CROSSHAIR_ON end,function(v) CROSSHAIR_ON=v end)
    toggle(sc,"FOV Circle","CÃ­rculo de Ã¡rea de mira",
        function() return FOV_ON end,function(v) FOV_ON=v end)
    slider(sc,"Raio do FOV",function() return FOV_RADIUS end,function(v) FOV_RADIUS=v; fovCircle.Radius=v end,50,600,"int")
end

-- === MOVIMENTO ===
do
    local sc=pages["Move"]
    secao(sc,"Movimento")
    toggle(sc,"Speed Hack","Aumenta velocidade de corrida",
        function() return SPEED_ON end,
        function(v) SPEED_ON=v; notify("Speed",v and "Ativado ("..math.floor(SPEED_VAL)..")" or "Desativado") end)
    slider(sc,"Velocidade",function() return SPEED_VAL end,function(v) SPEED_VAL=v end,16,120,"int")
    toggle(sc,"Pulo Infinito","Pula sem parar",
        function() return INF_JUMP end,
        function(v) INF_JUMP=v; notify("Pulo Infinito",v and "Ativado" or "Desativado") end)
    toggle(sc,"Noclip","Atravessa paredes e objetos",
        function() return NOCLIP_ON end,
        function(v) NOCLIP_ON=v; notify("Noclip",v and "Ativado" or "Desativado") end)
    secao(sc,"ProteÃ§Ã£o")
    toggle(sc,"Anti-AFK","Evita kick por inatividade",
        function() return ANTI_AFK end,function(v) ANTI_AFK=v end)
end

-- === MÃšSICA ===
do
    local sc=pages["Musica"]
    secao(sc,"Player de MÃºsica")

    -- Card "Tocando agora"
    local npCard=Instance.new("Frame",sc); npCard.Size=UDim2.new(1,0,0,56)
    npCard.BackgroundColor3=Color3.fromRGB(16,16,16); npCard.BorderSizePixel=0; npCard.ZIndex=155
    Instance.new("UICorner",npCard).CornerRadius=UDim.new(0,8)
    local npStr=Instance.new("UIStroke",npCard); npStr.Color=Color3.fromRGB(50,30,10); npStr.Thickness=1
    local npN=Instance.new("TextLabel",npCard); npN.Size=UDim2.new(1,-12,0,22); npN.Position=UDim2.new(0,10,0,6)
    npN.BackgroundTransparency=1; npN.TextColor3=Color3.fromRGB(255,200,50)
    npN.Font=Enum.Font.GothamBold; npN.TextSize=12
    npN.TextXAlignment=Enum.TextXAlignment.Left; npN.TextTruncate=Enum.TextTruncate.AtEnd; npN.ZIndex=156
    local npC=Instance.new("TextLabel",npCard); npC.Size=UDim2.new(1,-12,0,14); npC.Position=UDim2.new(0,10,0,30)
    npC.BackgroundTransparency=1; npC.TextColor3=C_SUBTEXT
    npC.Font=Enum.Font.Gotham; npC.TextSize=10; npC.TextXAlignment=Enum.TextXAlignment.Left; npC.ZIndex=156

    local bPlay
    local function atuNP()
        local m=MUSICAS[MUSIC_IDX]
        npN.Text=(MUSIC_ON and "â–¶ " or "â–  ")..m.n; npC.Text=m.c.." Â· ID "..m.id
        if bPlay then
            bPlay.Text=MUSIC_ON and "â¸ PAUSE" or "â–¶ PLAY"
            bPlay.BackgroundColor3=MUSIC_ON and Color3.fromRGB(100,18,18) or C_RED
        end
    end
    atuNP()

    -- Controles player
    local ctRow=Instance.new("Frame",sc); ctRow.Size=UDim2.new(1,0,0,40); ctRow.BackgroundTransparency=1; ctRow.ZIndex=155
    local function mkB(txt,x,w,col)
        local b=Instance.new("TextButton",ctRow); b.Size=UDim2.new(0,w,1,0); b.Position=UDim2.new(0,x,0,0)
        b.BackgroundColor3=col or C_ROW; b.Text=txt
        b.TextColor3=C_TEXT; b.Font=Enum.Font.GothamBold; b.TextSize=12
        b.BorderSizePixel=0; b.AutoButtonColor=false; b.ZIndex=156
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,7); return b
    end

    local bPrev=mkB("â®",0,42)
    bPlay=mkB("â–¶ PLAY",48,180,C_RED); bPlay.TextColor3=Color3.new(1,1,1); bPlay.Font=Enum.Font.GothamBlack
    local bNext=mkB("â­",234,42)

    bPlay.MouseButton1Click:Connect(function()
        MUSIC_ON=not MUSIC_ON
        if MUSIC_ON then MSnd:Play(); if MUSIC_WORLD and WSnd then WSnd:Play() end
        else MSnd:Pause(); if WSnd then WSnd:Pause() end end; atuNP()
    end)
    bPrev.MouseButton1Click:Connect(function() tocarIdx(MUSIC_IDX-1); atuNP(); if MUSIC_ON then MSnd:Play() end end)
    bNext.MouseButton1Click:Connect(function() tocarIdx(MUSIC_IDX+1); atuNP(); if MUSIC_ON then MSnd:Play() end end)

    slider(sc,"Volume",function() return MUSIC_VOL end,function(v)
        MUSIC_VOL=v; MSnd.Volume=v; if WSnd then WSnd.Volume=math.min(v*2,1) end
    end,0,1,"pct")
    toggle(sc,"Loop","Repetir mÃºsica atual",
        function() return MUSIC_LOOP end,
        function(v) MUSIC_LOOP=v; MSnd.Looped=v; if WSnd then WSnd.Looped=v end end)
    toggle(sc,"Shuffle","Ordem aleatÃ³ria",
        function() return MUSIC_SHUF end,function(v) MUSIC_SHUF=v end)

    secao(sc,"World Sound")
    toggle(sc,"Todos Ouvem","Outros jogadores ouvem sua mÃºsica",
        function() return MUSIC_WORLD end,
        function(v) MUSIC_WORLD=v
            if v then worldAttach()
            else if WSnd then WSnd:Stop(); WSnd:Destroy(); WSnd=nil end end
        end)

    -- Separador categorias
    secao(sc,"Playlist Elite â€” "..#MUSICAS.." faixas")

    local lastCat=""
    for idx,m in ipairs(MUSICAS) do
        -- CabeÃ§alho de categoria
        if m.c~=lastCat then
            lastCat=m.c
            local catRow=Instance.new("Frame",sc); catRow.Size=UDim2.new(1,0,0,20); catRow.BackgroundTransparency=1; catRow.ZIndex=155
            local catL=Instance.new("TextLabel",catRow); catL.Size=UDim2.new(1,0,1,0)
            catL.BackgroundTransparency=1; catL.Text="â€” "..m.c.." â€”"
            catL.TextColor3=Color3.fromRGB(160,80,30); catL.Font=Enum.Font.GothamBold
            catL.TextSize=9; catL.ZIndex=156
        end

        local tb=Instance.new("TextButton",sc); tb.Size=UDim2.new(1,0,0,38)
        tb.BackgroundColor3=C_ROW; tb.BorderSizePixel=0; tb.AutoButtonColor=false; tb.ZIndex=155
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,7)
        local tbStr=Instance.new("UIStroke",tb); tbStr.Color=Color3.fromRGB(28,28,28); tbStr.Thickness=1

        local tn=Instance.new("TextLabel",tb); tn.Size=UDim2.new(0.85,0,0,18); tn.Position=UDim2.new(0,10,0,4)
        tn.BackgroundTransparency=1; tn.Text=idx..". "..m.n; tn.TextColor3=C_TEXT
        tn.Font=Enum.Font.GothamBold; tn.TextSize=11; tn.TextXAlignment=Enum.TextXAlignment.Left
        tn.TextTruncate=Enum.TextTruncate.AtEnd; tn.ZIndex=156

        local tc=Instance.new("TextLabel",tb); tc.Size=UDim2.new(1,-12,0,12); tc.Position=UDim2.new(0,10,0,22)
        tc.BackgroundTransparency=1; tc.Text=m.c; tc.TextColor3=C_SUBTEXT
        tc.Font=Enum.Font.Gotham; tc.TextSize=9; tc.TextXAlignment=Enum.TextXAlignment.Left; tc.ZIndex=156

        local playing=Instance.new("TextLabel",tb)
        playing.Size=UDim2.new(0,30,1,0); playing.Position=UDim2.new(1,-34,0,0)
        playing.BackgroundTransparency=1; playing.Text=""
        playing.TextColor3=C_RED; playing.Font=Enum.Font.GothamBold; playing.TextSize=14; playing.ZIndex=156

        local myIdx=idx
        tb.MouseButton1Click:Connect(function()
            MUSIC_ON=true; tocarIdx(myIdx); MSnd:Play()
            if MUSIC_WORLD and WSnd then WSnd:Play() end; atuNP()
        end)
        tb.MouseEnter:Connect(function()
            TS:Create(tb,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(24,24,24)}):Play()
            TS:Create(tbStr,TweenInfo.new(0.1),{Color=C_REDFADE}):Play()
        end)
        tb.MouseLeave:Connect(function()
            TS:Create(tb,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play()
            TS:Create(tbStr,TweenInfo.new(0.1),{Color=Color3.fromRGB(28,28,28)}):Play()
        end)
        -- Indicador de tocando agora (loop)
        RunService.Heartbeat:Connect(function()
            playing.Text=(MUSIC_IDX==myIdx and MUSIC_ON) and "â–¶" or ""
        end)
    end
end

-- === CRÃ‰DITOS ===
do
    local sc=pages["Credits"]
    secao(sc,"Sobre")

    local function creditCard(label, valor, cor)
        local row=Instance.new("Frame",sc); row.Size=UDim2.new(1,0,0,50)
        row.BackgroundColor3=C_ROW; row.BorderSizePixel=0; row.ZIndex=155
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
        if cor then
            local s=Instance.new("UIStroke",row); s.Color=cor; s.Thickness=1
        else
            Instance.new("UIStroke",row).Color=Color3.fromRGB(28,28,28)
        end
        local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,-12,0,18); lbl.Position=UDim2.new(0,12,0,6)
        lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C_SUBTEXT
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=156
        local vlL=Instance.new("TextLabel",row); vlL.Size=UDim2.new(1,-12,0,20); vlL.Position=UDim2.new(0,12,0,24)
        vlL.BackgroundTransparency=1; vlL.Text=valor; vlL.TextColor3=C_TEXT
        vlL.Font=Enum.Font.GothamBlack; vlL.TextSize=14; vlL.TextXAlignment=Enum.TextXAlignment.Left; vlL.ZIndex=156
    end

    creditCard("Script",     "LYNX AWS v12.0",         C_RED)
    creditCard("Autor",      "red_wolf12370",           C_RED)
    creditCard("Discord",    "ryan_ejsjseke")
    creditCard("Chave Key",  "kronos_pt")
    creditCard("Executor",   "Delta / Solara / Wave / Arceus X")
    creditCard("Jogo",       "Arena de Pistola  Â·  Roblox")

    secao(sc,"Funcionalidades v12.0")
    local funcs={
        "âœ”  Aimbot MagnÃ©tico (cabeÃ§a mais prÃ³xima)",
        "âœ”  Silent Aim (projÃ©til certeiro)",
        "âœ”  Trigger Bot (auto-ataque ao mirar)",
        "âœ”  No Recoil (sem recuo da pistola)",
        "âœ”  Auto Reload (muniÃ§Ã£o zerada = reload auto)",
        "âœ”  FOV Circle customizÃ¡vel",
        "âœ”  ESP (Box, Nome, DistÃ¢ncia, HP)",
        "âœ”  Tracers / Linhas",
        "âœ”  Crosshair personalizado",
        "âœ”  FullBright / Sem Fog",
        "âœ”  Speed Hack persistente",
        "âœ”  Pulo Infinito",
        "âœ”  Noclip",
        "âœ”  Anti-AFK",
        "âœ”  Playlist Elite 25 faixas (Trap/Funk/Phonk)",
        "âœ”  World Sound (todos ouvem)",
        "âœ”  Indicador de faixa tocando",
        "âœ”  NotificaÃ§Ãµes em tempo real",
        "âœ”  Loading Screen animado",
        "âœ”  Dashboard 550x350 com Sidebar",
        "âœ”  Drag no painel",
        "âœ”  Key System",
    }
    for _,f in ipairs(funcs) do
        local r=Instance.new("Frame",sc); r.Size=UDim2.new(1,0,0,24); r.BackgroundTransparency=1; r.ZIndex=155
        local l=Instance.new("TextLabel",r); l.Size=UDim2.new(1,0,1,0)
        l.BackgroundTransparency=1; l.Text=f; l.TextColor3=Color3.fromRGB(160,155,155)
        l.Font=Enum.Font.Gotham; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=156
    end

    -- Banner versÃ£o
    local verCard=Instance.new("Frame",sc); verCard.Size=UDim2.new(1,0,0,40)
    verCard.BackgroundColor3=C_RED; verCard.BackgroundTransparency=0.82; verCard.BorderSizePixel=0; verCard.ZIndex=155
    Instance.new("UICorner",verCard).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",verCard).Color=C_RED
    local verT=Instance.new("TextLabel",verCard); verT.Size=UDim2.new(1,0,1,0)
    verT.BackgroundTransparency=1; verT.Text="LYNX AWS v12.0  Â·  2025  Â·  red_wolf12370  Â·  ryan_ejsjseke"
    verT.TextColor3=C_RED; verT.Font=Enum.Font.GothamBold; verT.TextSize=10; verT.ZIndex=156
end

-- Ativar pÃ¡gina inicial
pages["Combat"].Visible=true

-- ============================================================
-- TOGGLE MENU
-- ============================================================
local menuVis=false
local function toggleMenu()
    if not keyDone then return end
    menuVis=not menuVis; Main.Visible=menuVis
    if menuVis then
        Main.BackgroundTransparency=1
        TS:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{BackgroundTransparency=0}):Play()
        wL1.Text="âœ•"; wL1.TextColor3=Color3.fromRGB(140,90,90); wL1.TextSize=22
        wL2.Text="Fechar"; wL2.TextColor3=Color3.fromRGB(90,60,60)
    else
        wL1.Text="LYNX"; wL1.TextColor3=C_RED; wL1.TextSize=17
        wL2.Text="AWS"; wL2.TextColor3=C_TEXT
    end
end

-- Drag botÃ£o + tap
local wD,wDS,wSP,wasTap,tapT=false,nil,nil,false,0
wBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        wD=true; wDS=i.Position; wSP=btnH.Position; wasTap=true; tapT=tick()
    end
end)
UIS.InputChanged:Connect(function(i)
    if not wD then return end
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        local dv=i.Position-wDS
        if dv.Magnitude>10 then wasTap=false end
        btnH.Position=UDim2.new(wSP.X.Scale,wSP.X.Offset+dv.X,wSP.Y.Scale,wSP.Y.Offset+dv.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        if wasTap and (tick()-tapT)<0.35 then toggleMenu() end
        wD=false; wasTap=false
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end
    if i.KeyCode==Enum.KeyCode.Delete then
        pcall(function() fovCircle:Remove() end)
        pcall(function() chH:Remove(); chV:Remove() end)
        for _,v in pairs(tracers) do pcall(function() v:Remove() end) end
        MSnd:Stop(); if WSnd then WSnd:Stop() end
        sgui:Destroy()
        notify("LYNX","Script encerrado",Color3.fromRGB(180,80,80))
    end
end)

-- ============================================================
print("â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—")
print("â•‘   LYNX AWS v12.0  - Carregado   â•‘")
print("â•‘   Autor:   red_wolf12370        â•‘")
print("â•‘   Discord: ryan_ejsjseke        â•‘")
print("â•‘   Key:     kronos_pt            â•‘")
print("â•‘   RShift = Abrir  |  Del = Sair â•‘")
print("â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•")
-- Sakura Key System (versión estable)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Parent más compatible
local parent = CoreGui
pcall(function()
	if gethui then parent = gethui() end
end)

-- Borrar anterior
pcall(function()
	local old = parent:FindFirstChild("SakuraKeyUI")
	if old then old:Destroy() end
end)

local screen = Instance.new("ScreenGui")
screen.Name = "SakuraKeyUI"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.DisplayOrder = 9999
screen.Parent = parent

-- Panel
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(300, 200)
main.Position = UDim2.new(0.5, -150, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🌸 Sakura Duels"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 140, 180)
title.Parent = main

-- Caja de texto
local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -40, 0, 40)
box.Position = UDim2.fromOffset(20, 60)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
box.BorderSizePixel = 0
box.PlaceholderText = "Escribe tu llave..."
box.Text = ""
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.TextColor3 = Color3.fromRGB(240, 240, 248)
box.ClearTextOnFocus = false
box.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = box

-- Botón
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 40)
btn.Position = UDim2.fromOffset(20, 115)
btn.BackgroundColor3 = Color3.fromRGB(255, 130, 170)
btn.BorderSizePixel = 0
btn.Text = "Verificar"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.fromRGB(20, 20, 28)
btn.AutoButtonColor = false
btn.Parent = main

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

-- Estado
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 25)
status.Position = UDim2.fromOffset(10, 165)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(150, 150, 165)
status.Parent = main

-- Lógica de la llave
local KEY = "1234"

local function check()
	local text = box.Text

	if text == KEY then
		status.Text = "Key correcta ✓"
		status.TextColor3 = Color3.fromRGB(100, 220, 150)
		btn.Text = "Entrando..."
		btn.Active = false

		task.wait(0.6)
		screen:Destroy()

		-- ============================
		-- AQUÍ VA TU SCRIPT PRINCIPAL
		-- ============================
		print("Acceso concedido")

	else
		status.Text = "Key incorrecta"
		status.TextColor3 = Color3.fromRGB(255, 90, 110)
	end
end

btn.MouseButton1Click:Connect(check)

box.FocusLost:Connect(function(enter)
	if enter then
		check()
	end
end)

print("Sakura Key UI cargado")

-- 🌸sakura duels🌸 INTRO test (do not edit)
(function()
  local ok,err=pcall(function()
    local pl=game:GetService("Players").LocalPlayer
    local pg=pl:WaitForChild("PlayerGui",10)
    if not pg then return end
    if pl:GetAttribute("SakuraDuelsSeen")==true then return end
    local Images={"rbxassetid://90082193310359","rbxassetid://140111217806195","rbxassetid://113259892662011","rbxassetid://131132202280501","rbxassetid://119205939792116"}
    local sg=Instance.new("ScreenGui") sg.Name="SakuraDuels_INTRO" sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.Parent=pg
    local fr=Instance.new("Frame",sg) fr.Size=UDim2.new(1,0,1,0) fr.BackgroundColor3=Color3.new(0,0,0)
    local title=Instance.new("TextLabel",fr) title.Size=UDim2.new(1,0,0,60) title.Position=UDim2.new(0,0,0,40) title.BackgroundTransparency=1 title.Text="🌸sakura duels🌸" title.TextColor3=Color3.fromRGB(255,105,180) title.Font=Enum.Font.GothamBlack title.TextSize=48 title.ZIndex=5
    local img=Instance.new("ImageLabel",fr) img.Size=UDim2.new(1,0,1,-100) img.Position=UDim2.new(0,0,0,100) img.BackgroundTransparency=1 img.ScaleType=Enum.ScaleType.Fit img.Image=Images[1] img.ZIndex=2
    local SKIP=false
    local skip=Instance.new("TextButton",fr) skip.Size=UDim2.new(0,160,0,50) skip.Position=UDim2.new(0.5,-80,1,-90) skip.BackgroundColor3=Color3.fromRGB(10,10,10) skip.Text="SKIP" skip.TextColor3=Color3.new(1,1,1) skip.Font=Enum.Font.GothamBlack skip.TextSize=20 skip.ZIndex=10
    local c=Instance.new("UICorner",skip) c.CornerRadius=UDim.new(0,10)
    local st=Instance.new("UIStroke",skip) st.Color=Color3.fromRGB(255,0,0) st.Thickness=2
    skip.MouseButton1Click:Connect(function() SKIP=true end)
    local startT=os.clock()
    task.spawn(function()
      for _,id in ipairs(Images) do
        if SKIP or os.clock()-startT>3 then break end
        pcall(function() img.Image=id end)
        task.wait(0.6)
      end
      pcall(function() pl:SetAttribute("SakuraDuelsSeen",true) end)
      pcall(function() sg:Destroy() end)
    end)
  end)
end)()

-- SakuraDuels
-- Black & White theme, auto grab with half mode, old progress bar.
-- Linia ESP (white lines) and Player Tracers (cyan) fully working.
repeat task.wait() until game:IsLoaded()

-- ============================================================
-- ANTI-RAGDOLL MODULE (from Dependencies.txt)
-- ============================================================
local AntiRagdoll = {
    Enabled = false,
    Mode = "Splatter",          -- "Splatter" or "No Splatter"
    Connection = nil,
    NoSplatterCooldown = 0,
}

-- Force reset (No Splatter mode)
function AntiRagdoll:forceNoSplatterReset()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local CM = require(PM:FindFirstChild("ControlModule"))
            if CM then CM:Enable() end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

-- Start the anti‑ragdoll loop
function AntiRagdoll:Start()
    if self.Connection then return end
    self.Connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not self.Enabled then return end

        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        -- No Splatter: hard reset with cooldown
        if self.Mode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - self.NoSplatterCooldown > 0.15 then
                    self.NoSplatterCooldown = now
                    self:forceNoSplatterReset()
                end
            end
            return
        end

        -- Splatter mode: destroy constraints and reset state
        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end

        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)

            -- Remove ragdoll joints
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end

            -- Re‑enable all Motor6D joints
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end

            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end

            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function AntiRagdoll:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end
-- ============================================================

local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS,CS = 60,29
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
local _autoBatTarget = nil
local resetAutoBatMotion = nil
local _batSwingCooldown = 0
local BAT_SWING_INTERVAL = 0.08
local AUTO_BAT_SPEED = 60
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil

local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPConn = nil
local setAutoTPVisual = nil
local autoTPEnabled = false
local autoTPHeight = 8
local AUTO_TP_Y = -7.00

-- Default UI scale is 75% (0.75)
local uiScale = 0.75

local function canUseAutoPath()
    return true
end

local function forceWalkSpeed()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed < 30 then
            hum.WalkSpeed = 30
        end
    end
end
game:GetService("RunService").Heartbeat:Connect(forceWalkSpeed)

-- Blacklist check (kept for safety)
task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    local function httpGet(url)
        local methods={
            function() return game:HttpGet(url) end,
            function() return HS:GetAsync(url) end,
            function() return syn.request({Url=url,Method="GET"}).Body end,
            function() return http_request({Url=url,Method="GET"}).Body end,
            function() return request({Url=url,Method="GET"}).Body end
        }
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and result then return result end
        end
        return nil
    end
    while task.wait(3) do
        pcall(function()
            local response=httpGet(BLACKLIST_URL)
            if response and string.find(response,tostring(LP.UserId),1,true) then
                LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
                task.wait(999999)
            end
        end)
    end
end)

-- Insta Reset
local RESET_MAX_DURATION = 0.05
local resetCooldown = false
local resetThread = nil
local currentCharacter = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil

local function ResetPlayer()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false
    local character = LP.Character
    if not character then resetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end
    local camera = workspace.CurrentCamera
    if camera then
        lockedCameraCFrame = camera.CFrame
        cameraLocked = true
        camera.CFrame = lockedCameraCFrame
    end
    currentCharacter = character
    local isRespawning = false
    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight
        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)
            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end
            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end
        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end
        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
        cameraLocked = false
        resetCooldown = false
        resetThread = nil
        currentCharacter = nil
        stopResetSequence = false
    end)
end

local function StopResetSequence()
    stopResetSequence = true
    if resetThread then
        task.cancel(resetThread)
        resetThread = nil
    end
    resetCooldown = false
    currentCharacter = nil
    cameraLocked = false
    local character = LP.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

LP.CharacterAdded:Connect(function()
    StopResetSequence()
    resetCooldown = false
    currentCharacter = nil
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false
end)

task.spawn(function()
    local camera = workspace.CurrentCamera
    while true do
        task.wait(0.016)
        if cameraLocked and lockedCameraCFrame and camera then
            camera.CFrame = lockedCameraCFrame
        end
    end
end)

local function cursedInstaReset()
    ResetPlayer()
end

_G.FrameResetLite = {
    Reset = ResetPlayer,
    Stop = StopResetSequence,
}

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X},
    AutoLeft    ={kb=Enum.KeyCode.Z},
    AutoRight   ={kb=Enum.KeyCode.C},
    AutoBat     ={kb=Enum.KeyCode.E},
    TPFloor     ={kb=Enum.KeyCode.F},
    InstaReset  ={kb=Enum.KeyCode.T},
    GuiHide     ={kb=Enum.KeyCode.LeftControl},
    SpeedToggle ={kb=Enum.KeyCode.Q},
    LaggerToggle={kb=Enum.KeyCode.R},
    Aimbot2={kb=Enum.KeyCode.V},
    AntiDesyncAimbot={kb=Enum.KeyCode.B}
}

-- Controller support: these mappings work alongside the keyboard binds above.
-- They use standard Roblox gamepad inputs and do not replace keyboard controls.
local GAMEPAD_BINDS = {
    DropBrainrot = Enum.KeyCode.ButtonA,
    AutoLeft     = Enum.KeyCode.DPadLeft,
    AutoRight    = Enum.KeyCode.DPadRight,
    AutoBat      = Enum.KeyCode.ButtonR2,
    TPFloor      = Enum.KeyCode.ButtonX,
    InstaReset   = Enum.KeyCode.ButtonY,
    GuiHide      = Enum.KeyCode.ButtonStart,
    SpeedToggle  = Enum.KeyCode.ButtonL2,
    LaggerToggle = Enum.KeyCode.ButtonB,
}

-- Working Roblox catalog-based Ninja movement pack.
-- Roblox documents these asset IDs as the Ninja animation set.
local ANIMATION_PACK_ENABLED = true
local ANIMATION_PACK_NAME = "Ninja"
local ANIMATION_PACK = {
    idle1 = "rbxassetid://656117400",
    idle2 = "rbxassetid://656118341",
    walk  = "rbxassetid://656121766",
    run   = "rbxassetid://656118852",
    jump  = "rbxassetid://656117878",
    fall  = "rbxassetid://656115606",
    climb = "rbxassetid://656114359",
}

local AP_L1,AP_L2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local AP_R1,AP_R2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)

-- Steal system (half autograb)
local Steal = {
    AutoStealEnabled=true,
    StealRadius=55,
    StealDuration=0.1,
    Mode="v1",
    HalfFireRange=10,
    HalfHoldMin=1.3,
    HalfHoldMax=2.6,
    HalfEntryDelay=0.3,
    Data={}
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil

local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot=plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled==true
        end
    end
    return false
end

local function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
            local pods=plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _,pod in ipairs(pods:GetChildren()) do
                    local base=pod:FindFirstChild("Base")
                    local sp=base and base:FindFirstChild("Spawn")
                    if sp then
                        local d=(sp.Position-root.Position).Magnitude
                        if d<=Steal.StealRadius and d<dist then
                            local found=nil
                            local att=sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _,pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end
                                end
                            end
                            if not found then
                                for _,pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end
                                end
                            end
                            if found then nearest,dist=found,d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function _promptDist(prompt)
    local char=LP.Character
    if not char then return math.huge end
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part=prompt.Parent
    if part and part:IsA("Attachment") then part=part.Parent end
    if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
    local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf-root.Position).Magnitude end
    return math.huge
end

local function executeStealV1(prompt)
    -- V1: normal ProximityPrompt activation with a safe fallback.
    if not prompt or not prompt.Parent then return false end

    local fired = false
    pcall(function()
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
            fired = true
        end
    end)

    if not fired then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(math.max(Steal.StealDuration, 0.1))
            prompt:InputHoldEnd()
            fired = true
        end)
    end

    return fired
end

local function executeStealV2(prompt)
    -- V2: the existing half-hold timing, kept as a separate mode.
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}

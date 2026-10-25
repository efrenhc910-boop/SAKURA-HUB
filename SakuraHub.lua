--=============================================================
--  SAKURA SCRIPTS  ·  v1.1 (más estable)
--=============================================================

local success, err = pcall(function()

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- Esperar a que el jugador exista
if not LocalPlayer then
	LocalPlayer = Players.PlayerAdded:Wait()
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

-- Colores
local C = {
	bg      = Color3.fromRGB(14, 14, 16),
	panel   = Color3.fromRGB(22, 22, 26),
	panel2  = Color3.fromRGB(32, 32, 38),
	text    = Color3.fromRGB(245, 245, 250),
	dim     = Color3.fromRGB(145, 145, 160),
	accent  = Color3.fromRGB(255, 145, 175),
}

-- Limpiar versión anterior
pcall(function()
	for _, v in ipairs({PlayerGui, CoreGui}) do
		local old = v:FindFirstChild("SakuraScripts")
		if old then old:Destroy() end
	end
end)

----------------------------------------------------------------
-- Parent seguro
----------------------------------------------------------------
local function getParent()
	local ok, gui = pcall(function()
		if gethui then return gethui() end
		if get_hidden_gui then return get_hidden_gui() end
		return nil
	end)
	if ok and gui then return gui end

	-- syn
	if syn and syn.protect_gui then
		local sg = Instance.new("ScreenGui")
		syn.protect_gui(sg)
		sg.Parent = CoreGui
		return sg
	end

	return PlayerGui
end

local parentGui = getParent()

local screen = Instance.new("ScreenGui")
screen.Name = "SakuraScripts"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.DisplayOrder = 999
screen.Parent = parentGui

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local function new(class, props)
	local obj = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			obj[k] = v
		end
	end
	return obj
end

local function corner(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = obj
	return c
end

----------------------------------------------------------------
-- Estado
----------------------------------------------------------------
local State = {
	InfiniteJump = false,
	WalkSpeed    = 16,
	ESP          = false,
	ESPColor     = C.accent,
	Fly          = false,
}

----------------------------------------------------------------
-- Walk Speed
----------------------------------------------------------------
local function applyWalkSpeed()
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = State.WalkSpeed end
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyWalkSpeed()
end)

----------------------------------------------------------------
-- Infinite Jump
----------------------------------------------------------------
local jumpConn
local function setInfiniteJump(on)
	if jumpConn then
		jumpConn:Disconnect()
		jumpConn = nil
	end
	if on then
		jumpConn = UserInputService.JumpRequest:Connect(function()
			local char = LocalPlayer.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end)
	end
end

----------------------------------------------------------------
-- Fly
----------------------------------------------------------------
local flyConn, flyBV, flyBG

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end

local function setFly(on)
	stopFly()
	if not on then return end

	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum  = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end

	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = root

	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBG.P = 9e4
	flyBG.Parent = root

	hum.PlatformStand = true

	flyConn = RunService.RenderStepped:Connect(function()
		if not State.Fly or not root.Parent then
			stopFly()
			State.Fly = false
			return
		end
		local cam = Camera.CFrame
		local move = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end

		flyBV.Velocity = move.Magnitude > 0 and move.Unit * 55 or Vector3.zero
		flyBG.CFrame = CFrame.new(root.Position, root.Position + cam.LookVector)
	end)
end

----------------------------------------------------------------
-- ESP
----------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Folder"
espFolder.Parent = screen

local function clearESP()
	espFolder:ClearAllChildren()
end

local function createESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end

	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = State.ESPColor
	hl.OutlineColor = State.ESPColor
	hl.FillTransparency = 0.65
	hl.OutlineTransparency = 0.2
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = espFolder

	local bb = Instance.new("BillboardGui")
	bb.Adornee = head
	bb.Size = UDim2.fromOffset(100, 24)
	bb.StudsOffset = Vector3.new(0, 2.4, 0)
	bb.AlwaysOnTop = true
	bb.Parent = espFolder

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, 0, 1, 0)
	txt.BackgroundTransparency = 1
	txt.Text = plr.DisplayName
	txt.TextColor3 = State.ESPColor
	txt.TextStrokeTransparency = 0.5
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 12
	txt.Parent = bb
end

local function refreshESP()
	clearESP()
	if State.ESP then
		for _, p in ipairs(Players:GetPlayers()) do
			createESP(p)
		end
	end
end

local function setESPColor(col)
	State.ESPColor = col
	for _, obj in ipairs(espFolder:GetChildren()) do
		if obj:IsA("Highlight") then
			obj.FillColor = col
			obj.OutlineColor = col
		elseif obj:IsA("BillboardGui") then
			local t = obj:FindFirstChildOfClass("TextLabel")
			if t then t.TextColor3 = col end
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if State.ESP then
			task.wait(0.8)
			createESP(p)
		end
	end)
end)

----------------------------------------------------------------
-- UI
----------------------------------------------------------------
-- Botón flotante
local btn = new("TextButton", {
	Parent = screen,
	Name = "OpenBtn",
	Position = UDim2.new(0, 20, 0.35, 0),
	Size = UDim2.fromOffset(52, 52),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Text = "🌸",
	TextSize = 22,
	AutoButtonColor = false,
	ZIndex = 50,
})
corner(btn, 26)

local btnStroke = new("UIStroke", {
	Parent = btn,
	Color = C.accent,
	Thickness = 2,
	Transparency = 0.3,
})

-- Ventana
local main = new("Frame", {
	Parent = screen,
	Name = "Main",
	Position = UDim2.new(0, 20, 0.35, 65),
	Size = UDim2.fromOffset(270, 400),
	BackgroundColor3 = C.bg,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 40,
})
corner(main, 12)

new("UIStroke", {
	Parent = main,
	Color = Color3.fromRGB(55, 55, 65),
	Thickness = 1,
})

-- Header
local header = new("Frame", {
	Parent = main,
	Size = UDim2.new(1, 0, 0, 50),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	ZIndex = 41,
})
corner(header, 12)

new("Frame", { -- fix bottom corners of header
	Parent = header,
	Position = UDim2.new(0, 0, 1, -12),
	Size = UDim2.new(1, 0, 0, 12),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	ZIndex = 41,
})

new("TextLabel", {
	Parent = header,
	Position = UDim2.fromOffset(16, 9),
	Size = UDim2.fromOffset(180, 18),
	BackgroundTransparency = 1,
	Text = "SAKURA SCRIPTS",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 42,
})

new("TextLabel", {
	Parent = header,
	Position = UDim2.fromOffset(16, 27),
	Size = UDim2.fromOffset(180, 14),
	BackgroundTransparency = 1,
	Text = "elegant utilities",
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextColor3 = C.dim,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 42,
})

local close = new("TextButton", {
	Parent = header,
	Position = UDim2.new(1, -38, 0.5, -11),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.panel2,
	BorderSizePixel = 0,
	Text = "×",
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextColor3 = C.dim,
	AutoButtonColor = false,
	ZIndex = 42,
})
corner(close, 6)

-- Body
local body = new("Frame", {
	Parent = main,
	Position = UDim2.fromOffset(0, 54),
	Size = UDim2.new(1, 0, 1, -54),
	BackgroundTransparency = 1,
	ZIndex = 41,
})

local function label(y, text)
	new("TextLabel", {
		Parent = body,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 14),
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = C.dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 42,
	})
end

local function switch(y, name, callback)
	local on = false
	local row = new("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 28),
		BackgroundTransparency = 1,
		ZIndex = 42,
	})

	new("TextLabel", {
		Parent = row,
		Size = UDim2.new(1, -48, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 42,
	})

	local track = new("TextButton", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(36, 19),
		BackgroundColor3 = C.panel2,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 42,
	})
	corner(track, 10)

	local knob = new("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(13, 13),
		BackgroundColor3 = Color3.new(1,1,1),
		BorderSizePixel = 0,
		ZIndex = 43,
	})
	corner(knob, 7)

	track.MouseButton1Click:Connect(function()
		on = not on
		TweenService:Create(track, TweenInfo.new(0.15), {
			BackgroundColor3 = on and C.accent or C.panel2
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = UDim2.new(0, on and 20 or 3, 0.5, 0)
		}):Play()
		callback(on)
	end)
end

local function slider(y, name, minV, maxV, def, callback)
	local row = new("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 42),
		BackgroundTransparency = 1,
		ZIndex = 42,
	})

	new("TextLabel", {
		Parent = row,
		Size = UDim2.new(0.6, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = name,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 42,
	})

	local val = new("TextLabel", {
		Parent = row,
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = tostring(def),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = C.accent,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 42,
	})

	local track = new("Frame", {
		Parent = row,
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 5),
		BackgroundColor3 = C.panel2,
		BorderSizePixel = 0,
		ZIndex = 42,
	})
	corner(track, 3)

	local fill = new("Frame", {
		Parent = track,
		Size = UDim2.new((def-minV)/(maxV-minV), 0, 1, 0),
		BackgroundColor3 = C.accent,
		BorderSizePixel = 0,
		ZIndex = 43,
	})
	corner(fill, 3)

	local knob = new("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new((def-minV)/(maxV-minV), 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Color3.new(1,1,1),
		BorderSizePixel = 0,
		ZIndex = 44,
	})
	corner(knob, 6)

	local hold = false
	local function update(x)
		local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		fill.Size = UDim2.new(r, 0, 1, 0)
		knob.Position = UDim2.new(r, 0, 0.5, 0)
		local v = math.floor(minV + (maxV - minV) * r + 0.5)
		val.Text = tostring(v)
		callback(v)
	end

	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			hold = true
			update(i.Position.X)
		end
	end)
	knob.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			hold = true
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if hold and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			update(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			hold = false
		end
	end)
end

-- Controles
label(6, "MOVEMENT")
switch(24, "Infinite Jump", function(v)
	State.InfiniteJump = v
	setInfiniteJump(v)
end)
switch(56, "Fly", function(v)
	State.Fly = v
	setFly(v)
end)
slider(90, "Walk Speed", 16, 250, 16, function(v)
	State.WalkSpeed = v
	applyWalkSpeed()
end)

label(150, "VISION")
switch(168, "ESP", function(v)
	State.ESP = v
	refreshESP()
end)

-- Colores ESP
new("TextLabel", {
	Parent = body,
	Position = UDim2.fromOffset(16, 206),
	Size = UDim2.new(1, -32, 0, 14),
	BackgroundTransparency = 1,
	Text = "ESP Color",
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 42,
})

local cols = {
	Color3.fromRGB(255, 145, 175),
	Color3.fromRGB(255, 100, 130),
	Color3.fromRGB(120, 190, 255),
	Color3.fromRGB(120, 255, 170),
	Color3.fromRGB(255, 210, 100),
	Color3.fromRGB(240, 240, 245),
}

local activeStroke
for i, col in ipairs(cols) do
	local b = new("TextButton", {
		Parent = body,
		Position = UDim2.fromOffset(16 + (i-1)*38, 226),
		Size = UDim2.fromOffset(30, 24),
		BackgroundColor3 = col,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 42,
	})
	corner(b, 5)
	local st = new("UIStroke", {
		Parent = b,
		Color = Color3.new(1,1,1),
		Thickness = 2,
		Transparency = i == 1 and 0 or 1,
	})
	if i == 1 then activeStroke = st end

	b.MouseButton1Click:Connect(function()
		if activeStroke then activeStroke.Transparency = 1 end
		st.Transparency = 0
		activeStroke = st
		setESPColor(col)
	end)
end

new("TextLabel", {
	Parent = body,
	Position = UDim2.fromOffset(0, 270),
	Size = UDim2.new(1, 0, 0, 18),
	BackgroundTransparency = 1,
	Text = "Right Shift  ·  toggle menu",
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextColor3 = C.dim,
	ZIndex = 42,
})

----------------------------------------------------------------
-- Drag + Toggle
----------------------------------------------------------------
local open = false

local function toggle()
	open = not open
	main.Visible = open
end

-- Drag del botón
do
	local dragging, moved, start, startPos
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			start = input.Position
			startPos = btn.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - start
			if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then moved = true end
			btn.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging and not moved then toggle() end
			dragging = false
		end
	end)
end

-- Drag de la ventana
do
	local dragging, start, startPos
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = input.Position
			startPos = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - start
			main.Position = UDim2.new(0, startPos.X.Offset + d.X, 0, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

close.MouseButton1Click:Connect(function()
	open = false
	main.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)

-- Notificación de carga
local notif = new("TextLabel", {
	Parent = screen,
	Position = UDim2.new(0.5, -100, 0.1, 0),
	Size = UDim2.fromOffset(200, 32),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	Text = "Sakura Scripts loaded",
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextColor3 = C.accent,
	ZIndex = 100,
})
corner(notif, 8)

task.delay(2.5, function()
	if notif then notif:Destroy() end
end)

-- Abrir al inicio
toggle()

print("[Sakura Scripts] Loaded successfully")

end)

if not success then
	warn("[Sakura Scripts] Error:", err)
end
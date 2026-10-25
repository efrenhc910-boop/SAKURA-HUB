--=============================================================
--  DELTA UI  ·  menú flotante + funciones
--  · Walk Speed · Infinite Jump · ESP
--=============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local PlayerGui        = Players.LocalPlayer:WaitForChild("PlayerGui")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer

local T = {
	accentA = Color3.fromRGB(158, 118, 255),
	accentB = Color3.fromRGB( 72, 202, 255),
	panel   = Color3.fromRGB(18, 18, 26),
	panelHi = Color3.fromRGB(34, 34, 46),
	text    = Color3.fromRGB(240, 240, 248),
	dim     = Color3.fromRGB(136, 138, 156),
}

local prev = PlayerGui:FindFirstChild("DeltaUI")
if prev then prev:Destroy() end

----------------------------------------------------------------
-- helpers
----------------------------------------------------------------
local function new(class, props, children)
	local o = Instance.new(class)
	local parent = props and props.Parent
	for k, v in pairs(props or {}) do
		if k \~= "Parent" then o[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = o end
	if parent then o.Parent = parent end
	return o
end

local function round(o, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r), Parent = o })
end

local function gradient(o, a, b, rot)
	return new("UIGradient", {
		ColorSequence = ColorSequence.new(a, b),
		Rotation = rot or 45,
		Parent = o,
	})
end

local function dragify(handle, target, onTap)
	target = target or handle
	local dragging, moved, startInput, startPos = false, false, nil, nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging, moved = true, false
			startInput = input.Position
			startPos   = target.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType \~= Enum.UserInputType.MouseMovement
		and input.UserInputType \~= Enum.UserInputType.Touch then return end
		local d = input.Position - startInput
		if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
		local vp = Camera.ViewportSize
		local sz = target.AbsoluteSize
		target.Position = UDim2.new(
			0, math.clamp(startPos.X.Offset + d.X, 0, math.max(0, vp.X - sz.X)),
			0, math.clamp(startPos.Y.Offset + d.Y, 0, math.max(0, vp.Y - sz.Y))
		)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			if not moved and onTap then onTap() end
		end
	end)
end

----------------------------------------------------------------
-- ESTADO DE LAS FUNCIONES
----------------------------------------------------------------
local State = {
	AutoRun       = false,
	InfiniteJump  = false,
	WalkSpeed     = 16,
	ESP           = false,
	ShowFPS       = false,
}

----------------------------------------------------------------
-- WALK SPEED
----------------------------------------------------------------
local function applyWalkSpeed()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = State.WalkSpeed
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.3)
	applyWalkSpeed()
end)

----------------------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------------------
local jumpConn
local function setInfiniteJump(enabled)
	if jumpConn then
		jumpConn:Disconnect()
		jumpConn = nil
	end
	if enabled then
		jumpConn = UserInputService.JumpRequest:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end

----------------------------------------------------------------
-- ESP (nombres + highlight)
----------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "DeltaESP"
espFolder.Parent = PlayerGui

local function clearESP()
	for _, v in ipairs(espFolder:GetChildren()) do
		v:Destroy()
	end
end

local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end

	local char = player.Character
	local head = char:FindFirstChild("Head")
	if not head then return end

	-- Highlight
	local highlight = Instance.new("Highlight")
	highlight.Name = player.Name
	highlight.Adornee = char
	highlight.FillColor = T.accentA
	highlight.OutlineColor = T.accentB
	highlight.FillTransparency = 0.7
	highlight.OutlineTransparency = 0.2
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = espFolder

	-- Nombre
	local billboard = Instance.new("BillboardGui")
	billboard.Name = player.Name .. "_Name"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(120, 30)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = espFolder

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = player.DisplayName
	label.TextColor3 = T.text
	label.TextStrokeTransparency = 0.4
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.Parent = billboard
end

local function refreshESP()
	clearESP()
	if not State.ESP then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		createESP(plr)
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if State.ESP then
			task.wait(0.5)
			createESP(plr)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	local h = espFolder:FindFirstChild(plr.Name)
	if h then h:Destroy() end
	local n = espFolder:FindFirstChild(plr.Name .. "_Name")
	if n then n:Destroy() end
end)

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local gui = new("ScreenGui", {
	Name = "DeltaUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 500,
	Parent = PlayerGui,
})

--===================== BOTÓN FLOTANTE =========================
local btn = new("TextButton", {
	Name = "FloatButton",
	Parent = gui,
	Position = UDim2.new(0, 36, 0, 150),
	Size = UDim2.fromOffset(56, 56),
	BackgroundColor3 = T.panel,
	BorderSizePixel = 0,
	Text = "", AutoButtonColor = false, Active = true,
	ZIndex = 10,
})
round(btn, 28)
gradient(new("UIStroke", {
	Color = T.text, Thickness = 1.4, Transparency = 0.5, Parent = btn,
}), T.accentA, T.accentB)

local halo = new("Frame", {
	Parent = btn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(96, 96),
	BackgroundColor3 = T.accentA,
	BackgroundTransparency = 0.9,
	BorderSizePixel = 0, ZIndex = 9,
})
round(halo, 48)

local lines = {}
for i = -1, 1 do
	local l = new("Frame", {
		Parent = btn,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, i * 7),
		Size = UDim2.fromOffset(20, 2),
		BackgroundColor3 = T.text,
		BorderSizePixel = 0, ZIndex = 11,
	})
	round(l, 1)
	lines[i] = l
end

--====================== VENTANA ===============================
local root = new("CanvasGroup", {
	Name = "Menu",
	Parent = gui,
	Position = UDim2.new(0, 36, 0, 220),
	Size = UDim2.fromOffset(300, 400),
	BackgroundTransparency = 1,
	GroupTransparency = 1,
	Visible = false,
	ZIndex = 3,
})
local pop = new("UIScale", { Scale = 0.9, Parent = root })

new("Frame", {
	Parent = root,
	Position = UDim2.fromOffset(0, 10),
	Size = UDim2.new(1, 0, 1, -10),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.55,
	BorderSizePixel = 0, ZIndex = 1,
}, { new("UICorner", { CornerRadius = UDim.new(0, 16) }) })

local main = new("Frame", {
	Name = "Main",
	Parent = root,
	Size = UDim2.new(1, 0, 1, -10),
	BackgroundColor3 = T.panel,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 2,
})
round(main, 16)
local mStroke = new("UIStroke", { Color = T.text, Thickness = 1.2, Transparency = 0.8, Parent = main })
new("UIGradient", {
	ColorSequence = ColorSequence.new(T.accentA, T.accentB),
	Rotation = 90,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 0.9),
	}),
	Parent = mStroke,
})

local sheen = new("Frame", {
	Parent = main,
	Size = UDim2.new(1, 0, 0, 130),
	BackgroundColor3 = T.accentA,
	BackgroundTransparency = 0.92,
	BorderSizePixel = 0, ZIndex = 2,
})
new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	}),
	Rotation = 90,
	Parent = sheen,
})

local accent = new("Frame", {
	Parent = main,
	Size = UDim2.new(1, 0, 0, 2),
	BackgroundColor3 = T.accentA,
	BorderSizePixel = 0, ZIndex = 3,
})
gradient(accent, T.accentA, T.accentB, 0)

--====================== CABECERA ==============================
local header = new("Frame", {
	Name = "Header",
	Parent = main,
	Position = UDim2.fromOffset(0, 2),
	Size = UDim2.new(1, 0, 0, 50),
	BackgroundTransparency = 1,
	Active = true, ZIndex = 4,
})

local dot = new("Frame", {
	Parent = header,
	Position = UDim2.fromOffset(16, 21),
	Size = UDim2.fromOffset(9, 9),
	BackgroundColor3 = T.accentA,
	BorderSizePixel = 0, ZIndex = 5,
})
round(dot, 5)
gradient(dot, T.accentA, T.accentB)

new("TextLabel", {
	Parent = header, BackgroundTransparency = 1,
	Position = UDim2.fromOffset(34, 11),
	Size = UDim2.fromOffset(150, 17),
	Font = Enum.Font.GothamBold, Text = "DELTA",
	TextSize = 14, TextColor3 = T.text,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
new("TextLabel", {
	Parent = header, BackgroundTransparency = 1,
	Position = UDim2.fromOffset(34, 27),
	Size = UDim2.fromOffset(150, 13),
	Font = Enum.Font.Gotham, Text = "movement · vision",
	TextSize = 10, TextColor3 = T.dim,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})

local function iconBtn(glyph, xo)
	local b = new("TextButton", {
		Parent = header,
		Position = UDim2.new(1, xo, 0.5, -13),
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = T.panelHi, BackgroundTransparency = 0.3,
		BorderSizePixel = 0, Text = glyph,
		Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = T.dim,
		AutoButtonColor = false, ZIndex = 6,
	})
	round(b, 8)
	return b
end

local minBtn   = iconBtn("–", -66)
local closeBtn = iconBtn("×", -36)

new("Frame", {
	Parent = main,
	Position = UDim2.fromOffset(0, 52),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = T.text, BackgroundTransparency = 0.9,
	BorderSizePixel = 0, ZIndex = 4,
})

--====================== CONTENIDO =============================
local body = new("Frame", {
	Name = "Body",
	Parent = main,
	Position = UDim2.fromOffset(0, 54),
	Size = UDim2.new(1, 0, 1, -84),
	BackgroundTransparency = 1, ZIndex = 4,
})

local function section(y, text)
	return new("TextLabel", {
		Parent = body, BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 13),
		Font = Enum.Font.GothamBold, Text = text,
		TextSize = 9.5, TextColor3 = T.dim,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
	})
end

local function rowSwitch(y, label, default, callback)
	local state = default
	local row = new("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 28),
		BackgroundTransparency = 1, Active = true, ZIndex = 5,
	})
	new("TextLabel", {
		Parent = row, BackgroundTransparency = 1,
		Size = UDim2.new(1, -52, 1, 0),
		Font = Enum.Font.Gotham, Text = label,
		TextSize = 12, TextColor3 = T.text,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
	})
	local track = new("TextButton", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(36, 19),
		BackgroundColor3 = state and T.accentA or T.panelHi,
		BorderSizePixel = 0, Text = "",
		AutoButtonColor = false, ZIndex = 5,
	})
	round(track, 10)
	local knob = new("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, state and 19 or 3, 0.5, 0),
		Size = UDim2.fromOffset(13, 13),
		BackgroundColor3 = T.text,
		BorderSizePixel = 0, ZIndex = 6,
	})
	round(knob, 7)

	track.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(track, TweenInfo.new(0.16), {
			BackgroundColor3 = state and T.accentA or T.panelHi,
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint), {
			Position = UDim2.new(0, state and 19 or 3, 0.5, 0),
		}):Play()
		if callback then callback(state) end
	end)
	return row
end

local function rowSlider(y, label, minV, maxV, default, callback)
	local row = new("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(16, y),
		Size = UDim2.new(1, -32, 0, 40),
		BackgroundTransparency = 1, ZIndex = 5,
	})
	new("TextLabel", {
		Parent = row, BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 15),
		Font = Enum.Font.Gotham, Text = label,
		TextSize = 12, TextColor3 = T.text,
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
	})
	local val = new("TextLabel", {
		Parent = row, BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 15),
		Font = Enum.Font.GothamBold, Text = tostring(default),
		TextSize = 11.5, TextColor3 = T.accentB,
		TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
	})
	local track = new("Frame", {
		Parent = row,
		Position = UDim2.fromOffset(0, 25),
		Size = UDim2.new(1, 0, 0, 5),
		BackgroundColor3 = T.panelHi,
		BorderSizePixel = 0, Active = true, ZIndex = 5,
	})
	round(track, 3)

	local rel0 = (default - minV) / (maxV - minV)
	local fill = new("Frame", {
		Parent = track,
		Size = UDim2.new(rel0, 0, 1, 0),
		BackgroundColor3 = T.accentA,
		BorderSizePixel = 0, ZIndex = 6,
	})
	round(fill, 3)
	gradient(fill, T.accentA, T.accentB, 0)

	local knob = new("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(rel0, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = T.text,
		BorderSizePixel = 0, Active = true, ZIndex = 7,
	})
	round(knob, 6)

	local dragging = false
	local function setFromX(absX)
		local rel = math.clamp((absX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		knob.Position = UDim2.new(rel, 0, 0.5, 0)
		local value = math.floor(minV + (maxV - minV) * rel + 0.5)
		val.Text = tostring(value)
		if callback then callback(value) end
	end

	local function grab(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end
	knob.InputBegan:Connect(grab)
	track.InputBegan:Connect(grab)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	return row
end

-- CONTROLES
section(6, "MOVEMENT")
rowSwitch(22, "Infinite Jump", false, function(on)
	State.InfiniteJump = on
	setInfiniteJump(on)
end)

rowSlider(54, "Walk Speed", 16, 250, 16, function(value)
	State.WalkSpeed = value
	applyWalkSpeed()
end)

section(110, "VISION")
rowSwitch(126, "ESP (Players)", false, function(on)
	State.ESP = on
	refreshESP()
end)

--====================== PIE ===================================
new("Frame", {
	Parent = main,
	Position = UDim2.new(0, 0, 1, -27),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = T.text, BackgroundTransparency = 0.9,
	BorderSizePixel = 0, ZIndex = 4,
})
new("TextLabel", {
	Parent = main, BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 1, -24),
	Size = UDim2.new(1, 0, 0, 20),
	Font = Enum.Font.Gotham, Text = "delta  ·  movement + vision",
	TextSize = 10, TextColor3 = T.dim, ZIndex = 4,
})

--====================== LÓGICA UI =============================
local isOpen, hideToken = false, 0
local TI = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function setMenu(state)
	isOpen = state
	hideToken += 1
	local token = hideToken
	if state then root.Visible = true end

	if state then
		local vp = Camera.ViewportSize
		local bp, bs = btn.AbsolutePosition, btn.AbsoluteSize
		local w, h = root.AbsoluteSize.X, root.AbsoluteSize.Y
		local x = math.clamp(bp.X, 8, math.max(8, vp.X - w - 8))
		local y = (bp.Y + bs.Y + 14 + h > vp.Y) and (bp.Y - h - 14) or (bp.Y + bs.Y + 14)
		root.Position = UDim2.fromOffset(x, math.clamp(y, 8, math.max(8, vp.Y - h - 8)))
	end

	TweenService:Create(root, TI, { GroupTransparency = state and 0 or 1 }):Play()
	TweenService:Create(pop, TI, { Scale = state and 1 or 0.88 }):Play()
	TweenService:Create(halo, TI, { BackgroundTransparency = state and 0.75 or 0.9 }):Play()
	TweenService:Create(lines[0], TI, { BackgroundTransparency = state and 1 or 0 }):Play()
	TweenService:Create(lines[-1], TI, {
		Rotation = state and 45 or 0,
		Position = UDim2.new(0.5, 0, 0.5, state and 0 or -7),
	}):Play()
	TweenService:Create(lines[1], TI, {
		Rotation = state and -45 or 0,
		Position = UDim2.new(0.5, 0, 0.5, state and 0 or 7),
	}):Play()

	if not state then
		task.delay(0.28, function()
			if token == hideToken then root.Visible = false end
		end)
	end
end

dragify(btn, nil, function() setMenu(not isOpen) end)
dragify(header, root)
closeBtn.MouseButton1Click:Connect(function() setMenu(false) end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	TweenService:Create(root, TI, {
		Size = minimized and UDim2.fromOffset(300, 62) or UDim2.fromOffset(300, 400),
	}):Play()
	TweenService:Create(minBtn, TI, { Text = minimized and "+" or "–" }):Play()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		setMenu(not isOpen)
	end
end)

setMenu(true)
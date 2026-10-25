-- =========================================================
--  SAKURA SCRIPTS - DELTA EXECUTOR (CON CLAVE ADMIN)
--  Sistema de Claves + Anti-pantallas dobles + Clave Admin
-- =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 0. EVITAR PANTALLAS DOBLES (Elimina instancias anteriores si las hay)
if LocalPlayer.PlayerGui:FindFirstChild("SakuraScriptsUI") then
    LocalPlayer.PlayerGui.SakuraScriptsUI:Destroy()
end
if gethui then
    for _, gui in ipairs(gethui():GetChildren()) do
        if gui.Name == "SakuraScriptsUI" then
            gui:Destroy()
        end
    end
end

-----------------------------------------------------------
-- 1. BASE DE DATOS DE CLAVES Y CONFIGURACIÓN DE ADMIN
-----------------------------------------------------------
local CLAVE_ADMIN = "SAKURA8000" -- Clave universal para administradores

local DatabaseClaves = {
    ["ELINSANIDINu"] = "1234",
    ["ELINSANIDINU"] = "1234", -- Soporte para variantes de mayúsculas
}

-----------------------------------------------------------
-- 2. CREACIÓN DE LA INTERFAZ (UI) ESTILO SAKURA
-----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SakuraScriptsUI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 260)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 22, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 25))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 130, 180)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Barra Superior (Title Bar)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Text = "🌸 Sakura Scripts | Key System"
TitleLabel.TextColor3 = Color3.fromRGB(255, 180, 210)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = TitleBar

-- Subtítulo / Información del Usuario
local UserInfoLabel = Instance.new("TextLabel")
UserInfoLabel.Size = UDim2.new(1, -30, 0, 20)
UserInfoLabel.Position = UDim2.new(0, 15, 0, 40)
UserInfoLabel.Text = "Usuario detectado: " .. LocalPlayer.Name
UserInfoLabel.TextColor3 = Color3.fromRGB(180, 160, 190)
UserInfoLabel.TextSize = 12
UserInfoLabel.Font = Enum.Font.Gotham
UserInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
UserInfoLabel.BackgroundTransparency = 1
UserInfoLabel.Parent = MainFrame

-- Etiqueta: "Pega tu llave" encima de la caja de texto
local InstructionLabel = Instance.new("TextLabel")
InstructionLabel.Size = UDim2.new(1, -30, 0, 18)
InstructionLabel.Position = UDim2.new(0, 15, 0, 68)
InstructionLabel.Text = "Pega tu llave"
InstructionLabel.TextColor3 = Color3.fromRGB(255, 150, 190)
InstructionLabel.TextSize = 12
InstructionLabel.Font = Enum.Font.GothamBold
InstructionLabel.TextXAlignment = Enum.TextXAlignment.Left
InstructionLabel.BackgroundTransparency = 1
InstructionLabel.Parent = MainFrame

-- Campo de Texto (Key Box)
local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(1, -30, 0, 38)
KeyInput.Position = UDim2.new(0, 15, 0, 88)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 30, 45)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ingresa tu clave aquí..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 100, 130)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = KeyInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(80, 50, 90)
InputStroke.Thickness = 1
InputStroke.Parent = KeyInput

-- Botón de Verificación
local VerifyButton = Instance.new("TextButton")
VerifyButton.Name = "VerifyButton"
VerifyButton.Size = UDim2.new(1, -30, 0, 40)
VerifyButton.Position = UDim2.new(0, 15, 0, 135)
VerifyButton.BackgroundColor3 = Color3.fromRGB(235, 100, 160)
VerifyButton.Text = "VERIFICAR CLAVE"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextSize = 13
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.AutoButtonColor = false
VerifyButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = VerifyButton

-- Mensaje de Estado
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -30, 0, 30)
StatusLabel.Position = UDim2.new(0, 15, 0, 180)
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

-- Firma de Ejecutor
local ExecutorLabel = Instance.new("TextLabel")
ExecutorLabel.Size = UDim2.new(1, 0, 0, 20)
ExecutorLabel.Position = UDim2.new(0, 0, 1, -22)
ExecutorLabel.Text = "Delta Executor Compatible ✨"
ExecutorLabel.TextColor3 = Color3.fromRGB(100, 80, 110)
ExecutorLabel.TextSize = 10
ExecutorLabel.Font = Enum.Font.Gotham
ExecutorLabel.BackgroundTransparency = 1
ExecutorLabel.Parent = MainFrame

-----------------------------------------------------------
-- 3. SISTEMA DE ARRASTRE (DRAGGABLE) SUAVE
-----------------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    TweenService:Create(MainFrame, TweenInfo.new(0.08), {
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    }):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-----------------------------------------------------------
-- 4. LÓGICA DE VERIFICACIÓN Y EJECUCIÓN
-----------------------------------------------------------
local function ValidarAcceso()
    local userActual = LocalPlayer.Name
    local claveIngresada = KeyInput.Text
    local claveCorrectaUsuario = DatabaseClaves[userActual]

    -- Verificamos si ingresó la clave Admin O la clave correspondiente a su usuario
    local esAdmin = (claveIngresada == CLAVE_ADMIN)
    local esUsuarioValido = (claveCorrectaUsuario and claveIngresada == claveCorrectaUsuario)

    if esAdmin or esUsuarioValido then
        StatusLabel.TextColor3 = Color3.fromRGB(120, 255, 150)
        if esAdmin then
            StatusLabel.Text = "✓ Acceso Admin Concedido. ¡Iniciando!"
        else
            StatusLabel.Text = "✓ Acceso Concedido. ¡Iniciando!"
        end
        
        -- Transición suave de salida del menú de claves
        task.wait(1)
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
        
        -----------------------------------------------------------
        -- ACÁ ABAJO EL RESTO DE TU CÓDIGO
        -----------------------------------------------------------
        loadstring(game:HttpGet("https://raw.githubusercontent.com/efrenhc910-boop/SAKURA-HUB/main/SakuraHub.lua"))()

    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.Text = "✕ Clave incorrecta."
    end
end

VerifyButton.MouseButton1Click:Connect(ValidarAcceso)

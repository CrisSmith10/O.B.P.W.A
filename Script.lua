local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === CREACIÓN DE LA INTERFAZ (GUI) ===
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FruitBtn = Instance.new("TextButton")
local HopBtn = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui") -- Para que no se borre al morir
ScreenGui.Name = "DeltaFruitMenu"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Para que puedas moverla con el dedo

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FRUIT HELPER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Botón para buscar frutas
FruitBtn.Name = "FruitBtn"
FruitBtn.Parent = MainFrame
FruitBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
FruitBtn.Size = UDim2.new(0.8, 0, 0, 40)
FruitBtn.Text = "Buscar y Recoger"
FruitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- Botón para cambiar de server
HopBtn.Name = "HopBtn"
HopBtn.Parent = MainFrame
HopBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
HopBtn.Size = UDim2.new(0.8, 0, 0, 40)
HopBtn.Text = "Server Hop"
HopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

--- === LÓGICA DE FUNCIONES ===

-- Función de Vuelo Suave (Tween) para evitar Kick
local function volarAFuuta(targetCFrame)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local distancia = (hrp.Position - targetCFrame.Position).Magnitude
        local velocidad = 100 -- Ajusta esto para ir más rápido o lento
        
        local info = TweenInfo.new(distancia / velocidad, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
        tween:Play()
    end
end

-- Lógica para buscar frutas en el Workspace
FruitBtn.MouseButton1Click:Connect(function()
    local encontrada = false
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:find("Fruit") then
            encontrada = true
            volarAFuuta(v.Handle.CFrame)
            print("Yendo por: " .. v.Name)
            break
        end
    end
    if not encontrada then print("No hay frutas en este server.") end
end)

-- Lógica de Server Hop
HopBtn.MouseButton1Click:Connect(function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

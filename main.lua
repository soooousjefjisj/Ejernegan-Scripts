--[[ 
    EJERNEGAN SCRIPTZ - ADVANCED V2
    Modules: ESP (Red Box), Advanced Noclip, Floor Spawner
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // SETTINGS & STATE
local ScriptConfig = {
    Noclip = false,
    ESPEnabled = true,
    BoxColor = Color3.fromRGB(255, 0, 0),
    Floors = {}
}

-- // UI CONSTRUCTION
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)

MainFrame.Name = "EjerneganMain"
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "EJERNEGAN V2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- // UI HELPER FUNCTION
local function CreateButton(name, text, pos, callback)
    local Btn = Instance.new("TextButton", MainFrame)
    local BtnCorner = Instance.new("UICorner", Btn)
    Btn.Name = name
    Btn.Size = UDim2.new(0, 160, 0, 35)
    Btn.Position = pos
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.AutoButtonColor = true
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- // ADVANCED NOCLIP LOGIC
local NoclipBtn = CreateButton("NoclipBtn", "Noclip: OFF", UDim2.new(0, 10, 0, 45), function()
    ScriptConfig.Noclip = not ScriptConfig.Noclip
    _G.NoclipBtn.Text = "Noclip: " .. (ScriptConfig.Noclip and "ON" or "OFF")
end)
_G.NoclipBtn = NoclipBtn

RunService.Stepped:Connect(function()
    if ScriptConfig.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- // ESP BOX SYSTEM (NO TRACERS)
local function CreateESP(Player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = ScriptConfig.BoxColor
    Box.Thickness = 1.5
    Box.Filled = false
    Box.Transparency = 1

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                local RootPart = Player.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

                if OnScreen and ScriptConfig.ESPEnabled then
                    local Size = (Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y)
                    Box.Size = Vector2.new(Size * 0.7, Size)
                    Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                    Box.Visible = true
                else
                    Box.Visible = false
                end
            else
                Box.Visible = false
                if not Player.Parent then
                    Box:Remove()
                    Connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateESP(v) end
end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- // FLOOR & CLEAR LOGIC
CreateButton("FloorBtn", "Spawn Floor", UDim2.new(0, 10, 0, 90), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local p = LocalPlayer.Character.HumanoidRootPart
        local floor = Instance.new("Part")
        floor.Parent = workspace
        floor.Size = Vector3.new(25, 1, 25)
        floor.CFrame = p.CFrame * CFrame.new(0, -3.5, 0)
        floor.Anchored = true
        floor.Material = Enum.Material.Neon
        floor.Color = Color3.fromRGB(255, 0, 0)
        table.insert(ScriptConfig.Floors, floor)
    end
end)

CreateButton("ClearBtn", "Clear All", UDim2.new(0, 10, 0, 135), function()
    for _, f in pairs(ScriptConfig.Floors) do
        if f then f:Destroy() end
    end
    ScriptConfig.Floors = {}
end)

-- // UI TOGGLE (Press 'K' to Hide/Show)
CreateButton("HideBtn", "Close UI", UDim2.new(0, 10, 0, 180), function()
    ScreenGui:Destroy()
end)

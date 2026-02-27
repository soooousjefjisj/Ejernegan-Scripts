-- ejernegan scriptz
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local NoclipBtn = Instance.new("TextButton")
local FloorBtn = Instance.new("TextButton")
local ClearBtn = Instance.new("TextButton")

-- Setup GUI
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -100)
MainFrame.Size = UDim2.new(0, 150, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true -- Makes it moveable

Title.Parent = MainFrame
Title.Text = "ejernegan scriptz"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.new(1, 1, 1)

-- Noclip Logic (Walls only)
local noclip = false
NoclipBtn.Parent = MainFrame
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.Position = UDim2.new(0, 10, 0, 40)
NoclipBtn.Size = UDim2.new(0, 130, 0, 30)
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                -- Disable collision with everything EXCEPT the floor/ground
                part.CanCollide = false 
            end
        end
    end
end)

-- Floor Logic
local floorParts = {}
FloorBtn.Parent = MainFrame
FloorBtn.Text = "Spawn Floor"
FloorBtn.Position = UDim2.new(0, 10, 0, 80)
FloorBtn.Size = UDim2.new(0, 130, 0, 30)
FloorBtn.MouseButton1Click:Connect(function()
    local p = game.Players.LocalPlayer.Character.HumanoidRootPart
    local floor = Instance.new("Part", workspace)
    floor.Size = Vector3.new(20, 1, 20)
    floor.CFrame = p.CFrame * CFrame.new(0, -3.5, 0)
    floor.Anchored = true
    floor.Name = "EjerneganFloor"
    table.insert(floorParts, floor)
end)

-- Clear Logic
ClearBtn.Parent = MainFrame
ClearBtn.Text = "Delete Floors"
ClearBtn.Position = UDim2.new(0, 10, 0, 120)
ClearBtn.Size = UDim2.new(0, 130, 0, 30)
ClearBtn.MouseButton1Click:Connect(function()
    for _, f in pairs(floorParts) do
        if f then f:Destroy() end
    end
    floorParts = {}
end)

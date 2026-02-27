-- ejernegan silent strike scriptz
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Silent Strike Hub",
   LoadingTitle = "Initializing Strike Systems...",
   LoadingSubtitle = "by ejernegan",
})

local Tab = Window:CreateTab("Combat", 4483362458)
local roundPlayers = {}

-- 1. Round Detection (Every 5 seconds)
task.spawn(function()
    while task.wait(5) do
        roundPlayers = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            -- Detects players currently in a round/match
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                table.insert(roundPlayers, player)
            end
        end
    end
end)

-- 2. ESP System (Automatic for new players)
local function applyESP(player)
    player.CharacterAdded:Connect(function(char)
        local highlight = Instance.new("Highlight")
        highlight.Parent = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do applyESP(p) end
game.Players.PlayerAdded:Connect(applyESP)

-- 3. Strike Button (Teleport & Kill)
Tab:CreateButton({
   Name = "Strike Nearest Player",
   Callback = function()
       local localPlayer = game.Players.LocalPlayer
       local closestPlayer = nil
       local shortestDistance = math.huge

       for _, player in pairs(roundPlayers) do
           if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
               if distance < shortestDistance then
                   closestPlayer = player
                   shortestDistance = distance
               end
           end
       end

       if closestPlayer then
           -- Teleport slightly behind them
           local targetPos = closestPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
           localPlayer.Character:PivotTo(targetPos)
           
           -- Trigger Kill (Damage/Health to 0)
           closestPlayer.Character.Humanoid.Health = 0
           Rayfield:Notify({Title = "Strike Successful", Content = "Target: " .. closestPlayer.Name, Duration = 3})
       else
           Rayfield:Notify({Title = "Error", Content = "No targets found in round!", Duration = 3})
       end
   end,
})

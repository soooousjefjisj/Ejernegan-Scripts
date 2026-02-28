-- ejernegan scriptz
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Silent Strike Hub",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by ejernegan",
})

local Tab = Window:CreateTab("Combat", 4483362458)

Tab:CreateButton({
   Name = "Strike Nearest",
   Callback = function()
       print("Strike button pressed!")
       -- (Your teleport logic goes here)
   end,
})

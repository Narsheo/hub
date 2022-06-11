--// Editted by Narsheo#2585 full credits to vozoid#1346, their Dicord Server: https://discord.gg/nXU47hnk




local services = setmetatable({}, {
    __index = function(_, service)
        return game:GetService(service)
    end
})

local client = services.Players.LocalPlayer

--// library

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/venus-library/main/eggmodified.lua", true))()

local commons = {}
local uncommons = {}
local rares = {}
local legends = {}
local myths = {}
local colors = {}

do
    local elements = services.ReplicatedStorage.Client.GetElements:InvokeServer()

    for _, tbl in next, elements do
        if type(tbl) == "table" then
            colors[tbl[1]] = tbl[3]
            if tbl[2] == "Common" then
                table.insert(commons, tbl[1])
            elseif tbl[2] == "Uncommon" then
                table.insert(uncommons, tbl[1])
            elseif tbl[2] == "Rare" then
                table.insert(rares, tbl[1])
            elseif tbl[2] == "Legend" then
                table.insert(legends, tbl[1])
            elseif tbl[2] == "Myth" then
                table.insert(myths, tbl[1])
            end
        end
    end
end

local found = false


local main = library:Load({Name = "EGG Auto Farm 2xEXP", Theme = "Dark", SizeX = 238, SizeY = 318, ColorOverrides = {}})
local aimbot = main:Tab("Main")
local section = aimbot:Section({Name = "Autofarm", column = 1})

section:Toggle({Name = "Level Farmer", Flag = "levelfarm", Callback = function(value)
    if value == false then 
        if client.Character and client.Character:FindFirstChild("Humanoid") then
            client.Character.Humanoid.Health = 0
        end
    end
end})

section:Toggle({Name = "Spinner", Flag = "elementfarm", Callback = function(value)
    if value == false then 
        if client.Character and client.Character:FindFirstChild("Humanoid") then
            client.Character.Humanoid.Health = 0
        end

        found = false 
    end
end})

local elements = {}
local chosencommon = {}
local chosenuncommon = {}
local chosenrare = {}
local chosenlegend = {}
local chosenmyth = {}

section:Label("Commons")

section:Dropdown({Content = commons, MultiChoice = true, Callback = function(tbl)
    for _, elem in next, tbl do
        elements[elem] = true
        chosencommon = tbl
        for chosen, _ in next, elements do
            if not table.find(chosencommon, chosen) and not table.find(chosenuncommon, chosen) and not table.find(chosenrare, chosen) and not table.find(chosenlegend, chosen) and not table.find(chosenmyth, chosen) then
                elements[chosen] = false
            end
        end
    end
end})

section:Label("Uncommons")

section:Dropdown({Content = uncommons, MultiChoice = true, Callback = function(tbl)
    for _, elem in next, tbl do
        elements[elem] = true
        chosenuncommon = tbl
        for chosen, _ in next, elements do
            if not table.find(chosencommon, chosen) and not table.find(chosenuncommon, chosen) and not table.find(chosenrare, chosen) and not table.find(chosenlegend, chosen) and not table.find(chosenmyth, chosen) then
                elements[chosen] = false
            end
        end
    end
end})

section:Label("Rares")

section:Dropdown({Content = rares, MultiChoice = true, Callback = function(tbl)
    for _, elem in next, tbl do
        elements[elem] = true
        chosenrare = tbl
        for chosen, _ in next, elements do
            if not table.find(chosencommon, chosen) and not table.find(chosenuncommon, chosen) and not table.find(chosenrare, chosen) and not table.find(chosenlegend, chosen) and not table.find(chosenmyth, chosen) then
                elements[chosen] = false
            end
        end
    end
end})

section:Label("Legends")

section:Dropdown({Content = legends, MultiChoice = true, Callback = function(tbl)
    for _, elem in next, tbl do
        elements[elem] = true
        chosenlegend = tbl
        for chosen, _ in next, elements do
            if not table.find(chosencommon, chosen) and not table.find(chosenuncommon, chosen) and not table.find(chosenrare, chosen) and not table.find(chosenlegend, chosen) and not table.find(chosenmyth, chosen) then
                elements[chosen] = false
            end
        end
    end
end})

section:Label("Myths")

section:Dropdown({Content = myths, MultiChoice = true, Callback = function(tbl)
    for _, elem in next, tbl do
        elements[elem] = true
        chosenmyth = tbl
        for chosen, _ in next, elements do
            if not table.find(chosencommon, chosen) and not table.find(chosenuncommon, chosen) and not table.find(chosenrare, chosen) and not table.find(chosenlegend, chosen) and not table.find(chosenmyth, chosen) then
                elements[chosen] = false
            end
        end
    end
end}) 

--// main

local moves = services.ReplicatedStorage[client.UserId .. "Client"]


local function domoves()
    for _, move in next, client.Backpack:GetChildren() do
        local str = move.Name:split(" (")[1]

        task.spawn(function()
            moves.StartMove:FireServer(str)
            moves.EndMove:FireServer(str)
        end)
    end
end

local function farmlevel()
    repeat
        if client.Character:WaitForChild("Humanoid").Health <= 0 then startgame() end
        domoves()
        task.wait(0.1)
        until 
            library.flags.levelfarm == false or client.Character:WaitForChild("Humanoid").Health <= 0
    end 

local I=2
local function farmspinlevel()
    repeat
        domoves()
        wait(0.1)
    until
       I>1 
end

local rolls = 0

local spin
spin = function()
    repeat
        local currentelement = services.ReplicatedStorage.Client.GetElement:InvokeServer()

        if elements[currentelement] then
            found = true

        else
            services.ReplicatedStorage.Client.Spin:InvokeServer()
            rolls = rolls + 1

            if elements[services.ReplicatedStorage.Client.GetElement:InvokeServer()] then
                return spin()
            end
        end

        task.wait(0.1)
    until
        library.flags.elementfarm == false or found or services.ReplicatedStorage.Client.GetSpins:InvokeServer() <= 0
end

local function startgame()
    services.ReplicatedStorage.Client.Teleport:InvokeServer()
    services.ReplicatedStorage.Client.Intro:InvokeServer()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    workspace.CurrentCamera.CameraSubject = client.Character.Humanoid
    client.PlayerGui.IntroGui.Enabled = false
    client.PlayerGui.Spinner.Enabled = false
    client.PlayerGui.StatsGui.Enabled = true
end


--// main loop

while task.wait(0.1) do
    if library.flags.elementfarm == true and not found then
        repeat
            startgame()
            task.wait(0.1)
        until 
            #client.Backpack:GetChildren() > 0

        farmspinlevel()
        client.Character.Humanoid.Health = 0
        repeat task.wait(0.1) until client.Character and client.Character:WaitForChild("Humanoid").Health > 0
        spin()
    end
    if library.flags.levelfarm == true or library.flags.elementfarm == found and library.flags.elementfarm == true then
        repeat task.wait(0.1) until client.Character and client.Character:WaitForChild("Humanoid").Health > 0
        
        repeat
            startgame()
            task.wait(0.1)
        until 
            #client.Backpack:GetChildren() > 0
            
        farmlevel()    
    end

end
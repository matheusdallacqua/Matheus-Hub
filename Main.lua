-- [[ MATHEUS HUB - ULTRA COMPLEX MAIN VERSION 2026 ]]
-- Powered by Matheus & OpenSource Community

-- === 1. CARREGAMENTO DA INTERFACE (RAYFIELD) ===
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === 2. LINKS DO REPOSITÓRIO GITHUB ===
local URLS = {
    Teleport = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua",
    Visual   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua",
    Fruits   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua",
    Farm     = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Farm.lua",
}

-- === 3. CARREGAMENTO SEGURO DOS MÓDULOS ===
local function GetModule(url)
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if success then return result else return nil end
end

local TeleportModule = GetModule(URLS.Teleport)
local VisualsModule  = GetModule(URLS.Visual)
local FruitsModule   = GetModule(URLS.Fruits)

-- === 4. DETECÇÃO DE DADOS DO JOGADOR ===
local PlaceID = game.PlaceId
local Player = game.Players.LocalPlayer
local CurrentSea = "Sea 1"

if PlaceID == 2753915549 then CurrentSea = "Sea 1"
elseif PlaceID == 4442272183 or PlaceID == 4442245441 then CurrentSea = "Sea 2"
elseif PlaceID == 7449423635 then CurrentSea = "Sea 3" end

-- Tabelas de Controle
local Select_World_Sea = CurrentSea
local Select_Island_Travelling = ""

local IslandNames = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Cafe", "Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Dark Arena"},
    ["Sea 3"] = {"Mansion", "Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats", "Tiki Outpost"}
}

-- === 5. CRIAÇÃO DA JANELA PRINCIPAL ===
local Window = Rayfield:CreateWindow({
   Name = "Matheus Hub | V2 Ultra Complex",
   LoadingTitle = "Iniciando Matheus Hub...",
   LoadingSubtitle = "by Matheus (2026 Edition)",
   ConfigurationSaving = { Enabled = true, FolderName = "MatheusHub", FileName = "MainConfig" },
   KeySystem = false
})

-- [[ 2ª ABA: FARM CONFIG ]]
local FarmConfigTab = Window:CreateTab("Farm Config", 4483362458) -- Ícone de engrenagem

local Section = FarmConfigTab:AddSection({
	Name = "Ajustes de Velocidade"
})

-- Lista que você definiu
local AttackList = {"0", "0.1", "0.175", "0.2", "0.25", "0.3", "0.35", "0.4", "0.45", "0.5", "0.55", "0.6", "0.65", "0.7", "0.75", "0.8", "0.85", "0.9", "0.95", "1"}

-- Dropdown exatamente como você pediu
FarmConfigTab:AddDropdown({
	Name = "FastAttack Delay",
	Default = "0.5",
	Options = AttackList,
    Flag = "FastAttack Delay",
    Save = true,
	Callback = function(Value)
		_G.FastAttackDelay = Value
	end    
})

-- O Loop exato do Opensource do Tsuo para converter o Delay
spawn(function()
    while wait(.1) do
        if _G.FastAttackDelay then
            pcall(function()
                if _G.FastAttackDelay == "0" then
                    _G.FastAttackDelay = 0
                elseif _G.FastAttackDelay == "0.1" then
                    _G.FastAttackDelay = 0.1
                elseif _G.FastAttackDelay == "0.175" then
                    _G.FastAttackDelay = 0.175
                elseif _G.FastAttackDelay == "0.2" then
                    _G.FastAttackDelay = 0.2
                elseif _G.FastAttackDelay == "0.25" then
                    _G.FastAttackDelay = 0.25
                elseif _G.FastAttackDelay == "0.3" then
                    _G.FastAttackDelay = 0.3
                elseif _G.FastAttackDelay == "0.35" then
                    _G.FastAttackDelay = 0.35
                elseif _G.FastAttackDelay == "0.4" then
                    _G.FastAttackDelay = 0.4 -- Corrigido para 0.4
                elseif _G.FastAttackDelay == "0.45" then
                    _G.FastAttackDelay = 0.45
                elseif _G.FastAttackDelay == "0.5" then
                    _G.FastAttackDelay = 0.5
                elseif _G.FastAttackDelay == "0.55" then
                    _G.FastAttackDelay = 0.55
                elseif _G.FastAttackDelay == "0.6" then
                    _G.FastAttackDelay = 0.6
                elseif _G.FastAttackDelay == "0.65" then
                    _G.FastAttackDelay = 0.65
                elseif _G.FastAttackDelay == "0.7" then
                    _G.FastAttackDelay = 0.7
                elseif _G.FastAttackDelay == "0.75" then
                    _G.FastAttackDelay = 0.75
                elseif _G.FastAttackDelay == "0.8" then
                    _G.FastAttackDelay = 0.8
                elseif _G.FastAttackDelay == "0.85" then
                    _G.FastAttackDelay = 0.85
                elseif _G.FastAttackDelay == "0.9" then
                    _G.FastAttackDelay = 0.9
                elseif _G.FastAttackDelay == "0.95" then
                    _G.FastAttackDelay = 0.95
                elseif _G.FastAttackDelay == "1" then
                    _G.FastAttackDelay = 1
                end
            end)
        end
    end
end)
})

-- ==========================================
-- ABA 1: TELEPORT (PROFISSIONAL)
-- ==========================================
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("World Travel (Fast Travel)")

TeleportTab:CreateButton({
    Name = "Travel Sea 1 (Old World)",
    Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain") end,
})

TeleportTab:CreateButton({
    Name = "Travel Sea 2 (New World)",
    Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa") end,
})

TeleportTab:CreateButton({
    Name = "Travel Sea 3 (New World)",
    Callback = function() game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou") end,
})

TeleportTab:CreateSection("Island Teleport Settings")

TeleportTab:CreateDropdown({
    Name = "Select Sea Target",
    Options = {"Sea 1", "Sea 2", "Sea 3"},
    CurrentOption = {CurrentSea},
    Flag = "SeaSelectionFlag",
    Callback = function(Option)
        Select_World_Sea = Option[1]
        Rayfield.Flags["IslandSelectionFlag"]:Set(IslandNames[Select_World_Sea])
    end,
})

TeleportTab:CreateDropdown({
    Name = "Select Target Island",
    Options = IslandNames[CurrentSea],
    CurrentOption = {""},
    Flag = "IslandSelectionFlag",
    Callback = function(Option)
        Select_Island_Travelling = Option[1]
    end,
})

TeleportTab:CreateToggle({
    Name = "Active Auto Teleport (Tween Mode)",
    CurrentValue = false,
    Flag = "TPToggleFlag",
    Callback = function(Value)
        _G.Teleporting = Value
        if Value then
            if Select_Island_Travelling ~= "" and TeleportModule then
                local target = TeleportModule.Islands[Select_World_Sea][Select_Island_Travelling]
                if target then TeleportModule.ToPos(target, true) end
            else
                Rayfield:Notify({Title = "Error", Content = "Select an Island First!", Duration = 3})
                Rayfield.Flags["TPToggleFlag"]:Set(false)
            end
        else
            if TeleportModule then TeleportModule.ToPos(nil, false) end
        end
    end,
})

-- ==========================================
-- ABA 2: VISUALS (ESP & INFO)
-- ==========================================
local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateSection("ESP Settings")

VisualTab:CreateToggle({
   Name = "Player ESP (Show Name/Box)",
   CurrentValue = false,
   Callback = function(Value) if VisualsModule then VisualsModule.PlayerESP(Value) end end,
})

VisualTab:CreateToggle({
   Name = "Fruit ESP (Show Spawned)",
   CurrentValue = false,
   Callback = function(Value) if VisualsModule then VisualsModule.FruitESP(Value) end end,
})

-- ==========================================
-- ABA 3: DEVIL FRUIT (MANAGER)
-- ==========================================
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)

FruitTab:CreateSection("Automated Fruit Management")

FruitTab:CreateToggle({
    Name = "Auto Collect Spawned Fruits",
    CurrentValue = false,
    Callback = function(Value) if FruitsModule then FruitsModule.AutoCollectFruit(Value) end end,
})

FruitTab:CreateToggle({
    Name = "Bring All Fruits to Character",
    CurrentValue = false,
    Callback = function(Value) if FruitsModule then FruitsModule.BringFruits(Value) end end,
})

FruitTab:CreateToggle({
    Name = "Auto Store Fruits in Inventory",
    CurrentValue = false,
    Callback = function(Value) if FruitsModule then FruitsModule.AutoStoreFruit(Value) end end,
})

FruitTab:CreateSection("Gacha & Shop Sniper")

FruitTab:CreateToggle({
    Name = "Auto Gacha Loop (Every 60s)",
    CurrentValue = false,
    Flag = "GachaLoopFlag",
    Callback = function(Value)
        _G.AutoGachaLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoGachaLoop do
                    if FruitsModule then FruitsModule.BuyGacha() end
                    task.wait(60)
                end
            end)
        end
    end,
})

local StockLabel = FruitTab:CreateLabel("Stock Status: Fetching Data...")

task.spawn(function()
    while task.wait(15) do
        if VisualsModule then
            pcall(function()
                local stock = VisualsModule.GetStock()
                StockLabel:Set("Stock: " .. tostring(stock))
            end)
        end
    end
end)

-- ==========================================
-- ABA 4: CONFIG & CREDITS
-- ==========================================
local ConfigTab = Window:CreateTab("Config", 4483362458)

ConfigTab:CreateSection("Server Utils")

ConfigTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end,
})

ConfigTab:CreateButton({
    Name = "Server Hop (Search New)",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local _rt = Http:JSONDecode(game:HttpGet(Api))
        for _, v in pairs(_rt.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end,
})

ConfigTab:CreateSection("Credits")
ConfigTab:CreateParagraph({Title = "Developer", Content = "Matheus - V2 Complex Edition"})
ConfigTab:CreateParagraph({Title = "Support", Content = "Based on OpenSource Scripts (Hoho/Tsuo/Redz)"})

-- [[ ANTI-AFK SYSTEM ]]
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "team Morena do cabelo liso", Content = "Blox Fruit- Matheus Hub", Duration = 5})


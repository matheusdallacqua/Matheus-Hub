-- [[ MATHEUS HUB - ULTRA COMPLEX MAIN VERSION 2026 ]]
-- Powered by Matheus & OpenSource Community

-- === 1. CARREGAMENTO DA INTERFACE (RAYFIELD) ===
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === 2. LINKS DO REPOSITÃ“RIO GITHUB ===
local URLS = {
    Teleport = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua",
    Visual   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua",
    Fruits   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua",
    Farm     = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Farm.lua",
}

-- === 3. CARREGAMENTO SEGURO DOS MÃ“DULOS ===
local function GetModule(url)
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if success then return result else return nil end
end

local TeleportModule = GetModule(URLS.Teleport)
local VisualsModule  = GetModule(URLS.Visual)
local FruitsModule   = GetModule(URLS.Fruits)
local FarmModule     = GetModule(URLS.Farm)

-- === 4. DETECÃ‡ÃƒO DE DADOS DO JOGADOR ===
local PlaceID = game.PlaceId
local Player = game.Players.LocalPlayer
local CurrentSea = "Sea 1"

if PlaceID == 2753915549 then CurrentSea = "Sea 1"
elseif PlaceID == 4442272183 or PlaceID == 4442245441 then CurrentSea = "Sea 2"
elseif PlaceID == 7449423635 then CurrentSea = "Sea 3" end

local Select_World_Sea = CurrentSea
local Select_Island_Travelling = ""

local IslandNames = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Cafe", "Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Dark Arena"},
    ["Sea 3"] = {"Mansion", "Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats", "Tiki Outpost"}
}

-- === 5. CRIAÃ‡ÃƒO DA JANELA PRINCIPAL ===
local Window = Rayfield:CreateWindow({
   Name = "Matheus Hub | V2 Ultra Complex",
   LoadingTitle = "Iniciando Matheus Hub...",
   LoadingSubtitle = "by Matheus (2026 Edition)",
   ConfigurationSaving = { Enabled = true, FolderName = "MatheusHub", FileName = "MainConfig" },
   KeySystem = false
})

-- ==========================================
-- ABA 1: HOME (Ajustado para não bugar com a FarmTab)
-- ==========================================
local HomeTab = Window:CreateTab("Home", 4483362458)

-- ==========================================
-- ABA 2: FARM (VISUAL OPENSOURCE STYLE)
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

-- SeÃ§Ã£o de Status (Muito comum em scripts elite)
FarmTab:CreateSection("Farm Status")
local StatusLabel = FarmTab:CreateParagraph({Title = "Current Task:", Content = "Waiting for start..."})

FarmTab:CreateSection("Main Farm Settings")

-- Dropdown de Modo (O visual do Tsuo tem isso para escolher entre Level, Bone, etc)
FarmTab:CreateDropdown({
    Name = "Select Farm Mode",
    Options = {"Level Farm", "Nearest Farm", "Chest Farm"},
    CurrentOption = {"Level Farm"},
    Flag = "FarmMode",
    Callback = function(Value)
        _G.FarmMode = Value[1]
    end    
})

-- O Toggle Principal (Com o visual limpo)
FarmTab:CreateToggle({
    Name = "Auto Farm Level [Active]",
    CurrentValue = false,
    Flag = "AutoFarmLevel",
    Callback = function(Value)
        _G.AutoFarmLevel = Value
        if Value then
            StatusLabel:Set({Title = "Current Task:", Content = "Farming Levels..."})
            if FarmModule then FarmModule.StartLevelFarm(Value) end
        else
            StatusLabel:Set({Title = "Current Task:", Content = "Idle"})
        end
    end,
})


-- ==========================================
-- ABA 3: FARM CONFIG
-- ==========================================
local FarmConfigTab = Window:CreateTab("Farm Config", 4483362458)

FarmTab:CreateSection("Mob Settings")

-- FunÃ§Ã£o de Agrupar Mobs (Visual clÃ¡ssico do Redz/Tsuo)
FarmTab:CreateToggle({
    Name = "Bring Mobs (Fast Farm)",
    CurrentValue = true,
    Callback = function(Value)
        _G.BringMobs = Value
    end,
})

-- AUTO CLICK
FarmTab:CreateToggle({
    Name = "Auto Clicker / Attack",
    CurrentValue = false, -- Começa desligado por segurança
    Callback = function(Value)
        _G.AutoClick = Value
        
        -- Se o FarmModule foi carregado lá em cima pelo GitHub
        if FarmModule then
            -- Se o valor for verdadeiro, liga o clique
            if Value then
                FarmModule.StartAutoClick(true)
            else
                -- Se for falso, apenas muda a variável para o loop parar
                _G.AutoClick = false
            end
        else
            -- Aviso caso o módulo do GitHub não tenha carregado
            Rayfield:Notify({Title = "Erro", Content = "FarmModule não carregado!"})
        end
    end,
})


FarmTab:CreateToggle({
    Name = "Ativar Fast Attack",
    CurrentValue = false,
    Callback = function(Value)
        _G.FastAttack = Value
        if FarmModule then FarmModule.FastAttack(Value) end
    end,
})

-- Bloco FastAttack Delay que vocÃª enviou
local AttackList = {"0", "0.1", "0.175", "0.2", "0.25", "0.3", "0.35", "0.4", "0.45", "0.5", "0.55", "0.6", "0.65", "0.7", "0.75", "0.8", "0.85", "0.9", "0.95", "1"}
FarmConfigTab:CreateDropdown({
	Name = "FastAttack Delay",
	Options = AttackList,
    CurrentOption = {"0.5"},
    Flag = "FastAttack Delay",
    Save = true,
	Callback = function(Value)
		_G.FastAttackDelay = Value[1]
	end    
})

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
                    _G.FastAttackDelay = 0.4 
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

-- Bloco Select Weapon que vocÃª enviou
FarmConfigTab:CreateSection("Weapon Settings")

local WeaponList = {"Melee","Sword","Fruit","Gun"}
_G.SelectWeapon = "Melee"

FarmConfigTab:CreateDropdown({
    Name = "Select Weapon",
    Options = WeaponList,
    CurrentOption = {"Melee"},
    Flag = "Select Weapon",
    Save = true,
    Callback = function(Value)
        _G.SelectWeapon = Value[1]
    end    
})

-- O "cÃ©rebro" das armas
task.spawn(function()
    while wait() do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            _G.SelectWeapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- ABA 4: TELEPORT (PROFISSIONAL)
local function CreateSeaDropdown(seaName, tabTitle)
    local Tab = Window:CreateTab(tabTitle, 4483362458)
    local OptionsList = {}
    
    for name, _ in pairs(TeleportModule.Islands[seaName]) do
        table.insert(OptionsList, name)
    end
    table.sort(OptionsList)

    local Selected = ""
    Tab:CreateDropdown({
        Name = "Select Island",
        Options = OptionsList,
        CurrentOption = {""},
        Callback = function(Option) Selected = Option[1] end,
    })

    Tab:CreateToggle({
        Name = "Teleport To Island",
        CurrentValue = false,
        Callback = function(Value)
            if Value then
                local target = TeleportModule.Islands[seaName][Selected]
                if target then TeleportModule.ToPos(target, true) 
                else Rayfield:Notify({Title="Error", Content="Select an island!"}) end
            else
                TeleportModule.ToPos(nil, false)
            end
        end,
    })
end

CreateSeaDropdown("Sea 1", "Sea 1 TP")
CreateSeaDropdown("Sea 2", "Sea 2 TP")
CreateSeaDropdown("Sea 3", "Sea 3 TP")

-- ==========================================
-- ABA 5: VISUALS (ESP & INFO)
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
-- ABA 6: DEVIL FRUIT (MANAGER)
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

-- ==========================================
-- ABA 7: CONFIG & CREDITS
-- ==========================================
local ConfigTab = Window:CreateTab("Config", 4483362458)
ConfigTab:CreateSection("Server Utils")
ConfigTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end,
})

ConfigTab:CreateSection("Credits")
ConfigTab:CreateParagraph({Title = "Developer", Content = "Matheus - V2 Complex Edition"})
ConfigTab:CreateParagraph({Title = "Support", Content = "Based on OpenSource Scripts (Hoho/Tsuo/Redz)"})

local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "team Morena do cabelo liso", Content = "Blox Fruit- Matheus Hub", Duration = 5})


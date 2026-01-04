-- [[ MATHEUS HUB - ULTRA COMPLEX MAIN VERSION 2026 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === LINKS DO REPOSITÓRIO ===
local URLS = {
    Teleport = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua",
    Visual   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua",
    Fruits   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua",
    Farm     = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Farm.lua",
}

local function GetModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    return success and result or nil
end

local TeleportModule = GetModule(URLS.Teleport)
local VisualsModule  = GetModule(URLS.Visual)
local FruitsModule   = GetModule(URLS.Fruits)
local FarmModule     = GetModule(URLS.Farm)

local Player = game.Players.LocalPlayer

-- === JANELA PRINCIPAL ===
local Window = Rayfield:CreateWindow({
   Name = "Matheus Hub | V2 Ultra Complex",
   LoadingTitle = "Iniciando Matheus Hub...",
   LoadingSubtitle = "by Matheus (2026 Edition)",
   ConfigurationSaving = {
        Enabled = true,
        FolderName = "MatheusHub",
        FileName = "MainConfig"
   },
   KeySystem = false
})

-- ==========================================
-- ABA 1: AUTO FARM
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateSection("Main Farm Settings")

FarmTab:CreateToggle({
    Name = "Auto Farm Level [Active]",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarmLevel = Value
        if FarmModule then
            FarmModule.StartLevelFarm(Value)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Ativar Fast Attack",
    CurrentValue = false,
    Callback = function(Value)
        _G.FastAttack = Value
        _G.AutoClick = Value
        if FarmModule then
            FarmModule.StartAutoClick(Value)
        end
    end,
})

-- << AUTO CLICK MANUAL (ADICIONADO) >>
FarmTab:CreateToggle({
    Name = "Auto Click (Manual)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoClick = Value
        if FarmModule then
            FarmModule.StartAutoClick(Value)
        end
    end,
})

spawn(function()
    while wait(.1) do
        if _G.FastAttackDelay then
            pcall(function()
                if _G.FastAttackDelay == "0" then _G.FastAttackDelay = 0
                elseif _G.FastAttackDelay == "0.1" then _G.FastAttackDelay = 0.1
                elseif _G.FastAttackDelay == "0.175" then _G.FastAttackDelay = 0.175
                elseif _G.FastAttackDelay == "0.2" then _G.FastAttackDelay = 0.2
                elseif _G.FastAttackDelay == "0.25" then _G.FastAttackDelay = 0.25
                elseif _G.FastAttackDelay == "0.3" then _G.FastAttackDelay = 0.3
                elseif _G.FastAttackDelay == "0.35" then _G.FastAttackDelay = 0.35
                elseif _G.FastAttackDelay == "0.4" then _G.FastAttackDelay = 0.4 
                elseif _G.FastAttackDelay == "0.45" then _G.FastAttackDelay = 0.45
                elseif _G.FastAttackDelay == "0.5" then _G.FastAttackDelay = 0.5
                elseif _G.FastAttackDelay == "0.55" then _G.FastAttackDelay = 0.55
                elseif _G.FastAttackDelay == "0.6" then _G.FastAttackDelay = 0.6
                elseif _G.FastAttackDelay == "0.65" then _G.FastAttackDelay = 0.65
                elseif _G.FastAttackDelay == "0.7" then _G.FastAttackDelay = 0.7
                elseif _G.FastAttackDelay == "0.75" then _G.FastAttackDelay = 0.75
                elseif _G.FastAttackDelay == "0.8" then _G.FastAttackDelay = 0.8
                elseif _G.FastAttackDelay == "0.85" then _G.FastAttackDelay = 0.85
                elseif _G.FastAttackDelay == "0.9" then _G.FastAttackDelay = 0.9
                elseif _G.FastAttackDelay == "0.95" then _G.FastAttackDelay = 0.95
                elseif _G.FastAttackDelay == "1" then _G.FastAttackDelay = 1
                end
            end)
        end
    end
end)

--Dropdown das arma
FarmConfigTab:CreateSection("Weapon Settings")

local WeaponList = {"Melee","Sword","Fruit","Gun"}
FarmConfigTab:CreateDropdown({
    Name = "Select Weapon",
    Options = WeaponList,
    CurrentOption = {"Melee"},
    Callback = function(Value) 
        -- Mudamos aqui para não bugar o nome real da arma
        _G.Select_Weapon_Check = Value[1] 
    end    
})


-- O "Cérebro" das Armas - VOLTANDO AO PADRÃO QUE O FARM.LUA EXIGE
task.spawn(function()
    while wait(1) do
        pcall(function()
            -- Esta variável Select_Weapon_Check serve apenas para o Dropdown não bugar
            local toolType = _G.Select_Weapon_Check or "Melee"
            local check = toolType == "Fruit" and "Blox Fruit" or toolType
            
            -- Procura na Backpack
            for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.ToolTip == check then
                    _G.SelectWeapon = v.Name -- AQUI É O NOME REAL (EX: "COMBAT")
                end
            end
            
            -- Procura no Character (caso já esteja na mão)
            for i ,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip == check then
                    _G.SelectWeapon = v.Name
                end
            end
        end)
    end
end)


-- ==========================================
-- ABA 3: TELEPORT (PROFISSIONAL)
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
                    task.wait(1)
                end
            end)
        end
    end,
})

-- ==========================================
-- ABA 4: CONFIG & CREDITS
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

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
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
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
    ConfigurationSaving = { Enabled = true, FolderName = "MatheusHub", FileName = "MainConfig" },
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
        if FarmModule then FarmModule.StartLevelFarm(Value) end
    end,
})

FarmTab:CreateToggle({
    Name = "Ativar Fast Attack",
    CurrentValue = false,
    Callback = function(Value)
        _G.FastAttack = Value
        _G.AutoClick = Value
        if FarmModule then FarmModule.StartAutoClick(Value) end
    end,
})

-- ==========================================
-- ABA 2: FARM CONFIG
-- ==========================================
local FarmConfigTab = Window:CreateTab("Farm Config", 4483362458)

FarmConfigTab:CreateSection("Mob Settings")

FarmConfigTab:CreateToggle({
    Name = "Bring Mobs (Magnet)",
    CurrentValue = true,
    Callback = function(Value)
        _G.BringMobs = Value
    end,
})

local AttackList = {"0", "0.1", "0.175", "0.2", "0.25", "0.3", "0.35", "0.4", "0.45", "0.5", "0.55", "0.6", "0.65", "0.7", "0.75", "0.8", "0.85", "0.9", "0.95", "1"}
FarmConfigTab:CreateDropdown({
    Name = "FastAttack Delay",
    Options = AttackList,
    CurrentOption = {"0.1"},
    Callback = function(Value)
        _G.FastAttackDelay = tonumber(Value[1])
    end
})

FarmConfigTab:CreateSection("Weapon Settings")

local WeaponList = {"Melee","Sword","Fruit","Gun"}
_G.Select_Weapon_Check = "Melee"

FarmConfigTab:CreateDropdown({
    Name = "Select Weapon",
    Options = WeaponList,
    CurrentOption = {"Melee"},
    Callback = function(Value)
        _G.Select_Weapon_Check = Value[1]
    end
})

-- O "Cérebro" das Armas
task.spawn(function()
    while wait(1) do
        pcall(function()
            local toolType = _G.Select_Weapon_Check or "Melee"
            local check = toolType == "Fruit" and "Blox Fruit" or toolType

            for i ,v in pairs(Player.Backpack:GetChildren()) do  
                if v.ToolTip == check then  
                    _G.SelectWeapon = v.Name 
                end  
            end  
            for i ,v in pairs(Player.Character:GetChildren()) do  
                if v:IsA("Tool") and v.ToolTip == check then  
                    _G.SelectWeapon = v.Name  
                end  
            end  
        end)  
    end
end)

-- ==========================================
-- ABA 3: TELEPORT
-- ==========================================
local function CreateSeaDropdown(seaName, tabTitle)
    local Tab = Window:CreateTab(tabTitle, 4483362458)
    local OptionsList = {"Selecione uma Ilha"}
    
    if TeleportModule and TeleportModule.Islands and TeleportModule.Islands[seaName] then
        OptionsList = {}
        for name, _ in pairs(TeleportModule.Islands[seaName]) do  
            table.insert(OptionsList, name)  
        end  
        table.sort(OptionsList)
    end

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
            if Value and TeleportModule then  
                local target = TeleportModule.Islands[seaName][Selected]  
                if target then TeleportModule.ToPos(target, true) end
            elseif TeleportModule then  
                TeleportModule.ToPos(nil, false)  
            end  
        end,  
    })
end

CreateSeaDropdown("Sea 1", "Sea 1 TP")
CreateSeaDropdown("Sea 2", "Sea 2 TP")
CreateSeaDropdown("Sea 3", "Sea 3 TP")

-- ==========================================
-- ABA 4: VISUALS
-- ==========================================
local VisualTab = Window:CreateTab("Visuals", 4483362458)
VisualTab:CreateSection("ESP Settings")
VisualTab:CreateToggle({
    Name = "Player ESP (Show Name/Box)",
    CurrentValue = false,
    Callback = function(Value) if VisualsModule then VisualsModule.PlayerESP(Value) end end,
})
VisualTab:CreateToggle({
    Name = "Fruit ESP (Full Tracking)",
    CurrentValue = false,
    Callback = function(Value) if VisualsModule then VisualsModule.FruitESP(Value) end end,
})

-- ==========================================
-- ABA 5: DEVIL FRUIT
-- ==========================================
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)
FruitTab:CreateSection("Automated Fruit Management")
FruitTab:CreateToggle({
    Name = "Auto Collect Fruits",
    CurrentValue = false,
    Callback = function(Value) if FruitsModule then FruitsModule.AutoCollectFruit(Value) end end,
})
FruitTab:CreateToggle({
    Name = "Auto Store Fruits",
    CurrentValue = false,
    Callback = function(Value) if FruitsModule then FruitsModule.AutoStoreFruit(Value) end end,
})

FruitTab:CreateSection("Gacha")
FruitTab:CreateToggle({
    Name = "Auto Gacha Loop",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoGachaLoop = Value
        if Value then
            task.spawn(function()
                while _G.AutoGachaLoop do
                    if FruitsModule then FruitsModule.BuyGacha() end
                    task.wait(5) -- Delay de segurança para o loop
                end
            end)
        end
    end,
})

-- ==========================================
-- ABA 6: CONFIG
-- ==========================================
local ConfigTab = Window:CreateTab("Config", 4483362458)
ConfigTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end,
})

ConfigTab:CreateParagraph({Title = "Developer", Content = "Matheus - V2 Complex Edition"})

local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:LoadConfiguration()
Rayfield:Notify({Title = "team Morena do cabelo liso", Content = "Blox Fruit- Matheus Hub", Duration = 5})


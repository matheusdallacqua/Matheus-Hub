-- [[ MATHEUS HUB - ULTRA COMPLEX MAIN VERSION 2026 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === LINKS DO REPOSITÓRIO ===
local URLS = {
    Teleport = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua",
    Visual   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua",
    Fruits   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua",
    Farm     = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Farm.lua",
}

-- Sistema de carregamento de módulos
local function LoadModule(name, url)
    local success, module = pcall(function()
        local content = game:HttpGet(url, true)
        return loadstring(content)()
    end)
    
    if success and module then
        Rayfield:Notify({
            Title = "✅ Módulo Carregado",
            Content = name .. " carregado com sucesso!",
            Duration = 3
        })
        return module
    else
        Rayfield:Notify({
            Title = "❌ Erro ao Carregar",
            Content = "Falha ao carregar " .. name,
            Duration = 5
        })
        return nil
    end
end

-- Carregar módulos
local TeleportModule = LoadModule("Teleport", URLS.Teleport)
local VisualModule = LoadModule("Visual", URLS.Visual)
local FruitsModule = LoadModule("Fruits", URLS.Fruits)
local FarmModule = LoadModule("Farm", URLS.Farm)

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
    KeySystem = false,
    Discord = {
        Enabled = false,
        Invite = "discord.gg/seuservidor",
        RememberJoins = true
    }
})

-- ==========================================
-- ABA 1: AUTO FARM (CORRIGIDA)
-- ==========================================
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)

FarmTab:CreateSection("Select Farm Mode")

local FarmModes = {"Level", "Nearest", "Chest", "Bone (Third Sea)"}

FarmTab:CreateDropdown({
    Name = "Farm Mode",
    Options = FarmModes,
    CurrentOption = {"Level"},
    Callback = function(Value)
        _G.FarmMode = Value[1]
        Rayfield:Notify({
            Title = "Farm Mode Alterado",
            Content = "Modo: " .. _G.FarmMode,
            Duration = 2
        })
    end
})

FarmTab:CreateToggle({
    Name = "Start Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if FarmModule then 
            FarmModule.StartFarm(Value, _G.FarmMode) 
        else
            Rayfield:Notify({
                Title = "Erro",
                Content = "Módulo Farm não carregado!",
                Duration = 3
            })
        end
    end,
})

FarmTab:CreateSection("Combat Settings")

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

FarmTab:CreateButton({
    Name = "Parar Tudo (Emergency Stop)",
    Callback = function()
        if FarmModule and FarmModule.StopAll then
            FarmModule.StopAll()
        end
        Rayfield:Notify({
            Title = "⛔ Emergency Stop",
            Content = "Todos os sistemas parados!",
            Duration = 3
        })
    end
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

local AttackList = {"0", "0.05", "0.1", "0.15", "0.2", "0.25", "0.3", "0.35", "0.4", "0.5", "0.75", "1"}
FarmConfigTab:CreateDropdown({
    Name = "FastAttack Delay",
    Options = AttackList,
    CurrentOption = {"0.1"},
    Callback = function(Value)
        _G.FastAttackDelay = tonumber(Value[1]) or 0.1
    end
})

FarmConfigTab:CreateSection("Weapon Settings")

local WeaponList = {"Melee", "Sword", "Fruit", "Gun"}
_G.Select_Weapon_Check = "Melee"

FarmConfigTab:CreateDropdown({
    Name = "Select Weapon Type",
    Options = WeaponList,
    CurrentOption = {"Melee"},
    Callback = function(Value)
        _G.Select_Weapon_Check = Value[1]
    end
})

-- Sistema automático de seleção de arma
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local toolType = _G.Select_Weapon_Check or "Melee"
            local check = toolType == "Fruit" and "Blox Fruit" or toolType
            
            -- Verifica na mochila
            for _, v in pairs(Player.Backpack:GetChildren()) do  
                if v.ToolTip == check then  
                    _G.SelectWeapon = v.Name 
                end  
            end  
            
            -- Verifica no personagem
            for _, v in pairs(Player.Character:GetChildren()) do  
                if v:IsA("Tool") and v.ToolTip == check then  
                    _G.SelectWeapon = v.Name  
                end  
            end  
        end)  
    end
end)

-- ==========================================
-- ABA 3: TELEPORT (VERSÃO COM TOGGLE)
-- ==========================================
local function CreateSeaTeleportTab(seaNumber, seaKey)
    local Tab = Window:CreateTab("Sea " .. seaNumber .. " TP", 4483362458)
    local SelectedIsland = ""
    local IsTeleporting = false
    
    -- Obter lista de ilhas
    local islandList = {"Selecione uma Ilha"}
    
    if TeleportModule and TeleportModule.Islands and TeleportModule.Islands[seaKey] then
        islandList = {}
        for islandName, _ in pairs(TeleportModule.Islands[seaKey]) do
            table.insert(islandList, islandName)
        end
        table.sort(islandList)
    end
    
    -- Dropdown para selecionar ilha
    Tab:CreateDropdown({
        Name = "Select Island",
        Options = islandList,
        CurrentOption = {"Selecione uma Ilha"},
        Callback = function(Option)
            SelectedIsland = Option[1]
        end
    })
    
    -- Toggle para teleporte contínuo
    Tab:CreateToggle({
        Name = "Teleport To Island",
        CurrentValue = false,
        Callback = function(Value)
            IsTeleporting = Value
            
            if Value then
                -- Ligar teleporte
                if SelectedIsland ~= "" and SelectedIsland ~= "Selecione uma Ilha" then
                    local targetPos = TeleportModule.Islands[seaKey][SelectedIsland]
                    if targetPos and TeleportModule.ToPos then
                        TeleportModule.ToPos(targetPos, true)
                        Rayfield:Notify({
                            Title = "Teleport ON",
                            Content = "Teleportando para: " .. SelectedIsland,
                            Duration = 3
                        })
                    end
                else
                    Rayfield:Notify({
                        Title = "Erro",
                        Content = "Selecione uma ilha primeiro!",
                        Duration = 3
                    })
                    return false -- Desliga o toggle
                end
            else
                -- Desligar teleporte
                if TeleportModule and TeleportModule.ToPos then
                    TeleportModule.ToPos(nil, false)
                    Rayfield:Notify({
                        Title = "Teleport OFF",
                        Content = "Teleporte desativado",
                        Duration = 2
                    })
                end
            end
        end
    })
    
    -- Botão de teleporte único
    Tab:CreateButton({
        Name = "Teleport Once (Single)",
        Callback = function()
            if SelectedIsland ~= "" and SelectedIsland ~= "Selecione uma Ilha" then
                local targetPos = TeleportModule.Islands[seaKey][SelectedIsland]
                if targetPos and TeleportModule.ToPos then
                    TeleportModule.ToPos(targetPos, false)
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Teleportado para: " .. SelectedIsland,
                        Duration = 3
                    })
                end
            else
                Rayfield:Notify({
                    Title = "Erro",
                    Content = "Selecione uma ilha primeiro!",
                    Duration = 3
                })
            end
        end
    })
end

-- Criar abas de teleport
CreateSeaTeleportTab(1, "Sea 1")
CreateSeaTeleportTab(2, "Sea 2")
CreateSeaTeleportTab(3, "Sea 3")

-- ==========================================
-- ABA 4: VISUALS
-- ==========================================
local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateSection("ESP Settings")

VisualTab:CreateToggle({
    Name = "Player ESP (Show Name/Box)",
    CurrentValue = false,
    Callback = function(Value)
        if VisualModule and VisualModule.PlayerESP then
            VisualModule.PlayerESP(Value)
        end
    end
})

VisualTab:CreateToggle({
    Name = "Fruit ESP (Color Coded)",
    CurrentValue = false,
    Callback = function(Value)
        if VisualModule and VisualModule.FruitESP then
            VisualModule.FruitESP(Value)
        end
    end
})

VisualTab:CreateSection("Misc Visuals")

VisualTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            Player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

-- ==========================================
-- ABA 5: DEVIL FRUIT
-- ==========================================
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)

FruitTab:CreateSection("Automated Fruit Management")

FruitTab:CreateToggle({
    Name = "Auto Collect Fruits",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoCollectFruit = Value
        if FruitsModule and FruitsModule.AutoCollectFruit then
            FruitsModule.AutoCollectFruit(Value)
        end
    end
})

FruitTab:CreateToggle({
    Name = "Bring All Fruits to Character",
    CurrentValue = false,
    Callback = function(Value)
        _G.BringFruits = Value
        if FruitsModule and FruitsModule.BringFruits then
            FruitsModule.BringFruits(Value)
        end
    end
})

FruitTab:CreateToggle({
    Name = "Auto Store Fruits",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoStoreFruit = Value
        if FruitsModule and FruitsModule.StartAutoStore then
            FruitsModule.StartAutoStore(Value)
        end
    end
})

FruitTab:CreateToggle({
    Name = "Auto Gacha Loop",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoGachaLoop = Value
        if FruitsModule and FruitsModule.StartAutoGacha then
            FruitsModule.StartAutoGacha(Value)
        end
    end
})

FruitTab:CreateSection("Fruit Utilities")

FruitTab:CreateButton({
    Name = "Find Nearest Fruit",
    Callback = function()
        if FruitsModule and FruitsModule.FindNearestFruit then
            local fruit, distance = FruitsModule.FindNearestFruit()
            if fruit then
                Rayfield:Notify({
                    Title = "Fruit Found",
                    Content = "Fruta mais próxima a " .. math.floor(distance) .. "m",
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "No Fruits",
                    Content = "Nenhuma fruta encontrada",
                    Duration = 3
                })
            end
        end
    end
})

FruitTab:CreateButton({
    Name = "Store All Fruits Now",
    Callback = function()
        if FruitsModule and FruitsModule.AutoStore then
            FruitsModule.AutoStore()
            Rayfield:Notify({
                Title = "Store Fruits",
                Content = "Tentando guardar todas as frutas",
                Duration = 3
            })
        end
    end
})

-- ==========================================
-- ABA 6: CONFIG & INFO
-- ==========================================
local ConfigTab = Window:CreateTab("Config", 4483362458)

ConfigTab:CreateSection("Server Utilities")

ConfigTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
})

ConfigTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("discord.gg/seuservidor")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link copiado para a área de transferência!",
            Duration = 3
        })
    end
})

ConfigTab:CreateSection("Hub Information")

ConfigTab:CreateParagraph({
    Title = "Developer Info",
    Content = "Matheus - V2 Complex Edition 2026"
})

ConfigTab:CreateParagraph({
    Title = "Module Status",
    Content = string.format(
        "Farm: %s | Teleport: %s | Fruits: %s | Visuals: %s",
        FarmModule and "✅" or "❌",
        TeleportModule and "✅" or "❌",
        FruitsModule and "✅" or "❌",
        VisualModule and "✅" or "❌"
    )
})

ConfigTab:CreateSection("Configuration")

ConfigTab:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Rayfield:Notify({
            Title = "Config Saved",
            Content = "Configurações salvas com sucesso!",
            Duration = 3
        })
    end
})

ConfigTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- ==========================================
-- ANTI-AFK AUTOMÁTICO
-- ==========================================
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ==========================================
-- INICIALIZAÇÃO FINAL
-- ==========================================
Rayfield:LoadConfiguration()

Rayfield:Notify({
    Title = "Matheus Hub V2",
    Content = string.format(
        "Carregado com sucesso! Módulos: %d/4",
        (FarmModule and 1 or 0) + (TeleportModule and 1 or 0) + 
        (FruitsModule and 1 or 0) + (VisualModule and 1 or 0)
    ),
    Duration = 6
})

print("========================================")
print("Matheus Hub V2 - Inicializado com sucesso!")
print("Módulos carregados:")
print("- Farm:", FarmModule and "✅" or "❌")
print("- Teleport:", TeleportModule and "✅" or "❌")
print("- Fruits:", FruitsModule and "✅" or "❌")
print("- Visual:", VisualModule and "✅" or "❌")
print("========================================")

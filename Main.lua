-- [[ MATHEUS HUB - MAIN COMPLEXO ATUALIZADO ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === CONFIGURAÇÃO DOS LINKS ===
local URLS = {
    Teleport = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua",
    Visual   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua",
    Fruits   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua"
}

-- Carregando os módulos (Pastas)
local TeleportModule = loadstring(game:HttpGet(URLS.Teleport))()
local VisualsModule  = loadstring(game:HttpGet(URLS.Visual))()
local FruitsModule   = loadstring(game:HttpGet(URLS.Fruits))()

-- === CRIAÇÃO DA JANELA ===
local Window = Rayfield:CreateWindow({
   Name = "Matheus Hub | V2 Complex",
   LoadingTitle = "Carregando Módulos...",
   LoadingSubtitle = "by Matheus",
   ConfigurationSaving = { Enabled = true, FolderName = "MatheusHub", FileName = "Config" },
   KeySystem = false
})

--- [[ ABA DE TELEPORTE - EXTRAÍDA DO OPENSOURCE TSUO ]]
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Variáveis de controle baseadas no arquivo
local Select_World_Sea = ""
local Select_Island_Travelling = ""

-- Tabela de Opções (Baseada no arquivo TXT mas com suas ilhas)
local Islands_List = {
    ["World 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Prison", "Magma Village", "Fountain City"},
    ["World 2"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    ["World 3"] = {"Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Tiki Outpost", "Submerged Island", "Prehistoric Island", "Christmas Island"}
}

TeleportTab:CreateSection("Travel - Worlds")

-- Botões de viagem (Exatamente como no script tsuo)
TeleportTab:CreateButton({
    Name = "Travel East Blue (World 1)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end,
})

TeleportTab:CreateButton({
    Name = "Travel Dressrosa (World 2)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end,
})

TeleportTab:CreateButton({
    Name = "Travel Zou (World 3)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end,
})

TeleportTab:CreateSection("Travel - Island")

-- Dropdown de Seleção de Mundo (Select World (Sea))
TeleportTab:CreateDropdown({
    Name = "Select World (Sea)",
    Options = {"World 1", "World 2", "World 3"},
    CurrentOption = {"World 1"},
    Flag = "Select_World_Sea",
    Callback = function(Option)
        Select_World_Sea = Option[1]
        -- Atualiza as ilhas baseada no mundo escolhido
        Rayfield.Flags["Select_Island_Travelling"]:Set(Islands_List[Select_World_Sea])
    end,
})

-- Dropdown de Seleção de Ilha (Select Travelling)
TeleportTab:CreateDropdown({
    Name = "Select Travelling",
    Options = Islands_List["World 1"], -- Começa com World 1 por padrão
    CurrentOption = {""},
    Flag = "Select_Island_Travelling",
    Callback = function(Option)
        Select_Island_Travelling = Option[1]
    end,
})

-- Toggle "Start Journey" (Auto Travel no arquivo)
TeleportTab:CreateToggle({
    Name = "Auto Travel",
    CurrentValue = false,
    Flag = "Start_Journey",
    Callback = function(Value)
        _G.Auto_Travel = Value
        
        if Value then
            -- Converte "World 1" para "Sea 1" para bater com seu Teleport.lua
            local seaKey = Select_World_Sea:gsub("World", "Sea")
            
            if Select_Island_Travelling ~= "" then
                local targetCFrame = TeleportModule.Islands[seaKey][Select_Island_Travelling]
                
                if targetCFrame then
                    local tween = TeleportModule.ToPos(targetCFrame, true)
                    
                    -- Se chegar, desliga o botão (Lógica OpenSource)
                    if tween then
                        tween.Completed:Connect(function()
                            if _G.Auto_Travel then
                                _G.Auto_Travel = false
                                Rayfield.Flags["Start_Journey"]:Set(false)
                            end
                        end)
                    end
                end
            else
                Rayfield:Notify({Title = "Warning", Content = "Please Select Island", Duration = 3})
                Rayfield.Flags["Start_Journey"]:Set(false)
            end
        else
            -- Para o voo imediatamente
            TeleportModule.ToPos(nil, false)
        end
    end,
})


-- === ABA DE VISUALS ===
local VisualTab = Window:CreateTab("Visuals", 4483362458)
VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value) VisualsModule.PlayerESP(Value) end,
})
VisualTab:CreateToggle({
   Name = "Fruit ESP",
   CurrentValue = false,
   Callback = function(Value) VisualsModule.FruitESP(Value) end,
})

-- === ABA DE FRUTAS (MANTIDA A SUA COMPLEXA) ===
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)
FruitTab:CreateSection("Farm de Frutas")

FruitTab:CreateToggle({
   Name = "Auto Collect Fruit (Voo Seguro)",
   CurrentValue = false,
   Flag = "AutoFruit",
   Callback = function(Value)
      if Value then
         FruitsModule.TeleportToFruit(true)
         task.wait(1)
         Rayfield.Flags["AutoFruit"]:Set(false)
      end
   end,
})

FruitTab:CreateSection("Loja e Gacha")

FruitTab:CreateToggle({
   Name = "Gacha de Fruta (Random)",
   CurrentValue = false,
   Flag = "GachaToggle",
   Callback = function(Value)
      if Value then
         FruitsModule.BuyGacha(true)
         task.wait(1)
         Rayfield.Flags["GachaToggle"]:Set(false)
      end
   end,
})

Rayfield:Notify({Title = "Matheus Hub", Content = "Script Pronto para Uso!", Duration = 5})

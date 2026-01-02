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

-- === ABA TELEPORT (BASEADO NO TSUO OPENSOURCE) ===
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- 1. DETECÇÃO DE MUNDO (Lógica Tsuo)
-- Isso roda ANTES de criar os botões para garantir que carregue o Sea certo
local PlaceID = game.PlaceId
local CurrentSea = "Sea 1" -- Padrão

if PlaceID == 2753915549 then
    CurrentSea = "Sea 1"
elseif PlaceID == 4442272183 or PlaceID == 4442245441 then
    CurrentSea = "Sea 2"
elseif PlaceID == 7449423635 then
    CurrentSea = "Sea 3"
end

-- Variáveis para guardar a escolha do usuário
local Select_World_Sea = CurrentSea
local Select_Island_Travelling = ""

-- Tabela Simples para o Dropdown puxar os nomes (Igual ao Teleport.lua)
local IslandNames = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    ["Sea 3"] = {"Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Tiki Outpost", "Submerged Island", "Prehistoric Island", "Christmas Island"}
}

-- SEÇÃO 1: MUNDOS
TeleportTab:CreateSection("Travel - Worlds")

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

-- SEÇÃO 2: ILHAS
TeleportTab:CreateSection("Travel - Island")

-- Dropdown de Mundos
TeleportTab:CreateDropdown({
    Name = "Select World (Sea)",
    Options = {"Sea 1", "Sea 2", "Sea 3"},
    CurrentOption = {CurrentSea}, -- Começa marcado no Sea que você está!
    Flag = "WorldSelect",
    Callback = function(Option)
        Select_World_Sea = Option[1]
        -- ATUALIZAÇÃO DINÂMICA: Muda a lista de baixo assim que você troca o Sea
        Rayfield.Flags["IslandSelect"]:Set(IslandNames[Select_World_Sea])
    end,
})

-- Dropdown de Ilhas
TeleportTab:CreateDropdown({
    Name = "Select Travelling",
    Options = IslandNames[CurrentSea], -- Carrega APENAS as ilhas do Sea atual
    CurrentOption = {""},
    Flag = "IslandSelect",
    Callback = function(Option)
        Select_Island_Travelling = Option[1]
    end,
})

-- Toggle de Viagem
TeleportTab:CreateToggle({
    Name = "Auto Travel",
    CurrentValue = false,
    Flag = "StartTravel",
    Callback = function(Value)
        _G.Teleporting = Value
        
        if Value then
            -- Verifica se selecionou ilha
            if Select_Island_Travelling ~= "" and Select_Island_Travelling ~= nil then
                -- Busca a CFrame no modulo Teleport.lua
                local target = TeleportModule.Islands[Select_World_Sea][Select_Island_Travelling]
                
                if target then
                    local tween = TeleportModule.ToPos(target, true)
                    
                    -- Se o tween completar, desliga o botão sozinho
                    if tween then
                        tween.Completed:Connect(function()
                            if _G.Teleporting then
                                _G.Teleporting = false
                                Rayfield.Flags["StartTravel"]:Set(false)
                                Rayfield:Notify({Title = "Travel", Content = "Arrived!", Duration = 3})
                            end
                        end)
                    end
                end
            else
                Rayfield:Notify({Title = "Warning", Content = "Select Island First!", Duration = 3})
                Rayfield.Flags["StartTravel"]:Set(false)
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

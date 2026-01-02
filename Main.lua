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

-- [[ ABA TELEPORT - UI EXATA DO SCRIPT TSUO ]]
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Lógica de Detecção do Tsuo (PlaceId)
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 4442245441 then World2 = true
elseif game.PlaceId == 7449423635 then World3 = true end

-- Define o Sea inicial para o dropdown não bugar
local Default_Sea = "Sea 1"
if World2 then Default_Sea = "Sea 2" elseif World3 then Default_Sea = "Sea 3" end

local Select_World_Sea = Default_Sea
local Select_Island_Travelling = ""

-- Tabela de ilhas (Mantendo suas coordenadas de 2026)
local Island_Table = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    ["Sea 3"] = {"Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Tiki Outpost", "Submerged Island", "Prehistoric Island", "Christmas Island"}
}

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

TeleportTab:CreateSection("Travel - Island")

-- Dropdown de Mundo (Select World (Sea))
TeleportTab:CreateDropdown({
    Name = "Select World (Sea)",
    Options = {"Sea 1", "Sea 2", "Sea 3"},
    CurrentOption = {Default_Sea},
    Flag = "Select_World_Sea",
    Callback = function(Option)
        Select_World_Sea = Option[1]
        -- Atualiza as ilhas do próximo dropdown (Lógica de refresh do Rayfield)
        Rayfield.Flags["Select_Island_Travelling"]:Set(Island_Table[Select_World_Sea])
    end,
})

-- Dropdown de Ilhas (Select Travelling)
TeleportTab:CreateDropdown({
    Name = "Select Travelling",
    Options = Island_Table[Default_Sea],
    CurrentOption = {""},
    Flag = "Select_Island_Travelling",
    Callback = function(Option)
        Select_Island_Travelling = Option[1]
    end,
})

-- Toggle Iniciar Viagem (Auto Travel)
TeleportTab:CreateToggle({
    Name = "Auto Travel",
    CurrentValue = false,
    Flag = "Start_Journey",
    Callback = function(Value)
        _G.Teleporting = Value
        
        if Value then
            if Select_Island_Travelling ~= "" then
                -- Busca a CFrame no seu Teleport.lua
                local target = TeleportModule.Islands[Select_World_Sea][Select_Island_Travelling]
                if target then
                    local tween = TeleportModule.ToPos(target, true)
                    
                    -- Se chegar, desliga o botão (Lógica OpenSource do Tsuo)
                    if tween then
                        tween.Completed:Connect(function()
                            if _G.Teleporting then
                                _G.Teleporting = false
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
            -- Para o voo
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

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

-- === ABA DE TELEPORTES (OPENSOURCE STYLE) ===
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

-- Detecção Automática de Sea (Padrão Scripts Profissionais)
local function GetMySea()
    local pId = game.PlaceId
    if pId == 2753915549 then return "Sea 1"
    elseif pId == 4442245441 then return "Sea 2"
    elseif pId == 7449423635 then return "Sea 3"
    else return "Sea 1" end
end

local CurrentSea = GetMySea()
local SelectedIsland = ""

-- Tabela de Opções das Ilhas
local IslandData = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    ["Sea 3"] = {"Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Tiki Outpost", "Submerged Island", "Prehistoric Island", "Christmas Island"}
}

TeleportTab:CreateSection("Travel - Worlds")

-- Remotes Originais do Blox Fruits para mudar de Sea
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

-- Dropdown de Sea com Autodetecção
local WorldDrop = TeleportTab:CreateDropdown({
   Name = "Select World (Sea)",
   Options = {"Sea 1", "Sea 2", "Sea 3"},
   CurrentOption = {CurrentSea},
   Flag = "WorldDrop",
   Callback = function(Option)
      CurrentSea = Option[1]
      -- Atualiza as ilhas do próximo dropdown na hora
      Rayfield.Flags["IslandDrop"]:Set(IslandData[CurrentSea])
   end,
})

-- Dropdown de Ilhas
local IslandDrop = TeleportTab:CreateDropdown({
   Name = "Select Travelling",
   Options = IslandData[CurrentSea],
   CurrentOption = {""},
   Flag = "IslandDrop",
   Callback = function(Option)
      SelectedIsland = Option[1]
   end,
})

-- Toggle Profissional (Start Journey)
TeleportTab:CreateToggle({
   Name = "Auto Travel (Start Journey)",
   CurrentValue = false,
   Flag = "AutoTravel",
   Callback = function(Value)
      _G.Teleporting = Value
      
      if Value then
         if SelectedIsland ~= "" and SelectedIsland ~= nil then
            local target = TeleportModule.Islands[CurrentSea][SelectedIsland]
            if target then
               -- Chama o módulo de TP e aguarda finalização
               local flight = TeleportModule.ToPos(target, true)
               
               if flight then
                  flight.Completed:Connect(function()
                     if _G.Teleporting then
                        _G.Teleporting = false
                        Rayfield.Flags["AutoTravel"]:Set(false)
                        Rayfield:Notify({Title = "Matheus Hub", Content = "Arrived at Destination!", Duration = 3})
                     end
                  end)
               end
            end
         else
            Rayfield:Notify({Title = "Error", Content = "Please select an island first!", Duration = 3})
            Rayfield.Flags["AutoTravel"]:Set(false)
         end
      else
         -- Cancela o voo imediatamente via Módulo
         TeleportModule.ToPos(nil, false)
      end
   end,
})

-- Notificação de Sea Detectado ao carregar
Rayfield:Notify({Title = "System", Content = "Detected: " .. CurrentSea, Duration = 3})


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

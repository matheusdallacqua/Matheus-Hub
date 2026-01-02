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

-- === ABA DE TELEPORTES (ATUALIZADA) ===
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
TeleportTab:CreateSection("Seletor de Destino")

local selectedSea = "Sea 1"
local selectedIsland = ""

-- Tabela de ilhas para os Dropdowns dinâmicos
local IslandOptions = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Cursed Ship", "Ice Castle", "Forgotten Island"},
    ["Sea 3"] = {"Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Tiki Outpost", "Submerged Island", "Prehistoric Island", "Christmas Island"}
}

-- Dropdown de Mundo (Sea)
TeleportTab:CreateDropdown({
   Name = "Selecionar Mundo (Sea)",
   Options = {"Sea 1", "Sea 2", "Sea 3"},
   CurrentOption = {"Sea 1"},
   Callback = function(Option)
      selectedSea = Option[1]
      -- Isso aqui faz o segundo dropdown mudar as ilhas na hora
      Rayfield.Flags["IslandDropdown"]:Set(IslandOptions[selectedSea]) 
      selectedIsland = "" 
   end,
})

-- Dropdown de Ilha (Dinâmico)
TeleportTab:CreateDropdown({
   Name = "Selecionar Ilha",
   Options = IslandOptions["Sea 1"],
   CurrentOption = {""},
   Flag = "IslandDropdown", 
   Callback = function(Option)
      selectedIsland = Option[1]
   end,
})

TeleportTab:CreateToggle({
   Name = "Iniciar Viagem",
   CurrentValue = false,
   Flag = "TPIsland",
   Callback = function(Value)
      _G.Teleporting = Value
      if Value then
         if selectedIsland ~= "" and selectedIsland ~= nil then
            local target = TeleportModule.Islands[selectedSea][selectedIsland]
            if target then 
               local flight = TeleportModule.ToPos(target, true)
               if flight then
                  flight.Completed:Connect(function()
                     if _G.Teleporting then
                        _G.Teleporting = false
                        Rayfield.Flags["TPIsland"]:Set(false)
                     end
                  end)
               end
            end
         else
            Rayfield:Notify({Title = "Aviso", Content = "Escolha uma ilha!", Duration = 3})
            Rayfield.Flags["TPIsland"]:Set(false)
         end
      else
         -- Para o voo se desligar o toggle
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

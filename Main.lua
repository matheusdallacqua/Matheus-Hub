-- [[ MATHEUS HUB - MAIN COMPLEXO ]]
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

-- === ABA DE TELEPORTES ===
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
TeleportTab:CreateSection("Seletor de Mundo")

local selectedSea = "Sea 1"
local selectedIsland = ""

TeleportTab:CreateDropdown({
   Name = "Selecionar Sea",
   Options = {"Sea 1", "Sea 2", "Sea 3"},
   CurrentOption = {"Sea 1"},
   Callback = function(Option) selectedSea = Option[1] end,
})

TeleportTab:CreateDropdown({
   Name = "Selecionar Ilha",
   Options = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village", "Cafe", "Kingdom of Rose", "Green Bit", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Castle on the Sea", "Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats"},
   Callback = function(Option) selectedIsland = Option[1] end,
})

TeleportTab:CreateToggle({
   Name = "Teleportar para Ilha",
   CurrentValue = false,
   Flag = "TPIsland",
   Callback = function(Value)
      if Value then
         if selectedIsland ~= "" then
            local target = TeleportModule.Islands[selectedSea][selectedIsland]
            if target then TeleportModule.ToPos(target) end
         else
            Rayfield:Notify({Title = "Aviso", Content = "Escolha uma ilha!", Duration = 3})
         end
         task.wait(0.5)
         Rayfield.Flags["TPIsland"]:Set(false)
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

-- === ABA DE FRUTAS (A QUE VOCÊ QUERIA COMPLEXA) ===
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)

FruitTab:CreateSection("Farm de Frutas")

FruitTab:CreateToggle({
   Name = "Auto Collect Fruit (Voo Seguro)",
   CurrentValue = false,
   Flag = "AutoFruit",
   Callback = function(Value)
      if Value then
         -- Chama a função complexa que criamos no Fruits.lua
         FruitsModule.TeleportToFruit(true)
         
         -- Desliga o toggle automaticamente após a execução
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

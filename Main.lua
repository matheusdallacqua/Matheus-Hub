-- [[ MATHEUS HUB - MAIN COMPLETO ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === CONFIGURAÇÃO DOS LINKS (MÓDULOS GITHUB) ===
local URL_TELEPORT = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Teleport.lua"
local URL_VISUALS  = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Visual.lua"
local URL_FRUITS   = "https://raw.githubusercontent.com/matheusdallacqua/Matheus-Hub/refs/heads/main/Fruits.lua"

-- Carregando os Módulos
local TeleportModule = loadstring(game:HttpGet(URL_TELEPORT))()
local VisualsModule  = loadstring(game:HttpGet(URL_VISUALS))()
local FruitsModule   = loadstring(game:HttpGet(URL_FRUITS))()

local Window = Rayfield:CreateWindow({
   Name = "Matheus Hub",
   LoadingTitle = "Carregando Matheus Hub...",
   LoadingSubtitle = "by Matheus",
   ConfigurationSaving = { Enabled = true, FolderName = "MatheusHub", FileName = "Config" },
   KeySystem = false
})

-- === ABA DE TELEPORTES ===
local TeleportTab = Window:CreateTab("Teleports", 4483362458)

TeleportTab:CreateSection("Selecione o Sea e a Ilha")

TeleportTab:CreateDropdown({
   Name = "Sea 1 (Old World)",
   Options = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village"},
   Callback = function(Option) _G.SelectedIsland = Option[1]; _G.SelectedSea = "Sea 1" end,
})

TeleportTab:CreateDropdown({
   Name = "Sea 2 (New World)",
   Options = {"Cafe", "Kingdom of Rose", "Green Bit", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island"},
   Callback = function(Option) _G.SelectedIsland = Option[1]; _G.SelectedSea = "Sea 2" end,
})

TeleportTab:CreateDropdown({
   Name = "Sea 3",
   Options = {"Castle on the Sea", "Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats"},
   Callback = function(Option) _G.SelectedIsland = Option[1]; _G.SelectedSea = "Sea 3" end,
})

-- === INTERRUPTOR DE TELEPORTE (TOGGLE) ===
TeleportTab:CreateToggle({
   Name = "Iniciar Viagem",
   CurrentValue = false,
   Flag = "TeleportToggle",
   Callback = function(Value)
      if Value then
         -- Verifica se o usuário escolheu uma ilha
         if _G.SelectedSea and _G.SelectedIsland then
            local target = TeleportModule.Islands[_G.SelectedSea][_G.SelectedIsland]
            if target then 
               TeleportModule.ToPos(target) 
            end
         else
            Rayfield:Notify({Title = "Erro", Content = "Selecione uma ilha primeiro!", Duration = 3})
         end
         
         -- Faz o interruptor voltar para "Desligado" sozinho após iniciar o movimento
         task.wait(0.5)
         Rayfield.Flags["TeleportToggle"]:Set(false)
      end
   end,
})


-- === ABA DE VISUALS (ESP) ===
local VisualTab = Window:CreateTab("Visuals", 4483362458)

VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value) VisualsModule.PlayerESP(Value) end,
})

VisualTab:CreateToggle({
   Name = "Fruit ESP (No Chão)",
   CurrentValue = false,
   Callback = function(Value) VisualsModule.FruitESP(Value) end,
})

-- === ABA DE FRUTAS ===
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)

FruitTab:CreateSection("Ações")

FruitTab:CreateButton({
   Name = "Ir até Fruta no Chão (TP Fruit)",
   Callback = function() FruitsModule.TeleportToFruit() end,
})

FruitTab:CreateButton({
   Name = "Gacha de Fruta (Random)",
   Callback = function() FruitsModule.BuyGacha() end,
})

Rayfield:Notify({Title = "Matheus Hub", Content = "Script carregado com sucesso!", Duration = 5})

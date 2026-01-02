-- [[ ARQUIVO PRINCIPAL: main.lua ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === CONFIGURAÇÃO DE LINKS ===
-- IMPORTANTE: Vá no seu GitHub, abra o teleport.lua, clique em "Raw" e copie o link.
-- Cole o link entre as aspas abaixo:
local URL_TELEPORT = "COLE_AQUI_O_SEU_LINK_RAW_DO_TELEPORT_LUA"

-- Carregando sua "pasta" de teleporte do GitHub
local TeleportModule = loadstring(game:HttpGet(URL_TELEPORT))()

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

-- Dropdown Sea 1
TeleportTab:CreateDropdown({
   Name = "Sea 1 (Old World)",
   Options = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village"},
   Callback = function(Option) 
      _G.SelectedIsland = Option[1] 
      _G.SelectedSea = "Sea 1"
   end,
})

-- Dropdown Sea 2 (New World)
TeleportTab:CreateDropdown({
   Name = "Sea 2 (New World)",
   Options = {"Cafe", "Kingdom of Rose", "Green Bit", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island"},
   Callback = function(Option) 
      _G.SelectedIsland = Option[1] 
      _G.SelectedSea = "Sea 2"
   end,
})

-- Dropdown Sea 3
TeleportTab:CreateDropdown({
   Name = "Sea 3",
   Options = {"Castle on the Sea", "Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats"},
   Callback = function(Option) 
      _G.SelectedIsland = Option[1] 
      _G.SelectedSea = "Sea 3"
   end,
})

TeleportTab:CreateSection("Controle")

TeleportTab:CreateToggle({
   Name = "Iniciar Viagem",
   CurrentValue = false,
   Flag = "TeleportToggle",
   Callback = function(Value)
      _G.TeleportActive = Value
      if _G.TeleportActive then
         -- Busca a ilha dentro da estrutura de "Seas" que criamos no teleport.lua
         local target = TeleportModule.Islands[_G.SelectedSea][_G.SelectedIsland]
         
         if target then 
            TeleportModule.ToPos(target)
            
            -- Desliga o botão automaticamente ao iniciar o movimento
            task.wait(0.5)
            Rayfield.Flags["TeleportToggle"]:Set(false)
         else
            Rayfield:Notify({Title = "Erro", Content = "Selecione uma ilha primeiro!", Duration = 3})
            Rayfield.Flags["TeleportToggle"]:Set(false)
         end
      end
   end,
})

-- === ABA DE FRUTAS ===
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)
FruitTab:CreateButton({
   Name = "Gacha de Fruta (Random)",
   Callback = function() 
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy") 
   end,
})

Rayfield:Notify({Title = "Matheus Hub", Content = "Script carregado com sucesso!", Duration = 5})

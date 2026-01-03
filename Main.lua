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

-- === ABA TELEPORT (ESTILO HOHO/TSUO) ===
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Lista de nomes para o Dropdown (Pura, sem coordenadas)
local IslandList = {
    ["Sea 1"] = {"Starter Island", "Jungle", "Desert", "Middle Town", "Frozen Village", "Marineford", "Skypiea", "Prison", "Magma Village", "Fountain City"},
    ["Sea 2"] = {"Cafe", "Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Dark Arena"},
    ["Sea 3"] = {"Mansion", "Port Town", "Hydra Island", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats", "Tiki Outpost"}
}

local SelectedSea = CurrentSea
local SelectedIsland = ""

TeleportTab:CreateSection("World Travel")

-- Botões de Viagem entre Mundos (Padrão Tsuo)
local WorldButtons = {
    {"Travel Sea 1", "TravelMain"},
    {"Travel Sea 2", "TravelDressrosa"},
    {"Travel Sea 3", "TravelZou"}
}

for _, data in pairs(WorldButtons) do
    TeleportTab:CreateButton({
        Name = data[1],
        Callback = function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(data[2])
        end,
    })
end

TeleportTab:CreateSection("Island Teleport")

-- Dropdown de Seleção de Mar
TeleportTab:CreateDropdown({
    Name = "Select Sea",
    Options = {"Sea 1", "Sea 2", "Sea 3"},
    CurrentOption = {CurrentSea},
    Flag = "SeaDropdown",
    Callback = function(Option)
        SelectedSea = Option[1]
        -- Atualiza o Dropdown de ilhas com a lista correta
        Rayfield.Flags["IslandDropdown"]:Set(IslandList[SelectedSea])
    end,
})

-- Dropdown de Seleção de Ilha
TeleportTab:CreateDropdown({
    Name = "Select Island",
    Options = IslandList[CurrentSea],
    CurrentOption = {""},
    Flag = "IslandDropdown",
    Callback = function(Option)
        SelectedIsland = Option[1]
    end,
})

-- Toggle de Iniciar Teleporte (Voo do Tsuo)
TeleportTab:CreateToggle({
    Name = "Start Teleport",
    CurrentValue = false,
    Flag = "ToggleTeleport",
    Callback = function(Value)
        _G.Teleporting = Value
        if Value then
            if SelectedIsland ~= "" then
                -- Puxa a CFrame do módulo externo
                local target = TeleportModule.Islands[SelectedSea][SelectedIsland]
                if target then
                    TeleportModule.ToPos(target, true)
                end
            else
                Rayfield:Notify({Title = "Error", Content = "Select an Island First!", Duration = 3})
                Rayfield.Flags["ToggleTeleport"]:Set(false)
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

-- === ABA DE FRUTAS (CORRIGIDA E CONECTADA) ===
local FruitTab = Window:CreateTab("Devil Fruit", 4483362458)

FruitTab:CreateSection("Fruit Collector & Store")

-- Corrigido: Agora chama FruitsModule (o arquivo certo)
FruitTab:CreateToggle({
    Name = "Auto Collect Spawned Fruits",
    CurrentValue = false,
    Flag = "TsuoFruitToggle",
    Callback = function(Value)
        FruitsModule.AutoCollectFruit(Value)
    end,
})

-- Bring Fruit FruitTab
FruitTab:CreateToggle({
    Name = "Bring All Fruits (Exploit)",
    CurrentValue = false,
    Flag = "BringFruits",
    Callback = function(Value)
        FruitsModule.BringFruits(Value)
    end,
})


-- Corrigido: Agora chama FruitsModule.AutoStoreFruit
FruitTab:CreateToggle({
    Name = "Auto Store Fruit",
    CurrentValue = false,
    Flag = "AutoStore",
    Callback = function(Value)
        _G.AutoStore = Value
        if Value then
            spawn(function()
                while _G.AutoStore do
                    FruitsModule.AutoStoreFruit(true)
                    task.wait(2)
                end
            end)
        end
    end,
})

FruitTab:CreateSection("Gacha & Shop Sniper")

-- Corrigido: Auto random fruit BuyGacha
FruitTab:CreateToggle({
    Name = "Auto Gacha (Fica Tentando)",
    CurrentValue = false,
    Flag = "AutoGachaLoop",
    Callback = function(Value)
        _G.TentandoGacha = Value
        if Value then
            task.spawn(function()
                while _G.TentandoGacha do
                    -- Tenta girar a fruta
                    FruitsModule.BuyGacha()
                    -- Espera 60 segundos antes de tentar de novo
                    -- Assim não dá lag e pega a fruta no minuto que liberar
                    task.wait(60) 
                end
            end)
        end
    end,
})


-- Sniper Label (Agora chamando o seu módulo atualizado)
local StockLabel = FruitTab:CreateLabel("Fetching Stock...")

task.spawn(function()
    while task.wait(30) do
        -- Em vez de fazer a conta aqui, ele pede para o VisualsModule o texto pronto
        local currentStock = VisualsModule.GetStock()
        StockLabel:Set("Stock: " .. currentStock)
    end
end)


-- [[ SISTEMA ANTI-AFK - TSUO STYLE ]]
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:LoadConfiguration() -- Carrega as configs salvas do usuário


Rayfield:Notify({Title = "Matheus Hub", Content = "O Moreninha Covaaardeee!", Duration = 3})

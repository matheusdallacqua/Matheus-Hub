-- [[ FRUITS.LUA - MATHEUS HUB ULTRA VERSION 2026 ]]
local FruitsModule = {}
local Player = game.Players.LocalPlayer

-- === FUNÇÃO GACHA (TRIPLO MÉTODO) ===
function FruitsModule.BuyGacha()
    pcall(function()
        -- MÉTODO 1: O que você pegou no Turtle Spy (Evento)
        game:GetService("ReplicatedStorage").Modules.Net["RF/GachaUtilRF"]:InvokeServer({
            ["Context"] = "getGachaFromBoxName",
            ["BoxName"] = "SummerWeek5Gacha"
        })

        -- MÉTODO 2: Método "Cousin" Tradicional
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")

        -- MÉTODO 3: Método alternativo de Inventory (Alguns servidores usam)
        game:GetService("ReplicatedStorage").Modules.Net["RF/InventoryUtilRF"]:InvokeServer({
            ["Context"] = "BuyGacha"
        })
    end)
end

-- === FUNÇÃO AUTO STORE (BASEADA NO SEU SPY) ===
function FruitsModule.AutoStore()
    pcall(function()
        local function checkAndStore(tool)
            if tool:IsA("Tool") and (tool:GetAttribute("Fruit") or tool.Name:find("Fruit") or tool.Name:find("Fruta")) then
                local fName = tool:GetAttribute("FruitName") or tool.Name
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fName, tool)
            end
        end

        for _, v in pairs(Player.Backpack:GetChildren()) do checkAndStore(v) end
        for _, v in pairs(Player.Character:GetChildren()) do checkAndStore(v) end
    end)
end

-- === FUNÇÃO BRING FRUITS (PUXAR FRUTAS DO MAPA) ===
function FruitsModule.BringFruits(state)
    _G.BringFruits = state
    task.spawn(function()
        while _G.BringFruits do
            pcall(function()
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            handle.CFrame = Player.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

-- === FUNÇÃO AUTO COLLECT (VOAR ATÉ A FRUTA) ===
function FruitsModule.AutoCollectFruit(state)
    _G.AutoCollect = state
    task.spawn(function()
        while _G.AutoCollect do
            pcall(function()
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            Player.Character.HumanoidRootPart.CFrame = handle.CFrame
                            task.wait(0.5)
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

-- === LISTA DE FRUTAS (PARA IDENTIFICAÇÃO E LOGS) ===
FruitsModule.FruitList = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke", 
    "Spike-Spike", "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Sand", 
    "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Barrier-Barrier", "Ghost-Ghost", 
    "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love", "Spider-Spider", 
    "Sound-Sound", "Phoenix-Phoenix", "Portal-Portal", "Rumble-Rumble", "Pain-Pain", 
    "Blizzard-Blizzard", "Gravity-Gravity", "Mammoth-Mammoth", "T-Rex-T-Rex", 
    "Dough-Dough", "Venom-Venom", "Control-Control", "Spirit-Spirit", "Shadow-Shadow", 
    "Leopard-Leopard", "Kitsune-Kitsune", "Dragon-Dragon"
}

return FruitsModule

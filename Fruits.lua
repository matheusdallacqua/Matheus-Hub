-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ CONFIGURAÇÕES INTERNAS ]]
local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
local Player = game.Players.LocalPlayer

-- [[ 1. BLOX FRUIT GACHA (GIRO REAL) ]]
function FruitModule.BuyGacha()
    local result = Remote:InvokeServer("Cousin", "BuyItem")
    -- Após girar, o Tsuo tenta guardar automaticamente 3 vezes
    task.spawn(function()
        for i = 1, 3 do
            task.wait(1)
            FruitModule.AutoStoreFruit(true)
        end
    end)
    return result
end

-- [[ 2. AUTO COLLECT (MODO TWEEN - ANTI BAN) ]]
function FruitModule.AutoCollectFruit(state)
    _G.Auto_Collect_Fruit = state
    task.spawn(function()
        while _G.Auto_Collect_Fruit do
            task.wait(0.1)
            pcall(function()
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v:GetAttribute("Fruit")) then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            local root = Player.Character.HumanoidRootPart
                            -- Teleporte Seguro
                            root.CFrame = handle.CFrame
                            task.wait(0.2)
                            firetouchinterest(root, handle, 0)
                            firetouchinterest(root, handle, 1)
                        end
                    end
                end
            end)
        end
    end)
end

-- [[ 3. BRING FRUITS (TRAZ AS FRUTAS ATÉ VOCÊ) ]]
function FruitModule.BringFruits(state)
    _G.BringFruits = state
    task.spawn(function()
        while _G.BringFruits do
            task.wait(0.5)
            pcall(function()
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v:GetAttribute("Fruit")) then
                        local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                        if handle then
                            handle.CFrame = Player.Character.HumanoidRootPart.CFrame
                            handle.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)
end

-- [[ 4. AUTO STORE (SCANNER DE INVENTÁRIO COMPLETO) ]]
function FruitModule.AutoStoreFruit(state)
    _G.AutoStore = state
    task.spawn(function()
        while _G.AutoStore do
            task.wait(1)
            -- Scan na Backpack (Mochila)
            for _, item in pairs(Player.Backpack:GetChildren()) do
                if item.Name:find("Fruit") or item:GetAttribute("Fruit") then
                    Remote:InvokeServer("StoreFruit", item.Name, item)
                end
            end
            -- Scan no Character (Mão)
            if Player.Character then
                for _, item in pairs(Player.Character:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                        Remote:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
            end
            -- Se não quiser que o loop rode eterno, pare aqui se o state for falso
            if not _G.AutoStore then break end
        end
    end)
end

-- [[ 5. FRUIT SNIPER (AUTO BUY SE ESTIVER NO STOCK) ]]
function FruitModule.SniperBuy(fruitName)
    -- Compra uma fruta específica se ela estiver à venda
    return Remote:InvokeServer("Shop", "BuyItem", fruitName)
end

return FruitModule

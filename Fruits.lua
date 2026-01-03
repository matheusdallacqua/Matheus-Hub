-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ CONFIGURAÇÕES INTERNAS ]]
local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
local Player = game.Players.LocalPlayer

-- [[ 1. BLOX FRUIT GACHA (MÉTODO DIRETO - SEM TELEPORTE) ]]
function FruitModule.BuyGacha()
    -- Dispara o sinal direto pro servidor (Igual Banana/Azure/Redz)
    pcall(function()
        -- Sea 2 e 3
        Remote:InvokeServer("BloxFruitGacha", "Roll")
    end)
    
    pcall(function()
        -- Sea 1 (Cousin)
        Remote:InvokeServer("Cousin", "BuyItem")
    end)

    -- Auto Store (Garante que guarda o que girou)
    task.spawn(function()
        task.wait(1.5)
        local character = Player.Character
        local backpack = Player.Backpack
        
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                Remote:InvokeServer("StoreFruit", item.Name, item)
            end
        end
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                    Remote:InvokeServer("StoreFruit", item.Name, item)
                end
            end
        end
    end)
end

-- [[ 2. AUTO COLLECT (MÉTODO TWEEN/TP) ]]
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

-- [[ 3. BRING FRUITS (TRAZER PARA SI) ]]
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

-- [[ 4. AUTO STORE (MÉTODO DEFINITIVO) ]]
function FruitModule.AutoStoreFruit(state)
    _G.AutoStore = state
    if not state then return end
    
    task.spawn(function()
        while _G.AutoStore do
            pcall(function()
                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                        Remote:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
                if Player.Character then
                    for _, item in pairs(Player.Character:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                            Remote:InvokeServer("StoreFruit", item.Name, item)
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

return FruitModule

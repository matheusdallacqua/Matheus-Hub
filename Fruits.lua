-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ CONFIGURAÇÕES INTERNAS ]]
local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
local Player = game.Players.LocalPlayer

-- [[ 1. BLOX FRUIT GACHA (ESTILO W-AZURE / BANANA) ]]
function FruitModule.BuyGacha()
    local character = Player.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local oldPos = root.CFrame
    
    local gachaNPC = nil
    for _, v in pairs(game:GetService("Workspace").NPCs:GetDescendants()) do
        if v.Name == "Blox Fruit Gacha" or v.Name == "Cousin" then
            gachaNPC = v
            break
        end
    end

    if gachaNPC then
        root.CFrame = gachaNPC:GetModelCFrame()
        task.wait(0.3)
        
        -- AJUSTE: Sequência correta para simular o clique nos botões (Estilo Redz/W-Azure)
        pcall(function()
            Remote:InvokeServer("BloxFruitGacha", "Gacha") -- Simula o "Oi" pro NPC
            task.wait(0.1)
            Remote:InvokeServer("BloxFruitGacha", "Roll")  -- Simula o "Girar"
            Remote:InvokeServer("Cousin", "BuyItem")       -- Fallback Sea 1
        end)
        
        task.wait(0.2)
        root.CFrame = oldPos
        
        -- Auto Store reforçado
        task.spawn(function()
            for i = 1, 3 do
                task.wait(1)
                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item.Name:find("Fruit") or item:GetAttribute("Fruit") then
                        Remote:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
                -- Checa a mão também
                for _, item in pairs(character:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit")) then
                        Remote:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
            end
        end)
    else
        pcall(function() Remote:InvokeServer("BloxFruitGacha", "Roll") end)
    end
end

-- [[ 2. AUTO COLLECT ]]
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

-- [[ 3. BRING FRUITS ]]
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

-- [[ 4. AUTO STORE (W-AZURE & BANANA HUB METHOD) ]]
function FruitModule.AutoStoreFruit(state)
    _G.AutoStore = state
    if not state then return end
    
    task.spawn(function()
        while _G.AutoStore do
            pcall(function()
                local character = Player.Character
                local backpack = Player.Backpack
                
                -- Função interna para disparar o store no item correto
                local function StoreItem(item)
                    if item:IsA("Tool") and (item.Name:find("Fruit") or item:GetAttribute("Fruit") or item.Name:find("Fruta")) then
                        -- O segredo do Azure: disparar o Remote passando o nome e o OBJETO
                        Remote:InvokeServer("StoreFruit", tostring(item.Name), item)
                    end
                end

                -- Limpa a Mochila
                for _, item in pairs(backpack:GetChildren()) do
                    StoreItem(item)
                end
                
                -- Limpa a Mão (Character)
                if character then
                    for _, item in pairs(character:GetChildren()) do
                        StoreItem(item)
                    end
                end
            end)
            task.wait(1.5) -- Intervalo seguro para não dar kick por spam
        end
    end)
end

return FruitModule

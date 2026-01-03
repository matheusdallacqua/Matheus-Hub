-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ CONFIGURAÇÕES INTERNAS ]]
local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
local Player = game.Players.LocalPlayer

-- [[ 1. BLOX FRUIT GACHA (GIRO REAL) ]]
--- [[ 1. O GACHA QUE FUNCIONA (TELEPORT + MULTI-REMOTE) ]]
function FruitModule.BuyGacha()
    local character = Player.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local oldPos = root.CFrame -- Guarda a tua posição para voltar depois
    
    -- Busca o NPC em qualquer Sea (Selva, Café ou Mansão)
    local gachaNPC = nil
    for _, v in pairs(game:GetService("Workspace").NPCs:GetDescendants()) do
        if v.Name == "Blox Fruit Gacha" or v.Name == "Cousin" then
            gachaNPC = v
            break
        end
    end

    if gachaNPC then
        -- Teleporte instantâneo para o NPC (Bypass de distância)
        root.CFrame = gachaNPC:GetModelCFrame()
        task.wait(0.3) -- Tempo para o servidor processar a tua chegada
        
        -- Tenta todos os Remotes conhecidos até hoje
        local methods = {"BloxFruitGacha", "Cousin"}
        for _, method in pairs(methods) do
            pcall(function()
                Remote:InvokeServer(method, "Roll")
                Remote:InvokeServer(method, "BuyItem")
            end)
        end
        
        task.wait(0.2)
        root.CFrame = oldPos -- Volta-te para onde estavas
        
        -- Auto Store (Tenta guardar 3 vezes para garantir com o teu lag)
        task.spawn(function()
            for i = 1, 3 do
                task.wait(1)
                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item.Name:find("Fruit") or item.Name:find("Fruta") then
                        Remote:InvokeServer("StoreFruit", item.Name, item)
                    end
                end
            end
        end)
    else
        -- Se não encontrar o NPC físico, tenta o Remote direto por segurança
        pcall(function() Remote:InvokeServer("BloxFruitGacha", "Roll") end)
    end
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


return FruitModule

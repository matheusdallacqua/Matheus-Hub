-- [[ FRUITS.LUA - MATHEUS HUB 2026 (COMPLETO E FUNCIONAL) ]]
local FruitsModule = {}
local Player = game.Players.LocalPlayer

-- === LISTA COMPLETA DE FRUTAS 2026 ===
FruitsModule.FruitList = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb",
    "Smoke-Smoke", "Spike-Spike", "Flame-Flame", "Ice-Ice", "Sand-Sand",
    "Dark-Dark", "Eagle-Eagle", "Diamond-Diamond", "Light-Light", "Rubber-Rubber",
    "Ghost-Ghost", "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
    "Creation-Creation", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix",
    "Portal-Portal", "Lightining-Lightning", "Blizzard-Blizzard", "Gravity-Gravity",
    "Mammoth-Mammoth", "T-Rex-T-Rex", "Dough-Dough", "Shadow-Shadow", "Venom-Venom",
    "Gas-Gas", "Spirit-Spirit", "Tiger-Tiger", "Yeti-Yeti", "Kitsune-Kitsune",
    "Control-Control", "Dragon-Dragon"
}

-- === TABELA DE FRUTAS MÍTICAS ===
local MythicalFruits = {
    ["Dough-Dough"] = true,
    ["Shadow-Shadow"] = true,
    ["Venom-Venom"] = true,
    ["Control-Control"] = true,
    ["Spirit-Spirit"] = true,
    ["Dragon-Dragon"] = true,
    ["Tiger-Tiger"] = true,
    ["Kitsune-Kitsune"] = true,
    ["Mammoth-Mammoth"] = true,
    ["T-Rex-T-Rex"] = true,
    ["Gravity-Gravity"] = true
}

-- === VARIÁVEIS DE CONTROLE ===
local AutoGachaThread = nil
local AutoCollectThread = nil
local BringFruitsThread = nil
local AutoStoreThread = nil

-- === FUNÇÃO: AUTO GACHA ===
function FruitsModule.BuyGacha()
    pcall(function()
        -- Método 1: Remoto padrão do Blox Fruits
        local args = {"Cousin", "Buy"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        
        -- Método alternativo caso o primeiro falhe
        if not success then
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyCousin")
            if remote then
                remote:InvokeServer()
            end
        end
    end)
end

-- === FUNÇÃO: LOOP AUTO GACHA ===
function FruitsModule.StartAutoGacha(state)
    if AutoGachaThread then
        task.cancel(AutoGachaThread)
        AutoGachaThread = nil
    end
    
    if not state then return end
    
    AutoGachaThread = task.spawn(function()
        while _G.AutoGachaLoop do
            pcall(function()
                FruitsModule.BuyGacha()
            end)
            task.wait(0.3) -- Delay entre cada gacha (evita spam)
        end
    end)
end

-- === FUNÇÃO: AUTO COLLECT FRUITS ===
function FruitsModule.AutoCollectFruit(state)
    if AutoCollectThread then
        task.cancel(AutoCollectThread)
        AutoCollectThread = nil
    end
    
    if not state then return end
    
    AutoCollectThread = task.spawn(function()
        while _G.AutoCollectFruit do
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local rootPart = character.HumanoidRootPart
                
                -- Procura frutas próximas
                for _, fruit in pairs(game.Workspace:GetDescendants()) do
                    if fruit:IsA("Tool") then
                        local isFruit = fruit.Name:find("Fruit") or fruit.Name:find("Fruta") or fruit:GetAttribute("Fruit")
                        
                        if isFruit then
                            local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                            if handle then
                                local distance = (handle.Position - rootPart.Position).Magnitude
                                
                                -- Se estiver perto (15 studs), coleta
                                if distance < 15 then
                                    firetouchinterest(rootPart, handle, 0)
                                    firetouchinterest(rootPart, handle, 1)
                                    task.wait(0.2) -- Delay entre coletas
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(1) -- Verifica a cada 1 segundo
        end
    end)
end

-- === FUNÇÃO: BRING FRUITS TO PLAYER ===
function FruitsModule.BringFruits(state)
    if BringFruitsThread then
        task.cancel(BringFruitsThread)
        BringFruitsThread = nil
    end
    
    if not state then return end
    
    BringFruitsThread = task.spawn(function()
        while _G.BringFruits do
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local rootPart = character.HumanoidRootPart
                
                for _, fruit in pairs(game.Workspace:GetDescendants()) do
                    if fruit:IsA("Tool") then
                        local isFruit = fruit.Name:find("Fruit") or fruit.Name:find("Fruta") or fruit:GetAttribute("Fruit")
                        
                        if isFruit then
                            local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                            if handle then
                                -- Move a fruta suavemente para o jogador
                                local direction = (rootPart.Position - handle.Position).Unit
                                local newPosition = handle.Position + (direction * 10)
                                
                                -- Teleporta a fruta (sem físicas bruscas)
                                handle.CFrame = CFrame.new(newPosition)
                            end
                        end
                    end
                end
            end)
            task.wait(2) -- Atualiza a cada 2 segundos (não sobrecarrega)
        end
    end)
end

-- === FUNÇÃO: AUTO STORE FRUITS ===
function FruitsModule.AutoStore()
    pcall(function()
        -- Primeiro verifica se há frutas na mochila
        local hasFruits = false
        
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local isFruit = tool.Name:find("Fruit") or tool.Name:find("Fruta") or tool:GetAttribute("Fruit")
                
                if isFruit then
                    hasFruits = true
                    
                    -- Tenta identificar o nome exato da fruta
                    local fruitName = tool.Name
                    for _, fName in pairs(FruitsModule.FruitList) do
                        if tool.Name:find(fName:split("-")[1]) then
                            fruitName = fName
                            break
                        end
                    end
                    
                    -- Tenta guardar a fruta
                    local args = {"StoreFruit", fruitName, tool}
                    local success = pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end)
                    
                    if success then
                        print("[SUCCESS] Fruta guardada:", fruitName)
                    else
                        print("[ERROR] Falha ao guardar:", fruitName)
                    end
                    
                    task.wait(0.5) -- Delay entre cada fruta
                end
            end
        end
        
        -- Também verifica frutas equipadas
        for _, tool in pairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                local isFruit = tool.Name:find("Fruit") or tool.Name:find("Fruta") or tool:GetAttribute("Fruit")
                
                if isFruit then
                    -- Desequipa primeiro
                    Player.Character.Humanoid:UnequipTools()
                    task.wait(0.3)
                    
                    -- Tenta guardar
                    local fruitName = tool.Name
                    for _, fName in pairs(FruitsModule.FruitList) do
                        if tool.Name:find(fName:split("-")[1]) then
                            fruitName = fName
                            break
                        end
                    end
                    
                    local args = {"StoreFruit", fruitName, tool}
                    local success = pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    end)
                    
                    if success then
                        print("[SUCCESS] Fruta guardada (equipada):", fruitName)
                    end
                    
                    task.wait(0.5)
                end
            end
        end
        
        return hasFruits
    end)
end

-- === FUNÇÃO: LOOP AUTO STORE ===
function FruitsModule.StartAutoStore(state)
    if AutoStoreThread then
        task.cancel(AutoStoreThread)
        AutoStoreThread = nil
    end
    
    if not state then return end
    
    AutoStoreThread = task.spawn(function()
        while _G.AutoStoreFruit do
            local hasStored = FruitsModule.AutoStore()
            
            if hasStored then
                task.wait(3) -- Se guardou algo, espera 3 segundos
            else
                task.wait(10) -- Se não tinha frutas, espera 10 segundos
            end
        end
    end)
end

-- === FUNÇÃO: CHECK MYTHICAL FRUIT ===
function FruitsModule.IsMythical(fruitName)
    return MythicalFruits[fruitName] or false
end

-- === FUNÇÃO: GET FRUIT COLOR ===
function FruitsModule.GetFruitColor(fruitName)
    if MythicalFruits[fruitName] then
        return Color3.fromRGB(255, 215, 0) -- Dourado para míticas
    elseif fruitName:find("Buddha") then
        return Color3.fromRGB(255, 215, 0) -- Buda também dourado
    elseif fruitName:find("Light") or fruitName:find("Flame") or fruitName:find("Magma") then
        return Color3.fromRGB(255, 100, 0) -- Laranja para elementos
    else
        return Color3.fromRGB(255, 255, 255) -- Branco padrão
    end
end

-- === FUNÇÃO: FIND NEAREST FRUIT ===
function FruitsModule.FindNearestFruit()
    local nearest = nil
    local nearestDistance = math.huge
    local character = Player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local rootPos = character.HumanoidRootPart.Position
    
    pcall(function()
        for _, fruit in pairs(game.Workspace:GetDescendants()) do
            if fruit:IsA("Tool") then
                local isFruit = fruit.Name:find("Fruit") or fruit.Name:find("Fruta") or fruit:GetAttribute("Fruit")
                
                if isFruit then
                    local handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        local distance = (handle.Position - rootPos).Magnitude
                        
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearest = fruit
                        end
                    end
                end
            end
        end
    end)
    
    return nearest, nearestDistance
end

-- === FUNÇÃO: TELEPORT TO NEAREST FRUIT ===
function FruitsModule.TeleportToNearestFruit()
    local fruit, distance = FruitsModule.FindNearestFruit()
    
    if fruit and fruit:FindFirstChild("Handle") then
        local handle = fruit.Handle
        local tweenService = game:GetService("TweenService")
        local character = Player.Character
        
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = handle.CFrame + Vector3.new(0, 5, 0)
            local tweenInfo = TweenInfo.new(distance / 200, Enum.EasingStyle.Linear)
            local tween = tweenService:Create(character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            
            tween:Play()
            tween.Completed:Wait()
            return true
        end
    end
    
    return false
end

return FruitsModule

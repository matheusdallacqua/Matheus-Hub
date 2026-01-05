-- [[ FARM.LUA - VERSÃO COMPLETA E TESTADA ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === CONFIGURAÇÕES ===
local Config = {
    TweenSpeed = 100,           -- Velocidade do teleporte (studs/segundo)
    AttackDistance = 8,         -- Distância para atacar
    MobSearchRadius = 150,      -- Raio para procurar mobs
    QuestCheckDelay = 1,        -- Delay para verificar quest
    NPCTweenHeight = 5,         -- Altura ao teleportar para NPC
    MobTweenHeight = 3,         -- Altura ao teleportar para mobs
}

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.15
_G.SelectWeapon = _G.SelectWeapon or ""
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === TABELA COMPLETA DE QUESTS SEA 1 ===
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(1059.43872, 16.4550362, 1548.71362), 
         Mob_Pos = CFrame.new(1145.43872, 17.4550362, 1634.71362)},
        
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-1601.6554, 36.85213, 154.23784), 
         Mob_Pos = CFrame.new(-1623.6554, 21.85213, 142.23784)},
        
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(-1601.6554, 36.85213, 154.23784), 
         Mob_Pos = CFrame.new(-1236.6554, 6.85213, -493.23784)},
        
        {Level = 30, Name = "Pirate", QuestName = "PirateQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-1141.07483, 4.10001802, 3831.5498), 
         Mob_Pos = CFrame.new(-1218.07483, 4.10001802, 3911.5498)},
        
        {Level = 40, Name = "Brute", QuestName = "PirateQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(-1141.07483, 4.10001802, 3831.5498), 
         Mob_Pos = CFrame.new(-1363.07483, 15.10001802, 4172.5498)},
        
        {Level = 60, Name = "Desert Bandit", QuestName = "DesertQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(895.411987, 6.43832159, 4390.43311), 
         Mob_Pos = CFrame.new(1013.411987, 6.43832159, 4381.43311)},
        
        {Level = 75, Name = "Desert Officer", QuestName = "DesertQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(895.411987, 6.43832159, 4390.43311), 
         Mob_Pos = CFrame.new(1542.411987, 14.43832159, 4426.43311)},
        
        {Level = 90, Name = "Snow Bandit", QuestName = "SnowQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(1387.80737, 87.272789, -1298.35767), 
         Mob_Pos = CFrame.new(1287.80737, 15.272789, -1336.35767)},
        
        {Level = 100, Name = "Snowman", QuestName = "SnowQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(1387.80737, 87.272789, -1298.35767), 
         Mob_Pos = CFrame.new(1281.80737, 15.272789, -1071.35767)},
        
        {Level = 120, Name = "Chief Petty Officer", QuestName = "MarineQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-4855.66113, 20.6520939, 4304.4502), 
         Mob_Pos = CFrame.new(-4839.66113, 6.6520939, 4367.4502)},
        
        {Level = 150, Name = "Sky Bandit", QuestName = "SkyQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-4842.3422851563, 717.66949462891, -2623.0043945313), 
         Mob_Pos = CFrame.new(-1246.3422851563, 393.66949462891, -5943.0043945313)},
        
        {Level = 175, Name = "Dark Master", QuestName = "SkyQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(-4842.3422851563, 717.66949462891, -2623.0043945313), 
         Mob_Pos = CFrame.new(-1144.3422851563, 391.66949462891, -6161.0043945313)},
        
        {Level = 225, Name = "Toga Warrior", QuestName = "ColosseumQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-1577.79248, 7.41514206, -2984.57983), 
         Mob_Pos = CFrame.new(-1805.79248, 7.41514206, -2745.57983)},
        
        {Level = 250, Name = "Gladiator", QuestName = "ColosseumQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(-1577.79248, 7.41514206, -2984.57983), 
         Mob_Pos = CFrame.new(-1805.79248, 7.41514206, -3317.57983)},
        
        {Level = 300, Name = "Military Soldier", QuestName = "MagmaQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(-5314.6591796875, 12.26210975647, 8516.3876953125), 
         Mob_Pos = CFrame.new(-5414.6591796875, 11.26210975647, 8479.3876953125)},
        
        {Level = 325, Name = "Military Spy", QuestName = "MagmaQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(-5314.6591796875, 12.26210975647, 8516.3876953125), 
         Mob_Pos = CFrame.new(-5816.6591796875, 73.26210975647, 8456.3876953125)},
        
        {Level = 375, Name = "Fishman Warrior", QuestName = "FishmanQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(61122.5625, 18.4716396, 1568.79834), 
         Mob_Pos = CFrame.new(60907.5625, 18.4716396, 1546.79834)},
        
        {Level = 400, Name = "Fishman Commando", QuestName = "FishmanQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(61122.5625, 18.4716396, 1568.79834), 
         Mob_Pos = CFrame.new(61793.5625, 18.4716396, 1450.79834)},
        
        {Level = 450, Name = "God's Guard", QuestName = "SkyExp1Quest", QuestID = 1, 
         NPC_Pos = CFrame.new(-7894.6176757813, 5545.1147460938, -380.29119873047), 
         Mob_Pos = CFrame.new(-7516.9907226563, 5606.0786132813, -796.236328125)},
        
        {Level = 475, Name = "Shanda", QuestName = "SkyExp1Quest", QuestID = 2, 
         NPC_Pos = CFrame.new(-7894.6176757813, 5545.1147460938, -380.29119873047), 
         Mob_Pos = CFrame.new(-7684.20703125, 5606.84375, -1477.0672607422)},
        
        {Level = 525, Name = "Royal Squad", QuestName = "SkyExp2Quest", QuestID = 1, 
         NPC_Pos = CFrame.new(-7903.3828125, 5635.9897460938, -1411.4919433594), 
         Mob_Pos = CFrame.new(-7685.3168945313, 5607.6000976563, -1451.5568847656)},
        
        {Level = 550, Name = "Royal Soldier", QuestName = "SkyExp2Quest", QuestID = 2, 
         NPC_Pos = CFrame.new(-7903.3828125, 5635.9897460938, -1411.4919433594), 
         Mob_Pos = CFrame.new(-7869.0151367188, 5642.1391601563, -1701.7145996094)},
        
        {Level = 625, Name = "Galley Pirate", QuestName = "FountainQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(5256.666015625, 38.52693939209, 4050.447265625), 
         Mob_Pos = CFrame.new(5589.12109375, 162.52627563477, 3977.4162597656)},
        
        {Level = 650, Name = "Galley Captain", QuestName = "FountainQuest", QuestID = 2, 
         NPC_Pos = CFrame.new(5256.666015625, 38.52693939209, 4050.447265625), 
         Mob_Pos = CFrame.new(5663.8681640625, 161.01959228516, 4968.6665039063)},
    }
}

-- === THREADS ===
local MainFarmThread = nil
local AutoClickThread = nil

-- === FUNÇÕES AUXILIARES ===

-- 1. TELEPORTE SUAVE
local function SmoothTeleport(targetCFrame, heightOffset)
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return false end
    
    local humanoidRootPart = character.HumanoidRootPart
    local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
    
    -- Se está muito perto, não teleporta
    if distance < 20 then
        return true
    end
    
    -- Calcula tempo baseado na distância
    local travelTime = distance / Config.TweenSpeed
    travelTime = math.max(1, math.min(travelTime, 10)) -- Entre 1 e 10 segundos
    
    -- Ajusta altura
    local adjustedCFrame = CFrame.new(
        targetCFrame.X,
        targetCFrame.Y + (heightOffset or Config.NPCTweenHeight),
        targetCFrame.Z
    )
    
    -- Cria e executa tween
    local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = adjustedCFrame})
    
    tween:Play()
    
    -- Espera o tween terminar
    local startTime = tick()
    while tick() - startTime < travelTime + 3 do
        if not _G.AutoFarm then
            tween:Cancel()
            return false
        end
        
        local currentDistance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
        if currentDistance < 25 then
            break
        end
        
        task.wait(0.1)
    end
    
    -- Pequeno delay após teleporte
    task.wait(0.5)
    return true
end

-- 2. VERIFICA SE TEM QUEST ATIVA
local function HasActiveQuest()
    local playerGui = Player.PlayerGui
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local quest = main:FindFirstChild("Quest")
    if not quest then return false end
    
    return quest.Visible
end

-- 3. PEGA QUEST APROPRIADA PARA O LEVEL
local function GetAppropriateQuest()
    local playerLevel = Player.Data.Level.Value
    local selectedQuest = QuestData["Sea 1"][1] -- Default: primeira quest
    
    for _, quest in ipairs(QuestData["Sea 1"]) do
        if playerLevel >= quest.Level then
            selectedQuest = quest
        else
            break
        end
    end
    
    -- Se o nível for acima de 650, usa a última quest do Sea 1
    if playerLevel > 650 then
        selectedQuest = QuestData["Sea 1"][#QuestData["Sea 1"]]
    end
    
    return selectedQuest
end

-- 4. ENCONTRA MOB PRÓXIMO
local function FindClosestMob(mobName)
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return nil end
    
    local playerPos = character.HumanoidRootPart.Position
    local closestMob = nil
    local closestDistance = math.huge
    
    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local mobPos = mob.HumanoidRootPart.Position
            local distance = (mobPos - playerPos).Magnitude
            
            if distance < Config.MobSearchRadius and distance < closestDistance then
                closestDistance = distance
                closestMob = mob
            end
        end
    end
    
    return closestMob, closestDistance
end

-- 5. EQUIPA ARMA AUTOMATICAMENTE
local function AutoEquipWeapon()
    pcall(function()
        local character = Player.Character
        if not character then return end
        
        local weaponType = _G.Select_Weapon_Check or "Melee"
        local checkType = weaponType == "Fruit" and "Blox Fruit" or weaponType
        
        -- Procura na mochila
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool.ToolTip == checkType then
                _G.SelectWeapon = tool.Name
                character.Humanoid:EquipTool(tool)
                task.wait(0.2)
                return true
            end
        end
        
        -- Verifica se já está equipada
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == checkType then
                _G.SelectWeapon = tool.Name
                return true
            end
        end
        
        return false
    end)
end

-- 6. POSICIONA PARA ATACAR
local function PositionForAttack(targetMob)
    if not targetMob or not targetMob.HumanoidRootPart then return false end
    
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return false end
    
    local mobPos = targetMob.HumanoidRootPart.Position
    
    -- Posição de ataque (ao lado do mob)
    local attackPos = CFrame.new(
        mobPos.X + Config.AttackDistance,
        mobPos.Y + 3,
        mobPos.Z + Config.AttackDistance
    )
    
    -- Aplica posição
    character.HumanoidRootPart.CFrame = attackPos
    
    -- Vira para o mob
    character.HumanoidRootPart.CFrame = CFrame.new(
        character.HumanoidRootPart.Position,
        Vector3.new(mobPos.X, character.HumanoidRootPart.Position.Y, mobPos.Z)
    )
    
    return true
end

-- 7. MAGNET DE MOBS (OPCIONAL)
local function MagnetMobs(targetMob)
    if not _G.BringMobs or not targetMob then return end
    
    pcall(function()
        local character = Player.Character
        if not character or not character.HumanoidRootPart then return end
        
        local playerPos = character.HumanoidRootPart.Position
        
        for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
            if mob.Name == targetMob.Name and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local mobPos = mob.HumanoidRootPart.Position
                local distance = (mobPos - playerPos).Magnitude
                
                if distance < 100 then
                    mob.HumanoidRootPart.CFrame = CFrame.new(
                        playerPos.X,
                        playerPos.Y,
                        playerPos.Z - 5
                    )
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end

-- === AUTO CLICK ===
function FarmModule.StartAutoClick(toggle)
    _G.AutoClick = toggle
    
    if AutoClickThread then
        task.cancel(AutoClickThread)
        AutoClickThread = nil
    end
    
    if not toggle then return end
    
    AutoClickThread = task.spawn(function()
        while _G.AutoClick do
            pcall(function()
                if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
                    local virtualUser = game:GetService('VirtualUser')
                    virtualUser:CaptureController()
                    virtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(0.05)
                    virtualUser:Button1Up(Vector2.new(0, 0))
                end
            end)
            task.wait(_G.FastAttackDelay or 0.15)
        end
    end)
end

-- === SISTEMA PRINCIPAL DE FARM ===
function FarmModule.StartFarm(toggle, mode)
    _G.FarmMode = mode or "Level"
    _G.AutoFarm = toggle
    
    -- Para thread anterior
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if not toggle then 
        FarmModule.StartAutoClick(false)
        return 
    end
    
    MainFarmThread = task.spawn(function()
        local currentQuest = nil
        local currentState = "GET_QUEST"
        local attempts = 0
        
        while _G.AutoFarm do
            task.wait(Config.QuestCheckDelay)
            
            pcall(function()
                -- Verifica se o personagem existe
                local character = Player.Character
                if not character or not character.HumanoidRootPart then
                    task.wait(2)
                    return
                end
                
                -- Pega a quest apropriada
                if not currentQuest then
                    currentQuest = GetAppropriateQuest()
                end
                
                -- Verifica se tem quest ativa
                local hasQuest = HasActiveQuest()
                
                -- MÁQUINA DE ESTADOS
                if not hasQuest then
                    currentState = "GET_QUEST"
                else
                    currentState = "FARM_MOBS"
                end
                
                if currentState == "GET_QUEST" then
                    -- Para de atacar
                    FarmModule.StartAutoClick(false)
                    
                    -- Teleporta até o NPC
                    if SmoothTeleport(currentQuest.NPC_Pos, Config.NPCTweenHeight) then
                        -- Tenta aceitar a quest
                        local args = {"StartQuest", currentQuest.QuestName, currentQuest.QuestID}
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        
                        -- Espera a quest ser aceita
                        for i = 1, 15 do
                            if HasActiveQuest() then
                                break
                            end
                            task.wait(0.5)
                        end
                    end
                    
                elseif currentState == "FARM_MOBS" then
                    -- Encontra mob próximo
                    local targetMob, distance = FindClosestMob(currentQuest.Name)
                    
                    if targetMob then
                        -- Equipa arma
                        AutoEquipWeapon()
                        
                        -- Ativa auto click
                        FarmModule.StartAutoClick(true)
                        
                        -- Magnet (se ativado)
                        if _G.BringMobs then
                            MagnetMobs(targetMob)
                        end
                        
                        -- Posiciona para atacar
                        if distance > Config.AttackDistance + 5 then
                            local mobPos = targetMob.HumanoidRootPart.CFrame
                            local attackCFrame = CFrame.new(
                                mobPos.X,
                                mobPos.Y + Config.MobTweenHeight,
                                mobPos.Z
                            )
                            SmoothTeleport(attackCFrame, Config.MobTweenHeight)
                        else
                            PositionForAttack(targetMob)
                        end
                        
                        attempts = 0 -- Reseta tentativas
                        
                    else
                        -- Não encontrou mob, vai para spawn
                        FarmModule.StartAutoClick(false)
                        
                        attempts = attempts + 1
                        if attempts >= 3 then
                            -- Teleporta para spawn point
                            SmoothTeleport(currentQuest.Mob_Pos, Config.MobTweenHeight)
                            attempts = 0
                        end
                        
                        task.wait(2) -- Espera mobs spawnarem
                    end
                end
            end)
        end
        
        -- Limpeza ao finalizar
        FarmModule.StartAutoClick(false)
    end)
end

-- === STOP ALL ===
function FarmModule.StopAll()
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if AutoClickThread then
        task.cancel(AutoClickThread)
        AutoClickThread = nil
    end
    
    _G.AutoFarm = false
    _G.AutoClick = false
    
    return true
end

return FarmModule

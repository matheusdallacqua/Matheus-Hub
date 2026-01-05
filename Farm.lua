-- [[ FARM.LUA - MATHEUS HUB 2026 (VERSÃO REVISADA) ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- === VARIÁVEIS GLOBAIS ===
_G.BringMobs = _G.BringMobs or true
_G.FastAttackDelay = _G.FastAttackDelay or 0.1
_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false

-- === TABELA DE QUESTS (APENAS AS MAIS IMPORTANTES) ===
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest", QuestID = 1, NPC_Pos = CFrame.new(1059.43872, 16.4550362, 1548.71362), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601.6553955078, 36.852127075195, 154.23783874512), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601.6553955078, 36.852127075195, 154.23783874512), Mob_Pos = CFrame.new(-1236, 6, -493)},
        {Level = 30, Name = "Pirate", QuestName = "PirateQuest", QuestID = 1, NPC_Pos = CFrame.new(-1141.07483, 4.10001802, 3831.5498), Mob_Pos = CFrame.new(-1218, 4, 3911)},
        {Level = 40, Name = "Brute", QuestName = "PirateQuest", QuestID = 2, NPC_Pos = CFrame.new(-1141.07483, 4.10001802, 3831.5498), Mob_Pos = CFrame.new(-1363, 15, 4172)},
        {Level = 60, Name = "Desert Bandit", QuestName = "DesertQuest", QuestID = 1, NPC_Pos = CFrame.new(895.411987, 6.43832159, 4390.43311), Mob_Pos = CFrame.new(1013, 6, 4381)},
        {Level = 75, Name = "Desert Officer", QuestName = "DesertQuest", QuestID = 2, NPC_Pos = CFrame.new(895.411987, 6.43832159, 4390.43311), Mob_Pos = CFrame.new(1542, 14, 4426)},
        {Level = 90, Name = "Snow Bandit", QuestName = "SnowQuest", QuestID = 1, NPC_Pos = CFrame.new(1387.80737, 87.272789, -1298.35767), Mob_Pos = CFrame.new(1287, 15, -1336)},
        {Level = 100, Name = "Snowman", QuestName = "SnowQuest", QuestID = 2, NPC_Pos = CFrame.new(1387.80737, 87.272789, -1298.35767), Mob_Pos = CFrame.new(1281, 15, -1071)},
        {Level = 120, Name = "Chief Petty Officer", QuestName = "MarineQuest", QuestID = 1, NPC_Pos = CFrame.new(-4855.66113, 20.6520939, 4304.4502), Mob_Pos = CFrame.new(-4839, 6, 4367)},
        {Level = 150, Name = "Sky Bandit", QuestName = "SkyQuest", QuestID = 1, NPC_Pos = CFrame.new(-4842.3422851563, 717.66949462891, -2623.0043945313), Mob_Pos = CFrame.new(-1246, 393, -5943)},
        {Level = 175, Name = "Dark Master", QuestName = "SkyQuest", QuestID = 2, NPC_Pos = CFrame.new(-4842.3422851563, 717.66949462891, -2623.0043945313), Mob_Pos = CFrame.new(-1144, 391, -6161)},
        {Level = 225, Name = "Toga Warrior", QuestName = "ColosseumQuest", QuestID = 1, NPC_Pos = CFrame.new(-1577.79248, 7.41514206, -2984.57983), Mob_Pos = CFrame.new(-1805, 7, -2745)},
        {Level = 250, Name = "Gladiator", QuestName = "ColosseumQuest", QuestID = 2, NPC_Pos = CFrame.new(-1577.79248, 7.41514206, -2984.57983), Mob_Pos = CFrame.new(-1805, 7, -3317)},
        {Level = 300, Name = "Military Soldier", QuestName = "MagmaQuest", QuestID = 1, NPC_Pos = CFrame.new(-5314.6591796875, 12.26210975647, 8516.3876953125), Mob_Pos = CFrame.new(-5414, 11, 8479)},
        {Level = 325, Name = "Military Spy", QuestName = "MagmaQuest", QuestID = 2, NPC_Pos = CFrame.new(-5314.6591796875, 12.26210975647, 8516.3876953125), Mob_Pos = CFrame.new(-5816, 73, 8456)},
        {Level = 375, Name = "Fishman Warrior", QuestName = "FishmanQuest", QuestID = 1, NPC_Pos = CFrame.new(61122.5625, 18.4716396, 1568.79834), Mob_Pos = CFrame.new(60907, 18, 1546)},
        {Level = 400, Name = "Fishman Commando", QuestName = "FishmanQuest", QuestID = 2, NPC_Pos = CFrame.new(61122.5625, 18.4716396, 1568.79834), Mob_Pos = CFrame.new(61793, 18, 1450)},
    }
}

-- === THREADS ===
local MainFarmThread = nil
local ClickThread = nil

-- === FUNÇÕES AUXILIARES CORRIGIDAS ===

-- 1. GET CURRENT QUEST (CORRIGIDA)
local function GetCurrentQuest()
    local myLevel = Player.Data.Level.Value
    local lastValid = QuestData["Sea 1"][1]
    
    for _, quest in ipairs(QuestData["Sea 1"]) do
        if myLevel >= quest.Level then
            lastValid = quest
        else
            break
        end
    end
    
    return lastValid
end

-- 2. CHECK QUEST (CORRIGIDA)
local function HasQuest(questName, questId)
    local playerGui = Player.PlayerGui
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local questFrame = main:FindFirstChild("Quest")
    if not questFrame or not questFrame.Visible then return false end
    
    -- Verifica tanto nome quanto ID
    local questTitle = questFrame:FindFirstChild("QuestName")
    local questIdText = questFrame:FindFirstChild("QuestNumber")
    
    if questTitle then
        local hasName = string.find(questTitle.Text, questName) ~= nil
        local hasId = true
        
        if questIdText then
            hasId = string.find(questIdText.Text, tostring(questId)) ~= nil
        end
        
        return hasName and hasId
    end
    
    return false
end

-- 3. SMOOTH TWEEN (MELHORADA)
local function SmoothTween(targetCFrame)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end
    
    local root = character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    -- Se já está perto (50 studs), teleporta direto
    if distance < 50 then
        root.CFrame = targetCFrame
        return true
    end
    
    -- Velocidade dinâmica
    local speed = 250
    if distance > 1000 then speed = 300 end
    if distance > 3000 then speed = 350 end
    
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    
    -- Espera o tween completar ou timeout
    local startTime = tick()
    while tick() - startTime < 30 do  -- Timeout de 30 segundos
        if not _G.AutoFarm then
            tween:Cancel()
            return false
        end
        
        -- Verifica se chegou perto o suficiente
        local currentDist = (root.Position - targetCFrame.Position).Magnitude
        if currentDist < 25 then
            tween:Cancel()
            root.CFrame = targetCFrame
            return true
        end
        
        task.wait(0.1)
    end
    
    tween:Cancel()
    root.CFrame = targetCFrame
    return true
end

-- 4. MAGNET SEGURO (REVISADO)
local function SafeMagnet(targetMob)
    if not _G.BringMobs or not targetMob then return end
    
    pcall(function()
        local character = Player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        
        local playerPos = character.HumanoidRootPart.Position
        
        for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
            if mob.Name == targetMob.Name and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                local mobPos = mob.HumanoidRootPart.Position
                local distance = (mobPos - playerPos).Magnitude
                
                -- Só ativa magnet se estiver entre 20 e 100 studs
                if distance > 20 and distance < 100 then
                    -- Move suavemente (não teleporta bruscamente)
                    local direction = (playerPos - mobPos).Unit
                    mob.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + (direction * 5)
                    
                    -- Desativa colisão temporariamente
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end

-- 5. EQUIP WEAPON SIMPLIFICADA
local function EquipWeapon()
    pcall(function()
        local weaponName = _G.SelectWeapon
        if not weaponName then return end
        
        -- Procura na mochila
        local tool = Player.Backpack:FindFirstChild(weaponName)
        if tool then
            Player.Character.Humanoid:EquipTool(tool)
            task.wait(0.2) -- Pequeno delay após equipar
            return true
        end
        
        -- Verifica se já está equipada
        for _, v in pairs(Player.Character:GetChildren()) do
            if v:IsA("Tool") and v.Name == weaponName then
                return true
            end
        end
        
        return false
    end)
end

-- === SISTEMA DE AUTO CLICK (MELHORADO) ===
function FarmModule.StartAutoClick(toggle)
    _G.AutoClick = toggle
    
    -- Mata thread anterior
    if ClickThread then
        task.cancel(ClickThread)
        ClickThread = nil
    end
    
    if not toggle then return end
    
    ClickThread = task.spawn(function()
        local virtualUser = game:GetService('VirtualUser')
        
        while _G.AutoClick do
            pcall(function()
                if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
                    virtualUser:CaptureController()
                    virtualUser:Button1Down(Vector2.new(0, 0))
                    task.wait(0.01)
                    virtualUser:Button1Up(Vector2.new(0, 0))
                end
            end)
            
            -- Delay configurável
            task.wait(_G.FastAttackDelay or 0.1)
        end
    end)
end

-- === SISTEMA PRINCIPAL DE FARM (REESCRITO) ===
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
        print("[FARM] Auto Farm desativado")
        return 
    end
    
    print("[FARM] Iniciando Auto Farm no modo:", _G.FarmMode)
    
    MainFarmThread = task.spawn(function()
        local attemptCount = 0
        
        while _G.AutoFarm do
            task.wait(0.5) -- Loop principal mais lento
            
            pcall(function()
                -- Verifica se personagem está válido
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    print("[FARM] Esperando personagem carregar...")
                    task.wait(2)
                    return
                end
                
                -- SELEÇÃO DE MODO
                if _G.FarmMode == "Nearest" then
                    FarmModule.StartNearestFarm()
                    return
                end
                
                -- MODO LEVEL (PRINCIPAL)
                local currentQuest = GetCurrentQuest()
                if not currentQuest then
                    print("[FARM] Nenhuma quest disponível para o nível atual")
                    task.wait(5)
                    return
                end
                
                -- VERIFICA SE TEM A QUEST
                local hasQuest = HasQuest(currentQuest.QuestName, currentQuest.QuestID)
                
                if not hasQuest then
                    print("[FARM] Indo pegar quest:", currentQuest.QuestName, currentQuest.QuestID)
                    
                    -- Desliga auto click enquanto pega quest
                    FarmModule.StartAutoClick(false)
                    
                    -- Vai até o NPC
                    if SmoothTween(currentQuest.NPC_Pos) then
                        -- Aceita a quest
                        local args = {"StartQuest", currentQuest.QuestName, currentQuest.QuestID}
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        
                        -- Espera a quest aparecer
                        for i = 1, 10 do
                            if HasQuest(currentQuest.QuestName, currentQuest.QuestID) then
                                print("[FARM] Quest aceita com sucesso!")
                                break
                            end
                            task.wait(0.5)
                        end
                    end
                    
                else
                    -- PROCURA O MOB DA QUEST
                    local targetMob = game.Workspace.Enemies:FindFirstChild(currentQuest.Name)
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob.Humanoid.Health > 0 then
                        print("[FARM] Atacando:", currentQuest.Name)
                        
                        -- Equipa arma e ativa auto click
                        EquipWeapon()
                        FarmModule.StartAutoClick(true)
                        
                        -- Ativa magnet se configurado
                        if _G.BringMobs then
                            SafeMagnet(targetMob)
                        end
                        
                        -- Posicionamento inteligente
                        local mobPos = targetMob.HumanoidRootPart.CFrame
                        local safeDistance = 10 -- Distância segura
                        
                        -- Calcula posição de ataque
                        local attackPos = mobPos * CFrame.new(0, safeDistance, 0)
                        
                        -- Aplica rotação para ficar de frente
                        local lookVector = (mobPos.Position - character.HumanoidRootPart.Position).Unit
                        attackPos = CFrame.new(attackPos.Position, attackPos.Position + lookVector)
                        
                        -- Aplica posição
                        character.HumanoidRootPart.CFrame = attackPos
                        
                        attemptCount = 0 -- Reseta contador de tentativas
                        
                    else
                        -- MOB NÃO ENCONTRADO
                        print("[FARM] Mob não encontrado, indo para spawn...")
                        FarmModule.StartAutoClick(false)
                        
                        attemptCount = attemptCount + 1
                        
                        -- Se tentou muitas vezes, verifica se ainda tem a quest
                        if attemptCount >= 5 then
                            print("[FARM] Verificando status da quest...")
                            if not HasQuest(currentQuest.QuestName, currentQuest.QuestID) then
                                attemptCount = 0 -- Reseta se perdeu a quest
                            end
                        end
                        
                        -- Vai para o spawn do mob
                        SmoothTween(currentQuest.Mob_Pos)
                        task.wait(2) -- Espera mob spawnar
                    end
                end
            end)
        end
        
        -- LIMPEZA AO FINAL
        FarmModule.StartAutoClick(false)
        print("[FARM] Thread principal finalizada")
    end)
end

-- === MODO NEAREST (SIMPLIFICADO) ===
function FarmModule.StartNearestFarm()
    task.spawn(function()
        while _G.AutoFarm and _G.FarmMode == "Nearest" do
            task.wait(0.5)
            
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local playerPos = character.HumanoidRootPart.Position
                local nearestEnemy = nil
                local nearestDistance = math.huge
                
                -- Procura inimigo mais próximo
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        local distance = (enemy.HumanoidRootPart.Position - playerPos).Magnitude
                        if distance < nearestDistance then
                            nearestDistance = distance
                            nearestEnemy = enemy
                        end
                    end
                end
                
                if nearestEnemy then
                    -- Equipa e ataca
                    EquipWeapon()
                    FarmModule.StartAutoClick(true)
                    
                    if _G.BringMobs then
                        SafeMagnet(nearestEnemy)
                    end
                    
                    -- Posiciona
                    local attackPos = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    character.HumanoidRootPart.CFrame = attackPos
                else
                    FarmModule.StartAutoClick(false)
                end
            end)
        end
    end)
end

-- === FUNÇÃO DE PARADA ===
function FarmModule.StopAll()
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if ClickThread then
        task.cancel(ClickThread)
        ClickThread = nil
    end
    
    _G.AutoFarm = false
    _G.AutoClick = false
    
    print("[FARM] Todos os sistemas parados com sucesso")
    return true
end

return FarmModule


-- [[ FARM.LUA - APENAS SEA 1 COM TELEPORTE SUAVE ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === VARIÁVEIS GLOBAIS ===
_G.BringMobs = _G.BringMobs or true
_G.FastAttackDelay = _G.FastAttackDelay or 0.1
_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false

-- === TABELA DE QUESTS SEA 1 (COMPLETA) ===
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, NPC_Pos = CFrame.new(1060, 16, 1547), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1236, 6, -493)},
        {Level = 30, Name = "Pirate", QuestName = "PiratQuest1", QuestID = 1, NPC_Pos = CFrame.new(-1141, 4, 3827), Mob_Pos = CFrame.new(-1218, 4, 3911)},
        {Level = 40, Name = "Brute", QuestName = "PiratQuest1", QuestID = 2, NPC_Pos = CFrame.new(-1141, 4, 3827), Mob_Pos = CFrame.new(-1363, 15, 4172)},
        {Level = 60, Name = "Desert Bandit", QuestName = "DesertQuest", QuestID = 1, NPC_Pos = CFrame.new(895, 6, 4390), Mob_Pos = CFrame.new(1013, 6, 4381)},
        {Level = 75, Name = "Desert Officer", QuestName = "DesertQuest", QuestID = 2, NPC_Pos = CFrame.new(895, 6, 4390), Mob_Pos = CFrame.new(1542, 14, 4426)},
        {Level = 90, Name = "Snow Bandit", QuestName = "SnowQuest", QuestID = 1, NPC_Pos = CFrame.new(1387, 15, -1300), Mob_Pos = CFrame.new(1287, 15, -1336)},
        {Level = 100, Name = "Snowman", QuestName = "SnowQuest", QuestID = 2, NPC_Pos = CFrame.new(1387, 15, -1300), Mob_Pos = CFrame.new(1281, 15, -1071)},
        {Level = 120, Name = "Chief Petty Officer", QuestName = "MarineQuest1", QuestID = 1, NPC_Pos = CFrame.new(-4855, 23, 4338), Mob_Pos = CFrame.new(-4839, 6, 4367)},
        {Level = 150, Name = "Sky Bandit", QuestName = "SkyQuest", QuestID = 1, NPC_Pos = CFrame.new(-1240, 358, -5913), Mob_Pos = CFrame.new(-1246, 393, -5943)},
        {Level = 175, Name = "Dark Master", QuestName = "SkyQuest", QuestID = 2, NPC_Pos = CFrame.new(-1240, 358, -5913), Mob_Pos = CFrame.new(-1144, 391, -6161)},
        {Level = 225, Name = "Toga Warrior", QuestName = "ColosseumQuest", QuestID = 1, NPC_Pos = CFrame.new(-1580, 7, -2982), Mob_Pos = CFrame.new(-1805, 7, -2745)},
        {Level = 250, Name = "Gladiator", QuestName = "ColosseumQuest", QuestID = 2, NPC_Pos = CFrame.new(-1580, 7, -2982), Mob_Pos = CFrame.new(-1805, 7, -3317)},
        {Level = 300, Name = "Military Soldier", QuestName = "MagmaQuest", QuestID = 1, NPC_Pos = CFrame.new(-5314, 12, 8516), Mob_Pos = CFrame.new(-5414, 11, 8479)},
        {Level = 325, Name = "Military Spy", QuestName = "MagmaQuest", QuestID = 2, NPC_Pos = CFrame.new(-5314, 12, 8516), Mob_Pos = CFrame.new(-5816, 73, 8456)},
        {Level = 375, Name = "Fishman Warrior", QuestName = "FishmanQuest", QuestID = 1, NPC_Pos = CFrame.new(61122, 18, 1569), Mob_Pos = CFrame.new(60907, 18, 1546)},
        {Level = 400, Name = "Fishman Commando", QuestName = "FishmanQuest", QuestID = 2, NPC_Pos = CFrame.new(61122, 18, 1569), Mob_Pos = CFrame.new(61793, 18, 1450)},
        {Level = 450, Name = "God's Guard", QuestName = "UpperSkyQuest1", QuestID = 1, NPC_Pos = CFrame.new(-5707, 712, -7677), Mob_Pos = CFrame.new(-5820, 712, -7814)},
        {Level = 475, Name = "Shanda", QuestName = "UpperSkyQuest1", QuestID = 2, NPC_Pos = CFrame.new(-5707, 712, -7677), Mob_Pos = CFrame.new(-5552, 712, -7782)},
        {Level = 525, Name = "Royal Squad", QuestName = "UpperSkyQuest2", QuestID = 1, NPC_Pos = CFrame.new(-6006, 1593, -4905), Mob_Pos = CFrame.new(-5890, 1593, -4914)},
        {Level = 550, Name = "Royal Soldier", QuestName = "UpperSkyQuest2", QuestID = 2, NPC_Pos = CFrame.new(-6006, 1593, -4905), Mob_Pos = CFrame.new(-6194, 1593, -4783)},
        {Level = 625, Name = "Galley Pirate", QuestName = "FountainQuest", QuestID = 1, NPC_Pos = CFrame.new(5256, 38, 4050), Mob_Pos = CFrame.new(5426, 38, 3968)},
        {Level = 650, Name = "Galley Captain", QuestName = "FountainQuest", QuestID = 2, NPC_Pos = CFrame.new(5256, 38, 4050), Mob_Pos = CFrame.new(5663, 38, 4479)},
    }
}

-- === THREADS ===
local MainFarmThread = nil
local ClickThread = nil

-- === FUNÇÃO: TELEPORTE 100% SUAVE (SEM TP EM CIMA) ===
local function SmoothTween(targetCFrame)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end
    
    local root = character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    -- **REMOVI O TELEPORTE DIRETO!** Sempre usa tween agora
    -- Mesmo para distâncias curtas, usa tween
    
    -- Velocidade ajustável
    local speed = 200 -- studs por segundo
    
    -- Calcula tempo baseado na distância
    local travelTime = distance / speed
    
    -- Tempo mínimo de 0.5 segundos, máximo de 15 segundos
    travelTime = math.max(0.5, math.min(travelTime, 15))
    
    -- Cria o tween
    local tweenInfo = TweenInfo.new(
        travelTime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        0,      -- RepeatCount
        false,  -- Reverses
        0       -- DelayTime
    )
    
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    
    -- Conecta eventos
    local connection
    local completed = false
    
    connection = tween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)
    
    -- Inicia o tween
    tween:Play()
    
    -- Espera completar com timeout
    local startTime = tick()
    while not completed and (tick() - startTime) < (travelTime + 5) do -- Timeout extra
        if not _G.AutoFarm then
            tween:Cancel()
            return false
        end
        task.wait(0.1)
    end
    
    -- Se não completou, força posição final
    if not completed then
        tween:Cancel()
        root.CFrame = targetCFrame
    end
    
    -- Pequeno delay após teleporte
    task.wait(0.3)
    return true
end

-- === FUNÇÃO: GET CURRENT QUEST (APENAS SEA 1) ===
local function GetCurrentQuest()
    local myLevel = Player.Data.Level.Value
    local selectedQuest = QuestData["Sea 1"][1] -- Default primeira quest
    
    for _, quest in ipairs(QuestData["Sea 1"]) do
        if myLevel >= quest.Level then
            selectedQuest = quest
        else
            break -- Para quando achar uma quest acima do nível
        end
    end
    
    -- Se o nível for muito alto (ex: 2800), usa a última quest do Sea 1
    if myLevel > 650 then
        selectedQuest = QuestData["Sea 1"][#QuestData["Sea 1"]] -- Última quest
    end
    
    return selectedQuest
end

-- === FUNÇÃO: CHECK QUEST ===
local function HasQuest(questName, questId)
    local playerGui = Player.PlayerGui
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local questFrame = main:FindFirstChild("Quest")
    if not questFrame or not questFrame.Visible then return false end
    
    local questTitle = questFrame:FindFirstChild("QuestName")
    if questTitle then
        return string.find(questTitle.Text, questName) ~= nil
    end
    
    return false
end

-- === FUNÇÃO: MAGNET SEGURO ===
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
                
                -- Só magnet em distância média
                if distance > 30 and distance < 150 then
                    local direction = (playerPos - mobPos).Unit
                    mob.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + (direction * 3)
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end

-- === FUNÇÃO: EQUIP WEAPON ===
local function EquipWeapon()
    pcall(function()
        local weaponName = _G.SelectWeapon
        if not weaponName then return end
        
        -- Procura na mochila
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool.Name == weaponName then
                Player.Character.Humanoid:EquipTool(tool)
                task.wait(0.2)
                return true
            end
        end
        
        -- Verifica se já está equipada
        for _, tool in pairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == weaponName then
                return true
            end
        end
        
        return false
    end)
end

-- === AUTO CLICK ===
function FarmModule.StartAutoClick(toggle)
    _G.AutoClick = toggle
    
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
            task.wait(_G.FastAttackDelay or 0.1)
        end
    end)
end

-- === SISTEMA PRINCIPAL DE FARM ===
function FarmModule.StartFarm(toggle, mode)
    _G.FarmMode = mode or "Level"
    _G.AutoFarm = toggle
    
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if not toggle then 
        FarmModule.StartAutoClick(false)
        return 
    end
    
    MainFarmThread = task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.5)
            
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                -- MODO LEVEL
                local currentQuest = GetCurrentQuest()
                if not currentQuest then return end
                
                local hasQuest = HasQuest(currentQuest.QuestName, currentQuest.QuestID)
                
                if not hasQuest then
                    -- PEGAR QUEST
                    FarmModule.StartAutoClick(false)
                    SmoothTween(currentQuest.NPC_Pos)
                    
                    local args = {"StartQuest", currentQuest.QuestName, currentQuest.QuestID}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    
                    -- Espera quest aparecer
                    for i = 1, 20 do
                        if HasQuest(currentQuest.QuestName, currentQuest.QuestID) then
                            break
                        end
                        task.wait(0.5)
                    end
                    
                else
                    -- PROCURA MOB
                    local targetMob = game.Workspace.Enemies:FindFirstChild(currentQuest.Name)
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob.Humanoid.Health > 0 then
                        -- ATACA
                        EquipWeapon()
                        FarmModule.StartAutoClick(true)
                        
                        if _G.BringMobs then
                            SafeMagnet(targetMob)
                        end
                        
                        -- **POSICIONAMENTO SUAVE SEM TELEPORTE BRUSCO**
                        local mobPos = targetMob.HumanoidRootPart.CFrame
                        local attackDistance = 15
                        
                        -- Calcula posição ao redor do mob
                        local attackPos = mobPos * CFrame.new(0, attackDistance, 0)
                        
                        -- Usa tween mesmo para pequenos ajustes
                        local currentPos = character.HumanoidRootPart.CFrame
                        local distanceToMob = (currentPos.Position - mobPos.Position).Magnitude
                        
                        if distanceToMob > attackDistance + 5 then
                            -- Se está longe, usa tween
                            local tweenPos = CFrame.new(
                                mobPos.X, 
                                mobPos.Y + attackDistance, 
                                mobPos.Z
                            )
                            SmoothTween(tweenPos)
                        else
                            -- Se já está perto, pequeno ajuste
                            character.HumanoidRootPart.CFrame = attackPos
                        end
                        
                    else
                        -- MOB NÃO ENCONTRADO
                        FarmModule.StartAutoClick(false)
                        SmoothTween(currentQuest.Mob_Pos)
                        task.wait(2)
                    end
                end
            end)
        end
        
        -- LIMPEZA
        FarmModule.StartAutoClick(false)
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
    return true
end

return FarmModule

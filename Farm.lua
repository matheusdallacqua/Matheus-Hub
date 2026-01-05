-- [[ FARM.LUA - VERSÃO ESTÁVEL SEM BUGS ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === VARIÁVEIS DE CONTROLE ===
_G.BringMobs = _G.BringMobs or true
_G.FastAttackDelay = _G.FastAttackDelay or 0.2
_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false

-- Configurações ajustáveis
local Config = {
    AttackDistance = 15,  -- Distância para atacar
    MagnetRadius = 100,   -- Raio do magnet
    TweenSpeed = 150,     -- Velocidade do tween (mais lento)
    MinTweenTime = 1,     -- Tempo mínimo do tween
    MaxTweenTime = 10,    -- Tempo máximo do tween
}

-- === TABELA DE QUESTS SEA 1 ===
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
local CurrentTween = nil

-- === FUNÇÃO: TELEPORTE ESTÁVEL (SEM "QUICAR") ===
local function StableTween(targetCFrame)
    -- Cancela tween anterior se existir
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
        task.wait(0.1)
    end
    
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end
    
    local root = character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    -- Se já está muito perto (10 studs), não faz tween
    if distance < 10 then
        return true
    end
    
    -- Calcula tempo do tween (mais lento para evitar bugs)
    local travelTime = distance / Config.TweenSpeed
    travelTime = math.max(Config.MinTweenTime, math.min(travelTime, Config.MaxTweenTime))
    
    -- Ajusta altura do target (evita ficar no chão)
    local adjustedCFrame = targetCFrame + Vector3.new(0, 5, 0)
    
    -- Cria tween simples
    local tweenInfo = TweenInfo.new(
        travelTime,
        Enum.EasingStyle.Linear
    )
    
    local tween = TweenService:Create(root, tweenInfo, {CFrame = adjustedCFrame})
    CurrentTween = tween
    
    -- Inicia tween
    tween:Play()
    
    -- Espera de forma simples
    local startTime = tick()
    while tick() - startTime < travelTime + 2 do
        if not _G.AutoFarm then
            tween:Cancel()
            CurrentTween = nil
            return false
        end
        
        -- Verifica se chegou perto o suficiente
        local currentDist = (root.Position - targetCFrame.Position).Magnitude
        if currentDist < 15 then
            tween:Cancel()
            root.CFrame = adjustedCFrame
            CurrentTween = nil
            return true
        end
        
        task.wait(0.1)
    end
    
    tween:Cancel()
    root.CFrame = adjustedCFrame
    CurrentTween = nil
    return true
end

-- === FUNÇÃO: GET CURRENT QUEST ===
local function GetCurrentQuest()
    local myLevel = Player.Data.Level.Value
    local selectedQuest = QuestData["Sea 1"][1]
    
    for _, quest in ipairs(QuestData["Sea 1"]) do
        if myLevel >= quest.Level then
            selectedQuest = quest
        else
            break
        end
    end
    
    -- Limite máximo do Sea 1
    if myLevel > 650 then
        selectedQuest = QuestData["Sea 1"][#QuestData["Sea 1"]]
    end
    
    return selectedQuest
end

-- === FUNÇÃO: VERIFICA SE TEM QUEST ===
local function HasQuest()
    local playerGui = Player.PlayerGui
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local questFrame = main:FindFirstChild("Quest")
    if not questFrame then return false end
    
    return questFrame.Visible
end

-- === FUNÇÃO: VERIFICA SE É A QUEST CERTA ===
local function IsCorrectQuest(questName)
    if not HasQuest() then return false end
    
    local questFrame = Player.PlayerGui.Main.Quest
    local questTitle = questFrame:FindFirstChild("QuestName")
    
    if questTitle then
        return string.find(questTitle.Text, questName) ~= nil
    end
    
    return false
end

-- === FUNÇÃO: SIMPLE MAGNET ===
local function SimpleMagnet(targetMob)
    if not _G.BringMobs or not targetMob then return end
    
    pcall(function()
        local character = Player.Character
        if not character then return end
        
        for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
            if mob.Name == targetMob.Name and mob:FindFirstChild("HumanoidRootPart") then
                local distance = (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                
                if distance < Config.MagnetRadius then
                    mob.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -5)
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end)
end

-- === FUNÇÃO: EQUIP WEAPON SIMPLES ===
local function EquipWeapon()
    pcall(function()
        local weaponName = _G.SelectWeapon
        if not weaponName then return false end
        
        -- Verifica se já está equipada
        for _, tool in pairs(Player.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == weaponName then
                return true
            end
        end
        
        -- Procura na mochila
        local tool = Player.Backpack:FindFirstChild(weaponName)
        if tool then
            Player.Character.Humanoid:EquipTool(tool)
            task.wait(0.3) -- Delay após equipar
            return true
        end
        
        return false
    end)
end

-- === FUNÇÃO: ATACA O MOB ===
local function AttackMob(targetMob)
    if not targetMob or not targetMob:FindFirstChild("HumanoidRootPart") then return false end
    
    pcall(function()
        local character = Player.Character
        if not character then return false end
        
        -- Posiciona perto do mob (mas não em cima)
        local mobPos = targetMob.HumanoidRootPart.CFrame
        local attackPos = mobPos * CFrame.new(0, Config.AttackDistance, 0)
        
        character.HumanoidRootPart.CFrame = attackPos
        
        -- Vira para o mob
        character.HumanoidRootPart.CFrame = CFrame.new(
            character.HumanoidRootPart.Position,
            Vector3.new(mobPos.X, character.HumanoidRootPart.Position.Y, mobPos.Z)
        )
        
        return true
    end)
    
    return false
end

-- === FUNÇÃO: AUTO CLICK ===
function FarmModule.StartAutoClick(toggle)
    _G.AutoClick = toggle
    
    if ClickThread then
        task.cancel(ClickThread)
        ClickThread = nil
    end
    
    if not toggle then return end
    
    ClickThread = task.spawn(function()
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
            task.wait(_G.FastAttackDelay or 0.2)
        end
    end)
end

-- === SISTEMA PRINCIPAL SIMPLIFICADO ===
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
        local state = "GET_QUEST" -- Estados: GET_QUEST, FIND_MOB, ATTACK
        
        while _G.AutoFarm do
            task.wait(0.5) -- Loop mais lento
            
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                local currentQuest = GetCurrentQuest()
                if not currentQuest then return end
                
                -- VERIFICA SE TEM QUEST
                local hasQuest = HasQuest()
                local correctQuest = IsCorrectQuest(currentQuest.QuestName)
                
                if not hasQuest or not correctQuest then
                    state = "GET_QUEST"
                else
                    state = "FIND_MOB"
                end
                
                -- MÁQUINA DE ESTADOS
                if state == "GET_QUEST" then
                    -- PARA DE ATACAR
                    FarmModule.StartAutoClick(false)
                    
                    -- VAI ATÉ O NPC
                    print("[FARM] Indo pegar quest:", currentQuest.QuestName)
                    StableTween(currentQuest.NPC_Pos)
                    task.wait(1) -- Espera chegar
                    
                    -- TENTA PEGAR A QUEST
                    local args = {"StartQuest", currentQuest.QuestName, currentQuest.QuestID}
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    
                    -- ESPERA A QUEST APARECER
                    for i = 1, 10 do
                        if IsCorrectQuest(currentQuest.QuestName) then
                            print("[FARM] Quest aceita!")
                            state = "FIND_MOB"
                            break
                        end
                        task.wait(0.5)
                    end
                    
                elseif state == "FIND_MOB" then
                    -- PROCURA O MOB
                    local targetMob = game.Workspace.Enemies:FindFirstChild(currentQuest.Name)
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob.Humanoid.Health > 0 then
                        state = "ATTACK"
                    else
                        -- NÃO ACHOU MOB, VAI PARA SPAWN
                        print("[FARM] Mob não encontrado, indo para spawn")
                        FarmModule.StartAutoClick(false)
                        StableTween(currentQuest.Mob_Pos)
                        task.wait(2)
                    end
                    
                elseif state == "ATTACK" then
                    local targetMob = game.Workspace.Enemies:FindFirstChild(currentQuest.Name)
                    
                    if targetMob and targetMob.Humanoid.Health > 0 then
                        -- EQUIPA ARMA
                        EquipWeapon()
                        
                        -- ATIVA AUTO CLICK
                        FarmModule.StartAutoClick(true)
                        
                        -- MAGNET (SE LIGADO)
                        if _G.BringMobs then
                            SimpleMagnet(targetMob)
                        end
                        
                        -- POSICIONA PARA ATACAR
                        AttackMob(targetMob)
                        
                        print("[FARM] Atacando:", currentQuest.Name)
                    else
                        -- MOB MORREU
                        state = "FIND_MOB"
                        FarmModule.StartAutoClick(false)
                    end
                end
            end)
        end
        
        -- LIMPEZA
        FarmModule.StartAutoClick(false)
        if CurrentTween then
            CurrentTween:Cancel()
            CurrentTween = nil
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
    
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    
    _G.AutoFarm = false
    _G.AutoClick = false
    
    print("[FARM] Parado completamente")
    return true
end

return FarmModule

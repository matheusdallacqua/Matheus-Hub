-- [[ FARM.LUA - MATHEUS HUB 2026 (VERSÃO ULTIMATE) ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- === INICIALIZAÇÃO DE VARIÁVEIS ===
if _G.BringMobs == nil then _G.BringMobs = true end
if _G.FastAttackDelay == nil then _G.FastAttackDelay = 0.1 end
if _G.SelectWeapon == nil then _G.SelectWeapon = "Melee" end
if _G.FarmMode == nil then _G.FarmMode = "Level" end

-- === TABELA DE QUESTS COMPLETA 2026 ===
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

-- === VARIÁVEIS DE THREAD ===
local FarmThread = nil
local ClickThread = nil
local MagnetThread = nil

-- === FUNÇÃO: SMOOTH TWEEN (OTIMIZADA) ===
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - TargetCFrame.Position).Magnitude
    
    -- Se já está perto, teleporta direto
    if Distance < 25 then
        Root.CFrame = TargetCFrame
        return true
    end
    
    -- Cria e executa tween
    local TweenInfo = TweenInfo.new(
        Distance / 250,  -- Velocidade balanceada
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.InOut,
        0,  -- RepeatCount
        false,  -- Reverses
        0   -- DelayTime
    )
    
    local Tween = TweenService:Create(Root, TweenInfo, {CFrame = TargetCFrame})
    
    local Completed = false
    local Connection
    Connection = Tween.Completed:Connect(function()
        Completed = true
        if Connection then Connection:Disconnect() end
    end)
    
    Tween:Play()
    
    -- Timeout de segurança
    local StartTime = tick()
    while not Completed and (tick() - StartTime) < 15 do
        if not _G.AutoFarm then
            Tween:Cancel()
            return false
        end
        task.wait()
    end
    
    if not Completed then
        Tween:Cancel()
        Root.CFrame = TargetCFrame
    end
    
    return true
end

-- === FUNÇÃO: MAGNET SYSTEM (OTIMIZADO) ===
local function Magnet(TargetMob)
    if not _G.BringMobs or not TargetMob or not TargetMob:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    pcall(function()
        local Character = Player.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        local PlayerPos = Character.HumanoidRootPart.Position
        local TargetPos = TargetMob.HumanoidRootPart.Position
        
        -- Raio do magnet (configurável)
        local MagnetRadius = 200
        
        for _, Mob in pairs(game.Workspace.Enemies:GetChildren()) do
            if Mob.Name == TargetMob.Name and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 then
                local MobPos = Mob.HumanoidRootPart.Position
                local Distance = (MobPos - PlayerPos).Magnitude
                
                if Distance < MagnetRadius then
                    -- Configurações anti-detection
                    Mob.HumanoidRootPart.CanCollide = false
                    Mob.HumanoidRootPart.Velocity = Vector3.zero
                    Mob.HumanoidRootPart.RotVelocity = Vector3.zero
                    
                    -- Calcula direção suave
                    local Direction = (TargetPos - MobPos).Unit
                    local MoveSpeed = 15
                    
                    -- Aplica movimento suave
                    Mob.HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame + (Direction * MoveSpeed)
                    
                    -- Anti-stuck: pequeno impulso vertical se estiver preso
                    if Mob.HumanoidRootPart.Position.Y < 0 then
                        Mob.HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end)
end

-- === FUNÇÃO: FAST ATTACK & AUTO CLICK (OTIMIZADO) ===
function FarmModule.StartAutoClick(Toggle)
    _G.AutoClick = Toggle
    
    -- Mata thread anterior se existir
    if ClickThread then
        task.cancel(ClickThread)
        ClickThread = nil
    end
    
    if not Toggle then return end
    
    ClickThread = task.spawn(function()
        local VirtualUser = game:GetService('VirtualUser')
        local LastAttack = 0
        
        while _G.AutoClick do
            local CurrentTime = tick()
            
            -- Sistema de cooldown baseado no delay configurado
            if (CurrentTime - LastAttack) >= (_G.FastAttackDelay or 0.1) then
                pcall(function()
                    if Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
                        VirtualUser:CaptureController()
                        
                        -- Simula clique real
                        VirtualUser:Button1Down(Vector2.new(0, 0))
                        task.wait(0.01)
                        VirtualUser:Button1Up(Vector2.new(0, 0))
                        
                        LastAttack = CurrentTime
                    end
                end)
            end
            
            task.wait(0.03) -- Loop principal mais rápido
        end
    end)
end

-- === FUNÇÃO: EQUIP WEAPON (INTELIGENTE) ===
function FarmModule.EquipWeapon()
    pcall(function()
        local WeaponName = _G.SelectWeapon
        if not WeaponName then return end
        
        local Character = Player.Character
        if not Character then return end
        
        -- Verifica se já está equipada
        for _, Tool in pairs(Character:GetChildren()) do
            if Tool:IsA("Tool") and Tool.Name == WeaponName then
                return true -- Já equipada
            end
        end
        
        -- Procura na mochila
        local Tool = Player.Backpack:FindFirstChild(WeaponName)
        if Tool then
            -- Delay antes de equipar (evita spam)
            task.wait(0.1)
            Character.Humanoid:EquipTool(Tool)
            return true
        end
        
        return false -- Arma não encontrada
    end)
end

-- === FUNÇÃO: GET CURRENT QUEST ===
local function GetCurrentQuest()
    pcall(function()
        local MyLevel = Player.Data.Level.Value
        local SelectedQuest = nil
        
        for _, Quest in ipairs(QuestData["Sea 1"]) do
            if MyLevel >= Quest.Level then
                SelectedQuest = Quest
            else
                break
            end
        end
        
        return SelectedQuest
    end)
    
    return nil
end

-- === FUNÇÃO: CHECK IF HAS QUEST ===
local function HasQuest(QuestName, QuestID)
    local PlayerGui = Player.PlayerGui
    if not PlayerGui then return false end
    
    local MainGui = PlayerGui:FindFirstChild("Main")
    if not MainGui then return false end
    
    local QuestFrame = MainGui:FindFirstChild("Quest")
    if not QuestFrame then return false end
    
    if QuestFrame.Visible then
        local QuestText = QuestFrame:FindFirstChild("QuestName")
        if QuestText then
            return QuestText.Text:find(QuestName) ~= nil
        end
    end
    
    return false
end

-- === FUNÇÃO: START FARM (PRINCIPAL) ===
function FarmModule.StartFarm(Toggle, Mode)
    _G.FarmMode = Mode or "Level"
    _G.AutoFarm = Toggle
    
    -- Mata thread anterior
    if FarmThread then
        task.cancel(FarmThread)
        FarmThread = nil
    end
    
    if not Toggle then 
        FarmModule.StartAutoClick(false)
        return 
    end
    
    FarmThread = task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            
            pcall(function()
                local Character = Player.Character
                if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                local MyLevel = Player.Data.Level.Value
                local CurrentQuest = GetCurrentQuest()
                
                if not CurrentQuest then
                    print("[FARM] Nenhuma quest encontrada para o nível", MyLevel)
                    task.wait(3)
                    return
                end
                
                -- VERIFICA SE TEM QUEST
                local HasActiveQuest = HasQuest(CurrentQuest.QuestName, CurrentQuest.QuestID)
                
                if not HasActiveQuest then
                    -- VAI PEGAR QUEST
                    FarmModule.StartAutoClick(false)
                    
                    if SmoothTween(CurrentQuest.NPC_Pos) then
                        local Args = {"StartQuest", CurrentQuest.QuestName, CurrentQuest.QuestID}
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(Args))
                        
                        -- Espera a quest ser aceita
                        for i = 1, 30 do -- 3 segundos de timeout
                            if HasQuest(CurrentQuest.QuestName, CurrentQuest.QuestID) then
                                break
                            end
                            task.wait(0.1)
                        end
                    end
                else
                    -- PROCURA MOB DA QUEST
                    local TargetMob = game.Workspace.Enemies:FindFirstChild(CurrentQuest.Name)
                    
                    if TargetMob and TargetMob:FindFirstChild("HumanoidRootPart") and TargetMob.Humanoid.Health > 0 then
                        -- MOB ENCONTRADO - ATACA
                        FarmModule.EquipWeapon()
                        FarmModule.StartAutoClick(true)
                        
                        -- ATIVA MAGNET SE CONFIGURADO
                        if _G.BringMobs then
                            Magnet(TargetMob)
                        end
                        
                        -- POSICIONAMENTO INTELIGENTE
                        local MobPos = TargetMob.HumanoidRootPart.CFrame
                        local SafeDistance = 15
                        
                        -- Evita ficar em cima do mob
                        local AttackPosition = MobPos * CFrame.new(0, SafeDistance, 0)
                        
                        -- Aplica rotação para ficar de frente
                        local LookVector = (MobPos.Position - Character.HumanoidRootPart.Position).Unit
                        AttackPosition = CFrame.new(AttackPosition.Position, AttackPosition.Position + LookVector)
                        
                        Character.HumanoidRootPart.CFrame = AttackPosition
                        
                    else
                        -- MOB NÃO ENCONTRADO - VAI PARA SPAWN
                        FarmModule.StartAutoClick(false)
                        SmoothTween(CurrentQuest.Mob_Pos)
                        task.wait(1) -- Espera mob spawnar
                    end
                end
            end)
        end
        
        -- LIMPEZA QUANDO DESATIVA
        FarmModule.StartAutoClick(false)
    end)
end

-- === FUNÇÃO: FIND NEAREST ENEMY ===
function FarmModule.FindNearestEnemy()
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local PlayerPos = Character.HumanoidRootPart.Position
    local NearestEnemy = nil
    local NearestDistance = math.huge
    
    pcall(function()
        for _, Enemy in pairs(game.Workspace.Enemies:GetChildren()) do
            if Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                local Distance = (Enemy.HumanoidRootPart.Position - PlayerPos).Magnitude
                
                if Distance < NearestDistance then
                    NearestDistance = Distance
                    NearestEnemy = Enemy
                end
            end
        end
    end)
    
    return NearestEnemy, NearestDistance
end

-- === FUNÇÃO: FARM MODE NEAREST ===
function FarmModule.StartNearestFarm(Toggle)
    if not Toggle then return end
    
    task.spawn(function()
        while _G.AutoFarm and _G.FarmMode == "Nearest" do
            task.wait(0.1)
            
            pcall(function()
                local NearestEnemy, Distance = FarmModule.FindNearestEnemy()
                
                if NearestEnemy then
                    FarmModule.EquipWeapon()
                    FarmModule.StartAutoClick(true)
                    
                    if _G.BringMobs then
                        Magnet(NearestEnemy)
                    end
                    
                    local Character = Player.Character
                    if Character and Character.HumanoidRootPart then
                        local AttackPos = NearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        Character.HumanoidRootPart.CFrame = AttackPos
                    end
                else
                    FarmModule.StartAutoClick(false)
                    task.wait(1)
                end
            end)
        end
    end)
end

-- === FUNÇÃO: STOP ALL FARM ===
function FarmModule.StopAll()
    if FarmThread then
        task.cancel(FarmThread)
        FarmThread = nil
    end
    
    if ClickThread then
        task.cancel(ClickThread)
        ClickThread = nil
    end
    
    _G.AutoFarm = false
    _G.AutoClick = false
    
    print("[FARM] Todos os sistemas parados")
end

-- === INICIALIZAÇÃO AUTOMÁTICA ===
task.spawn(function()
    while true do
        if _G.AutoFarm then
            -- Verifica se o modo de farm mudou
            if _G.FarmMode == "Nearest" then
                FarmModule.StartNearestFarm(true)
            end
        end
        task.wait(5)
    end
end)

return FarmModule

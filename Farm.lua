-- [[ FARM.LUA - COM AUTO CLICK FUNCIONAL ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- === CONFIGURAÇÕES ===
local Config = {
    TweenSpeed = 100,
    AttackDistance = 8,
    MobSearchRadius = 100,
    QuestCheckDelay = 1,
}

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.15
_G.SelectWeapon = _G.SelectWeapon or ""
_G.Select_Weapon_Check = _G.Select_Weapon_Check or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === TABELA DE QUESTS ===
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
local AutoClickThread = nil

-- === FUNÇÃO EQUIP WEAPON (DO SEU CÓDIGO) ===
local function EquipWeapon()
    local char = Player.Character
    if not char then return false end

    -- Se já tem arma equipada, não faz nada
    if char:FindFirstChildOfClass("Tool") then
        return true
    end

    -- Procura arma na mochila baseada no tipo selecionado
    local weaponType = _G.Select_Weapon_Check or "Melee"
    local checkType = weaponType == "Fruit" and "Blox Fruit" or weaponType
    
    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == checkType then
            _G.SelectWeapon = tool.Name
            char.Humanoid:EquipTool(tool)
            task.wait(0.2) -- Pequeno delay após equipar
            return true
        end
    end

    return false
end

-- === AUTO CLICK FUNCIONAL (SEU CÓDIGO) ===
function FarmModule.StartAutoClick(Toggle)
    _G.AutoClick = Toggle

    if AutoClickThread then
        task.cancel(AutoClickThread)
        AutoClickThread = nil
    end

    if not Toggle then 
        print("[AUTO CLICK] Desativado")
        return 
    end

    AutoClickThread = task.spawn(function()
        print("[AUTO CLICK] Iniciado")
        
        while _G.AutoClick do
            task.wait(_G.FastAttackDelay or 0.15)

            pcall(function()
                local char = Player.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local tool = char:FindFirstChildOfClass("Tool")

                if not hrp then return end

                -- Se não tem arma, tenta equipar
                if not tool then
                    EquipWeapon()
                    return
                end

                -- Ataca
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(500, 500))
                task.wait(0.01) -- Pequeno delay entre down e up
                VirtualUser:Button1Up(Vector2.new(500, 500))
                
                print("[AUTO CLICK] Ataque realizado")
            end)
        end
        
        print("[AUTO CLICK] Finalizado")
    end)
end

-- Para compatibilidade com sua GUI (StartCombat também funciona)
FarmModule.StartCombat = FarmModule.StartAutoClick

-- === SISTEMA DE TELEPORTE ===
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    
    if Distance < 15 then 
        Root.CFrame = TargetCFrame 
        return true
    end
    
    local info = TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Root, info, {CFrame = TargetCFrame})
    tween:Play()
    
    local completed = false
    tween.Completed:Connect(function()
        completed = true
    end)
    
    local startTime = tick()
    while not completed and (tick() - startTime) < 15 do
        if not _G.AutoFarm then
            tween:Cancel()
            return false
        end
        task.wait()
    end
    
    return true
end

-- === VERIFICA QUEST ===
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

-- === MAGNET ===
local function Magnet(TargetMob)
    if not _G.BringMobs or not TargetMob or not TargetMob:FindFirstChild("HumanoidRootPart") then return end
    
    pcall(function()
        local TargetPos = TargetMob.HumanoidRootPart.CFrame
        
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v.Name == TargetMob.Name and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                local dist = (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if dist < 250 then
                    v.HumanoidRootPart.CanCollide = false
                    v.HumanoidRootPart.CFrame = TargetPos
                end
            end
        end
    end)
end

-- === SISTEMA PRINCIPAL DE FARM ===
function FarmModule.StartFarm(Toggle, Mode)
    _G.FarmMode = Mode or "Level"
    _G.AutoFarm = Toggle
    
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if not Toggle then 
        FarmModule.StartAutoClick(false)
        return 
    end
    
    MainFarmThread = task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.1)
            
            pcall(function()
                local myLevel = Player.Data.Level.Value
                local data = nil
                
                -- Busca a Quest ideal para o seu nível
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if myLevel >= q.Level then 
                        data = q 
                    end
                end

                if data then
                    -- Verifica se já está com a missão na tela
                    local hasQuest = HasQuest(data.QuestName, data.QuestID)
                    
                    if not hasQuest then
                        -- Para de atacar para pegar a quest
                        FarmModule.StartAutoClick(false)
                        
                        -- Vai até o NPC
                        SmoothTween(data.NPC_Pos)
                        
                        -- Aceita a quest
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                        
                        task.wait(1) -- Espera a quest ser aceita
                        
                    else
                        -- Procura o inimigo da missão
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name)
                        
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            -- Equipa arma
                            EquipWeapon()
                            
                            -- Ativa auto click
                            FarmModule.StartAutoClick(true)
                            
                            -- Magnet
                            Magnet(Enemy)
                            
                            -- Posicionamento: 10 studs acima do inimigo
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            
                        else
                            -- Se o mob morreu, vai para o spawn point
                            FarmModule.StartAutoClick(false)
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
        
        -- Limpeza
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
    
    print("[FARM] Parado completamente")
    return true
end

return FarmModule

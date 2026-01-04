local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ 1. TABELA DE QUESTS - SEA 1 COMPLETA ]]
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

-- [[ 2. TWEEN DE MOVIMENTAÇÃO ]]
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    if Distance < 15 then Root.CFrame = TargetCFrame return end
    local info = TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Root, info, {CFrame = TargetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- [[ 3. BRING MOBS (HOHO STYLE - NO CHÃO) ]]
local function BringMobs(TargetMob)
    pcall(function()
        local TargetPos = TargetMob.HumanoidRootPart.CFrame
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if string.find(v.Name, TargetMob.Name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < 300 then
                    v.HumanoidRootPart.CanCollide = false
                    v.HumanoidRootPart.CFrame = TargetPos -- Fixa no chão
                    v.Humanoid.WalkSpeed = 0
                    if v.Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                        v.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    end
                end
            end
        end
    end)
end

-- [[ 4. FAST ATTACK (HOHO HUB) ]]
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    local CombatFramework = require(Player.PlayerScripts.CombatFramework)
    local AttackLogic = debug.getupvalues(CombatFramework.Attack)[1]
    local VirtualUser = game:GetService("VirtualUser")

    task.spawn(function()
        while _G.FastAttack do
            task.wait(0.01)
            pcall(function()
                if Player.Character:FindFirstChildOfClass("Tool") then
                    if AttackLogic and AttackLogic.activeController then
                        AttackLogic.activeController.timeToNextAttack = 0
                        AttackLogic.activeController.attacking = false
                        AttackLogic.activeController.incrementAttackCounter()
                        AttackLogic.activeController:attack()
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(850, 450), game.Workspace.CurrentCamera.CFrame)
                    end
                end
            end)
        end
    end)
end

-- [[ 5. SISTEMA DE EQUIPE COMPLETO (TRADUTOR + EQUIPER) ]]

-- 5a. TRADUTOR (O código que você achou, otimizado)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.AutoFarmLevel then
                -- Se o usuário selecionou uma categoria, este loop acha o nome real da arma
                local category = _G.SelectWeaponType or "Melee" -- "Melee", "Sword", "Gun", "Fruit"
                local toolTipTarget = (category == "Fruit" and "Blox Fruit" or category)

                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.ToolTip == toolTipTarget then
                        _G.RealWeaponName = v.Name -- Salva o nome real (ex: "Combat")
                        break
                    end
                end
            end
        end)
    end
end)

-- 5b. FUNÇÃO QUE REALMENTE COLOCA NA MÃO
function FarmModule.EquipWeapon()
    pcall(function()
        if _G.RealWeaponName then
            local tool = Player.Backpack:FindFirstChild(_G.RealWeaponName)
            local toolInHand = Player.Character:FindFirstChild(_G.RealWeaponName)
            
            -- Só equipa se não estiver na mão
            if tool and not toolInHand then
                Player.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end


-- [[ 6. LOOP DE FARM ]]
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait()
            pcall(function()
                local myLevel = Player.Data.Level.Value
                local data = nil
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if myLevel >= q.Level then data = q end
                end

                if data then
                    local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                    if not hasQuest then
                        SmoothTween(data.NPC_Pos)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    else
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name)
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            -- EQUIPA A ARMA
                            FarmModule.EquipWeapon()
                            
                            -- POSICIONA 10 STUDS ACIMA (SEGURO)
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            
                            -- PUXA OS MOBS PRO CHÃO
                            BringMobs(Enemy)
                        else
                            -- VAI ATÉ O SPAWN DOS MOBS
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
    end)
end

return FarmModule


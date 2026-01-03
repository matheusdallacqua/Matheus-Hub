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

-- [[ 3. BRING MOBS (LITERAL: MOBS NO CHÃO) ]]
local function BringMobs(TargetMob)
    pcall(function()
        local TargetPos = TargetMob.HumanoidRootPart.CFrame
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v.Name == TargetMob.Name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if (v.HumanoidRootPart.Position - TargetPos.p).Magnitude < 300 then
                    v.HumanoidRootPart.CanCollide = false
                    -- Teleporta para o MOB alvo (no chão), não para o player
                    v.HumanoidRootPart.CFrame = TargetPos
                    if v.Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                        v.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    end
                end
            end
        end
    end)
end

-- [[ 4. FAST ATTACK (CANCELAMENTO DE ANIMAÇÃO) ]]
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    task.spawn(function()
        local CombatFramework = require(Player.PlayerScripts.CombatFramework)
        local CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]
        while _G.FastAttack do
            task.wait(_G.FastAttackDelay or 0.01)
            pcall(function()
                local Controller = CombatFrameworkLib.activeController
                if Controller and Controller.equipped then
                    Controller.attackInterval = 0
                    Controller.timeToNextAttack = 0
                    Controller.hitboxMagnitude = 60
                    Controller:attack()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                end
            end)
        end
    end)
end

-- [[ 5. AUTO EQUIP ]]
function FarmModule.EquipWeapon()
    pcall(function()
        local weaponType = _G.SelectWeapon or "Melee"
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v.ToolTip == weaponType or (weaponType == "Fruit" and v.ToolTip == "Blox Fruit") then
                Player.Character.Humanoid:EquipTool(v)
                break
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
                            FarmModule.EquipWeapon()
                            -- VOCÊ fica em cima, o NPC fica no chão
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            BringMobs(Enemy)
                        else
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
    end)
end

return FarmModule


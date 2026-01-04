local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- [[ VARIÁVEIS DE CONTROLE ]]
_G.FastAttack = false
_G.AutoClick = false
_G.BringMobs = false

-- [[ 1. TABELA DE QUESTS (MANTIDA) ]]
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

-- [[ 2. UTILS ]]
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    -- Se tiver sentado, levanta (evita bugs de barco)
    if Character.Humanoid.Sit then Character.Humanoid.Sit = false end

    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    if Distance < 15 then 
        Root.CFrame = TargetCFrame 
        return 
    end
    
    local Speed = 300 -- Velocidade do Tween
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Root, info, {CFrame = TargetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- [[ 3. FAST ATTACK & AUTO CLICK (REFORMULADO) ]]
-- Lógica potente inspirada no Redz/Hoho Hub
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CameraShaker = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
local RigController = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.RigController)

-- Função auxiliar para "burlar" o delay
local function FastAttackLogic()
    pcall(function()
        local AC = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))
        local Key = AC[2]

        if _G.FastAttack then
            -- Reduz cooldown interno da arma para 0
            if debug.getupvalues(CombatFramework)[2] then
                debug.setupvalue(CombatFramework, 2, {
                    activeController = {
                        timeToNextAttack = 0,
                        focusStart = 0,
                        hitboxMagnitude = 60, -- Tenta aumentar a hitbox interna
                        humanoid = game.Players.LocalPlayer.Character.Humanoid
                    }
                })
            end
            
            -- Dispara o ataque
            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange", tostring(Player.Backpack:FindFirstChild(_G.SelectWeapon) or Player.Character:FindFirstChild(_G.SelectWeapon)))
            game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.floor(os.clock() / 99999))
            
            -- Clique Virtual
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
        end
    end)
end

-- Hook para ativar o Fast Attack no módulo
function FarmModule.FastAttack(State)
    _G.FastAttack = State
end

function FarmModule.StartAutoClick(State)
    _G.AutoClick = State
end

-- Loop separado extremamente rápido para o ataque
task.spawn(function()
    while true do
        task.wait() -- Roda o mais rápido possível sem travar (Heartbeat seria melhor, mas wait() é seguro)
        if _G.FastAttack or _G.AutoClick then
            FastAttackLogic()
        end
    end
end)

-- [[ 4. BRING MOBS + HITBOX EXPANDER (CORREÇÃO DE INTANGÍVEL) ]]
local function BringMobs(TargetMobName)
    if not _G.BringMobs then return end
    
    local MyRoot = Player.Character:FindFirstChild("HumanoidRootPart")
    if not MyRoot then return end

    pcall(function()
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                -- Verifica se é o mob correto
                if string.find(v.Name, TargetMobName) then
                    local Mag = (v.HumanoidRootPart.Position - MyRoot.Position).Magnitude
                    
                    -- CORREÇÃO: Só puxa se estiver a menos de 350 studs (Evita desync extremo)
                    if Mag < 350 then 
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.CFrame = MyRoot.CFrame * CFrame.new(0, 0, -5) -- Puxa para frente do player
                        
                        -- HITBOX EXPANDER (A Mágica)
                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60) 
                        v.HumanoidRootPart.Transparency = 0.5 -- Para você ver a hitbox (opcional)
                        if v.Humanoid.Health < v.Humanoid.MaxHealth * 0.1 then
                            v.HumanoidRootPart.Size = Vector3.new(5,5,5) -- Reseta se for morrer
                        end
                        
                        -- Anula a gravidade para ele não cair
                        local bodyVel = v.HumanoidRootPart:FindFirstChild("BodyVelocity")
                        if not bodyVel then
                            bodyVel = Instance.new("BodyVelocity")
                            bodyVel.Velocity = Vector3.new(0,0,0)
                            bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bodyVel.Parent = v.HumanoidRootPart
                        end
                    end
                end
            end
        end
    end)
end

-- [[ 5. SISTEMA DE ARMAS ]]
function FarmModule.EquipWeapon()
    pcall(function()
        local weapon = _G.SelectWeapon or "Melee" -- Fallback
        
        -- Verifica se já está equipado
        if Player.Character:FindFirstChild(weapon) then return end
        
        local tool = Player.Backpack:FindFirstChild(weapon)
        if tool then
            Player.Character.Humanoid:EquipTool(tool)
        end
    end)
end

-- [[ 6. LOOP PRINCIPAL DE FARM ]]
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait(0.1) -- Loop de lógica (não precisa ser instantâneo)
            pcall(function()
                -- Verifica Level
                local myLevel = Player.Data.Level.Value
                local data = nil
                
                -- Seleciona a Quest certa
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if myLevel >= q.Level then data = q end
                end

                if data then
                    -- Checa se já tem a quest
                    local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                    
                    if not hasQuest then
                        -- PEGAR QUEST
                        _G.AutoClick = false
                        _G.FastAttack = false -- Pausa ataque pra não bugar
                        SmoothTween(data.NPC_Pos)
                        
                        -- Interação com NPC
                        if (Player.Character.HumanoidRootPart.Position - data.NPC_Pos.p).Magnitude < 10 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                        end
                    else
                        -- FAZER QUEST
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name)
                        
                        -- Se o inimigo existe e está vivo
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            
                            -- Vai até o mob (TP acima dele)
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                            
                            -- Ativa ferramentas de combate
                            FarmModule.EquipWeapon()
                            _G.AutoClick = true
                            _G.FastAttack = true -- Ativa o modo turbo
                            
                            -- Puxa os mobs próximos e aumenta hitbox
                            BringMobs(data.Name)
                        else
                            -- Se não achou mob, vai para o spawnpoint deles
                            _G.AutoClick = false
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
        -- Quando desativa o farm
        _G.AutoClick = false
        _G.FastAttack = false
    end)
end

return FarmModule


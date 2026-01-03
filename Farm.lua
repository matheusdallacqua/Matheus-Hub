local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- [[ 1. TWEEN SUAVE ]]
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

-- [[ 2. BRING MOBS CORRIGIDO (ESTILO OPENSOURCE) ]]
-- Faz os mobs ficarem parados em um ponto fixo, sem subir com você
local function BringMobs(MonsterName)
    pcall(function()
        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v.Name == MonsterName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                v.HumanoidRootPart.CanCollide = false
                -- Posiciona o Mob um pouco abaixo da sua posição de farm para eles não te darem knockback
                v.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -8, 0)
                
                -- Congela o Mob para ele não cair nem revidar (State 11 = Physics Off)
                if v.Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                    v.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end
        end
    end)
end

-- [[ 3. AUTO EQUIP ]]
function FarmModule.EquipWeapon()
    pcall(function()
        local weaponType = _G.SelectWeapon or "Melee"
        if weaponType == "Fruit" then weaponType = "Blox Fruit" end
        
        if not Player.Character:FindFirstChildOfClass("Tool") or (Player.Character:FindFirstChildOfClass("Tool").ToolTip ~= weaponType) then
            for _, v in pairs(Player.Backpack:GetChildren()) do
                if v.ToolTip == weaponType or v.Name == weaponType then
                    Player.Character.Humanoid:EquipTool(v)
                    break
                end
            end
        end
    end)
end

-- [[ 4. FAST ATTACK ULTRA RAPIDO (CANCELAMENTO DE ANIMAÇÃO) ]]
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    
    task.spawn(function()
        -- Puxa as bibliotecas internas do jogo
        local CombatFramework = require(Player.PlayerScripts.CombatFramework)
        local CombatFrameworkLib = debug.getupvalues(CombatFramework)[2]
        
        while _G.FastAttack do
            -- O delay aqui deve ser mínimo (quase 0) para o soco sair infinito
            task.wait(_G.FastAttackDelay or 0.05) 
            
            pcall(function()
                if Player.Character:FindFirstChildOfClass("Tool") then
                    -- 1. Pega o controlador de ataque ativo
                    local Controller = CombatFrameworkLib.activeController
                    
                    if Controller and Controller.equipped then
                        -- 2. O PULO DO GATO: Reseta os timers internos de ataque do jogo
                        -- Isso faz o jogo achar que você ainda não deu o primeiro soco
                        Controller.hitboxMagnitude = 60
                        Controller.attackInterval = 0
                        Controller.maxAttacks = 1
                        Controller.increment = 3 -- Pula para o soco final da animação que é mais rápido
                        Controller.timeToNextAttack = 0
                        Controller.blocking = false
                        
                        -- 3. Dispara o ataque diretamente no Framework
                        Controller:attack()
                        
                        -- 4. Validador (Remote que faz o dano ser real e não apenas visual)
                        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                    end
                end
            end)
        end
    end)
end


-- [[ 5. DATABASE DE QUESTS (SEA 1) ]]
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, NPC_Pos = CFrame.new(1060, 16, 1547), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1236, 6, -493)},
    }
}

-- [[ 6. AUTO FARM MAIN LOOP ]]
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait()
            pcall(function()
                local myLevel = Player.Data.Level.Value
                local data = nil
                
                -- Busca automática da Quest
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if myLevel >= q.Level then data = q end
                end

                if data then
                    local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                    
                    if not hasQuest then
                        SmoothTween(data.NPC_Pos)
                        task.wait(0.3)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    else
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name)
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            -- 1. Equipar
                            FarmModule.EquipWeapon()
                            
                            -- 2. Posicionar o Jogador (Fica em cima do Mob)
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            
                            -- 3. Trazer os Mobs (Abaixo de você para não te levar junto)
                            BringMobs(data.Name)
                        else
                            -- Se não tem mob, vai pro spawn esperar
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
    end)
end

return FarmModule

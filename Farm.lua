local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ 1. FUNÇÃO TWEEN (VOCÊ DISSE QUE ESTÁ OK) ]]
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

-- [[ 2. BRING MOBS (LOGICA OPENSOURCE) ]]
-- Essa função puxa todos os monstros com o nome certo para a sua frente
local function BringMobs(MonsterName)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == MonsterName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            v.HumanoidRootPart.CanCollide = false
            v.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            v.Humanoid:ChangeState(11) -- Desativa a física do mob para ele não cair
            if v.Humanoid.Health <= 0 then v:Destroy() end
        end
    end
end

-- [[ 3. AUTO EQUIP (CORRIGIDO) ]]
function FarmModule.EquipWeapon()
    pcall(function()
        local weaponType = _G.SelectWeapon or "Melee"
        if weaponType == "Fruit" then weaponType = "Blox Fruit" end
        
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v.ToolTip == weaponType or v.Name == weaponType then
                Player.Character.Humanoid:EquipTool(v)
                break
            end
        end
    end)
end

-- [[ 4. DATABASE DE QUESTS ]]
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, NPC_Pos = CFrame.new(1060, 16, 1547), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1236, 6, -493)},
    }
}

-- [[ 5. AUTO FARM PRINCIPAL ]]
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait()
            pcall(function()
                local level = Player.Data.Level.Value
                local data = nil
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if level >= q.Level then data = q end
                end

                if data then
                    local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                    if not hasQuest then
                        SmoothTween(data.NPC_Pos)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    else
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name)
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            -- Equipar Arma
                            FarmModule.EquipWeapon()
                            
                            -- Ir para o monstro
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            
                            -- Puxar os outros monstros (Bring Mobs)
                            BringMobs(data.Name)
                        else
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
    end)
end

-- [[ 6. FAST ATTACK (MÉTODO UNIVERSAL VIRTUALUSER) ]]
-- O método do framework costuma falhar em alguns executors, o VirtualUser é infalível.
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    task.spawn(function()
        while _G.FastAttack do
            task.wait(_G.FastAttackDelay or 0.1)
            pcall(function()
                if Player.Character:FindFirstChildOfClass("Tool") then
                    -- Simula o clique de ataque
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(850, 450))
                    
                    -- Validador de dano (Obrigatório para registrar o hit)
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                end
            end)
        end
    end)
end

return FarmModule


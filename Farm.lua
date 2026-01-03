local FarmModule = {}

-- === CONFIGURAÇÕES GLOBAIS ===
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ 1. FUNÇÃO DE TWEEN (ANTI-KICK) ]]
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Root = Character.HumanoidRootPart
    
    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    if Distance < 15 then 
        Root.CFrame = TargetCFrame 
        return 
    end

    local Speed = 250 -- Velocidade segura
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Root, info, {CFrame = TargetCFrame})
    
    -- Se o farm for desligado durante o trajeto, cancela o tween
    if not _G.AutoFarmLevel then tween:Cancel() return end
    
    tween:Play()
    tween.Completed:Wait()
end

-- [[ 2. SELETOR E EQUIPADOR DE ARMA ]]
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.SelectWeapon and Player.Backpack:FindFirstChild(_G.SelectWeapon) == nil then
                -- Esta lógica converte o Tipo (Melee) no Nome Real da ferramenta
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        if (_G.SelectWeapon == "Melee" and v.ToolTip == "Melee") or 
                           (_G.SelectWeapon == "Sword" and v.ToolTip == "Sword") or
                           (_G.SelectWeapon == "Fruit" and v.ToolTip == "Blox Fruit") then
                            _G.CurrentEquip = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

function FarmModule.EquipWeapon()
    pcall(function()
        if _G.CurrentEquip and not Player.Character:FindFirstChild(_G.CurrentEquip) then
            local tool = Player.Backpack:FindFirstChild(_G.CurrentEquip)
            if tool then Player.Character.Humanoid:EquipTool(tool) end
        end
    end)
end

-- [[ 3. DATABASE DE QUESTS (SEA 1) ]]
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, NPC_Pos = CFrame.new(1060, 16, 1547), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1236, 6, -493)},
    }
}

-- [[ 4. LÓGICA DE AUTO FARM COM TWEEN ]]
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait()
            pcall(function()
                local level = Player.Data.Level.Value
                local data = nil
                
                -- Pega a melhor quest
                for _, q in ipairs(QuestData["Sea 1"]) do
                    if level >= q.Level then data = q end
                end

                if data then
                    local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                    
                    if not hasQuest then
                        SmoothTween(data.NPC_Pos)
                        task.wait(0.2)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    else
                        local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name) or game.ReplicatedStorage:FindFirstChild(data.Name)
                        if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                            FarmModule.EquipWeapon()
                            -- Posicionamento perfeito em cima do mob
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        else
                            SmoothTween(data.Mob_Pos)
                        end
                    end
                end
            end)
        end
    end)
end

-- [[ 5. FAST ATTACK (COMBAT FRAMEWORK) ]]
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    task.spawn(function()
        local CombatFramework = require(Player.PlayerScripts.CombatFramework)
        while _G.FastAttack do
            task.wait(_G.FastAttackDelay or 0.1)
            pcall(function()
                local ActiveController = debug.getupvalues(CombatFramework)[2].activeController
                if ActiveController then
                    ActiveController.attackInterval = 0
                    ActiveController:attack()
                    game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge)
                end
            end)
        end
    end)
end

return FarmModule

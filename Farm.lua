local FarmModule = {}

-- === VARIÁVEIS DE SERVIÇO ===
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- [[ 1. CÉREBRO: SELETOR DE ARMA (LÓGICA DO TSUO) ]]
-- Este loop roda em background transformando "Melee" no nome real da arma
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.SelectWeapon == "Melee" then
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.ToolTip == "Melee" then
                        _G.WeaponName = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Sword" then
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.ToolTip == "Sword" then
                        _G.WeaponName = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Gun" then
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.ToolTip == "Gun" then
                        _G.WeaponName = v.Name
                    end
                end
            elseif _G.SelectWeapon == "Fruit" then
                for _, v in pairs(Player.Backpack:GetChildren()) do
                    if v.ToolTip == "Blox Fruit" then
                        _G.WeaponName = v.Name
                    end
                end
            end
        end)
    end
end)

-- [[ 2. FUNÇÃO PARA EQUIPAR ARMA ]]
function FarmModule.EquipWeapon()
    pcall(function()
        if _G.WeaponName then
            local tool = Player.Backpack:FindFirstChild(_G.WeaponName)
            if tool then
                Player.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end

-- [[ 3. FAST ATTACK (ESTILO TSUO / OPENSOURCE) ]]
function FarmModule.FastAttack(state)
    _G.FastAttack = state
    if not state then return end
    
    task.spawn(function()
        -- Puxa o framework de combate original do Blox Fruits
        local CombatFramework = require(Player.PlayerScripts.CombatFramework)
        local CameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
        CameraShaker:Stop() -- Desativa o tremor da tela
        
        while _G.FastAttack do
            -- Usa o delay exato que o seu Dropdown converteu na Main.lua
            task.wait(_G.FastAttackDelay or 0.1)
            
            pcall(function()
                local ActiveController = debug.getupvalues(CombatFramework)[2].activeController
                if ActiveController then
                    -- Equipar a arma antes de bater
                    FarmModule.EquipWeapon()
                    
                    -- Lógica de reset de ataque do Tsuo
                    ActiveController.attackInterval = 0
                    ActiveController.maxAttacks = 4
                    ActiveController.timeToNextAttack = 0
                    ActiveController.hitboxMagnitude = 60
                    
                    -- Executa o ataque
                    ActiveController:attack()
                end
            end)
        end
    end)
end

local FarmModule = {}

-- === 1. TABELA DE DADOS (DATABASE) ===
-- Aqui ficam os IDs e nomes que o jogo usa internamente
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, NPC_Pos = CFrame.new(1060, 16, 1547), Mob_Pos = CFrame.new(1145, 17, 1634)},
        {Level = 10, Name = "Monkey", QuestName = "JungleQuest", QuestID = 1, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1623, 21, 142)},
        {Level = 15, Name = "Gorilla", QuestName = "JungleQuest", QuestID = 2, NPC_Pos = CFrame.new(-1601, 36, 153), Mob_Pos = CFrame.new(-1236, 6, -493)},
        -- [Nota: Você pode expandir esta lista até o Level 2550]
    }
}

-- === 2. FUNÇÕES DE SUPORTE (O "MOTOR") ===
local function GetCurrentSea()
    local id = game.PlaceId
    if id == 2753915549 then return "Sea 1"
    elseif id == 4442272183 or id == 4442245441 then return "Sea 2"
    elseif id == 7449423635 then return "Sea 3" end
end

local function GetBestQuest()
    local level = game.Players.LocalPlayer.Data.Level.Value
    local sea = GetCurrentSea()
    local best = nil
    for _, quest in ipairs(QuestData[sea]) do
        if level >= quest.Level then best = quest end
    end
    return best
end

-- === 3. LÓGICA DE AUTO FARM (STARTLEVELFARM) ===
function FarmModule.StartLevelFarm(Toggle)
    _G.AutoFarmLevel = Toggle
    
    task.spawn(function()
        while _G.AutoFarmLevel do
            task.wait()
            pcall(function()
                local Player = game.Players.LocalPlayer
                local Character = Player.Character
                local Root = Character.HumanoidRootPart
                local data = GetBestQuest()

                -- Verificação: Já tem Quest?
                local hasQuest = Player.PlayerGui.Main:FindFirstChild("Quest") and Player.PlayerGui.Main.Quest.Visible
                
                if not hasQuest then
                    -- Lógica: Ir até o NPC e Pegar Quest
                    local dist = (Root.Position - data.NPC_Pos.p).Magnitude
                    if dist > 15 then
                        Root.CFrame = data.NPC_Pos -- Aqui você pode trocar por Tween se quiser
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    end
                else
                    -- Lógica: Matar Mobs
                    local Enemy = game.Workspace.Enemies:FindFirstChild(data.Name) or game.ReplicatedStorage:FindFirstChild(data.Name)
                    
                    if Enemy and Enemy:FindFirstChild("HumanoidRootPart") and Enemy.Humanoid.Health > 0 then
                        -- Farm Positional (Fica atrás/cima do Mob)
                        Root.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        
                        -- Ativa o Fast Attack se estiver perto
                        if _G.AutoClick then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(850, 450))
                        end
                    else
                        -- Se mob não spawnou, vai para o ponto de spawn
                        Root.CFrame = data.Mob_Pos
                    end
                end
            end)
        end
    end)
end

-- === 4. FAST ATTACK (MÉTODO TSUO) ===
function FarmModule.FastAttack(Toggle)
    _G.FastAttack = Toggle
    task.spawn(function()
        while _G.FastAttack do
            local delay = _G.FastAttackDelay or 0.1
            task.wait(delay)
            pcall(function()
                -- Remote de validação de combate do Blox Fruits
                local combat = game:GetService("ReplicatedStorage").Remotes.Validator
                combat:FireServer(math.huge)
                -- Simula o clique
                game:GetService("VirtualUser"):ClickButton1(Vector2.new(850, 450))
            end)
        end
    end)
end

return FarmModule




-- [[ FARM.LUA - VERSÃO CORRIGIDA SEM BUGS ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === CONFIGURAÇÕES ===
local Config = {
    TweenSpeed = 80,           -- MAIS LENTO para não quicar
    AttackDistance = 3,        -- MAIS PERTO do mob
    MobSearchRadius = 100,
    QuestCheckDelay = 1,
}

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.1  -- MAIS RÁPIDO
_G.SelectWeapon = _G.SelectWeapon or ""
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === TABELA DE QUESTS (SÓ AS PRIMEIRAS) ===
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest", QuestID = 1, 
         NPC_Pos = CFrame.new(1059, 17, 1548),  -- Coordenada SIMPLIFICADA
         Mob_Pos = CFrame.new(1145, 17, 1634)},
    }
}

-- === THREADS ===
local MainFarmThread = nil
local CombatThread = nil

-- === FUNÇÕES SIMPLIFICADAS ===

-- TELEPORTE DIRETO (SEM TWEEN PARA NPC)
local function GoToNPC(targetCFrame)
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return false end
    
    -- Teleporte DIRETO em cima do NPC (como você quer)
    local teleportCFrame = CFrame.new(
        targetCFrame.X,
        targetCFrame.Y + 1,  -- 1 stud acima (EM CIMA)
        targetCFrame.Z
    )
    
    character.HumanoidRootPart.CFrame = teleportCFrame
    task.wait(0.5)  -- Pequeno delay após teleporte
    
    return true
end

-- TELEPORTE SUAVE APENAS PARA MOBS
local function GoToMob(targetCFrame)
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return false end
    
    local root = character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    
    if distance < 10 then
        -- Já está perto, só ajusta
        root.CFrame = CFrame.new(
            targetCFrame.X,
            targetCFrame.Y + 3,
            targetCFrame.Z
        )
        return true
    end
    
    -- Tween apenas para mobs (mais lento)
    local travelTime = distance / Config.TweenSpeed
    travelTime = math.max(1, math.min(travelTime, 5))
    
    local targetPos = CFrame.new(
        targetCFrame.X,
        targetCFrame.Y + 3,
        targetCFrame.Z
    )
    
    local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetPos})
    
    tween:Play()
    
    local startTime = tick()
    while tick() - startTime < travelTime + 2 do
        local currentDist = (root.Position - targetCFrame.Position).Magnitude
        if currentDist < 15 then break end
        task.wait(0.1)
    end
    
    task.wait(0.3)
    return true
end

-- VERIFICA QUEST (MELHORADO)
local function HasActiveQuest()
    local playerGui = Player.PlayerGui
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local quest = main:FindFirstChild("Quest")
    if not quest then return false end
    
    -- Verifica se a quest está visível E tem texto
    if quest.Visible then
        local questName = quest:FindFirstChild("QuestName")
        if questName and questName.Text ~= "" then
            return true
        end
    end
    
    return false
end

-- ACEITA QUEST (MELHORADO)
local function AcceptQuest(questName, questId)
    print("[QUEST] Tentando aceitar:", questName, questId)
    
    local args = {"StartQuest", questName, questId}
    
    -- Tenta 3 vezes
    for attempt = 1, 3 do
        local success = pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        end)
        
        if success then
            print("[QUEST] Comando enviado (tentativa", attempt, ")")
            
            -- Verifica se a quest apareceu
            for i = 1, 5 do
                if HasActiveQuest() then
                    print("[QUEST] ✅ Aceita com sucesso!")
                    return true
                end
                task.wait(0.5)
            end
        else
            print("[QUEST] ❌ Erro na tentativa", attempt)
        end
        
        task.wait(1)
    end
    
    print("[QUEST] ❌ Falha ao aceitar quest")
    return false
end

-- ENCONTRA MOB PRÓXIMO
local function FindClosestMob(mobName)
    local character = Player.Character
    if not character or not character.HumanoidRootPart then return nil end
    
    local playerPos = character.HumanoidRootPart.Position
    local closestMob = nil
    local closestDistance = math.huge
    
    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local mobPos = mob.HumanoidRootPart.Position
            local distance = (mobPos - playerPos).Magnitude
            
            if distance < Config.MobSearchRadius and distance < closestDistance then
                closestDistance = distance
                closestMob = mob
            end
        end
    end
    
    return closestMob, closestDistance
end

-- EQUIPA ARMA SIMPLES
local function EquipWeapon()
    pcall(function()
        local character = Player.Character
        if not character then return false end
        
        -- Primeiro, tenta qualquer arma de Melee
        for _, tool in pairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword") then
                character.Humanoid:EquipTool(tool)
                _G.SelectWeapon = tool.Name
                print("[ARMA] Equipada:", tool.Name)
                task.wait(0.2)
                return true
            end
        end
        
        -- Se não achou, pega a primeira ferramenta
        local firstTool = Player.Backpack:FindFirstChildWhichIsA("Tool")
        if firstTool then
            character.Humanoid:EquipTool(firstTool)
            _G.SelectWeapon = firstTool.Name
            print("[ARMA] Equipada (qualquer):", firstTool.Name)
            task.wait(0.2)
            return true
        end
        
        print("[ARMA] ❌ Nenhuma arma encontrada")
        return false
    end)
end

-- === AUTO CLICK MELHORADO ===
function FarmModule.StartCombat(toggle)
    _G.AutoClick = toggle
    
    if CombatThread then
        task.cancel(CombatThread)
        CombatThread = nil
    end
    
    if not toggle then 
        print("[COMBATE] ❌ Desligado")
        return 
    end
    
    CombatThread = task.spawn(function()
        print("[COMBATE] ✅ Iniciado")
        
        while _G.AutoClick do
            pcall(function()
                local character = Player.Character
                if not character then return end
                
                -- Verifica se tem arma equipada
                local hasTool = false
                for _, child in pairs(character:GetChildren()) do
                    if child:IsA("Tool") then
                        hasTool = true
                        break
                    end
                end
                
                if not hasTool then
                    print("[COMBATE] ❌ Sem arma equipada")
                    return
                end
                
                -- Sistema de ataque SIMPLES mas funcional
                local virtualUser = game:GetService('VirtualUser')
                
                -- Click DOWN
                virtualUser:CaptureController()
                virtualUser:Button1Down(Vector2.new(0, 0))
                
                -- Pequeno delay (importante!)
                task.wait(0.03)
                
                -- Click UP
                virtualUser:Button1Up(Vector2.new(0, 0))
                
                print("[COMBATE] 🔥 Atacando...")
                
            end)
            
            -- Delay configurável ENTRE ataques
            task.wait(_G.FastAttackDelay or 0.1)
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
        FarmModule.StartCombat(false)
        print("[FARM] ❌ Desativado")
        return 
    end
    
    MainFarmThread = task.spawn(function()
        print("[FARM] ✅ Iniciando...")
        
        local currentQuest = QuestData["Sea 1"][1]  -- Bandit quest
        local state = "GET_QUEST"  -- Estados: GET_QUEST, FIND_MOB, ATTACK
        
        while _G.AutoFarm do
            task.wait(1)  -- Loop principal mais lento
            
            pcall(function()
                local character = Player.Character
                if not character or not character.HumanoidRootPart then
                    print("[FARM] ⏳ Esperando personagem...")
                    task.wait(2)
                    return
                end
                
                -- VERIFICA SE TEM QUEST
                local hasQuest = HasActiveQuest()
                
                if not hasQuest then
                    state = "GET_QUEST"
                else
                    state = "FIND_MOB"
                end
                
                print("[FARM] Estado:", state)
                
                if state == "GET_QUEST" then
                    print("[FARM] 🎯 Indo pegar quest...")
                    
                    -- PARA DE ATACAR
                    FarmModule.StartCombat(false)
                    
                    -- TELEPORTE DIRETO EM CIMA DO NPC (SEM QUICAR)
                    GoToNPC(currentQuest.NPC_Pos)
                    
                    -- TENTA ACEITAR QUEST
                    AcceptQuest(currentQuest.QuestName, currentQuest.QuestID)
                    
                    -- ESPERA UM POUCO
                    task.wait(2)
                    
                elseif state == "FIND_MOB" then
                    print("[FARM] 🔍 Procurando Bandits...")
                    
                    local targetMob, distance = FindClosestMob(currentQuest.Name)
                    
                    if targetMob then
                        print("[FARM] ✅ Bandit encontrado a", math.floor(distance), "studs")
                        state = "ATTACK"
                    else
                        print("[FARM] ❌ Nenhum Bandit encontrado, indo para spawn...")
                        GoToMob(currentQuest.Mob_Pos)
                        task.wait(2)
                    end
                    
                elseif state == "ATTACK" then
                    local targetMob = FindClosestMob(currentQuest.Name)
                    
                    if targetMob and targetMob.Humanoid.Health > 0 then
                        -- EQUIPA ARMA (se necessário)
                        EquipWeapon()
                        
                        -- ATIVA AUTO CLICK
                        FarmModule.StartCombat(true)
                        
                        -- POSICIONA BEM PERTO DO MOB (3 studs)
                        local mobPos = targetMob.HumanoidRootPart.Position
                        character.HumanoidRootPart.CFrame = CFrame.new(
                            mobPos.X + Config.AttackDistance,
                            mobPos.Y + 3,  -- 3 studs acima
                            mobPos.Z + Config.AttackDistance
                        )
                        
                        -- VIRA PARA O MOB
                        character.HumanoidRootPart.CFrame = CFrame.new(
                            character.HumanoidRootPart.Position,
                            Vector3.new(mobPos.X, character.HumanoidRootPart.Position.Y, mobPos.Z)
                        )
                        
                        print("[FARM] ⚔️ Atacando Bandit | HP:", math.floor(targetMob.Humanoid.Health))
                        
                    else
                        -- MOB MORREU
                        print("[FARM] 🎉 Bandit morto!")
                        state = "FIND_MOB"
                        FarmModule.StartCombat(false)
                    end
                end
            end)
        end
        
        -- LIMPEZA
        FarmModule.StartCombat(false)
        print("[FARM] 🛑 Finalizado")
    end)
end

-- === STOP ALL ===
function FarmModule.StopAll()
    if MainFarmThread then
        task.cancel(MainFarmThread)
        MainFarmThread = nil
    end
    
    if CombatThread then
        task.cancel(CombatThread)
        CombatThread = nil
    end
    
    _G.AutoFarm = false
    _G.AutoClick = false
    
    print("[FARM] 🛑 Parado completamente")
    return true
end

return FarmModule

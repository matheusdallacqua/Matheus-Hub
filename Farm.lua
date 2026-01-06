-- [[ FARM.LUA - COM SEU CÓDIGO DE ATAQUE ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.15
_G.SelectWeapon = _G.SelectWeapon or ""
_G.Select_Weapon_Check = _G.Select_Weapon_Check or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === TABELA DE QUESTS (APENAS BANDIT PARA TESTE) ===
local QuestData = {
    ["Sea 1"] = {
        {Level = 0, Name = "Bandit", QuestName = "BanditQuest1", QuestID = 1, 
         NPC_Pos = CFrame.new(1060, 16, 1547), 
         Mob_Pos = CFrame.new(1145, 17, 1634)},
    }
}

-- === THREADS ===
local MainFarmThread = nil
local AutoClickThread = nil

-- === FUNÇÕES DO SEU CÓDIGO ===

-- TELEPORTE SUAVE (SIMPLIFICADO)
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    
    if Distance < 15 then 
        Root.CFrame = TargetCFrame 
        return true
    end
    
    local info = TweenInfo.new(Distance / 200, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(Root, info, {CFrame = TargetCFrame})
    tween:Play()
    
    local startTime = tick()
    while tick() - startTime < 10 do
        local currentDist = (Root.Position - TargetCFrame.p).Magnitude
        if currentDist < 20 then break end
        task.wait(0.1)
    end
    
    return true
end

-- VERIFICA QUEST
local function HasQuest(QuestName)
    local PlayerGui = Player.PlayerGui
    if not PlayerGui then return false end
    
    local MainGui = PlayerGui:FindFirstChild("Main")
    if not MainGui then return false end
    
    local QuestFrame = MainGui:FindFirstChild("Quest")
    if not QuestFrame then return false end
    
    return QuestFrame.Visible
end

-- EQUIPA ARMA (SEU CÓDIGO)
local function EquipWeapon()
    local char = Player.Character
    if not char then return false end

    -- Se já tem arma equipada
    if char:FindFirstChildOfClass("Tool") then
        return true
    end

    -- Procura pela arma selecionada
    local weaponType = _G.Select_Weapon_Check or "Melee"
    local checkType = weaponType == "Fruit" and "Blox Fruit" or weaponType
    
    for _, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == checkType then
            char.Humanoid:EquipTool(v)
            _G.SelectWeapon = v.Name
            task.wait(0.2)
            return true
        end
    end

    return false
end

-- MAGNET (SEU CÓDIGO)
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

-- === AUTO CLICK (SEU CÓDIGO) ===
function FarmModule.StartAutoClick(Toggle)
    _G.AutoClick = Toggle

    if AutoClickThread then
        task.cancel(AutoClickThread)
        AutoClickThread = nil
    end

    if not Toggle then return end

    AutoClickThread = task.spawn(function()
        while _G.AutoClick do
            task.wait(_G.FastAttackDelay or 0.15)

            pcall(function()
                local char = Player.Character
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local tool = char:FindFirstChildOfClass("Tool")

                if not hrp then return end

                if not tool then
                    EquipWeapon()
                    return
                end

                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(500, 500))
                task.wait(0.01)
                VirtualUser:Button1Up(Vector2.new(500, 500))
            end)
        end
    end)
end

-- === SISTEMA PRINCIPAL COM SEU CÓDIGO DE ATAQUE ===
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
        print("[FARM] Iniciando sistema de farm...")
        
        while _G.AutoFarm do
            task.wait(0.5)  -- Loop principal mais lento
            
            pcall(function()
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    return
                end
                
                local myLevel = Player.Data.Level.Value
                local data = QuestData["Sea 1"][1]  -- Bandit quest para teste
                
                if not data then return end
                
                -- VERIFICA SE TEM QUEST
                local hasQuest = HasQuest(data.QuestName)
                
                if not hasQuest then
                    print("[FARM] Indo pegar quest...")
                    
                    -- PARA DE ATACAR
                    FarmModule.StartAutoClick(false)
                    
                    -- VAI ATÉ O NPC
                    SmoothTween(data.NPC_Pos)
                    
                    -- TENTA ACEITAR QUEST
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestID)
                    
                    -- ESPERA QUEST APARECER
                    for i = 1, 10 do
                        if HasQuest(data.QuestName) then
                            print("[FARM] ✅ Quest aceita!")
                            break
                        end
                        task.wait(0.5)
                    end
                    
                else
                    -- 🔥 SEU CÓDIGO DE ATAQUE AQUI 🔥
                    print("[FARM] Procurando Bandits...")
                    
                    local Enemy = nil
                    
                    -- PROCURA O MOB (SEU CÓDIGO)
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name:find(data.Name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            Enemy = v
                            break
                        end
                    end
                    
                    if Enemy then
                        print("[FARM] ✅ Bandit encontrado! Atacando...")
                        
                        -- EQUIPA ARMA
                        EquipWeapon()
                        
                        -- ATIVA AUTO CLICK
                        FarmModule.StartAutoClick(true)
                        
                        -- 🎯 SEU LOOP DE ATAQUE 🎯
                        repeat
                            if not Enemy or not Enemy:FindFirstChild("HumanoidRootPart") then 
                                print("[FARM] Bandit desapareceu")
                                break 
                            end
                            
                            -- MAGNET
                            Magnet(Enemy)
                            
                            -- POSICIONAMENTO
                            Player.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            
                            print("[FARM] Atacando Bandit | HP:", math.floor(Enemy.Humanoid.Health))
                            
                            task.wait(0.1)
                            
                        until Enemy.Humanoid.Health <= 0 or not _G.AutoFarm
                        
                        print("[FARM] Bandit morto!")
                        
                    else
                        print("[FARM] ❌ Nenhum Bandit encontrado, indo para spawn...")
                        
                        FarmModule.StartAutoClick(false)
                        
                        -- VAI PRO SPAWN DA QUEST
                        SmoothTween(data.Mob_Pos)
                        task.wait(0.3)
                        
                        -- FORÇA POSIÇÃO (SEU CÓDIGO)
                        Player.Character.HumanoidRootPart.CFrame = data.Mob_Pos
                        
                        -- ESPERA MOBS SPAWNArem
                        task.wait(2)
                    end
                end
            end)
        end
        
        -- LIMPEZA
        FarmModule.StartAutoClick(false)
        print("[FARM] Sistema parado")
    end)
end

-- === FUNÇÕES EXTRAS PARA COMPATIBILIDADE ===
FarmModule.StartCombat = FarmModule.StartAutoClick

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

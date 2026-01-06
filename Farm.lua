-- [[ FARM.LUA - VERSÃO CORRETA ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.15
_G.SelectWeapon = _G.SelectWeapon or ""
_G.Select_Weapon_Check = _G.Select_Weapon_Check or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === THREADS ===
local MainFarmThread = nil
local AutoClickThread = nil

-- === QUEST DATA ===
local QuestData = {
    ["Sea 1"] = {
        {
            Level = 0,
            Name = "Bandit",
            QuestName = "BanditQuest1",
            QuestID = 1,
            NPC_Pos = CFrame.new(1060, 16, 1547),
            Mob_Pos = CFrame.new(1145, 17, 1634)
        },
    }
}

-- =========================
--  FAST ATTACK ARCEUS X NEO (AGORA DENTRO DE UMA FUNÇÃO)
-- =========================
local CombatFramework, CombatFrameworkR, RigControllerR, CameraShaker

local function SetupFastAttack()
    -- Só carrega os módulos quando a função for chamada PELA PRIMEIRA VEZ
    if not CombatFramework then
        local success = pcall(function()
            CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
            CombatFrameworkR = getupvalues(CombatFramework)[2]
            local RigController = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.RigController)
            RigControllerR = getupvalues(RigController)[2]
            CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
            CameraShaker:Stop()
        end)
        
        if not success then
            print("[FAST ATTACK] Não conseguiu carregar módulos do CombatFramework")
            return false
        end
    end
    return true
end

local function FastAttack()
    pcall(function()
        -- Tenta usar Arceus X Neo
        if SetupFastAttack() then
            local AC = CombatFrameworkR.activeController
            if AC and AC.equipped then
                AC.hitboxMagnitude = 55
                AC.timeToNextAttack = 0
                AC.increment = 3
                AC.blocking = false
                AC:attack()
                return
            end
        end
        
        -- Fallback: VirtualUser normal
        local VirtualUser = game:GetService('VirtualUser')
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(500, 500))
        task.wait(0.01)
        VirtualUser:Button1Up(Vector2.new(500, 500))
    end)
end

-- =========================
--  RESTANTE DO CÓDIGO (MESMO DE ANTES)
-- =========================

-- EQUIPAR ARMA
local function EquipWeapon()
    local char = Player.Character
    if not char then return false end

    if char:FindFirstChildOfClass("Tool") then
        return true
    end

    local weaponType = _G.Select_Weapon_Check or "Melee"
    local checkType = weaponType == "Fruit" and "Blox Fruit" or weaponType

    for _, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == checkType then
            char.Humanoid:EquipTool(v)
            _G.SelectWeapon = v.Name
            task.wait(0.1)
            return true
        end
    end

    return false
end

-- AUTO CLICK
function FarmModule.StartAutoClick(Toggle)
    _G.AutoClick = Toggle

    if AutoClickThread then
        task.cancel(AutoClickThread)
        AutoClickThread = nil
    end

    if not Toggle then 
        print("[FAST ATTACK] Desativado")
        return 
    end

    AutoClickThread = task.spawn(function()
        print("[FAST ATTACK] Iniciado | Delay:", _G.FastAttackDelay or 0.15)
        
        while _G.AutoClick do
            task.wait(_G.FastAttackDelay or 0.15)
            
            pcall(function()
                if not EquipWeapon() then
                    return
                end
                
                FastAttack()
            end)
        end
        
        print("[FAST ATTACK] Parado")
    end)
end

-- COMPATIBILIDADE
FarmModule.StartCombat = FarmModule.StartAutoClick

-- TELEPORTE SUAVE
local function SmoothTween(TargetCFrame)
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return false end

    local Root = Character.HumanoidRootPart
    local Distance = (Root.Position - TargetCFrame.Position).Magnitude

    if Distance < 10 then
        Root.CFrame = TargetCFrame
        return true
    end

    local TweenInfoData = TweenInfo.new(Distance / 200, Enum.EasingStyle.Linear)
    local Tween = TweenService:Create(Root, TweenInfoData, {CFrame = TargetCFrame})
    Tween:Play()
    
    -- Timeout de segurança
    local startTime = tick()
    while tick() - startTime < 10 do
        local currentDist = (Root.Position - TargetCFrame.Position).Magnitude
        if currentDist < 15 then break end
        task.wait(0.1)
    end
    
    return true
end

-- VERIFICA QUEST
local function HasQuest()
    local PlayerGui = Player:FindFirstChild("PlayerGui")
    if not PlayerGui then return false end

    local MainGui = PlayerGui:FindFirstChild("Main")
    if not MainGui then return false end

    local QuestFrame = MainGui:FindFirstChild("Quest")
    if not QuestFrame then return false end

    return QuestFrame.Visible
end

-- MAGNET
local function Magnet(TargetMob)
    if not _G.BringMobs then return end
    if not TargetMob then return end
    if not TargetMob:FindFirstChild("HumanoidRootPart") then return end

    pcall(function()
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == TargetMob.Name and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if v.Humanoid.Health > 0 then
                    local dist = (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 300 then
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.CFrame = TargetMob.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end)
end

-- SISTEMA PRINCIPAL
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
        print("[FARM] Sistema iniciado")

        while _G.AutoFarm do
            task.wait(0.3)

            pcall(function()
                local char = Player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local data = QuestData["Sea 1"][1]
                if not data then return end

                if not HasQuest() then
                    print("[FARM] Indo pegar quest")

                    FarmModule.StartAutoClick(false)
                    SmoothTween(data.NPC_Pos)
                    task.wait(0.3)

                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                        "StartQuest",
                        data.QuestName,
                        data.QuestID
                    )

                    task.wait(1)
                    return
                end

                local Enemy = nil

                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name:find(data.Name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        Enemy = v
                        break
                    end
                end

                if Enemy then
                    FarmModule.StartAutoClick(true)

                    repeat
                        if not Enemy or not Enemy:FindFirstChild("HumanoidRootPart") then break end
                        if Enemy.Humanoid.Health <= 0 then break end

                        Magnet(Enemy)

                        char.HumanoidRootPart.CFrame =
                            Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)

                        task.wait(0.1)
                    until not _G.AutoFarm

                else
                    print("[FARM] Mob não encontrado, indo para spawn")

                    FarmModule.StartAutoClick(false)
                    SmoothTween(data.Mob_Pos)
                    task.wait(1)
                end
            end)
        end

        FarmModule.StartAutoClick(false)
        print("[FARM] Sistema finalizado")
    end)
end

-- STOP
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

    print("[FARM] Tudo parado")
end

return FarmModule

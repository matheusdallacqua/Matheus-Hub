-- [[ FARM.LUA - VERSÃO CORRETA COM AUTO-CLICK DE MOUSE INTEGRADO ]]
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- === VARIÁVEIS ===
_G.BringMobs = _G.BringMobs or false
_G.FastAttackDelay = _G.FastAttackDelay or 0.15
_G.SelectWeapon = _G.SelectWeapon or ""
_G.Select_Weapon_Check = _G.Select_Weapon_Check or "Melee"
_G.FarmMode = _G.FarmMode or "Level"
_G.AutoFarm = _G.AutoFarm or false
_G.AutoClick = _G.AutoClick or false

-- === NOVAS VARIÁVEIS PARA O AUTO-CLICK DE MOUSE ===
_G.AutoClickMouseEnabled = false  -- Ativar/desativar
_G.ClickCooldown = 0.05           -- 50ms entre cliques (padrão)
_G.ClickDuration = 0.02           -- 20ms duração do clique
_G.TargetScreenX = 1720           -- Coordenadas da tela (ajustável)
_G.TargetScreenY = 934            -- Coordenadas da tela (ajustável)

-- === THREADS ===
local MainFarmThread = nil
local AutoClickThread = nil
local MouseAutoClickThread = nil  -- Nova thread para auto-click de mouse

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
--  SISTEMA DE AUTO-CLICK DE MOUSE (DO SEU CÓDIGO LOGITECH)
-- =========================

-- Converte coordenadas de tela para o sistema do Roblox (0-65535)
local function ConvertToRobloxCoordinates(screenX, screenY)
    local viewport = workspace.CurrentCamera.ViewportSize
    local scaleX = screenX / viewport.X
    local scaleY = screenY / viewport.Y
    
    -- Sistema de 0 a 65535 (igual Logitech G Hub)
    local robloxX = math.floor(scaleX * 65535)
    local robloxY = math.floor(scaleY * 65535)
    
    return robloxX, robloxY
end

-- Simula movimento do mouse para coordenadas específicas
local function MoveMouseToScreen(x, y)
    local robloxX, robloxY = ConvertToRobloxCoordinates(x, y)
    
    -- Usando o mouse virtual do Roblox
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    -- Move o cursor
    VirtualInputManager:SendMouseMoveEvent(robloxX, robloxY, workspace)
    
    -- Também move o Mouse real se possível
    pcall(function()
        local Mouse = Player:GetMouse()
        -- Nota: Não podemos mover o cursor REAL do jogador no Roblox,
        -- mas podemos simular o movimento para alguns scripts
    end)
end

-- Sistema de auto-click mantendo pressionado G4 (Botão 4 do mouse)
function FarmModule.StartMouseAutoClick(Toggle)
    _G.AutoClickMouseEnabled = Toggle
    
    if MouseAutoClickThread then
        task.cancel(MouseAutoClickThread)
        MouseAutoClickThread = nil
    end
    
    if not Toggle then
        print("[MOUSE AUTO-CLICK] Desativado")
        return
    end
    
    MouseAutoClickThread = task.spawn(function()
        print(string.format("[MOUSE AUTO-CLICK] Iniciado | Coord: X=%d Y=%d | Delay: %dms", 
            _G.TargetScreenX, _G.TargetScreenY, _G.ClickCooldown * 1000))
        
        -- Configura o mouse para clicar automaticamente
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local startTime = tick()
        local clickCount = 0
        
        while _G.AutoClickMouseEnabled do
            local currentTime = tick()
            
            -- Só funciona se o jogo estiver em foco
            if game:GetService("UserInputService").WindowFocused then
                
                -- 1. Move o mouse para a posição alvo
                MoveMouseToScreen(_G.TargetScreenX, _G.TargetScreenY)
                task.wait(0.01)
                
                -- 2. Pressiona botão esquerdo (20ms)
                VirtualInputManager:SendMouseButtonEvent(
                    _G.TargetScreenX, 
                    _G.TargetScreenY, 
                    0,  -- Botão esquerdo
                    true,  -- Pressionar
                    workspace, 
                    1
                )
                task.wait(_G.ClickDuration)
                
                -- 3. Solta botão esquerdo
                VirtualInputManager:SendMouseButtonEvent(
                    _G.TargetScreenX, 
                    _G.TargetScreenY, 
                    0,  -- Botão esquerdo
                    false,  -- Soltar
                    workspace, 
                    1
                )
                
                clickCount = clickCount + 1
                
                -- Log a cada 100 cliques
                if clickCount % 100 == 0 then
                    print(string.format("[MOUSE AUTO-CLICK] %d cliques realizados", clickCount))
                end
            end
            
            -- Espera o intervalo entre cliques (50ms padrão)
            task.wait(_G.ClickCooldown)
        end
        
        print(string.format("[MOUSE AUTO-CLICK] Finalizado | Total cliques: %d | Tempo: %.1fs", 
            clickCount, tick() - startTime))
    end)
end

-- =========================
--  FAST ATTACK ARCEUS X NEO (SEU CÓDIGO ORIGINAL)
-- =========================
local CombatFramework, CombatFrameworkR, RigControllerR, CameraShaker

local function SetupFastAttack()
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
        
        local VirtualUser = game:GetService('VirtualUser')
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(500, 500))
        task.wait(0.01)
        VirtualUser:Button1Up(Vector2.new(500, 500))
    end)
end

-- =========================
--  RESTANTE DO CÓDIGO (MODIFICADO PARA USAR AMBOS SISTEMAS)
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

-- AUTO CLICK ORIGINAL (Fast Attack)
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

-- FUNÇÃO UNIFICADA PARA AMBOS OS SISTEMAS
function FarmModule.StartAllAutoClick(Toggle)
    if Toggle then
        print("[SISTEMA DUPLO] Ativando ambos os auto-clicks")
        FarmModule.StartAutoClick(true)
        FarmModule.StartMouseAutoClick(true)
    else
        print("[SISTEMA DUPLO] Desativando todos os auto-clicks")
        FarmModule.StartAutoClick(false)
        FarmModule.StartMouseAutoClick(false)
    end
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
        FarmModule.StartAllAutoClick(false)
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

                    FarmModule.StartAllAutoClick(false)
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
                    FarmModule.StartAllAutoClick(true)

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

                    FarmModule.StartAllAutoClick(false)
                    SmoothTween(data.Mob_Pos)
                    task.wait(1)
                end
            end)
        end

        FarmModule.StartAllAutoClick(false)
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

    if MouseAutoClickThread then
        task.cancel(MouseAutoClickThread)
        MouseAutoClickThread = nil
    end

    _G.AutoFarm = false
    _G.AutoClick = false
    _G.AutoClickMouseEnabled = false

    print("[FARM] Todos os sistemas parados")
end

-- FUNÇÕES DE CONFIGURAÇÃO
function FarmModule.SetMouseTarget(x, y)
    _G.TargetScreenX = x
    _G.TargetScreenY = y
    print(string.format("[CONFIG] Posição do mouse definida: X=%d, Y=%d", x, y))
end

function FarmModule.SetClickTiming(cooldown, duration)
    _G.ClickCooldown = cooldown
    _G.ClickDuration = duration
    print(string.format("[CONFIG] Timing ajustado: Cooldown=%.3fs, Duration=%.3fs", cooldown, duration))
end

-- MENU INTERATIVO
print("==============================================")
print("FARM.LUA CARREGADO COM AUTO-CLICK DE MOUSE")
print("==============================================")
print("Funções disponíveis:")
print("  FarmModule.StartFarm(true) - Iniciar farm")
print("  FarmModule.StartMouseAutoClick(true) - Apenas auto-click de mouse")
print("  FarmModule.StartAllAutoClick(true) - Ambos sistemas")
print("  FarmModule.SetMouseTarget(1720, 934) - Definir posição")
print("  FarmModule.StopAll() - Parar tudo")
print("==============================================")

return FarmModule

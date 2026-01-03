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

return FarmModule

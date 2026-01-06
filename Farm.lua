--[[ 
    FARM.LUA - FULL TEST VERSION
    Compatível: Arceus X Neo
    Auto Farm + Fast Attack + Mouse Auto Click
]]

-- =========================
-- SERVICES / PLAYER
-- =========================
local FarmModule = {}
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- =========================
-- WINDOW FOCUS (REAL)
-- =========================
local WindowIsFocused = true
UIS.WindowFocused:Connect(function()
    WindowIsFocused = true
end)
UIS.WindowFocusReleased:Connect(function()
    WindowIsFocused = false
end)

-- =========================
-- GLOBAL CONFIG
-- =========================
_G.AutoFarm = false
_G.BringMobs = true

-- Fast Attack
_G.AutoClick = false
_G.FastAttackDelay = 0.15
_G.Select_Weapon_Check = "Melee"

-- Mouse Auto Click
_G.AutoClickMouseEnabled = false
_G.ClickCooldown = 0.05
_G.ClickDuration = 0.02
_G.TargetScreenX = 1720
_G.TargetScreenY = 934

-- =========================
-- THREADS
-- =========================
local FarmThread
local FastAttackThread
local MouseClickThread

-- =========================
-- QUEST DATA (EXEMPLO SEA 1)
-- =========================
local QuestData = {
    Name = "Bandit",
    QuestName = "BanditQuest1",
    QuestID = 1,
    NPC_Pos = CFrame.new(1060, 16, 1547),
    Mob_Pos = CFrame.new(1145, 17, 1634)
}

-- =========================
-- UTIL
-- =========================
local function GetChar()
    return Player.Character
end

local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- =========================
-- WEAPON EQUIP
-- =========================
local function EquipWeapon()
    local char = GetChar()
    if not char then return false end
    if char:FindFirstChildOfClass("Tool") then return true end

    for _, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.Select_Weapon_Check then
            char.Humanoid:EquipTool(v)
            task.wait(0.1)
            return true
        end
    end
    return false
end

-- =========================
-- FAST ATTACK (CF)
-- =========================
local CombatFramework, CombatFrameworkR

local function SetupFastAttack()
    if CombatFramework then return true end
    return pcall(function()
        CombatFramework = require(Player.PlayerScripts.CombatFramework)
        CombatFrameworkR = getupvalues(CombatFramework)[2]
    end)
end

local function FastAttack()
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

    -- fallback
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(500, 500))
    task.wait(0.01)
    VirtualUser:Button1Up(Vector2.new(500, 500))
end

function FarmModule.StartFastAttack(toggle)
    _G.AutoClick = toggle

    if FastAttackThread then
        task.cancel(FastAttackThread)
        FastAttackThread = nil
    end
    if not toggle then return end

    FastAttackThread = task.spawn(function()
        while _G.AutoClick do
            task.wait(_G.FastAttackDelay)
            if EquipWeapon() then
                FastAttack()
            end
        end
    end)
end

-- =========================
-- MOUSE AUTO CLICK (PIXEL)
-- =========================
function FarmModule.StartMouseAutoClick(toggle)
    _G.AutoClickMouseEnabled = toggle

    if MouseClickThread then
        task.cancel(MouseClickThread)
        MouseClickThread = nil
    end
    if not toggle then return end

    MouseClickThread = task.spawn(function()
        while _G.AutoClickMouseEnabled do
            if WindowIsFocused then
                VirtualInputManager:SendMouseMoveEvent(
                    _G.TargetScreenX,
                    _G.TargetScreenY,
                    workspace
                )

                task.wait(0.01)

                VirtualInputManager:SendMouseButtonEvent(
                    _G.TargetScreenX,
                    _G.TargetScreenY,
                    0,
                    true,
                    workspace,
                    1
                )

                task.wait(_G.ClickDuration)

                VirtualInputManager:SendMouseButtonEvent(
                    _G.TargetScreenX,
                    _G.TargetScreenY,
                    0,
                    false,
                    workspace,
                    1
                )
            end
            task.wait(_G.ClickCooldown)
        end
    end)
end

-- =========================
-- SISTEMA INTELIGENTE
-- =========================
function FarmModule.StartAllAutoClick(toggle)
    if toggle then
        if SetupFastAttack() then
            FarmModule.StartFastAttack(true)
            FarmModule.StartMouseAutoClick(false)
        else
            FarmModule.StartFastAttack(false)
            FarmModule.StartMouseAutoClick(true)
        end
    else
        FarmModule.StartFastAttack(false)
        FarmModule.StartMouseAutoClick(false)
    end
end

-- =========================
-- TWEEN / TP
-- =========================
local function MoveTo(cf)
    local hrp = GetHRP()
    if not hrp then return end

    local dist = (hrp.Position - cf.Position).Magnitude
    if dist > 800 then
        hrp.CFrame = cf
        return
    end

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(dist / 200, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    tween:Play()
end

-- =========================
-- QUEST CHECK
-- =========================
local function HasQuest()
    local gui = Player.PlayerGui:FindFirstChild("Main")
    return gui and gui:FindFirstChild("Quest") and gui.Quest.Visible
end

-- =========================
-- MAGNET
-- =========================
local function Magnet(target)
    if not _G.BringMobs or not target then return end
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == target.Name and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
                v.HumanoidRootPart.CanCollide = false
                v.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
            end
        end
    end
end

-- =========================
-- FARM MAIN
-- =========================
function FarmModule.StartFarm(toggle)
    _G.AutoFarm = toggle

    if FarmThread then
        task.cancel(FarmThread)
        FarmThread = nil
    end

    if not toggle then
        FarmModule.StartAllAutoClick(false)
        return
    end

    FarmThread = task.spawn(function()
        while _G.AutoFarm do
            task.wait(0.3)

            if not HasQuest() then
                FarmModule.StartAllAutoClick(false)
                MoveTo(QuestData.NPC_Pos)
                task.wait(0.5)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "StartQuest",
                    QuestData.QuestName,
                    QuestData.QuestID
                )
                task.wait(1)
            end

            local enemy
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name:find(QuestData.Name) and v.Humanoid.Health > 0 then
                    enemy = v
                    break
                end
            end

            if enemy then
                FarmModule.StartAllAutoClick(true)
                repeat
                    if not enemy or enemy.Humanoid.Health <= 0 then break end
                    Magnet(enemy)
                    GetHRP().CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    task.wait(0.1)
                until not _G.AutoFarm
            else
                FarmModule.StartAllAutoClick(false)
                MoveTo(QuestData.Mob_Pos)
                task.wait(1)
            end
        end
    end)
end

-- =========================
-- STOP
-- =========================
function FarmModule.StopAll()
    if FarmThread then task.cancel(FarmThread) end
    if FastAttackThread then task.cancel(FastAttackThread) end
    if MouseClickThread then task.cancel(MouseClickThread) end

    _G.AutoFarm = false
    _G.AutoClick = false
    _G.AutoClickMouseEnabled = false
end

-- =========================
-- CONFIG
-- =========================
function FarmModule.SetMouseTarget(x, y)
    _G.TargetScreenX = x
    _G.TargetScreenY = y
end

return FarmModule

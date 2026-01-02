-- [[ PASTA: teleport.lua - MATHEUS HUB ]]
local TeleportModule = {}

-- Organização das Ilhas por Sea (Dados para os Dropdowns)
TeleportModule.Islands = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(944, 15, 10),
        ["Jungle"] = CFrame.new(-1612, 36, 147),
        ["Pirate Village"] = CFrame.new(-1181, 4, 3851),
        ["Desert"] = CFrame.new(1094, 6, 4192),
        ["Frozen Village"] = CFrame.new(1132, 5, -1150),
        ["Marineford"] = CFrame.new(-2439, 7, 3170),
        ["Skypiea"] = CFrame.new(-4835, 716, -2619),
        ["Prison"] = CFrame.new(4875, 5, 734),
        ["Magma Village"] = CFrame.new(-5245, 12, 8475)
    },
    ["Sea 2"] = {
        ["Cafe"] = CFrame.new(-382, 73, 284),
        ["Kingdom of Rose"] = CFrame.new(-451, 72, 1546),
        ["Green Bit"] = CFrame.new(-2183, 38, -2131),
        ["Graveyard"] = CFrame.new(-805, 15, -3104),
        ["Snow Mountain"] = CFrame.new(780, 403, -5263),
        ["Hot and Cold"] = CFrame.new(-2608, 15, -5126),
        ["Cursed Ship"] = CFrame.new(923, 125, 32885),
        ["Ice Castle"] = CFrame.new(6131, 30, -6443),
        ["Forgotten Island"] = CFrame.new(-3048, 239, -10188)
    },
    ["Sea 3"] = {
        ["Castle on the Sea"] = CFrame.new(-5085, 315, -3156),
        ["Port Town"] = CFrame.new(-8139, 73, -3050),
        ["Hydra Island"] = CFrame.new(5745, 602, -270),
        ["Great Tree"] = CFrame.new(2732, 10, -1140),
        ["Floating Turtle"] = CFrame.new(-13233, 431, -7647),
        ["Haunted Castle"] = CFrame.new(-9515, 164, 5786),
        ["Sea of Treats"] = CFrame.new(-13032, 12, 513)
    }
}

-- Função de Teleporte Direto com Pulo no Final
function TeleportModule.ToPos(Pos)
    local char = game.Players.LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local Distance = (Pos.Position - root.Position).Magnitude
    local Speed = 350 -- Velocidade do voo (ajuste se quiser mais rápido)
    
    local info = TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(root, info, {CFrame = Pos})
    
    -- Ativa o Noclip para não morrer em paredes durante o trajeto
    char.Humanoid:ChangeState(11) 
    tween:Play()

    -- Quando o movimento terminar, dá o pulinho de 3 studs
    tween.Completed:Connect(function()
        task.wait(0.1)
        root.CFrame = root.CFrame * CFrame.new(0, 3, 0)
        char.Humanoid:ChangeState(8) -- Volta ao estado normal
    end)
end

return TeleportModule

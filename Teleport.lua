-- [[ PASTA: Teleport.lua - MATHEUS HUB ]]
local TeleportModule = {}

-- Tabela de Coordenadas Revisadas
TeleportModule.Islands = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(1045, 16, 1420),
        ["Jungle"] = CFrame.new(-1250, 6, 330),
        ["Pirate Village"] = CFrame.new(-1120, 14, 3850),
        ["Desert"] = CFrame.new(1095, 14, 4375),
        ["Frozen Village"] = CFrame.new(1200, 28, -1350),
        ["Marineford"] = CFrame.new(-4800, 20, 4300),
        ["Skypiea"] = CFrame.new(-4850, 715, -2650),
        ["Prison"] = CFrame.new(4850, 6, 730),
        ["Magma Village"] = CFrame.new(-5250, 8, 8450)
    },
    ["Sea 2"] = {
        ["Cafe"] = CFrame.new(-380, 73, 255),
        ["Kingdom of Rose"] = CFrame.new(-450, 73, 500),
        ["Green Bit"] = CFrame.new(-2450, 73, -3000),
        ["Graveyard"] = CFrame.new(-3250, 73, -4000),
        ["Snow Mountain"] = CFrame.new(800, 400, -11000),
        ["Hot and Cold"] = CFrame.new(-6100, 15, -5000),
        ["Cursed Ship"] = CFrame.new(900, 125, 33000),
        ["Ice Castle"] = CFrame.new(6100, 28, -6200),
        ["Forgotten Island"] = CFrame.new(-3050, 235, -10200)
    },
    ["Sea 3"] = {
        ["Castle on the Sea"] = CFrame.new(-5050, 315, -3150),
        ["Port Town"] = CFrame.new(-8150, 15, 5450),
        ["Hydra Island"] = CFrame.new(5250, 600, 350),
        ["Great Tree"] = CFrame.new(2150, 10, -6500),
        ["Floating Turtle"] = CFrame.new(-13200, 530, -7600),
        ["Haunted Castle"] = CFrame.new(-9500, 140, 5500),
        ["Sea of Treats"] = CFrame.new(-1000, 15, -14000)
    }
}

-- Função de Teleporte Suave (Tween)
function TeleportModule.ToPos(targetCFrame)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local dist = (targetCFrame.p - root.Position).Magnitude
        local speed = 350 -- Velocidade ajustada para não dar kick
        
        -- Noclip durante o TP
        local noclip = game:GetService("RunService").Stepped:Connect(function()
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)

        local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
        
        tween.Completed:Connect(function()
            noclip:Disconnect()
        end)
    end
end

return TeleportModule

-- [[ PASTA: Teleport.lua - MATHEUS HUB v2026 ]]
local TeleportModule = {}
local currentTween = nil -- Variável para controlar o voo atual

TeleportModule.Islands = {
    -- (Suas coordenadas estão perfeitas, mantenha-as aqui...)
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(-1103, 15, 3838),
        ["Jungle"] = CFrame.new(-1255, 10, 310),
        ["Desert"] = CFrame.new(1094, 10, 437),
        ["Middle Town"] = CFrame.new(-650, 20, 1583),
        ["Prison"] = CFrame.new(4875, 10, 734),
        ["Magma Village"] = CFrame.new(-5241, 12, 8504),
        ["Fountain City"] = CFrame.new(5122, 65, 4105)
    },
    ["Sea 2"] = {
        ["Kingdom of Rose"] = CFrame.new(-480, 20, 720),
        ["Green Zone"] = CFrame.new(-2448, 18, -2699),
        ["Graveyard"] = CFrame.new(-5422, 15, -2630),
        ["Snow Mountain"] = CFrame.new(606, 405, -5370),
        ["Cursed Ship"] = CFrame.new(923, 130, 32853),
        ["Ice Castle"] = CFrame.new(5422, 35, -6064),
        ["Forgotten Island"] = CFrame.new(-3033, 240, -10179)
    },
    ["Sea 3"] = {
        ["Port Town"] = CFrame.new(-8670, 20, 5500),
        ["Hydra Island"] = CFrame.new(5745, 615, -270),
        ["Floating Turtle"] = CFrame.new(-13246, 335, -7625),
        ["Castle on the Sea"] = CFrame.new(-5035, 320, -3150),
        ["Haunted Castle"] = CFrame.new(-9514, 170, -8406),
        ["Tiki Outpost"] = CFrame.new(-16234, 15, 465),
        ["Submerged Island"] = CFrame.new(-19450, -240, 1230),
        ["Prehistoric Island"] = CFrame.new(-21000, 55, -5000),
        ["Christmas Island"] = CFrame.new(2315, 20, 1150)
    }
}

-- FUNÇÃO ATUALIZADA (ESTILO OPENSOURCE)
function TeleportModule.ToPos(targetCFrame, state)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- SE O TOGGLE FOR DESLIGADO NO MENU
    if state == false then
        if currentTween then
            currentTween:Cancel() -- CANCELA O VOO NA HORA
            currentTween = nil
        end
        return
    end

    -- SE O TOGGLE FOR LIGADO
    if targetCFrame then
        local dist = (targetCFrame.Position - root.Position).Magnitude
        local speed = 350 
        
        -- Cria o voo
        currentTween = game:GetService("TweenService"):Create(root, TweenInfo.new(dist/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        
        -- Noclip ativo apenas enquanto estiver voando
        local noclip = game:GetService("RunService").Stepped:Connect(function()
            if not currentTween then return end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)

        currentTween:Play()
        
        currentTween.Completed:Connect(function()
            noclip:Disconnect()
            currentTween = nil
            root.Velocity = Vector3.new(0,0,0)
        end)

        return currentTween -- Retorna o voo para o Main.lua saber quando acabou
    end
end

return TeleportModule

local TeleportModule = {}

-- [[ COORDENADAS DO MATHEUS HUB ]]
TeleportModule.Islands = {
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

-- [[ FUNÇÃO DE VOO TSUO STYLE ]]
function TeleportModule.ToPos(targetCFrame, state)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart

    -- Se state for false, CANCELA TUDO
    if state == false then
        if _G.Tweening then 
            _G.Tweening:Cancel() 
            _G.Tweening = nil
        end
        -- Remove BodyVelocity se existir (para o boneco não cair girando)
        if root:FindFirstChild("BodyVelocity") then
            root.BodyVelocity:Destroy()
        end
        _G.Teleporting = false
        return
    end

    -- Inicia o Voo
    local dist = (targetCFrame.Position - root.Position).Magnitude
    local speed = 350 -- Velocidade ajustada
    
    -- Usa BodyVelocity para sustentar o voo (melhor que só Tween)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    
    local tweenInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    _G.Tweening = game:GetService("TweenService"):Create(root, tweenInfo, {CFrame = targetCFrame})
    
    _G.Tweening:Play()

    -- Loop de Noclip para não bater em paredes
    spawn(function()
        while _G.Teleporting and _G.Tweening do
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            task.wait()
        end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
    end)
    
    return _G.Tweening
end

return TeleportModule



local TeleportModule = {}

-- [Mantenha suas coordenadas aqui em cima...]

-- FUNÇÃO AUTO FRUIT EXTRAÍDA DO TSUO
function TeleportModule.AutoCollectFruit(state)
    _G.Auto_Collect_Fruit = state
    
    spawn(function()
        while _G.Auto_Collect_Fruit do
            task.wait(0.1) -- Loop rápido para não perder o spawn
            for i, v in pairs(game.Workspace:GetChildren()) do
                -- Lógica do Tsuo: Verifica se é uma Tool e se tem "Fruit" no nome
                if v:IsA("Tool") and (string.find(v.Name, "Fruit") or string.find(v.Name, "Fruta")) then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                        -- Teleporta exatamente para a posição da fruta
                        root.CFrame = handle.CFrame
                        -- Simula o toque (essencial do opensource)
                        firetouchinterest(root, handle, 0)
                        firetouchinterest(root, handle, 1)
                        task.wait(0.5)
                    end
                end
            end
        end
    end)
end

-- [Mantenha sua função TeleportModule.ToPos aqui embaixo...]
return TeleportModule

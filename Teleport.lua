local TeleportModule = {}

-- [[ COORDENADAS DO MATHEUS HUB ]]
TeleportModule.Islands = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(973, 25, 1413),
        ["Jungle"] = CFrame.new(-1612, 50, 147),
        ["Desert"] = CFrame.new(944, 25, 4373),
        ["Middle Town"] = CFrame.new(-690, 25, 1583),
        ["Prison"] = CFrame.new(4875, 25, 734),
        ["Magma Village"] = CFrame.new(-5244, 25, 8486),
        ["Fountain City"] = CFrame.new(5127, 70, 4105)
    },
    ["Sea 2"] = {
        ["Cafe"] = CFrame.new(-382, 85, 255), -- Café Adicionado
        ["Kingdom of Rose"] = CFrame.new(-451, 85, 1727),
        ["Green Zone"] = CFrame.new(-2448, 85, -253),
        ["Graveyard"] = CFrame.new(-2322, 25, 3140),
        ["Snow Mountain"] = CFrame.new(900, 50, 4400),
        ["Cursed Ship"] = CFrame.new(923, 140, 32852),
        ["Ice Castle"] = CFrame.new(6140, 310, -6742),
        ["Forgotten Island"] = CFrame.new(-3033, 250, -10175)
    },
    ["Sea 3"] = {
        ["Mansion"] = CFrame.new(-12463, 350, -7541),
        ["Port Town"] = CFrame.new(-780, 25, 5322),
        ["Hydra Island"] = CFrame.new(5747, 630, -266),
        ["Floating Turtle"] = CFrame.new(-13274, 550, -7583),
        ["Castle on the Sea"] = CFrame.new(-5075, 330, -3153),
        ["Haunted Castle"] = CFrame.new(-9547, 180, 5532),
        ["Tiki Outpost"] = CFrame.new(-16234, 25, 485)
    }
}

-- [[ FUNÇÃO DE VOO TSUO STYLE ]]
function TeleportModule.ToPos(targetCFrame, state)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if state == false then
        if _G.Tweening then _G.Tweening:Cancel() _G.Tweening = nil end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
        _G.Teleporting = false
        return
    end

    local dist = (targetCFrame.Position - root.Position).Magnitude
    local speed = 350 
    
    local bv = root:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = root
    
    _G.Teleporting = true
    _G.Tweening = game:GetService("TweenService"):Create(root, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    _G.Tweening:Play()

    spawn(function()
        while _G.Teleporting and _G.Tweening do
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            task.wait()
        end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
    end)
end

return TeleportModule


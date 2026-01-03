local TeleportModule = {}

-- [[ TABELA DE ILHAS COMPLETA - ESTILO HOHO/TSUO ]]
TeleportModule.Islands = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(973, 16, 1413),
        ["Jungle"] = CFrame.new(-1612, 37, 147),
        ["Desert"] = CFrame.new(944, 16, 4373),
        ["Middle Town"] = CFrame.new(-690, 15, 1583),
        ["Frozen Village"] = CFrame.new(1129, 5, -1149),
        ["Marineford"] = CFrame.new(-5029, 28, 4310),
        ["Skypiea"] = CFrame.new(-4839, 717, -2622),
        ["Prison"] = CFrame.new(4875, 16, 734),
        ["Magma Village"] = CFrame.new(-5244, 12, 8486),
        ["Fountain City"] = CFrame.new(5127, 59, 4105)
    },
    ["Sea 2"] = {
        ["Cafe"] = CFrame.new(-382, 73, 255),
        ["Kingdom of Rose"] = CFrame.new(-451, 73, 1727),
        ["Green Zone"] = CFrame.new(-2448, 73, -253),
        ["Graveyard"] = CFrame.new(-2322, 10, 3140),
        ["Snow Mountain"] = CFrame.new(900, 40, 4400),
        ["Hot and Cold"] = CFrame.new(-6062, 16, -5003),
        ["Cursed Ship"] = CFrame.new(923, 125, 32852),
        ["Ice Castle"] = CFrame.new(6140, 294, -6742),
        ["Forgotten Island"] = CFrame.new(-3033, 235, -10175),
        ["Dark Arena"] = CFrame.new(3776, 15, -3498)
    },
    ["Sea 3"] = {
        ["Mansion"] = CFrame.new(-12463, 332, -7541),
        ["Port Town"] = CFrame.new(-780, 15, 5322),
        ["Hydra Island"] = CFrame.new(5747, 613, -266),
        ["Floating Turtle"] = CFrame.new(-13274, 531, -7583),
        ["Castle on the Sea"] = CFrame.new(-5075, 314, -3153),
        ["Haunted Castle"] = CFrame.new(-9547, 164, 5532),
        ["Sea of Treats"] = CFrame.new(-9510, 164, -14150),
        ["Tiki Outpost"] = CFrame.new(-16234, 12, 485)
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


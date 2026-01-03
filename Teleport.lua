local TeleportModule = {}

-- [[ COORDENADAS QUE VOCÊ ENCONTROU ]]
TeleportModule.Islands = {
    ["Sea 1"] = {
        ["WindMill"] = CFrame.new(979.79, 16.51, 1429.04),
        ["Marine"] = CFrame.new(-2566.42, 6.85, 2045.25),
        ["Middle Town"] = CFrame.new(-690.33, 15.09, 1582.23),
        ["Jungle"] = CFrame.new(-1612.79, 36.85, 149.12),
        ["Pirate Village"] = CFrame.new(-1181.30, 4.75, 3803.54),
        ["Desert"] = CFrame.new(944.15, 20.91, 4373.30),
        ["Snow Island"] = CFrame.new(1347.80, 104.66, -1319.73),
        ["MarineFord"] = CFrame.new(-4914.82, 50.96, 4281.02),
        ["Colosseum"] = CFrame.new(-1427.62, 7.28, -2792.77),
        ["Sky Island 1"] = CFrame.new(-4869.10, 733.46, -2667.01),
        ["Prison"] = CFrame.new(4875.33, 5.65, 734.85),
        ["Magma Village"] = CFrame.new(-5247.71, 12.88, 8504.96),
        ["Fountain City"] = CFrame.new(5127.12, 59.50, 4105.44),
        ["Shank Room"] = CFrame.new(-1442.16, 29.87, -28.35),
        ["Mob Island"] = CFrame.new(-2850.20, 7.39, 5354.99)
    },
    ["Sea 2"] = {
        ["The Cafe"] = CFrame.new(-380.47, 77.22, 255.82),
        ["Frist Spot"] = CFrame.new(-11.31, 29.27, 2771.52),
        ["Dark Area"] = CFrame.new(3780.03, 22.65, -3498.58),
        ["Flamingo Mansion"] = CFrame.new(-483.73, 332.03, 595.32),
        ["Flamingo Room"] = CFrame.new(2284.41, 15.15, 875.72),
        ["Green Zone"] = CFrame.new(-2448.53, 73.01, -3210.63),
        ["Factory"] = CFrame.new(424.12, 211.16, -427.54),
        ["Colossuim"] = CFrame.new(-1503.62, 219.79, 1369.31),
        ["Zombie Island"] = CFrame.new(-5622.03, 492.19, -781.78),
        ["Two Snow Mountain"] = CFrame.new(753.14, 408.23, -5274.61),
        ["Punk Hazard"] = CFrame.new(-6127.65, 15.95, -5040.28),
        ["Cursed Ship"] = CFrame.new(923.40, 125.05, 32885.87),
        ["Ice Castle"] = CFrame.new(6148.41, 294.38, -6741.11),
        ["Forgotten Island"] = CFrame.new(-3032.76, 317.89, -10075.37),
        ["Ussop Island"] = CFrame.new(4816.86, 8.45, 2863.81)
    },
    ["Sea 3"] = {
        ["Port Town"] = CFrame.new(-290.73, 6.72, 5343.55),
        ["Hydra Island"] = CFrame.new(5228.88, 604.23, 345.04),
        ["Floating Turtle"] = CFrame.new(-13274.52, 531.82, -7579.22),
        ["Mansion"] = CFrame.new(-12471.16, 374.94, -7551.67),
        ["Haunted Castle"] = CFrame.new(-9515.37, 164.00, 5786.06),
        ["Ice Cream Island"] = CFrame.new(-902.56, 79.93, -10988.84),
        ["Peanut Island"] = CFrame.new(-2062.74, 50.47, -10232.56),
        ["Cake Island"] = CFrame.new(-1884.77, 19.32, -11666.89),
        ["Cocoa Island"] = CFrame.new(87.94, 73.55, -12319.46),
        ["Candy Island"] = CFrame.new(-1014.42, 149.11, -14555.96),
        ["Tiki Outpost"] = CFrame.new(-16101.18, 12.84, 380.94)
    }
}

-- [[ FUNÇÃO DE VOO (TOPOS) ]]
function TeleportModule.ToPos(targetCFrame, state)
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if state == false then
        if _G.Tweening then _G.Tweening:Cancel() end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
        _G.Teleporting = false
        return
    end

    _G.Teleporting = true
    local bv = root:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)

    local dist = (targetCFrame.Position - root.Position).Magnitude
    _G.Tweening = game:GetService("TweenService"):Create(root, TweenInfo.new(dist/350, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    _G.Tweening:Play()
    
    task.spawn(function()
        while _G.Teleporting do
            pcall(function()
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
            task.wait()
        end
    end)
end

return TeleportModule


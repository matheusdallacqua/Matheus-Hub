-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ COLETOR TSUO 2026 ]]
function FruitModule.AutoCollectFruit(state)
    _G.Auto_Collect_Fruit = state
    spawn(function()
        while _G.Auto_Collect_Fruit do
            task.wait(0.1)
            for _, v in pairs(game.Workspace:GetChildren()) do
                -- Detecção por nome e atributo (segurança 2026)
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta") or v:GetAttribute("Fruit")) then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if handle and root then
                        root.CFrame = handle.CFrame
                        firetouchinterest(root, handle, 0)
                        firetouchinterest(root, handle, 1)
                        task.wait(0.5)
                    end
                end
            end
        end
    end)
end

-- [[ AUTO STORE TSUO ]]
function FruitModule.AutoStoreFruit(state)
    _G.AutoStore = state
    spawn(function()
        while _G.AutoStore do
            task.wait(2)
            local char = game.Players.LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool and (tool.Name:find("Fruit") or tool:GetAttribute("FruitName")) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", tool:GetAttribute("FruitName") or tool.Name, tool)
            end
        end
    end)
end

-- [[ GACHA ]]
function FruitModule.BuyGacha()
    return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "BuyItem")
end

return FruitModule

-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- [[ AUTO COLLECT - SCANNER DO TSUO ]]
function FruitModule.AutoCollectFruit(state)
    _G.Auto_Collect_Fruit = state
    spawn(function()
        while _G.Auto_Collect_Fruit do
            task.wait(0.1) 
            for i, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- TP e Coleta Instantânea
                            char.HumanoidRootPart.CFrame = handle.CFrame
                            firetouchinterest(char.HumanoidRootPart, handle, 0)
                            firetouchinterest(char.HumanoidRootPart, handle, 1)
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end)
end

-- [[ AUTO STORE - LOGICA DO TSUO ]]
function FruitModule.AutoStoreFruit(state)
    _G.AutoStore = state
    spawn(function()
        while _G.AutoStore do
            task.wait(2)
            local char = game.Players.LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and string.find(tool.Name, "Fruit") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", tool:GetAttribute("FruitName"), tool)
                end
            end
        end
    end)
end

-- [[ GACHA - REMOTOS DO TSUO ]]
function FruitModule.BuyGacha()
    return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "BuyItem")
end

return FruitModule

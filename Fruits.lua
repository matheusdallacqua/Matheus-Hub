--- [[ FRUITS.LUA - MATHEUS HUB ]]
local FruitsModule = {}

-- FUNÇÃO GACHA (O QUE VOCÊ PEGOU ANTES)
function FruitsModule.BuyGacha()
    pcall(function()
        game:GetService("ReplicatedStorage").Modules.Net["RF/GachaUtilRF"]:InvokeServer({
            ["Context"] = "getGachaFromBoxName",
            ["BoxName"] = "SummerWeek5Gacha"
        })
    end)
end

-- FUNÇÃO STORE (O QUE VOCÊ PEGOU AGORA)
function FruitsModule.AutoStore()
    pcall(function()
        -- Procura na mochila (Backpack)
        for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and (v:GetAttribute("Fruit") or v.Name:find("Fruit")) then
                local fruitName = v:GetAttribute("FruitName") or v.Name:split("-")[1] or v.Name
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName, v)
            end
        end
        -- Procura no personagem (Character - mão)
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") and (v:GetAttribute("Fruit") or v.Name:find("Fruit")) then
                local fruitName = v:GetAttribute("FruitName") or v.Name:split("-")[1] or v.Name
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName, v)
            end
        end
    end)
end

return FruitsModule


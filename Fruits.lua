-- [[ PASTA: Fruit.lua - MATHEUS HUB ]]
local FruitModule = {}

-- Função para Teleportar até a Fruta mais próxima no chão
function FruitModule.TeleportToFruit()
    local character = game.Players.LocalPlayer.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local targetFruit = nil
    
    -- Procura no Workspace por itens que sejam frutas
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
            targetFruit = v
            break
        end
    end

    if targetFruit and targetFruit:FindFirstChild("Handle") then
        Rayfield:Notify({Title = "Fruit Finder", Content = "Fruta encontrada! Teleportando...", Duration = 3})
        
        -- Usa a lógica de movimento (Tween)
        local Pos = targetFruit.Handle.CFrame
        local Distance = (Pos.Position - root.Position).Magnitude
        local Speed = 300
        
        local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Pos})
        character.Humanoid:ChangeState(11) -- Noclip
        tween:Play()
        
        tween.Completed:Connect(function()
            character.Humanoid:ChangeState(8)
            root.CFrame = root.CFrame * CFrame.new(0, 3, 0) -- Pulo de segurança
        end)
    else
        Rayfield:Notify({Title = "Aviso", Content = "Nenhuma fruta encontrada no chão deste servidor.", Duration = 3})
    end
end

-- Função de Gacha (Comprar fruta aleatória)
function FruitModule.BuyGacha()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end

return FruitModule

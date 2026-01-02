-- [[ PASTA: Fruits.lua - MATHEUS HUB COMPLEX EDITION ]]
local FruitModule = {}

-- Configurações Internas
local Services = {
    Workspace = game:GetService("Workspace"),
    Players = game:GetService("Players"),
    RS = game:GetService("ReplicatedStorage"),
    Tween = game:GetService("TweenService")
}

local LocalPlayer = Services.Players.LocalPlayer

-- Função Profissional de Teleporte (Tween com Noclip)
local function SecureMove(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = character.HumanoidRootPart
    local distance = (targetCFrame.Position - root.Position).Magnitude
    local speed = 300 -- Velocidade segura para evitar kick
    
    -- Ativa Noclip para não morrer ou bugar em paredes
    local noclipLoop = game:GetService("RunService").Stepped:Connect(function()
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)

    local tween = Services.Tween:Create(root, TweenInfo.new(distance/speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    
    tween.Completed:Connect(function()
        noclipLoop:Disconnect()
        root.CFrame = root.CFrame * CFrame.new(0, 3, 0) -- Pulo de segurança ao chegar
    end)
end

-- [[ FUNÇÃO: TELEPORT FRUIT ]]
function FruitModule.TeleportToFruit(state)
    if not state then return end
    
    local fruitFound = nil
    
    -- Procura avançada por frutas (suporta nomes em PT e EN)
    for _, item in pairs(Services.Workspace:GetChildren()) do
        if item:IsA("Tool") and (item.Name:find("Fruit") or item.Name:find("Fruta")) then
            fruitFound = item
            break
        end
    end
    
    if fruitFound and fruitFound:FindFirstChild("Handle") then
        -- Notificação estilo profissional
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Matheus Hub",
            Text = "Fruta detetada: " .. fruitFound.Name .. ". Iniciando TP...",
            Duration = 5
        })
        SecureMove(fruitFound.Handle.CFrame)
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Aviso",
            Text = "Nenhuma fruta encontrada no chão.",
            Duration = 5
        })
    end
end

-- [[ FUNÇÃO: GACHA AUTOMÁTICO ]]
function FruitModule.BuyGacha(state)
    if not state then return end
    
    -- Tenta comprar a fruta via Remote
    local result = Services.RS.Remotes.CommF_:InvokeServer("Cousin", "Buy")
    
    -- Se o resultado for uma tabela ou string, podemos tratar a resposta aqui
    if result then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Gacha Result",
            Text = "Verifica o teu inventário!",
            Duration = 5
        })
    end
end

return FruitModule

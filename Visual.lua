-- [[ PASTA: Visuals.lua - MATHEUS HUB ]]
local VisualsModule = {}

-- [[ ESP DE PLAYERS ]]
function VisualsModule.PlayerESP(state)
    _G.PlayerESP = state
    task.spawn(function()
        while _G.PlayerESP do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character.HumanoidRootPart:FindFirstChild("ESP_Label") then
                        local bill = Instance.new("BillboardGui", v.Character.HumanoidRootPart)
                        bill.Name = "ESP_Label"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        local lab = Instance.new("TextLabel", bill)
                        lab.Size = UDim2.new(1, 0, 1, 0)
                        lab.BackgroundTransparency = 1
                        lab.TextColor3 = Color3.fromRGB(0, 255, 0) -- ALTERADO PARA VERDE
                        lab.Font = Enum.Font.GothamBold
                        lab.TextSize = 14
                        lab.TextStrokeTransparency = 0 
                        task.spawn(function()
                            while v.Character and v.Character:FindFirstChild("HumanoidRootPart") and _G.PlayerESP do
                                local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    local dist = math.floor((root.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                                    lab.Text = v.Name .. " [" .. dist .. "m]"
                                end
                                task.wait(0.3)
                            end
                            if bill then bill:Destroy() end
                        end)
                    end
                end
            end
            task.wait(2)
        end
    end)
end

-- [[ ESP DE FRUTAS 2026 ]]
function VisualsModule.FruitESP(state)
    _G.FruitESP = state
    task.spawn(function()
        while _G.FruitESP do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta") or v:GetAttribute("Fruit")) then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                    if handle and not handle:FindFirstChild("FruitLabel") then
                        local bill = Instance.new("BillboardGui", handle)
                        bill.Name = "FruitLabel"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        local lab = Instance.new("TextLabel", bill)
                        lab.Size = UDim2.new(1, 0, 1, 0)
                        lab.BackgroundTransparency = 1
                        lab.TextColor3 = Color3.fromRGB(255, 0, 0) -- ALTERADO PARA VERMELHO
                        lab.Font = Enum.Font.GothamBold
                        lab.TextSize = 14
                        lab.TextStrokeTransparency = 0 
                        task.spawn(function()
                            while v.Parent == game.Workspace and _G.FruitESP do
                                local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root then
                                    local dist = math.floor((root.Position - handle.Position).Magnitude)
                                    lab.Text = "🍎 " .. v.Name .. " [" .. dist .. "m]"
                                end
                                task.wait(0.3)
                            end
                            if bill then bill:Destroy() end
                        end)
                    end
                end
            end
            task.wait(2)
        end
    end)
end

-- [[ SNIPER DE STOCK ATUALIZADO (CONTROL 9M) ]]
function VisualsModule.GetStock()
    local success, stock = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end)
    if success and type(stock) == "table" then
        local text = ""
        for _, v in pairs(stock) do
            if v.OnSale then
                local prefix = "⚪"
                if v.Price >= 9000000 then prefix = "💎 [CONTROL/RARE]" 
                elseif v.Price >= 5000000 then prefix = "🔥 [MYTHIC]"
                elseif v.Price >= 1000000 then prefix = "🟣 [LEGEND]" end
                text = text .. prefix .. " " .. v.Name .. " | "
            end
        end
        return text ~= "" and text or "Estoque mudando..."
    end
    return "Erro ao ler Dealer"
end

return VisualsModule

-- [[ PASTA: Visuals.lua - MATHEUS HUB ]]
local VisualsModule = {}

-- ESP de Jogadores
function VisualsModule.PlayerESP(state)
    _G.PlayerESP = state
    task.spawn(function()
        while _G.PlayerESP do
            for i, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character.HumanoidRootPart:FindFirstChild("ESP_Label") then
                        local bill = Instance.new("BillboardGui", v.Character.HumanoidRootPart)
                        bill.Name = "ESP_Label"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        
                        local lab = Instance.new("TextLabel", bill)
                        lab.Size = UDim2.new(1, 0, 1, 0)
                        lab.BackgroundTransparency = 1
                        lab.TextColor3 = Color3.new(1, 0, 0) -- Cor Vermelha
                        lab.TextStrokeTransparency = 0
                        lab.Font = Enum.Font.GothamBold
                        lab.TextSize = 14
                        
                        task.spawn(function()
                            while v.Character and v.Character:FindFirstChild("HumanoidRootPart") and _G.PlayerESP do
                                local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                                lab.Text = v.Name .. " [" .. dist .. "m]"
                                task.wait(0.5)
                            end
                            bill:Destroy()
                        end)
                    end
                end
            end
            task.wait(2)
        end
    end)
end

-- ESP de Frutas no Chão
function VisualsModule.FruitESP(state)
    _G.FruitESP = state
    task.spawn(function()
        while _G.FruitESP do
            for i, v in pairs(game.Workspace:GetChildren()) do
                if v:IsA("Tool") or v:IsA("Model") then
                    if v:FindFirstChild("Handle") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
                        if not v.Handle:FindFirstChild("FruitLabel") then
                            local bill = Instance.new("BillboardGui", v.Handle)
                            bill.Name = "FruitLabel"
                            bill.AlwaysOnTop = true
                            bill.Size = UDim2.new(1, 200, 1, 30)
                            local lab = Instance.new("TextLabel", bill)
                            lab.Size = UDim2.new(1, 0, 1, 0)
                            lab.BackgroundTransparency = 1
                            lab.TextColor3 = Color3.new(0, 1, 0) -- Cor Verde
                            lab.Text = "[FRUTA] " .. v.Name
                            lab.Font = Enum.Font.GothamBold
                            lab.TextSize = 14
                        end
                    end
                end
            end
            task.wait(5)
        end
    end)
end

return VisualsModule

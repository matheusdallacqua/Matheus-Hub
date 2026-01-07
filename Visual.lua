-- [[ VISUAL.LUA - MATHEUS HUB 2026 (COMPLETO E CORRETO) ]]
local VisualsModule = {}
local Player = game.Players.LocalPlayer

-- === LISTA COMPLETA 2026 ===
local FruitNames2026 = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb",
    "Smoke-Smoke", "Spike-Spike", "Flame-Flame", "Ice-Ice", "Sand-Sand",
    "Dark-Dark", "Eagle-Eagle", "Diamond-Diamond", "Light-Light", "Rubber-Rubber",
    "Ghost-Ghost", "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
    "Creation-Creation", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix",
    "Portal-Portal", "Lightining-Lightning", "Blizzard-Blizzard", "Gravity-Gravity",
    "Mammoth-Mammoth", "T-Rex-T-Rex", "Dough-Dough", "Shadow-Shadow", "Venom-Venom",
    "Gas-Gas", "Spirit-Spirit", "Tiger-Tiger", "Yeti-Yeti", "Kitsune-Kitsune",
    "Control-Control", "Dragon-Dragon"
}

-- === TABELA DE MÍTICAS 2026 ===
local MythicalFruits = {
    ["Gravity-Gravity"] = true,
    ["Mammoth-Mammoth"] = true,
    ["T-Rex-T-Rex"] = true,
    ["Dough-Dough"] = true,
    ["Shadow-Shadow"] = true,
    ["Venom-Venom"] = true,
    ["Gas-Gas"] = true,
    ["Spirit-Spirit"] = true,
    ["Tiger-Tiger"] = true,
    ["Yeti-Yeti"] = true,
    ["Kitsune-Kitsune"] = true,
    ["Control-Control"] = true,
    ["Dragon-Dragon"] = true
}

-- === TABELA DE RARIDADES E CORES ===
local FruitColors = {
    -- (Branco)
    ["Rocket-Rocket"] = Color3.fromRGB(255, 255, 255),
    ["Spin-Spin"] = Color3.fromRGB(255, 255, 255),
    ["Blade-Blade"] = Color3.fromRGB(255, 255, 255),
    ["Spring-Spring"] = Color3.fromRGB(255, 255, 255),
    ["Bomb-Bomb"] = Color3.fromRGB(255, 255, 255),
    
    -- (Azul Claro)
    ["Smoke-Smoke"] = Color3.fromRGB(100, 200, 255),
    ["Spike-Spike"] = Color3.fromRGB(100, 200, 255),
    ["Flame-Flame"] = Color3.fromRGB(255, 100, 100),
    ["Ice-Ice"] = Color3.fromRGB(100, 200, 255),
    ["Sand-Sand"] = Color3.fromRGB(255, 200, 100),
    ["Dark-Dark"] = Color3.fromRGB(100, 100, 100),
    ["Eagle-Eagle"] = Color3.fromRGB(100, 200, 255),
    ["Diamond-Diamond"] = Color3.fromRGB(100, 200, 255),
    ["Light-Light"] = Color3.fromRGB(255, 255, 150),
    ["Rubber-Rubber"] = Color3.fromRGB(100, 200, 255),
    
    -- (Roxo)
    ["Ghost-Ghost"] = Color3.fromRGB(150, 0, 255),
    ["Magma-Magma"] = Color3.fromRGB(255, 100, 0),
    ["Quake-Quake"] = Color3.fromRGB(150, 0, 255),
    ["Buddha-Buddha"] = Color3.fromRGB(255, 215, 0),
    ["Love-Love"] = Color3.fromRGB(255, 100, 200),
    ["Creation-Creation"] = Color3.fromRGB(150, 0, 255),
    ["Spider-Spider"] = Color3.fromRGB(150, 0, 255),
    ["Sound-Sound"] = Color3.fromRGB(150, 0, 255),
    ["Phoenix-Phoenix"] = Color3.fromRGB(255, 100, 0),
    ["Portal-Portal"] = Color3.fromRGB(150, 0, 255),
    ["Lightining-Lightning"] = Color3.fromRGB(255, 255, 100),
    ["Blizzard-Blizzard"] = Color3.fromRGB(100, 200, 255),
    
    -- (Dourado)
    ["Gravity-Gravity"] = Color3.fromRGB(255, 215, 0),
    ["Mammoth-Mammoth"] = Color3.fromRGB(255, 215, 0),
    ["T-Rex-T-Rex"] = Color3.fromRGB(255, 215, 0),
    ["Dough-Dough"] = Color3.fromRGB(255, 215, 0),
    ["Shadow-Shadow"] = Color3.fromRGB(255, 215, 0),
    ["Venom-Venom"] = Color3.fromRGB(255, 215, 0),
    ["Gas-Gas"] = Color3.fromRGB(255, 215, 0),
    ["Spirit-Spirit"] = Color3.fromRGB(255, 215, 0),
    ["Tiger-Tiger"] = Color3.fromRGB(255, 215, 0),
    ["Yeti-Yeti"] = Color3.fromRGB(255, 215, 0),
    ["Kitsune-Kitsune"] = Color3.fromRGB(255, 215, 0),
    ["Control-Control"] = Color3.fromRGB(255, 215, 0),
    ["Dragon-Dragon"] = Color3.fromRGB(255, 215, 0)
}

-- === SISTEMA DE ESP ===
local FruitESPInstances = {}
local PlayerESPInstances = {}

function VisualsModule.CleanFruitESP()
    for _, inst in pairs(FruitESPInstances) do
        if inst and inst.Parent then
            inst:Destroy()
        end
    end
    FruitESPInstances = {}
end

function VisualsModule.CleanPlayerESP()
    for _, inst in pairs(PlayerESPInstances) do
        if inst and inst.Parent then
            inst:Destroy()
        end
    end
    PlayerESPInstances = {}
end

-- === FRUIT ESP (COMPLETO) ===
function VisualsModule.FruitESP(state)
    _G.FruitESP = state
    
    if not state then
        VisualsModule.CleanFruitESP()
        return
    end
    
    task.spawn(function()
        while _G.FruitESP do
            pcall(function()
                local Workspace = game:GetService("Workspace")
                
                -- Procura por frutas dropadas no Workspace
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Tool") then
                        local isFruit = v.Name:find("Fruit") or v.Name:find("Fruta") or v:GetAttribute("Fruit")
                        
                        if isFruit then
                            local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                            if handle and not handle:FindFirstChild("FruitLabel") then
                                
                                -- Detecta o nome real da fruta
                                local detectedName = "Unknown Fruit"
                                local isMythical = false
                                local fruitColor = Color3.fromRGB(255, 255, 255) -- Default branco
                                
                                for _, fName in pairs(FruitNames2026) do
                                    if v.Name:find(fName:split("-")[1]) then
                                        detectedName = fName
                                        isMythical = MythicalFruits[fName] or false
                                        fruitColor = FruitColors[fName] or Color3.fromRGB(255, 255, 255)
                                        break
                                    end
                                end
                                
                                -- Cria o ESP
                                local bill = Instance.new("BillboardGui", handle)
                                bill.Name = "FruitLabel"
                                bill.AlwaysOnTop = true
                                bill.Size = UDim2.new(0, 200, 0, 50)
                                bill.Adornee = handle
                                bill.MaxDistance = 100000000
                                
                                local lab = Instance.new("TextLabel", bill)
                                lab.Size = UDim2.new(1, 0, 1, 0)
                                lab.BackgroundTransparency = 1
                                lab.Font = Enum.Font.GothamBold
                                lab.TextSize = 14
                                lab.TextStrokeTransparency = 0
                                lab.TextColor3 = fruitColor
                                
                                table.insert(FruitESPInstances, bill)
                                
                                -- Thread para atualizar distância
                                task.spawn(function()
                                    while v and v.Parent and _G.FruitESP do
                                        pcall(function()
                                            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                                            if root and handle.Parent then
                                                local dist = math.floor((root.Position - handle.Position).Magnitude)
                                                local prefix = isMythical and "💎 " or "🍎 "
                                                lab.Text = prefix .. detectedName .. "\n[" .. dist .. "m]"
                                            end
                                        end)
                                        task.wait(0.5)
                                    end
                                    
                                    -- Limpa quando a fruta desaparece
                                    if bill and bill.Parent then
                                        bill:Destroy()
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
            
            -- Limpa ESPs de frutas que não existem mais
            for i = #FruitESPInstances, 1, -1 do
                local esp = FruitESPInstances[i]
                if not esp or not esp.Parent or esp.Parent.Parent == nil then
                    table.remove(FruitESPInstances, i)
                end
            end
            
            task.wait(2) -- Verifica a cada 2 segundos
        end
        
        -- Limpa tudo quando desativa
        VisualsModule.CleanFruitESP()
    end)
end

-- === PLAYER ESP (COMPLETO) ===
function VisualsModule.PlayerESP(state)
    _G.PlayerESP = state
    
    if not state then
        VisualsModule.CleanPlayerESP()
        return
    end
    
    task.spawn(function()
        while _G.PlayerESP do
            pcall(function()
                local Players = game:GetService("Players")
                
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player and plr.Character then
                        local humanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                        local humanoid = plr.Character:FindFirstChild("Humanoid")
                        
                        if humanoidRootPart and humanoid then
                            -- Verifica se já tem ESP
                            if not humanoidRootPart:FindFirstChild("PlayerESP") then
                                
                                -- Cria a caixa (Box)
                                local box = Instance.new("BoxHandleAdornment", humanoidRootPart)
                                box.Name = "PlayerESP"
                                box.Adornee = humanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Size = Vector3.new(4, 6, 4)
                                box.Color3 = plr.Team == Player.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                                box.Transparency = 0.5
                                
                                -- Cria o texto com nome e nível
                                local bill = Instance.new("BillboardGui", humanoidRootPart)
                                bill.Name = "PlayerNameTag"
                                bill.Size = UDim2.new(0, 200, 0, 50)
                                bill.Adornee = humanoidRootPart
                                bill.AlwaysOnTop = true
                                bill.MaxDistance = 500000
                                
                                local textLabel = Instance.new("TextLabel", bill)
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.Text = plr.Name
                                textLabel.TextColor3 = plr.Team == Player.Team and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextSize = 14
                                textLabel.TextStrokeTransparency = 0
                                
                                table.insert(PlayerESPInstances, box)
                                table.insert(PlayerESPInstances, bill)
                                
                                -- Atualiza informações
                                task.spawn(function()
                                    while plr and plr.Parent and humanoidRootPart and humanoidRootPart.Parent and _G.PlayerESP do
                                        pcall(function()
                                            -- Tenta pegar o nível do jogador
                                            local level = "??"
                                            if plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Level") then
                                                level = tostring(plr.Data.Level.Value)
                                            end
                                            
                                            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                                            textLabel.Text = plr.Name .. " [Lv. " .. level .. "]\n" .. healthPercent .. "% HP"
                                            
                                            -- Atualiza cor baseada na saúde
                                            if plr.Team ~= Player.Team then
                                                if healthPercent > 75 then
                                                    box.Color3 = Color3.fromRGB(255, 0, 0)
                                                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                                elseif healthPercent > 25 then
                                                    box.Color3 = Color3.fromRGB(255, 165, 0)
                                                    textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                                                else
                                                    box.Color3 = Color3.fromRGB(0, 255, 0)
                                                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                                end
                                            end
                                        end)
                                        task.wait(1)
                                    end
                                    
                                    -- Limpa quando o jogador sai
                                    if box and box.Parent then box:Destroy() end
                                    if bill and bill.Parent then bill:Destroy() end
                                end)
                            end
                        end
                    end
                end
            end)
            
            -- Limpa ESPs de jogadores que saíram
            for i = #PlayerESPInstances, 1, -1 do
                local esp = PlayerESPInstances[i]
                if not esp or not esp.Parent or esp.Parent.Parent == nil then
                    table.remove(PlayerESPInstances, i)
                end
            end
            
            task.wait(3) -- Atualiza a cada 3 segundos
        end
        
        -- Limpa tudo quando desativa
        VisualsModule.CleanPlayerESP()
    end)
end

return VisualsModule

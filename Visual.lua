-- [[ MATHEUS HUB - VISUALS MODULE 2026 ]]
local VisualsModule = {}
local Player = game.Players.LocalPlayer

-- 1. LISTA COMPLETA 2026 (Para identificação)
local FruitNames2026 = {
    "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring", "Bomb-Bomb", 
    "Smoke-Smoke", "Spike-Spike", "Flame-Flame", "Ice-Ice", "Sand-Sand", 
    "Dark-Dark", "Eagle-Eagle", "Diamond-Diamond", "Light-Light", "Rubber-Rubber", 
    "Ghost-Ghost", "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love", 
    "Creation-Creation", "Spider-Spider", "Sound-Sound", "Fenix-Fenix", 
    "Portal-Portal", "Lightining-Lightning", "Blizzard-Blizzard", "Gravity-Gravity", 
    "Mammoth-Mammoth", "T-Rex-T-Rex", "Dough-Dough", "Shadow-Shadow", "Venom-Venom", 
    "Gas-Gas", "Spirit-Spirit", "Tiger-Tiger", "Yeti-Yeti", "Kitsune-Kitsune", 
    "Control-Control", "Dragon-Dragon"
}

-- 2. TABELA DE MÍTICAS (PARA COR DOURADA) - De Gravity até Dragon
local MythicalFruits = {
    ["Gravity-Gravity"] = true, ["Mammoth-Mammoth"] = true, ["T-Rex-T-Rex"] = true, 
    ["Dough-Dough"] = true, ["Shadow-Shadow"] = true, ["Venom-Venom"] = true, 
    ["Gas-Gas"] = true, ["Spirit-Spirit"] = true, ["Tiger-Tiger"] = true, 
    ["Yeti-Yeti"] = true, ["Kitsune-Kitsune"] = true, ["Control-Control"] = true, 
    ["Dragon-Dragon"] = true
}

-- 3. FUNÇÃO DE ESP DE FRUTAS
function VisualsModule.FruitESP(state)
    _G.FruitESP = state
    
    task.spawn(function()
        while _G.FruitESP do
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta") or v:GetAttribute("Fruit")) then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                    if handle and not handle:FindFirstChild("FruitLabel") then
                        
                        local detectedName = v.Name
                        local isMythical = false

                        -- Busca o nome real na lista 2026
                        for _, fName in pairs(FruitNames2026) do
                            if v.Name:find(fName:split("-")[1]) then
                                detectedName = fName
                                if MythicalFruits[fName] then
                                    isMythical = true
                                end
                                break
                            end
                        end

                        local bill = Instance.new("BillboardGui", handle)
                        bill.Name = "FruitLabel"
                        bill.AlwaysOnTop = true
                        bill.Size = UDim2.new(0, 200, 0, 50)
                        bill.Adornee = handle
                        
                        local lab = Instance.new("TextLabel", bill)
                        lab.Size = UDim2.new(1, 0, 1, 0)
                        lab.BackgroundTransparency = 1
                        lab.Font = Enum.Font.GothamBold
                        lab.TextSize = 14
                        lab.TextStrokeTransparency = 0 
                        
                        -- Aplica a Cor Dourada para Míticas e Branco para as outras
                        if isMythical then
                            lab.TextColor3 = Color3.fromRGB(255, 215, 0) -- Dourado
                        else
                            lab.TextColor3 = Color3.fromRGB(255, 255, 255) -- Branco
                        end

                        task.spawn(function()
                            while v and v.Parent and _G.FruitESP do
                                local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                                if root and handle.Parent then
                                    local dist = math.floor((root.Position - handle.Position).Magnitude)
                                    local prefix = isMythical and "💎 [MÍTICA] " or "🍎 "
                                    lab.Text = prefix .. detectedName .. "\n[" .. dist .. "m]"
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

return VisualsModule

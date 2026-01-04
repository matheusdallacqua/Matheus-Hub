-- [[ FRUITS.LUA - MATHEUS HUB UPDATE 2026 ]]
local FruitsModule = {}
local Player = game.Players.LocalPlayer

-- === LISTA OFICIAL QUE VOCÊ MANDOU ===
FruitsModule.FruitList = {
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

-- === FUNÇÃO GACHA ATUALIZADA (MÉTODO TURTLE SPY + FALLBACK) ===
function FruitsModule.BuyGacha()
    pcall(function()
        -- Tenta o método do Turtle Spy que você pegou
        local GachaModule = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/GachaUtilRF")
        if GachaModule then
            GachaModule:InvokeServer({
                ["Context"] = "getGachaFromBoxName",
                ["BoxName"] = "SummerWeek6Gacha" -- Se não funcionar, mude para Week6
            })
        end
        
        -- Fallback: Método clássico se o de cima falhar
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
    end)
end

-- === FUNÇÃO AUTO STORE (USANDO SUA LISTA PARA CONFERIR) ===
function FruitsModule.AutoStore()
    pcall(function()
        local function store(tool)
            if tool:IsA("Tool") then
                local toolName = tool.Name
                -- Verifica se o nome da ferramenta está na sua FruitList
                local isFruit = false
                for _, name in pairs(FruitsModule.FruitList) do
                    if toolName:find(name:split("-")[1]) or tool:GetAttribute("Fruit") then
                        isFruit = true
                        break
                    end
                end

                if isFruit then
                    -- Usa o nome exato que o Turtle Spy pegou ("StoreFruit")
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", toolName, tool)
                end
            end
        end

        for _, v in pairs(Player.Backpack:GetChildren()) do store(v) end
        for _, v in pairs(Player.Character:GetChildren()) do store(v) end
    end)
end

-- === FUNÇÃO BRING FRUITS (SOLICITADA) ===
function FruitsModule.BringFruits(state)
    _G.BringFruits = state
    task.spawn(function()
        while _G.BringFruits do
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Fruta")) then
                    local handle = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        handle.CFrame = Player.Character.HumanoidRootPart.CFrame
                    end
                end
            end
            task.wait(1)
        end
    end)
end

return FruitsModule

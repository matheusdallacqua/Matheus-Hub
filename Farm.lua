--Fast attack
function FarmModule.FastAttack(state)
    _G.FastAttack = state
    task.spawn(function()
        while _G.FastAttack do
            -- Ele vai usar o número que o loop do Main.lua converteu
            task.wait(_G.FastAttackDelay or 0.1) 
            -- ... resto do código de ataque ...
        end
    end)
end

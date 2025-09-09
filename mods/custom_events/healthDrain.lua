local draining = false
local drainAmount = 0.25 -- valor padrão caso value2 não seja passado

function onEvent(name, value1, value2)
    if name == "DrainLife" then
        if value1 == "1" then
            draining = true
            if tonumber(value2) then
                drainAmount = tonumber(value2) -- define quanto drena
            else
                drainAmount = 0.25
            end
        else
            draining = false
        end
    end
end

function onUpdatePost(elapsed)
    if draining then
        local health = getProperty('health')
        if health > 0 then
            setProperty('health', math.max(0, health - drainAmount))
        end
    end
end

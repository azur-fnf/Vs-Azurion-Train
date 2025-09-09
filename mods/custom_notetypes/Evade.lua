function onCreate()
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Evade' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'mechanics/EVADE')
            setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0)
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0)
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false)
            setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
        end
    end
end

-- Guarda notas de sustain já processadas
local evadeSustainPlayed = {}

function goodNoteHit(id, direction, noteType, isSustainNote)
    if noteType == "Evade" then
        if isSustainNote then
            -- Só toca uma vez por nota
            if not evadeSustainPlayed[id] then
                characterPlayAnim('boyfriend', 'dodgeHold', true)
                playSound('evadeHit', 2)
                evadeSustainPlayed[id] = true
            end
        else
            -- Nota normal
            characterPlayAnim('boyfriend', 'dodge', true)
            playSound('evadeHit', 2)
        end

        cameraShake('game', 0.02, 0.15)
        cameraShake('hud', 0.015, 0.12)
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
    if noteType == "Evade" then
        local curHealth = getProperty('health')
        setProperty('health', math.max(0, curHealth - 0.5))

        playSound('evadeMiss', 2)
        characterPlayAnim('boyfriend', 'hurt', true)

        cameraShake('game', 0.08, 0.35)
        cameraShake('hud', 0.05, 0.3)

        -- Limpa flag apenas da nota específica
        if isSustainNote then
            evadeSustainPlayed[id] = nil
        end
    end
end

function onUpdate(elapsed)
    if getProperty('notes') ~= nil then
        for id, _ in pairs(evadeSustainPlayed) do
            local success, mustPress = pcall(function()
                return getPropertyFromGroup('notes', id, 'mustPress')
            end)
            if not success or mustPress == nil then
                evadeSustainPlayed[id] = nil
            end
        end
    end
end
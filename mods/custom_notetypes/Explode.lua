--[[ 
    Script de nota Explode (melhorado)
    - Apertar a nota: explosão mais forte (40% de vida).
    - Ignorar a nota: explosão menor (25% de vida).
    - Combo zera em ambos os casos.
    - Feedback visual, som e animações incluídos.
--]]

local explodeHits = 0 -- contador de explosões sofridas

function onCreate()
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Explode' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'mechanics/EXPLODE')
            setPropertyFromGroup('unspawnNotes', i, 'hitHealth', 0)
            setPropertyFromGroup('unspawnNotes', i, 'missHealth', 0)
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true) -- não interfere no score padrão
        end
    end
end

-- Pressionar a nota explode = explosão forte
function goodNoteHit(id, direction, noteType, isSustainNote)
    if noteType == "Explode" then
        explodeHits = explodeHits + 1
        setProperty('health', math.max(0, getProperty('health') - 0.4))
        spawnExplosionEffect()

        -- Animação de dano
        characterPlayAnim('boyfriend', 'hurt', true)

        -- Som com pitch levemente aleatório
        playSound('boom', 1.2 + math.random() * 0.8)

        -- Tremor forte
        cameraShake('game', 0.07, 0.3)
        cameraShake('hud', 0.05, 0.25)

        -- Travar score/accuracy
        lockScore()
    end
end

-- Ignorar a nota explode = explosão menor
function noteMiss(id, direction, noteType, isSustainNote)
    if noteType == "Explode" then
        explodeHits = explodeHits + 1
        setProperty('health', math.max(0, getProperty('health') - 0.25))
        setProperty('combo', 0) -- zera combo
        spawnExplosionEffect()

        -- Som mais fraco
        playSound('boom', 1)

        -- Tremor mais leve
        cameraShake('game', 0.04, 0.2)
        cameraShake('hud', 0.025, 0.15)

        lockScore()
    end
end

-- Função para spawnar efeito de explosão
function spawnExplosionEffect()
    local id = 'explosionFX' .. tostring(math.random(999999))
    makeLuaSprite(id, 'effects/explosionFlash', 0, 0)
    setObjectCamera(id, 'hud')
    setProperty(id..'.alpha', 0.8)
    addLuaSprite(id, true)
    
    doTweenAlpha(id..'fade', id, 0, 0.4, 'linear')
    
    runTimer(id..'Remove', 0.4)
end

function onTimerCompleted(tag, loops, loopsLeft)
    local success = pcall(function() removeLuaSprite(tag:gsub('Remove',''), true) end)
end



-- Travar score/accuracy para não alterar
function lockScore()
    setProperty('songScore', getProperty('songScore'))
    setProperty('ratingPercent', getProperty('ratingPercent'))
end

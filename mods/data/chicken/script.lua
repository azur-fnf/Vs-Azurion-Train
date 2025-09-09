-- ================================
-- Script com penalidade por miss (sem mostrar Health)
-- ================================




local playerHits = 0
local playerMisses = 0

-- Configuração da punição
local basePenalty = 0.005 -- metade do valor anterior
local penaltyMult = 1      -- linear, sem exponencial

-- ================================
-- Intro de créditos
-- ================================
function onCreate()
    makeLuaText('text1', 'Chart By Azurion', 600, screenWidth / 2 - 300, -50)
    setTextSize('text1', 40)
    setTextBorder('text1', 2, '000000')
    setTextColor('text1', '00FFFF')
    setObjectCamera('text1', 'hud')
    setTextAlignment('text1', 'center')
    addLuaText('text1')

    makeLuaText('text2', 'Good Luck This is a fukin suffer', 600, screenWidth / 2 - 300, screenHeight / 2 + 10)
    setTextSize('text2', 35)
    setTextBorder('text2', 2, '000000')
    setTextColor('text2', 'FFFFFF')
    setObjectCamera('text2', 'hud')
    setTextAlignment('text2', 'center')
    setProperty('text2.alpha', 0)
    addLuaText('text2')

    makeLuaText('text3', 'Chicken BeatBox', 600, screenWidth / 2 - 300, screenHeight / 2 + 70)
    setTextSize('text3', 45)
    setTextBorder('text3', 3, '000000')
    setTextColor('text3', 'FF00FF')
    setObjectCamera('text3', 'hud')
    setTextAlignment('text3', 'center')
    setProperty('text3.alpha', 0)
    addLuaText('text3')

    runTimer('startAnimation', 2)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startAnimation' then
        doTweenY('text1Down', 'text1', screenHeight / 2 - 60, 1.2, 'elasticOut')
        doTweenAlpha('text2Reveal', 'text2', 1, 1.5, 'quadOut')
        doTweenAlpha('text3Reveal', 'text3', 1, 1.5, 'quadOut')
        runTimer('moveText3', 3)
    elseif tag == 'moveText3' then
        doTweenY('text3Down', 'text3', screenHeight / 2 + 150, 1, 'quadInOut')
        runTimer('fadeOutTexts', 3)
    elseif tag == 'fadeOutTexts' then
        doTweenAlpha('text1FadeOut', 'text1', 0, 1.2, 'quadIn')
        doTweenAlpha('text2FadeOut', 'text2', 0, 1.2, 'quadIn')
        doTweenAlpha('text3FadeOut', 'text3', 0, 1.2, 'quadIn')
        runTimer('removeTexts', 1.3)
    elseif tag == 'removeTexts' then
        removeLuaText('text1', true)
        removeLuaText('text2', true)
        removeLuaText('text3', true)
    end
end

-- ================================
-- Mecânica de penalidade por erro
-- ================================
function goodNoteHit(id, direction, noteType, isSustainNote)
    if isSustainNote then return end
    playerHits = playerHits + 1
    updateRating()
end

function noteMiss(id, direction, noteType, isSustainNote)
    if isSustainNote then return end
    playerMisses = playerMisses + 1

    -- Penalidade linear
    local penalty = basePenalty * playerMisses
    local curHealth = getProperty('health')
    setProperty('health', math.max(0, curHealth - penalty))

    updateRating()
end

-- Atualização do HUD
function onUpdatePost(elapsed)
    local accuracy = (getProperty('ratingPercent') or 0) * 100
    local accuracyText = ""
    if accuracy % 1 == 0 then
        accuracyText = string.format("(%d%%)", accuracy)
    else
        accuracyText = string.format("(%.2f%%)", accuracy)
    end

    -- Penalidade linear
    local penalty = basePenalty * playerMisses
    local npcText = string.format("Miss Penalty: %.3f HP", penalty)

    local text = npcText
    text = text .. " | Combo Breaks: " .. playerMisses
    text = text .. " | Accuracy " .. accuracyText

    setTextString('scoreTxt', text)
end
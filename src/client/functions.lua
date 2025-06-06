local isStripping, animNumber, coords = false, 0, 0

ShowUI = function(show)
    SetNuiFocus(show, show)
    SendNUIMessage({
        type = show and 'show' or 'hide',
        danceNumber = animNumber
    })
end

ChangeAnim = function(up)
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    if up then
        animNumber += 1
    else
        animNumber -= 1
    end

    if animNumber == 0 then
        animNumber = #Config.Anims
    elseif Config.Anims[animNumber] == nil then
        animNumber = 1
    end

    SetEntityCoords(cache.ped, coords)
    local currentAnim = Config.Anims[animNumber]
    lib.playAnim(cache.ped, currentAnim.dict, currentAnim.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    SendNUIMessage({
        type = 'updateDance',
        danceNumber = animNumber
    })
    DoScreenFadeIn(800)
end

BeginStrip = function()
    if not Config.AllowMen and GetEntityModel(cache.ped) == `mp_m_freemode_01` then
        lib.notify({
            title = 'Strip Club',
            description = 'Why are you trying to strip? Fruitcup.',
            position = 'top',
            duration = 10000,
            icon = 'ribbon',
            iconColor = '#dd62fc'
        })
        return
    end

    isStripping = true
    animNumber = 1
    coords = GetEntityCoords(cache.ped)
    lib.hideTextUI()

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityCoords(cache.ped, coords)
    local curdict = Config.Anims[animNumber]
    print('Playing animation:', curdict.dict, curdict.clip)
    lib.playAnim(cache.ped, curdict.dict, curdict.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    ShowUI(true)
    DoScreenFadeIn(800)
end

local isStripping, animNumber, coords = false, 0, 0

CreateThread(function()
    while true do
    
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local ShowUI = false

        for k, v in pairs(Config.StripPoles) do
            local dist = #(playerCoords - v.coords)
            
            if dist <= 1.0 then
                coords = v.coords 
                
                if not isStripping and not ShowUI and not IsEntityDead(playerPed) then
                    ShowUI = true
                end
            end
        end

        if ShowUI then
            sleep = 5
            lib.showTextUI('[E] - Strip')
        end

        if ShowUI and not IsEntityDead(playerPed) and IsControlJustReleased(0, 38) then
            TriggerEvent('DE_poledance:startStrip')
        end

        if not ShowUI then
            sleep = 1000
            lib.hideTextUI()
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 500

        if isStripping then
            sleep = 5

            hintToDisplay('~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ to change dances\n~INPUT_VEH_DUCK~ to stop stripping')

            if IsControlJustReleased(0, 174) then
                changeAnims(false)
            elseif IsControlJustReleased(0, 175) then
                changeAnims(true)
            elseif IsControlJustReleased(0, 73) then
                isStripping = false
                animNumber = 0

                ClearPedTasks(PlayerPedId())
            end
        end
        
        Wait(sleep)
    end
end)

RegisterCommand('fix', function()
    DoScreenFadeIn(800)
end)

RegisterNetEvent('DE_poledance:startStrip')
AddEventHandler('DE_poledance:startStrip', function()
    isStripping = true
    animNumber = 1

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityCoords(PlayerPedId(), coords)
    LoadDict(Config.Anims[animNumber].dict)
    TaskPlayAnim(PlayerPedId(), Config.Anims[animNumber].dict, Config.Anims[animNumber].clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    DoScreenFadeIn(800)
end)

changeAnims = function(up)
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

    SetEntityCoords(PlayerPedId(), coords)
    LoadDict(Config.Anims[animNumber].dict)
    TaskPlayAnim(PlayerPedId(), Config.Anims[animNumber].dict, Config.Anims[animNumber].clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    DoScreenFadeIn(800)
end


hintToDisplay = function(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end

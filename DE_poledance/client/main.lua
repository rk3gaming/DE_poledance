local isStripping, animNumber, coords = false, 0, 0

local function DrawHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function ChangeAnim(up)
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
    lib.RequestAnimDict(currentAnim.dict, 500)
    
    TaskPlayAnim(cache.ped, currentAnim.dict, currentAnim.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    DoScreenFadeIn(800)
end

local function StartLoop()
    CreateThread(function ()
        while isStripping do 
            Wait(5)
            DrawHelpText('~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ to change dances\n~INPUT_VEH_DUCK~ to stop stripping')
            if IsControlJustReleased(0, 174) then
                ChangeAnim(false)
            elseif IsControlJustReleased(0, 175) then
                ChangeAnim(true)
            elseif IsControlJustReleased(0, 73) then
                isStripping = false
                animNumber = 0
                ClearPedTasks(cache.ped)
                break
            end
        end 
    end)
end

local function BeginStrip()
    isStripping = true
    animNumber = 1

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    SetEntityCoords(cache.ped, coords)
    local curdict = Config.Anims[animNumber]
    lib.RequestAnimDict(curdic.dict, 500)
    TaskPlayAnim(cache.ped, curdict.dict, curdict.clip, 8.0, -8.0, -1, 1, 0, false, false, false)
    DoScreenFadeIn(800)
    StartLoop()
end

for i = 1, #Config.StripPoles do 
    local data = Config.StripPoles[i]
    local Point <const> = lib.points.new({coords = data, distance = 5}) 

    function Point:onEnter()
        if not isStripping then 
            lib.showTextUI('[E] - Strip')
        end 
    end 

    function Point:onExit()
        if not isStripping then 
            lib.hideTextUI()
        end
    end 

    function Point:nearby()
        if self.currentDistance < 1.5 and not isStripping and IsControlJustReleased(0, 38) then 
            BeginStrip()
        end 
    end 
end 

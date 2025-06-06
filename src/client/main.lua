RegisterNUICallback('changeDance', function(data, cb)
    if data.direction == 'next' then
        ChangeAnim(true)
    else
        ChangeAnim(false)
    end
    cb('ok')
end)

RegisterNUICallback('stopStrip', function(data, cb)
    isStripping = false
    animNumber = 0
    ClearPedTasks(cache.ped)
    ShowUI(false)
    
    for i = 1, #Config.Locations do
        local location = Config.Locations[i]
        local playerCoords = GetEntityCoords(cache.ped)
        local distance = #(playerCoords - location)
        if distance < 1.5 then
            lib.showTextUI('[E] - Strip')
            break
        end
    end
    
    cb('ok')
end)

for i = 1, #Config.Locations do 
    local data = Config.Locations[i]
    local Point <const> = lib.points.new({
        coords = data,
        distance = 5,
        onEnter = function(self)
            if not isStripping then 
                lib.showTextUI('[E] - Strip')
            end 
        end,
        onExit = function(self)
            if not isStripping then 
                lib.hideTextUI()
            end
        end,
        nearby = function(self)
            if self.currentDistance < 1.5 and not isStripping and IsControlJustReleased(0, 38) then 
                BeginStrip()
            end 
        end
    })
end 

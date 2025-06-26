-- //Variables\\ --
local busspawned, ClockedIn, injob, insideIPL, CurrentlyWashing, inZone = false, false, false, false, false
local index, previousIndex, deliveryLocation, exitCoords, spawnCoords = nil, nil, nil, nil, nil
local pedVariants = {}
local animations = {
    [8] = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}, -- Shirt
    [3] = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1200}, -- Gloves
    [6] = {Dict = "random@domestic", Anim = "pickup_low", Move = 0, Dur = 1200}, -- Shoes
    [9] = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}, -- Vest
    [5] = {Dict = "nmt_3_rcm-10", Anim = "cs_nigel_dual-10", Move = 51, Dur = 1400}, -- Bag 
    [1] = {Dict = "mp_masks@standard_car@ds@", Anim = "put_on_mask", Move = 51, Dur = 800}, -- Mask
    [7] = {Dict = "clothingtie", Anim = "check_out_a", Move = 51, Dur = 2000}, -- Hair
    [4] = {Dict = "re@construction", Anim = "out_of_breath", Move = 51, Dur = 1300}, -- Pants
    [11] = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}, -- Jacket
    [10] = {Dict = "clothingtie", Anim = "try_tie_negative_a", Move = 51, Dur = 1200}, -- Extras
}

-- //Functions\\ --
local function PlayAnimation(emote)
    RequestAnimDict(emote.Dict)
    while not HasAnimDictLoaded(emote.Dict) do
        Wait(100)
    end

    TaskPlayAnim(cache.ped, emote.Dict, emote.Anim, 8.0, -8.0, emote.Dur, emote.Move, 0, false, false, false)
end

local function TriggerClothingAnimation(componentIndex)
    local emote = nil

    emote = animations[componentIndex]
    if emote then
        PlayAnimation(emote)
        Wait(emote.Dur)
    end
end

local function WashMoney()
    if CurrentlyWashing then
        notification("Laundry System", "You already tried laundering your money here.", 2500, 'error')
    else
        CurrentlyWashing = true
        local skillCheck = lib.skillCheck({'easy', 'medium', {areaSize = 40, speedMultiplier = 1.75}}, {'E'})

        if skillCheck then
        notification("Laundry System", "You have finished the minigame, you will continue laundering", 2500, 'success')
        TriggerEvent('nv-moneylaundering:startlaundryprocess')
        else
            notification("Laundry System", "You have failed the minigame, go to the next location.", 2500, 'error')
        end
    end
end

local function exitWitwasIPL(lastWashLocation)
    local ped = PlayerPedId()

    lib.requestAnimDict("anim@heists@keypad@")  
    TaskPlayAnim(ped, "anim@heists@keypad@", "enter", 8.0, 1.0, -1, 50, 0, false, false, false)

    Wait(1000)

    if ped then
        startRun()
    end
    DoScreenFadeOut(1000)
    Wait(1500)

    if lastWashLocation then
        SetEntityCoords(ped, lastWashLocation.x, lastWashLocation.y, lastWashLocation.z)
    else
        local spawncoords = Config.InteractionLocations["Spawn Vehicle"].vehicle.spawnCoords
        SetEntityCoords(ped, spawncoords.x, spawncoords.y, spawncoords.z)
        notification("Laundry System", "There is a problem with finding your old coords", 2500, 'warning')
    end

    DoScreenFadeIn(1000)
    insideIPL = false  
    CurrentlyWashing = false
end

local function enterWitwasIPL(entryCoords, doorCoords)
    local ped = PlayerPedId()

    lib.requestAnimDict("timetable@jimmy@doorknock@")  
    TaskPlayAnim(ped, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 1.0, -1, 50, 0, false, false, false)
    exitCoords = entryCoords
    spawnCoords = doorCoords
    Wait(2500)
    DoScreenFadeOut(1000)
    Wait(1500)
    SetEntityCoords(ped, entryCoords.x, entryCoords.y, entryCoords.z)
    DoScreenFadeIn(1000)
    insideIPL = true
end

function startRun()
    repeat index = math.random(1, #Config.DeliveryLocations)
    until index ~= previousIndex
    previousIndex = index
    deliveryLocation = Config.DeliveryLocations[index]

    createBlip(deliveryLocation.doorCoords)
    
    Citizen.CreateThread(function()
        while injob do
            Wait(1)
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local x, y, z = table.unpack(deliveryLocation.doorCoords)
            local dist = #(vector3(x, y, z) - coords)
            
            if dist < 10 then
                DrawMarker(20, x, y, z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.35, 225, 150, 0, 100, false, true, 2, false, nil, nil, false)
                
                if dist < 2.0 and not IsPedInAnyVehicle(ped, false) then
                    lib.showTextUI(deliveryLocation.interactText)
                    if IsControlJustReleased(0, 38) then
                        enterWitwasIPL(deliveryLocation.insideCoords, deliveryLocation.doorCoords)
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
    end)
end

-- //Threads\\ --

Citizen.CreateThread(function()
    local sleep = 0
    while true do
        Wait(sleep)
        if insideIPL then
           local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())
           local dist = #(vector3(exitCoords.x, exitCoords.y, exitCoords.z) - coords)
           sleep = 1000
           if dist < 2.0 then
               sleep = 0
               lib.showTextUI("[E] Exit laundry location")
               if IsControlJustReleased(0, 38) then 
                   exitWitwasIPL(spawnCoords)
                   lib.hideTextUI()
               end
           else
               lib.hideTextUI()
           end
        end
    end
end)

Citizen.CreateThread(function()
    local sleep = 0
    while true do
        Citizen.Wait(sleep)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        sleep = 5000 
        
        if deliveryLocation then 
            sleep = 2000 

            local washCoords = deliveryLocation.laundryCoords 

            if #(playerCoords - washCoords) < 5 then
                sleep = 1000 

                if #(playerCoords - washCoords) < 2 then
                    sleep = 0 

                    if not CurrentlyWashing then
                        DrawMarker(20, washCoords.x, washCoords.y, washCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.35, 225, 150, 0, 100, false, true, 2, false, nil, nil, false)
                        lib.showTextUI(deliveryLocation.interactText) 

                        if IsControlJustReleased(0, 38) then 
                            lib.hideTextUI()
                            WashMoney() 
                        end
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local ShowingTextUi = false
    local lastLocation = nil 
    local sleep = 1000

    for k, v in pairs(Config.InteractionLocations) do
        if v.blip and v.blip.enabled then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipColour(blip, v.blip.color)
            SetBlipScale(blip, v.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.blip.name)
            EndTextCommandSetBlipName(blip)
        end
    end

    while true do 
        Wait(sleep)
        local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())
        local closestLocation = nil
        local closestDist = 10  
        sleep = 1000

        for k, v in pairs(Config.InteractionLocations) do 
            local x, y, z = table.unpack(v.coords)
            local dist = #(vector3(x, y, z) - coords)

            if dist < closestDist then
                if v.requiredClockedIn and not ClockedIn then 
                    break 
                end 

                DrawMarker(20, x, y, z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.35, 225, 150, 0, 100, false, true, 2, false, nil, nil, false)
                
                closestDist = dist
                closestLocation = v 
            end

        end

        if closestLocation then
            sleep = 0
            local x, y, z = table.unpack(closestLocation.coords)
            local dist = closestDist

            if dist < 10 then
                if dist <= 2.5 then 
                    if not ShowingTextUi or lastLocation ~= closestLocation then
                        lib.showTextUI(closestLocation.interactText)
                        ShowingTextUi = true
                        lastLocation = closestLocation  
                    end

                    if IsControlJustReleased(0, 38) then 
                        TriggerEvent(closestLocation.trigger)
                    end
                end
            end
        end 

        if ShowingTextUi and (not closestLocation or closestDist > 2.5) then
            ShowingTextUi = false
            lib.hideTextUI()
        end
    end
end)

-- //Events\\ --

RegisterNetEvent("nv-moneylaundering:client:openMenu")
AddEventHandler("nv-moneylaundering:client:openMenu", function()
    lib.registerContext({
        id = 'laundry_menu',
        title = 'Laundry Menu', 
        options = {
            {
                title = 'Get Disguised Outfit', 
                description = 'Get a disguised outfit to blend in.',
                icon = 'fas fa-user-secret',
                onSelect = function()
                if not ClockedIn and not lib.progressActive() then
                ClockedIn = true
                    for i = 1, 11 do
                        pedVariants[i] = {
                            drawable = GetPedDrawableVariation(cache.ped, i),
                            texture = GetPedTextureVariation(cache.ped, i),
                        }
                    end
                    local components = IsPedMale(cache.ped) and Config.maleComponents or Config.femaleComponents
                    
                    local totalDuration = 0
                    for i, component in pairs(components) do
                        if component ~= nil and animations[i] then
                            totalDuration = totalDuration + animations[i].Dur
                        end
                    end
    
                    CreateThread(function()
                        lib.progressBar({
                            duration = totalDuration, 
                            label = "Putting on disguise...",
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                move = true,
                                car = true,
                                combat = true
                            }
                        })
                    end)
    
                    for i, component in pairs(components) do
                        if component ~= nil then
                            TriggerClothingAnimation(i)
                            SetPedComponentVariation(cache.ped, component[1], component[2], component[3], 0)
                        end
                    end
                    notification("Laundry System", "Go to the parking and grab a truck to start money laundering.", 2500, 'info')
                else
                notification("Laundry System", "You are already wearing the disguised outfit, your doing the job", 2500, 'warning')
            end
        end
            },
            {
                title = 'Revert Clothes',       
                description = 'Return to your normal clothes.',  
                icon = 'fas fa-tshirt',           
                onSelect = function()  
                    if ClockedIn and not lib.progressActive() then 
                    ClockedIn = false
                    
                    local totalDuration = 0
                    for i = 1, 11 do
                        if pedVariants[i] and animations[i] then
                            totalDuration = totalDuration + animations[i].Dur
                        end
                    end
    
                    CreateThread(function()
                        lib.progressBar({
                            duration = totalDuration,
                            label = "Changing back...",
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                move = true,
                                car = true,
                                combat = true
                            }
                        })
                    end)
    
                    for i = 1, 11 do
                        local variants = pedVariants[i]
                        if variants ~= nil then
                            TriggerClothingAnimation(i)
                            SetPedComponentVariation(cache.ped, i, variants.drawable, variants.texture, 0)
                        end
                    end
                    notification("Laundry System", "You picked up your clothes and stopped money laundering", 2500, 'info')
            else
                notification("Laundry System", "We could not find your old clothes, your not doing the job", 2500, 'error')
                end
            end
            }
        }
    })    
    lib.showContext('laundry_menu')
end)

RegisterNetEvent('nv-moneylaundering:startlaundryprocess')
AddEventHandler('nv-moneylaundering:startlaundryprocess', function()
    local playerPed = PlayerPedId()
    local animDict = "mp_car_bomb"        -- Animation dictionary
    local animClip = "car_bomb_mechanic"  -- Animation clip
    local blendIn = 3.0                   -- Blend-in time for animation
    local blendOut = 1.0                  -- Blend-out time for animation
    local duration = Config.WashDuration  -- Duration of the progress bar

    lib.requestAnimDict(animDict)

    local success = lib.progressBar({
        duration = duration,
        label = 'Laundering money...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = animDict,     -- Animation dictionary
            clip = animClip,     -- Animation clip
            blendIn = blendIn,   -- Blend-in speed
            blendOut = blendOut, -- Blend-out speed
            playbackRate = 0,    -- Playback rate (0 for normal)
            flag = 49,           -- Flag for animation
        }
    })

    ClearPedTasks(playerPed)

    if success then
        TriggerServerEvent('nv-moneylaundering:givemoney')
    else
        notification("Laundry System", "Laundering cancelled...", 2500, 'warning')
    end
end)

RegisterNetEvent("nv-moneylaundering:client:spawnVehicle")
AddEventHandler("nv-moneylaundering:client:spawnVehicle", function()
    if not busspawned then
        if not injob then 
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local spawnLocation = Config.InteractionLocations["Spawn Vehicle"].vehicle.spawnCoords
            local vehicleModel = Config.InteractionLocations["Spawn Vehicle"].vehicle.model
            local plateText = Config.InteractionLocations["Spawn Vehicle"].vehicle.plateText
            local x, y, z, h = table.unpack(spawnLocation)

            busspawned = true

            CreateCamera(playerCoords + vector3(0, 0, 2), vector3(0, 0, 0), 1500) 
            
            RequestModel(vehicleModel)
            while not HasModelLoaded(vehicleModel) do
                Wait(500)
            end

            local vehicle = CreateVehicle(vehicleModel, x, y, z, h, true, false)

            SetVehicleNumberPlateText(vehicle, plateText)
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            DestroyCamera(1000)

            injob = true
            startRun()
        end
    else
        notification("Laundry System", "You already got your vehicle.", 2500, 'info')
    end
end)

RegisterNetEvent("nv-moneylaundering:client:despawnVehicle")
AddEventHandler("nv-moneylaundering:client:despawnVehicle", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local vehicleModel = Config.InteractionLocations["Spawn Vehicle"].vehicle.model
    local plateText = Config.InteractionLocations["Spawn Vehicle"].vehicle.plateText:upper()
    local verifiedPlateText = GetVehicleNumberPlateText(vehicle):upper()

    plateText = plateText:gsub("^%s*(.-)%s*$", "%1")
    verifiedPlateText = verifiedPlateText:gsub("^%s*(.-)%s*$", "%1")

    if vehicle ~= 0 and GetEntityModel(vehicle) == GetHashKey(vehicleModel) then
        if verifiedPlateText == plateText then
            TaskLeaveVehicle(ped, vehicle, 0)
            Wait(1000)
            FadeOutEntityNew(vehicle, false)
            Wait(1000)
            DeleteEntity(vehicle)

            injob = false
            RemoveBlip(blip)
            busspawned = false
        else
            notification("Laundry System", "The vehicle plate does not match or it cannot be deleted here.", 2500, 'error')
        end
    else
        notification("Laundry System", "You cannot delete this vehicle here", 2500, 'error')
    end
end)

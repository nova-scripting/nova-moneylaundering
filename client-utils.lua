local _internal_camera
local lastAction = 0


-- // FUNCTION FOR NOTIFICTATIONS \\
function notification(title, text, time, type)
    TriggerEvent('mdev-moneylaundering:client:DefaultNotify', title, text, time, type)
end

RegisterNetEvent('mdev-moneylaundering:client:DefaultNotify')
AddEventHandler('mdev-moneylaundering:client:DefaultNotify', function(title, text, time, type)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(text)
        DrawNotification(0,1)

        -- Default ESX Notify:
        --TriggerEvent('esx:showNotification', text)

        -- Default QB Notify:
        --TriggerEvent('QBCore:Notify', text, 'info', 5000)

        -- OKOK Notify:
        -- exports['okokNotify']:Alert(title, text, time, type, false)
end)

-- // DELETE VEHICLE TRANSITIONS \\
function FadeOutEntityNew(entity, fast, await)
    NetworkFadeOutEntity(entity, fast, not fast)
    local start = GetGameTimer()
    if await then
        while GetEntityAlpha(entity) > 5 and GetGameTimer() - start < 2000 do
            Citizen.Wait(50)
        end
    end
    SetEntityCollision(entity, false, false)
end

-- // FUNCTION FOR CAMERA TRANSITIONS \\
function CreateCamera(pos, rot, transitionTime)
    pos = pos or GetFinalRenderedCamCoord()
    rot = rot or GetFinalRenderedCamRot(2)

    if _internal_camera and DoesCamExist(_internal_camera) then
        SetCamActive(_internal_camera, false)
        DestroyCam(_internal_camera)
    end
    _internal_camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    transitionTime = transitionTime or 1000

    SetPlayerControl(PlayerId(), false, 1 << 8)
    SetCamActive(_internal_camera, true)
    SetCamCoord(_internal_camera, pos.x, pos.y, pos.z)
    SetCamRot(_internal_camera, rot.x, rot.y, rot.z, 2)
    SetCamFov(_internal_camera, GetGameplayCamFov())
    if lastAction == GetGameTimer() then
        Citizen.Wait(0)
    end
    if transitionTime > 0 then
        RenderScriptCams(true, true, transitionTime, 1, 0)
    else
        RenderScriptCams(true, false, transitionTime, 1, 0)
    end
    lastAction = GetGameTimer()
end

function DestroyCamera(transitionTime)
    transitionTime = transitionTime or 1000
    if lastAction == GetGameTimer() then
        Citizen.Wait(0)
    end
    DestroyCam(_internal_camera)
    SetPlayerControl(PlayerId(), true)
    if transitionTime > 0 then
        RenderScriptCams(false, true, transitionTime, 1, 0)
    else
        RenderScriptCams(false, false, 0, 1, 0)
    end
    lastAction = GetGameTimer()
    _internal_camera = nil
end

-- // FUNCTION FOR DELIVER BLIPS \\

function createBlip(coords) 
    local x,y,z = table.unpack(coords)
    if not DoesBlipExist(blip) then 
        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 5)
        SetBlipRoute(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Laundry Location')
        EndTextCommandSetBlipName(blip)
    else
        RemoveBlip(blip)

        blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 5)
        SetBlipRoute(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Laundry Location')
        EndTextCommandSetBlipName(blip)
    end
end
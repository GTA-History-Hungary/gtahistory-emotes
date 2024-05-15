InMovementMode = false
local Ped, EmoteName, StartCoords = -1, nil, nil

function SetMovementMode(bool, GotEmoteName)
    if bool == false and InMovementMode and StartCoords then
        FreezeEntityPosition(Ped, false)
        SetEntityCoordsNoOffset(Ped, StartCoords)
    end

    Ped = GetPlayerPed(-1)

    if(not InMovementMode and bool == true) then
        StartCoords = GetEntityCoords(Ped)
        DebugPrint('set StartCoords', StartCoords)
    end

    InMovementMode = bool == true
    EmoteName = GotEmoteName

    if (not IsPedInAnyVehicle(Ped, false)) then
        FreezeEntityPosition(Ped, InMovementMode)
    end
end

function GetMovementMode()
    return InMovementMode
end

RegisterNetEvent('gtahistory-emotes:client:syncPosition')
AddEventHandler('gtahistory-emotes:client:syncPosition', function (target, pos, rot)
    local ped = GetPlayerPed((GetPlayerFromServerId(target)))

    if(ped ~= Ped) then
        SetEntityCoordsNoOffset(ped, pos)
        SetEntityHeading(ped, rot)
    end
end)

Citizen.CreateThread(function()
    local counter = 0
    local needsSync = false

    while true do
        Citizen.Wait(50)

        if(needsSync) then
            counter = counter + 1
        end

        if not InMovementMode then
            Citizen.Wait(1000)
            needsSync = false
        else
            for key, func in pairs(Config.MovementKeys) do
                DisableControlAction(0, key, true)
                if IsDisabledControlPressed(0, key) then
                    func(Ped)
                    OnEmotePlay(EmoteName)
                    needsSync = true
                end
            end

            if (needsSync and counter > 20) then
                counter = 0
                needsSync = false
                TriggerServerEvent('gtahistory-emotes:server:syncPosition', GetEntityCoords(Ped), GetEntityHeading(Ped))
            end
        end
    end
end)

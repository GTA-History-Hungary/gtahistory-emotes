InMovementMode = false
local Ped, EmoteName, StartCoords = GetPlayerPed(-1), nil, nil

function SetMovementMode(bool, GotEmoteName)
    InMovementMode = bool == true
    EmoteName = GotEmoteName

    Ped = GetPlayerPed(-1)
    StartCoords = GetEntityCoords(Ped)

    if (not IsPedInAnyVehicle(Ped, false)) then
        FreezeEntityPosition(Ped, InMovementMode)
    end
end

function GetMovementMode()
    return InMovementMode
end

function GetStartCoords()
    return StartCoords
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)

        if not InMovementMode then
            Citizen.Wait(1000)
        else
            for key, func in pairs(Config.MovementKeys) do
                DisableControlAction(0, key, true)
                if IsDisabledControlPressed(0, key) then
                    func(Ped)
                    OnEmotePlay(EmoteName)
                end
            end
        end
    end
end)

local active = false
local waypoint = nil
local drivingStyle = 959

RegisterNetEvent('autopilot:start')
AddEventHandler('autopilot:start', function(args)
    -- Setup variables
    if(active) then
        TriggerEvent('autopilot:stop')
    end
    
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local bip =GetFirstBlipInfoId(8)
    if(bip == nil or bip == 0 or vehicle == nil) then
        ESX.ShowHelpNotification('Please mark waypoint')
        return
    end
    
    waypoint = GetBlipCoords(bip)
    local stopRange = 10
    local speed = args.speed_kph / 3.6 -- unit KPH to In game
    local maxSpeed = GetVehicleModelEstimatedMaxSpeed(GetEntityModel(vehicle))
    if(speed > maxSpeed) then   
        speed = maxSpeed
    end

    -- Useful functions to make the ped perform better while driving.
    SetDriverAbility(ped, 1.0)        -- values between 0.0 and 1.0 are allowed.
    SetDriverAggressiveness(ped, 0.0) 
    
    TaskVehicleDriveToCoordLongrange(ped, vehicle, waypoint, speed, drivingStyle, stopRange);
    active = true
    ESX.ShowNotification('~g~Auto pilot start')
end)

RegisterNetEvent('autopilot:stop')
AddEventHandler('autopilot:stop', function()
    -- Setup variables
    if(not active) then
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped,false)
    ESX.ShowNotification('~g~Auto pilot stop')
    ClearPedTasks(ped)
    active = false
    waypoint = nil
end)

CreateThread(function() 
    while true do
        Wait(0)  
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if(active and vehicle) then
            local coords = GetEntityCoords(ped)
            local distToWaypoint = GetDistanceBetweenCoords(coords, waypoint, false)
            if(distToWaypoint <= 50) then
                StopVehicleAtStreetClosest()
            end
        end
    end
end)
function StopVehicleAtStreetClosest()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped,false)
    local coords = GetEntityCoords(ped)
    local bClosestVehicleNode, parkPos = GetNthClosestVehicleNode(waypoint.x,waypoint.y,coords.z, 3,0,0,0)
    if(bClosestVehicleNode) then
        ClearPedTasks(ped)
        ESX.ShowNotification('~g~Please wait. We will take you to your safe destination.')
        ESX.ShowHelpNotification('Can press ~INPUT_MULTIPLAYER_INFO~ for cancel auto pilot')
        TaskVehiclePark(ped,vehicle, parkPos.x, parkPos.y, parkPos.z, GetEntityHeading(ped),0,5,true)
        while true do
            if(IsControlJustReleased(0, 20)) then
                TriggerEvent('autopilot:stop')

                break
            end
            coords = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(coords , parkPos,false)
            if(dist <= 5) then
                break
            end
            Wait(0)
        end
    end
    TriggerEvent('autopilot:stop')
end
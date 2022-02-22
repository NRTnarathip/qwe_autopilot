ESX.RegisterCommand('atpstart', {'user','admin'}, function(xPlayer, args, showError)
    xPlayer.triggerEvent('autopilot:start', args)
end, true, { help ='auto pilot vehicle to waypoint', arguments={
    { name = 'speed_kph', help = 'speed drive unit KPH', type = 'number' }
}})

ESX.RegisterCommand('atpstop', {'user','admin'}, function(xPlayer, args, showError)
    xPlayer.triggerEvent('autopilot:stop')
end, true, { help ='auto pilot vehicle to waypoint'})

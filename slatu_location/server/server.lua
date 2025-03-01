ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterNetEvent('locpurchaseSolazone')
AddEventHandler('locpurchaseSolazone', function(vehicleModel, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= price then

        xPlayer.removeMoney(price)
        
  
        TriggerClientEvent('spawnVehicle', source, vehicleModel)
        

        TriggerClientEvent('esx:showNotification', source, "Vous avez payé "..price.." ~o~$")
    else
   
        TriggerClientEvent('esx:showNotification', source, Config.PasDargentNotif)
    end
end)

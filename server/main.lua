ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand','tow',function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "mechanic" or xPlayer.job.name == "bennys" or xPlayer.job.name == "police" then
        TriggerClientEvent('relisoft_trucktown:tow',source)
    else
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Pro tyto funkce musíte být mechanik!' }, color = { 255, 50, 50 } })
    end
end, {help = 'tento příkaz se používá pro testování'})

TriggerEvent('es:addCommand','savetow',function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "mechanic" or xPlayer.job.name == "bennys" or xPlayer.job.name == "police" then
        TriggerClientEvent('relisoft_trucktown:towSave',source)
    else
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Pro tyto funkce musíte být mechanik!' }, color = { 255, 50, 50 } })
    end
end, {help = 'tento příkaz se používá pro testování'})
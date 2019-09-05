ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand','tow',function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)

    if inJob(xPlayer) then
        TriggerClientEvent('relisoft_trucktown:tow',source)
    else
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Pro tyto funkce musíte být mechanik!' }, color = { 255, 50, 50 } })
    end
end, {help = 'tento příkaz se používá pro testování'})

TriggerEvent('es:addCommand','savetow',function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if inJob(xPlayer) then
        TriggerClientEvent('relisoft_trucktown:towSave',source)
    else
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Pro tyto funkce musíte být mechanik!' }, color = { 255, 50, 50 } })
    end
end, {help = 'tento příkaz se používá pro testování'})

function inJob(xPlayer)
    local inJob = false
    for _, v in pairs(Config.MechanicJobs) do
        if xPlayer.job.name == v then
            inJob = true
        end
    end
    return inJob
end
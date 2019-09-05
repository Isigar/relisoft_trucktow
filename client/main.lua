local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local towning = false
local savedVehicle
local towedVehicle

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        towning = false
        savedVehicle = nil
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Detach!' }, color = { 255, 50, 50 } })
        DetachVehicleFromAnyTowTruck(towedVehicle)
    end
end)

RegisterNetEvent('relisoft_trucktown:towSave')
AddEventHandler('relisoft_trucktown:towSave',function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)

    if vehicle ~= 0 then
        local model = GetEntityModel(vehicle)
        local modelName = GetDisplayNameFromVehicleModel(model)
        if modelName == "TOWTRUCK" then
            savedVehicle = vehicle
            TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Uložil sis svůj truck nyní můžeš použít /tow u vozidla, které chceš připnout nezapomeň k němu nacouvat!' }, color = { 255, 50, 50 } })
        else
            TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Nejsi v towtruck vozidlu!' }, color = { 255, 50, 50 } })
        end

    else
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Nejsi v žádném vozidla!' }, color = { 255, 50, 50 } })
    end
end)

RegisterNetEvent('relisoft_trucktown:tow')
AddEventHandler('relisoft_trucktown:tow',function()
    if savedVehicle == nil then
        TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Pro odtah musíte prvně vlézt do truck townu a použít /savetow' }, color = { 255, 50, 50 } })
    else
        local currentPed = PlayerPedId()
        local pedCoords = GetEntityCoords(currentPed)
        local vehicle = ESX.Game.GetClosestVehicle(coords)
        local vehiclePos = GetEntityCoords(vehicle)
        local vehicleDistance = GetDistanceBetweenCoords(vehiclePos,pedCoords)
        if vehicle == savedVehicle then
            TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Nemůžes připoutat svoje vozidlo!' }, color = { 255, 50, 50 } })
        else
            if vehicle and vehicleDistance < 5 then
                if towning and IsVehicleAttachedToTowTruck(savedVehicle,vehicle) then
                    DetachVehicleFromAnyTowTruck(vehicle)
                    towning = false
                    towedVehicle = nil
                    TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Vozidlo bylo odpojeno!' }, color = { 255, 50, 50 } })
                else
                    AttachVehicleToTowTruck(savedVehicle,vehicle,false)
                    towning = true
                    towedVehicle = vehicle
                    TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Vozidlo bylo připojeno, jeďte opatrně!' }, color = { 255, 50, 50 } })
                end
--                TriggerEvent('chat:addMessage', { args = { 'TowTruck', ESX.DumpTable(towning) }, color = { 255, 50, 50 } })
            else
                TriggerEvent('chat:addMessage', { args = { 'TowTruck', 'Nejsi u žádného vozidla!' }, color = { 255, 50, 50 } })
            end
        end

    end
end)
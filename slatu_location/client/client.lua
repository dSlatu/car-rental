ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local PlayerData = {}
local isMenuOpen = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.PosBlips)

    SetBlipSprite(blip, Config.Imagedublips)
    SetBlipScale(blip, Config.Tailledublips)
    SetBlipColour(blip, Config.CouleurduBlips)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.NomduBlips)
    EndTextCommandSetBlipName(blip)
end)

function Solazoneloc()
    if isMenuOpen then return end
    isMenuOpen = true

    local Solazoneloc = RageUI.CreateMenu("~B~Location", "Menu Intéraction..")
    local Voitures = RageUI.CreateSubMenu(Solazoneloc, "~B~Location", "Menu Intéraction..")

    Solazoneloc:SetRectangleBanner(35, 41, 100)
    Voitures:SetRectangleBanner(35, 41, 100)

    RageUI.Visible(Solazoneloc, not RageUI.Visible(Solazoneloc))
    
    Citizen.CreateThread(function()
        while isMenuOpen do
            Citizen.Wait(0)

            RageUI.IsVisible(Solazoneloc, true, true, true, function()

                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.pos.Location.position.x, Config.pos.Location.position.y, Config.pos.Location.position.z)
                if dist >= Config.DistanceVoirLePoint then
                    RageUI.CloseAll()
                    isMenuOpen = false
                else
                    RageUI.ButtonWithStyle("~F~→ Voitures", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
                        if Selected then
                       
                        end
                    end, Voitures)
                end
            end, function() end)

            RageUI.IsVisible(Voitures, true, true, true, function()

                local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.pos.Location.position.x, Config.pos.Location.position.y, Config.pos.Location.position.z)
                if dist >= Config.DistanceVoirLePoint then
                    RageUI.CloseAll()
                    isMenuOpen = false
                else
                    RageUI.ButtonWithStyle(Config.LabelVoiture2, "Prix : "..Config.PrixBlista.. " ~f~$", {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local price = Config.PrixBlista
                            local vehicle = "blista" 
                            TriggerServerEvent('locpurchaseSolazone', vehicle, price)
                            RageUI.CloseAll()
                            isMenuOpen = false
                        end
                    end)

                    RageUI.ButtonWithStyle(Config.LabelVoiture6, "Prix : "..Config.PrixPanto.. " ~f~$", {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local price = Config.PrixPanto
                            local vehicle = "panto"
                            TriggerServerEvent('locpurchaseSolazone', vehicle, price)
                            RageUI.CloseAll()
                            isMenuOpen = false
                        end
                    end)
                end
            end, function() end)

            if not RageUI.Visible(Solazoneloc) and not RageUI.Visible(Voitures) then
                isMenuOpen = false
                break
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.pos.Location.position.x, Config.pos.Location.position.y, Config.pos.Location.position.z)
        if dist <= Config.DistanceVoirLeMarker then
            Timer = 0
            if dist <= Config.DistanceVoirLePoint then
                Timer = 0   
                RageUI.Text({message = Config.TextLocation, time_display = 1})
                if IsControlJustPressed(1, 51) and not isMenuOpen then
                    Solazoneloc()    
                end
            end 
        end
        Citizen.Wait(Timer)
    end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.HashPed)
    while not HasModelLoaded(hash) do 
        RequestModel(hash) 
        Wait(20) 
    end
    for _,v in pairs(Config.pos.PedPos) do
        local ped = CreatePed("PED_TYPE_CIVFEMALE", Config.HashPed, v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end
end)

RegisterNetEvent('spawnVehicle')
AddEventHandler('spawnVehicle', function(vehicleModel)
    local playerPed = PlayerPedId()
    local spawnCoords = Config.pos.SpawnVehicle.position
    local spawnHeading = Config.pos.SpawnVehicle.position.h

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(500)
        RequestModel(vehicleModel)
    end

    ESX.Game.SpawnVehicle(vehicleModel, spawnCoords, spawnHeading, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "LOC" .. math.random(1000, 9999)) 
    end)
end)

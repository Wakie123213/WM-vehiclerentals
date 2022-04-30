--[[
=============================================================
               Made By: Wakie Modifications 
=============================================================
--]]

QBCore = exports['qb-core']:GetCoreObject()

local RentingCar = false
local Vehspawn = nil
local VehPlate = nil
local currentvehicle = nil
local time = 0
local currentfee = 0
local Account = "none"

CreateThread(function()
    for k,v in pairs(Config.Locations) do
        if Config.Blips.Enabled then
            RentalVehicle = AddBlipForCoord(Config.Locations[k].GetVehicle.x, Config.Locations[k].GetVehicle.y, Config.Locations[k].GetVehicle.z)
            SetBlipSprite(RentalVehicle, Config.Blips.Icon)
            SetBlipScale(RentalVehicle, Config.Blips.Size)
            SetBlipDisplay(RentalVehicle, 4)
            SetBlipColour(RentalVehicle, Config.Blips.Color)
            SetBlipAsShortRange(RentalVehicle, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Blips.Label)
            EndTextCommandSetBlipName(RentalVehicle)
        end
    end
end)

function GetPlrMoney(currentfee)
    local PlrCash = QBCore.Functions.GetPlayerData().money["cash"]
    local PlrBank = QBCore.Functions.GetPlayerData().money["bank"]
    
    if PlrCash >= currentfee then
        Account = "cash"
    elseif PlrBank >= currentfee then
        Account = "bank"
    else
        Account = "none"
    end
end

function GetVehicleSpawn()
    for k,v in pairs(Config.Locations) do
        local PlrCoords = GetEntityCoords(PlayerPedId())
        local RenCoords = Config.Locations[k].GetVehicle
        local dist = #(vector3(PlrCoords) - vector3(RenCoords))

        if dist < 8 then
            Vehspawn = Config.Locations[k].VehicleSpawn
        end
    end
end

function GenerateLicensePlate()
    VehPlate = Config.Localization.RentalVehiclePlate..math.random(1000, 9999)
end

function GetTime()
    time = Config.Rental.RentalRateInterval
end

CreateThread(function()
    while true do
        if RentingCar then
            if time > 0 then
                time = time - 1
            else
                GetPlrMoney(currentfee)
                if Account == "cash" then
                    TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, currentfee, "cash")
                elseif Account == "bank" or Account == "none" then
                    TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, currentfee, "bank")
                end
                QBCore.Functions.Notify(Config.Localization.RentalSuccessNotificationFiv..currentfee..Config.Localization.RentalSuccessNotificationSix, "success", 5000)
                GetTime()
            end
            local vehhealth = GetVehicleEngineHealth(currentvehicle)
            if vehhealth <= 0 then
                RentingCar = false
                TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, Config.Rental.RentalVehicleDamagedFee, "bank")
                QBCore.Functions.Notify(Config.Localization.ErrorVehicleBroken..Config.Rental.RentalVehicleDamagedFee, "error", 5000)
            end
        end
    Wait(1000)
    end
end)

RegisterNetEvent('wm-vehiclerentals:client:spawncar', function(data)
    if not RentingCar then
        currentfee = data.fee
        GetPlrMoney(currentfee)
        if Account == "cash" or Account == "bank" then
            local src = PlayerPedId()
            local PlayerFirstName = QBCore.Functions.GetPlayerData().charinfo.firstname
            local PlayerLastName = QBCore.Functions.GetPlayerData().charinfo.lastname
            RentalRateTime = (Config.Rental.RentalRateInterval / 60)
            TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, data.fee, Account)
            GetTime()
            GetVehicleSpawn()
            GenerateLicensePlate()
            RentingCar = true
            QBCore.Functions.SpawnVehicle(data.vehicle, function(rentvehicle)
                currentvehicle = rentvehicle
                SetVehicleNumberPlateText(rentvehicle, VehPlate)
                SetEntityHeading(rentvehicle, Vehspawn.w)
                exports[Config.FuelScript]:SetFuel(rentvehicle, 100.0)
                TaskWarpPedIntoVehicle(PlayerPedId(), rentvehicle, -1)
                TriggerEvent("vehiclekeys:client:SetOwner", VehPlate)
                SetVehicleEngineOn(rentvehicle, true, true)
            end, Vehspawn, true)
            TriggerServerEvent('wm-vehiclerentals:server:givedocument', src, PlayerFirstName, PlayerLastName, data.label, VehPlate)
            QBCore.Functions.Notify(Config.Localization.RentalSuccessNotificationOne..data.label, 'success', 5000)
            QBCore.Functions.Notify(Config.Localization.RentalSuccessNotificationThr..RentalRateTime..Config.Localization.RentalSuccessNotificationFor, 'primary', 10000)
        else
            QBCore.Functions.Notify(Config.Localization.ErrorNotEnoughMoney, 'error')
        end
    else
        QBCore.Functions.Notify(Config.Localization.ErrorAlreadyRenting, 'error')
    end
end)

RegisterNetEvent('wm-vehiclerentals:client:returncar', function()
    if currentvehicle ~= nil then
        local PlrCoords = GetEntityCoords(PlayerPedId())
        local VehCoords = GetEntityCoords(currentvehicle)
        local dist = #(vector3(PlrCoords) - vector3(VehCoords))
        if dist < 10 then
            DeleteEntity(currentvehicle)
            QBCore.Functions.Notify(Config.Localization.RentalReturnedSuccess, 'success')
            RentingCar = false
            TriggerServerEvent('wm-vehiclerentals:server:removedocument', src)
        else
            QBCore.Functions.Notify(Config.Localization.ErrorRentalVehicleNotNearby, 'error')
        end
    else
        QBCore.Functions.Notify(Config.Localization.ErrorNoRentalVehicle, 'error')
    end
end)

RegisterNetEvent('wm-vehiclerentals:client:openmenu', function()
    local rentvehicleMenu = {
        {
            header = Config.Localization.RentalSelectionHeader,
            isMenuHeader = true
        }
    }

    for k,v in pairs(Config.RentableVehicles) do
        rentvehicleMenu[#rentvehicleMenu+1] = {
            header = {Config.RentableVehicles[k].Label..Config.Localization.RentalSelectionRentalFeeText..Config.RentableVehicles[k].RentFee},
            txt = "",
            params = {
                event = "wm-vehiclerentals:client:spawncar",
                args = {
                    vehicle = Config.RentableVehicles[k].SpawnName,
                    label = Config.RentableVehicles[k].Label,
                    fee = Config.RentableVehicles[k].RentFee
                }
            }
        }
    end

    rentvehicleMenu[#rentvehicleMenu+1] = {
        header = Config.Localization.RentalSelectionCloseButton,
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(rentvehicleMenu)
end)

CreateThread(function()
    for k,v in pairs(Config.Locations) do
            Ped = type(Config.Target.TargetPed) == "string" and GetHashKey(Config.Target.TargetPed) or Ped
            RequestModel(Ped)

            while not HasModelLoaded(Ped) do
                Wait(0)
            end

            RentalPed = CreatePed(0, Ped, Config.Locations[k].GetVehicle.x, Config.Locations[k].GetVehicle.y, Config.Locations[k].GetVehicle.z-1, Config.Locations[k].GetVehicle.w, false, false)
            TaskStartScenarioInPlace(RentalPed, Config.Target.TargetPedScenario, true)
            FreezeEntityPosition(RentalPed, true)
            SetEntityInvincible(RentalPed, true)
            SetBlockingOfNonTemporaryEvents(RentalPed, true)

            exports['qb-target']:AddTargetEntity(RentalPed, {
                options = {
                    {
                        label = Config.Localization.TargetText,
                        icon = "fa fa-car",
                        action = function()
                            TriggerEvent('wm-vehiclerentals:client:openmenu')
                            GetVehicleSpawn()
                        end
                    },
                    {
                        label = Config.Localization.TargetTextTwo,
                        icon = "fa fa-long-arrow-right",
                        action = function()
                            TriggerEvent('wm-vehiclerentals:client:returncar')
                            GetVehicleSpawn()
                        end
                    }
                },
                distance = 2.0,
            }) 
    end
end)
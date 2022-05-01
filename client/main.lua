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
local currentcatagory = nil
local time = 0
local currentfee = 0
local Account = "none"

CreateThread(function()
    for k,v in pairs(Config.Locations) do
        if Config.Locations[k].BlipEnabled then
            RentalVehicle = AddBlipForCoord(Config.Locations[k].GetVehicle.x, Config.Locations[k].GetVehicle.y, Config.Locations[k].GetVehicle.z)
            SetBlipSprite(RentalVehicle, Config.Locations[k].BlipIcon)
            SetBlipScale(RentalVehicle, Config.Locations[k].BlipSize)
            SetBlipDisplay(RentalVehicle, 4)
            SetBlipColour(RentalVehicle, Config.Locations[k].BlipColor)
            SetBlipAsShortRange(RentalVehicle, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Locations[k].BlipLabel)
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

        if dist < 10 then
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
            if Config.Rental.CheckForEngineDamage then
                if GetVehicleEngineHealth(currentvehicle) <= 0 then
                    RentingCar = false
                    TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, Config.Rental.RentalVehicleDamagedFee, "bank")
                    QBCore.Functions.Notify(Config.Localization.ErrorVehicleBroken..Config.Rental.RentalVehicleDamagedFee, "error", 5000)
                end
            end

            if Config.Rental.CheckForUnderWaterVeh then
                if currentcatagory ~= 3 then
                    if IsEntityInWater(currentvehicle) then
                        Wait(5000)
                        if not GetIsVehicleEngineRunning(currentvehicle) then
                            RentingCar = false
                            TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, Config.Rental.RentalVehicleDamagedFee, "bank")
                            QBCore.Functions.Notify(Config.Localization.ErrorVehicleBroken..Config.Rental.RentalVehicleDamagedFee, "error", 5000)
                        end
                    end
                end
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
            currentcatagory = data.catagory
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
        if dist < 20 then
            if Config.Rental.ChrgPlrFeeIfRtrnDmged then
                if (GetVehicleBodyHealth(currentvehicle) <= 980 or GetVehicleEngineHealth(currentvehicle) <= 980) then
                    TriggerServerEvent('wm-vehiclerentals:server:removemoney', src, Config.Rental.RentalVehicleRtrnDmgFee, "bank")
                    QBCore.Functions.Notify(Config.Localization.ErrorRentalReturnedDamaged..Config.Rental.RentalVehicleRtrnDmgFee, 'error', 7000)
                end
            end
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

RegisterNetEvent('wm-vehiclerentals:client:openmenu', function(Catagory)
    local rentvehicleMenu = {
        {
            header = Config.Localization.RentalSelectionHeader,
            isMenuHeader = true
        }
    }
    if Catagory == 1 then
        for k,v in pairs(Config.RentableVehicles.Catagorys[1]) do
            rentvehicleMenu[#rentvehicleMenu+1] = {
                header = {Config.RentableVehicles.Catagorys[1][k].Label..Config.Localization.RentalSelectionRentalFeeText..Config.RentableVehicles.Catagorys[1][k].RentFee},
                txt = "",
                params = {
                    event = "wm-vehiclerentals:client:spawncar",
                    args = {
                        vehicle = Config.RentableVehicles.Catagorys[1][k].SpawnName,
                        label = Config.RentableVehicles.Catagorys[1][k].Label,
                        fee = Config.RentableVehicles.Catagorys[1][k].RentFee,
                        catagory = 1
                    }
                }
            }
        end
    elseif Catagory == 2 then
        for k,v in pairs(Config.RentableVehicles.Catagorys[2]) do
            rentvehicleMenu[#rentvehicleMenu+1] = {
                header = {Config.RentableVehicles.Catagorys[2][k].Label..Config.Localization.RentalSelectionRentalFeeText..Config.RentableVehicles.Catagorys[2][k].RentFee},
                txt = "",
                params = {
                    event = "wm-vehiclerentals:client:spawncar",
                    args = {
                        vehicle = Config.RentableVehicles.Catagorys[2][k].SpawnName,
                        label = Config.RentableVehicles.Catagorys[2][k].Label,
                        fee = Config.RentableVehicles.Catagorys[2][k].RentFee,
                        catagory = 2
                    }
                }
            }
        end
    elseif Catagory == 3 then
        for k,v in pairs(Config.RentableVehicles.Catagorys[3]) do
            rentvehicleMenu[#rentvehicleMenu+1] = {
                header = {Config.RentableVehicles.Catagorys[3][k].Label..Config.Localization.RentalSelectionRentalFeeText..Config.RentableVehicles.Catagorys[3][k].RentFee},
                txt = "",
                params = {
                    event = "wm-vehiclerentals:client:spawncar",
                    args = {
                        vehicle = Config.RentableVehicles.Catagorys[3][k].SpawnName,
                        label = Config.RentableVehicles.Catagorys[3][k].Label,
                        fee = Config.RentableVehicles.Catagorys[3][k].RentFee,
                        catagory = 3
                    }
                }
            }
        end
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
            Ped = type(Config.Locations[k].TargetPed) == "string" and GetHashKey(Config.Locations[k].TargetPed) or Ped
            RequestModel(Ped)

            while not HasModelLoaded(Ped) do
                Wait(0)
            end

            RentalPed = CreatePed(0, Ped, Config.Locations[k].GetVehicle.x, Config.Locations[k].GetVehicle.y, Config.Locations[k].GetVehicle.z-1, Config.Locations[k].GetVehicle.w, false, false)
            TaskStartScenarioInPlace(RentalPed, Config.Locations[k].TargetPedScenario, true)
            FreezeEntityPosition(RentalPed, true)
            SetEntityInvincible(RentalPed, true)
            SetBlockingOfNonTemporaryEvents(RentalPed, true)

            if Config.Locations[k].VehicleCatagory == 1 then
                exports['qb-target']:AddTargetEntity(RentalPed, {
                    options = {
                        {
                            label = Config.Localization.TargetText,
                            icon = "fa fa-car",
                            action = function()
                                TriggerEvent('wm-vehiclerentals:client:openmenu', 1)
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
            elseif Config.Locations[k].VehicleCatagory == 2 then
                exports['qb-target']:AddTargetEntity(RentalPed, {
                    options = {
                        {
                            label = Config.Localization.TargetTextAir,
                            icon = "fas fa-plane",
                            action = function()
                                TriggerEvent('wm-vehiclerentals:client:openmenu', 2)
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
            elseif Config.Locations[k].VehicleCatagory == 3 then
                exports['qb-target']:AddTargetEntity(RentalPed, {
                    options = {
                        {
                            label = Config.Localization.TargetTextWater,
                            icon = "fas fa-water",
                            action = function()
                                TriggerEvent('wm-vehiclerentals:client:openmenu', 3)
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
    end
end)
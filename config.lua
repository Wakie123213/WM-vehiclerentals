--[[
=============================================================
               Made By: Wakie Modifications 
=============================================================
--]]

Config = {
    FuelScript = "LegacyFuel", -- Change to the Fuel script you are using (For Ex. if you are using lj-fuel)
    Rental = {
        RentalRateInterval = 900, -- Everytime the player gets charged for renting the vehicle. (In Seconds) (Default 15 Mins)
        RentalVehicleRtrnDmgFee = 250, -- The fee a player has to pay if ChrgPlrFeeIfRtrnDmged is set to true. 
        ChrgPlrFeeIfRtrnDmged = true, -- If a player returns a damaged vehicle they will be charged the RentalVehicleRtrnDmgFee. (Set to false if you don't want them charged for returning a damaged vehicle)
        RentalVehicleDamagedFee = 5000, -- If the rental vehicle is destroyed, the player will pay this fee
        CheckForEngineDamage = true, -- Checks if the engine health is below 0 (If the car is blown up)
        CheckForUnderWaterVeh = true, -- Check if the vehicle is underwater (If you are having issues with this, please change it to false :)
    },
    RentableVehicles = {
        Catagorys = {
            [1] = {  -- Land Vehicle Catagory
                [1] = { -- Example One
                    SpawnName = "buffalo", -- Vehicles Spawn Name
                    Label = "Bravado Buffalo", -- Vehicles Label
                    RentFee = 85, -- The fee that will be charged at every rental rate interval
                },
                [2] = { -- Example Two
                    SpawnName = "bati", -- Vehicles Spawn Name
                    Label = "Bati 801", -- Vehicles Label
                    RentFee = 50, -- The fee that will be charged at every rental rate interval
                },
            },
            [2] = { -- Aircraft Catagory
                [1] = { -- Example One
                    SpawnName = "frogger", -- Vehicles Spawn Name
                    Label = "Frogger", -- Vehicles Label
                    RentFee = 250, -- The fee that will be charged at every rental rate interval
                },
                [2] = { -- Example Two
                    SpawnName = "cuban800", -- Vehicles Spawn Name
                    Label = "Cuban 800", -- Vehicles Label
                    RentFee = 300, -- The fee that will be charged at every rental rate interval
                },
            },
            [3] = { -- Boat Catagory
                [1] = { -- Example One
                    SpawnName = "jetmax", -- Vehicles Spawn Name
                    Label = "Jet Max", -- Vehicles Label
                    RentFee = 155, -- The fee that will be charged at every rental rate interval
                },
                [2] = { -- Example Two
                    SpawnName = "seashark3", -- Vehicles Spawn Name
                    Label = "Sea Shark", -- Vehicles Label
                    RentFee = 110, -- The fee that will be charged at every rental rate interval
                },
            }
        }
    },
    Locations = {
        [1] = { -- Example Land Rental Location
            GetVehicle = vector4(180.29, -1725.31, 29.29, 235.47), -- This is where the Ped spawns (Vector 4 Required)
            VehicleSpawn = vector4(164.82, -1730.95, 29.29, 136.25), -- Vehicle Spawn Point (Make sure its not too far away from the GetVehicle Point) (Vector 4 Required)
            TargetPed = "a_m_y_business_02", -- The ped model
            TargetPedScenario = "WORLD_HUMAN_CLIPBOARD", -- The scenario the ped is doing
            BlipEnabled = true, -- Blips Enabled
            BlipIcon = 227, -- Blip Icon
            BlipColor = 3, -- Blip Color
            BlipSize = 0.6, -- Blip Size
            BlipLabel = "Vehicle Rental", -- Label for the blip
            VehicleCatagory = 1, -- The rentable vehicle catagory that this loccation will use
        },
        [2] = { -- Example Aircraft Rental Location
            GetVehicle = vector4(-955.28, -3009.83, 13.95, 59.13), -- This is where the Ped spawns (Vector 4 Required)
            VehicleSpawn = vector4(-970.93, -3000.69, 13.95, 59.67), -- Vehicle Spawn Point (Make sure its not too far away from the GetVehicle Point) (Vector 4 Required)
            TargetPed = "s_m_y_airworker", -- The ped model
            TargetPedScenario = "WORLD_HUMAN_CLIPBOARD", -- The scenario the ped is doing
            BlipEnabled = true, -- Blips Enabled
            BlipIcon = 307, -- Blip Icon
            BlipColor = 3, -- Blip Color
            BlipSize = 0.6, -- Blip Size
            BlipLabel = "Aircraft Rental", -- Label for the blip
            VehicleCatagory = 2, -- The rentable vehicle catagory that this loccation will use
        },
        [3] = { -- Example Boat Rental Location
            GetVehicle = vector4(-781.12, -1506.4, 1.6, 315.65), -- This is where the Ped spawns (Vector 4 Required)
            VehicleSpawn = vector4(-799.62, -1504.05, -0.47, 109.17), -- Vehicle Spawn Point (Make sure its not too far away from the GetVehicle Point) (Vector 4 Required)
            TargetPed = "a_m_m_hillbilly_01", -- The ped model
            TargetPedScenario = "WORLD_HUMAN_CLIPBOARD", -- The scenario the ped is doing
            BlipEnabled = true, -- Blips Enabled
            BlipIcon = 410, -- Blip Icon
            BlipColor = 3, -- Blip Color
            BlipSize = 0.6, -- Blip Size
            BlipLabel = "Boat Rental", -- Label for the blip
            VehicleCatagory = 3, -- The rentable vehicle catagory that this loccation will use
        },
    },
    Localization = { -- Localization
        TargetText = "Rentable Vehicles",
        TargetTextAir = "Rentable Aircrafts",
        TargetTextWater = "Rentable Boats",
        TargetTextTwo = "Return A Rental",
        ErrorInVehicle = "You cannot view the rentable vehicles, while in a vehicle..",
        ErrorRentalVehicleNotNearby = "Your rental vehicle is not nearby..",
        ErrorAlreadyRenting = "You cannot get another rental, please return your previous rental..",
        ErrorNoRentalVehicle = "You are not renting any vehicles..",
        ErrorNotEnoughMoney = "You do not have enough money..",
        ErrorVehicleBroken = "Your rental vehicle has been badly damaged, you have been charged $",
        ErrorRentalReturnedDamaged = "You have returned a damaged rental vehicle, you have received an additional charge of $",
        RentalSelectionHeader = "Rentable Vehicles",
        RentalSelectionCloseButton = "Close",
        RentalSelectionRentalFeeText = " | Rental Rate $",
        RentalVehiclePlate = "RENT",
        RentalReturnedSuccess = "You have successfully returned your rental!",
        RentalSuccessNotificationOne = "You have successfully rented the ",
        RentalSuccessNotificationThr = "You will be charged the rental rate again in ",
        RentalSuccessNotificationFor = " Minutes!",
        RentalSuccessNotificationFiv = "You have been charged $",
        RentalSuccessNotificationSix = " For your rental fee!",
        RentalPapersRemovedError = "You do not have a rental certificate on you, so the rental certificate was not removed..",
    }
}
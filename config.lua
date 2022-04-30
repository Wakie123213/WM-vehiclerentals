--[[
=============================================================
               Made By: Wakie Modifications 
=============================================================
--]]

Config = {
    FuelScript = "LegacyFuel", -- Change to your Fuel script you are using (Ex. lj-fuel)
    Rental = {
        RentalRateInterval = 900, -- Everytime the player gets charged for renting the vehicle. (In Seconds) (Default 15 Mins)
        RentalVehicleDamagedFee = 5000, -- If the rental vehicle is badly damaged, the player will pay this fee
    },
    Target = {
        TargetPed = "a_m_y_business_02", -- The ped model
        TargetPedScenario = "WORLD_HUMAN_CLIPBOARD", -- The scenario the ped is doing
    },
    Blips = {
        Enabled = true, -- Blips Enabled
        Icon = 227, -- Blip Icon
        Color = 3, -- Blip Color
        Size = 0.6, -- Blip Size
        Label = "Vehicle Rental", -- Label for the blip
    },
    RentableVehicles = {
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
    Locations = {
        [1] = { -- Example Location
            GetVehicle = vector4(180.29, -1725.31, 29.29, 235.47), -- This is where the Ped spawns (Vector 4 Required)
            VehicleSpawn = vector4(164.82, -1730.95, 29.29, 136.25), -- Vehicle Spawn Point (Make sure its not too far away from the GetVehicle Point) (Vector 4 Required)
        },
    },
    Localization = { -- Localization
        TargetText = "Rent A Vehicle",
        TargetTextTwo = "Return A Rental",
        ErrorInVehicle = "You cannot view the rentable vehicles, while in a vehicle..",
        ErrorRentalVehicleNotNearby = "Your rental vehicle is not nearby..",
        ErrorAlreadyRenting = "You cannot get another rental, please return your previous rental..",
        ErrorNoRentalVehicle = "You are not renting any vehicles..",
        ErrorNotEnoughMoney = "You do not have enough money..",
        ErrorVehicleBroken = "Your rental vehicle has been badly damaged, you have been charged $",
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
        RentalPapersRemovedError = "You do not have a rental certificate on you..",
    }
}
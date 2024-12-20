--[[ 
    Configuration file for ox_fuel
    All prices and settings can be adjusted here
]]

Config = {}

-- Economy settings
Config.JerryCanPrice = 100       -- Price to purchase a jerry can
Config.RefillPrice = 50          -- Base price for refilling jerry can
Config.FuelPrice = 1.0          -- Base price per unit of fuel
Config.MaxFuelTankSize = 100.0  -- Maximum fuel tank size for vehicles

-- Fuel consumption settings
Config.FuelUsage = {
    [1.0] = 1.4,
    [0.9] = 1.2,
    [0.8] = 1.0,
    [0.7] = 0.9,
    [0.6] = 0.8,
    [0.5] = 0.7,
    [0.4] = 0.5,
    [0.3] = 0.4,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0,
}

-- Vehicle class fuel usage multipliers
Config.ClassesMultiplier = {
    [0] = 1.0,  -- Compacts
    [1] = 1.0,  -- Sedans
    [2] = 1.0,  -- SUVs
    [3] = 1.0,  -- Coupes
    [4] = 1.0,  -- Muscle
    [5] = 1.0,  -- Sports Classics
    [6] = 1.0,  -- Sports
    [7] = 1.2,  -- Super
    [8] = 0.8,  -- Motorcycles
    [9] = 1.3,  -- Off-road
    [10] = 1.5, -- Industrial
    [11] = 1.5, -- Utility
    [12] = 1.5, -- Vans
    [13] = 0.0, -- Cycles
    [14] = 1.0, -- Boats
    [15] = 1.0, -- Helicopters
    [16] = 1.0, -- Planes
    [17] = 1.2, -- Service
    [18] = 1.5, -- Emergency
    [19] = 2.0, -- Military
    [20] = 1.5, -- Commercial
    [21] = 1.0, -- Trains
}

-- Blacklisted vehicle models that don't use fuel
Config.BlacklistedVehicles = {
    'BMX',
    'CRUISER',
    'FIXTER',
    'SCORCHER',
    'TRIBIKE',
    'TRIBIKE2',
    'TRIBIKE3',
}

-- Pump models in the game world
Config.PumpModels = {
    [-2007231801] = true,
    [1339433404] = true,
    [1694452750] = true,
    [1933174915] = true,
    [-462817101] = true,
    [-469694731] = true,
    [-164877493] = true
}

-- UI Configuration
Config.ShowHUD = true           -- Enable/disable fuel HUD
Config.ShowAllStations = false  -- Show all gas stations on map
Config.ShowNearestStation = true -- Show nearest gas station only

-- Localization
Config.Locale = {
    exit_vehicle = 'Exit the vehicle to refuel',
    press_to_refuel = 'Press E to refuel vehicle',
    jerry_can_empty = 'Jerry can is empty',
    tank_full = 'Fuel tank is full',
    purchase_can = 'Press E to purchase a jerry can for $%s',
    cancel_fuel = 'Press E to stop fueling',
    not_enough_money = 'Insufficient funds',
    refill_jerry = 'Press E to refill jerry can for $%s',
    jerry_can_full = 'Jerry can is full',
    total_cost = 'Total Cost: $%s'
}

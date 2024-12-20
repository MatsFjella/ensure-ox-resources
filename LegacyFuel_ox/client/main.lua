--[[ 
    ox_fuel - Client Implementation
    Handles all client-side fuel mechanics and UI
]]

local ox_core = exports.ox_core
local ox_inventory = exports.ox_inventory

-- State variables
local nearbyPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local fuelSynced = false

-- Initialize player data and register fuel decor
local function Initialize()
    -- Register decor for fuel level persistence
    DecorRegister('_FUEL_LEVEL', 1)
    
    -- Convert blacklisted vehicles to hash table for faster lookups
    local blacklistedHashes = {}
    for _, model in ipairs(Config.BlacklistedVehicles) do
        blacklistedHashes[GetHashKey(model)] = true
    end
    Config.BlacklistedVehicles = blacklistedHashes
end

-- Calculate fuel usage based on vehicle RPM and class
local function CalculateFuelUsage(vehicle)
    if not vehicle then return 0.0 end
    
    local rpm = GetVehicleCurrentRpm(vehicle)
    local vehicleClass = GetVehicleClass(vehicle)
    
    -- Get base fuel usage from RPM
    local rpmUsage = Config.FuelUsage[math.floor(rpm * 10) / 10] or 0.0
    
    -- Apply vehicle class multiplier
    local classMultiplier = Config.ClassesMultiplier[vehicleClass] or 1.0
    
    return rpmUsage * classMultiplier
end

-- Manage vehicle fuel level
local function ManageFuel(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local model = GetEntityModel(vehicle)
    if Config.BlacklistedVehicles[model] then return end
    
    -- Initialize fuel level if not set
    if not DecorExistOn(vehicle, '_FUEL_LEVEL') then
        local fuel = math.random(200, 800) / 10
        SetFuel(vehicle, fuel)
    elseif not fuelSynced then
        SetFuel(vehicle, GetFuel(vehicle))
        fuelSynced = true
    end
    
    -- Consume fuel if engine is running
    if GetIsVehicleEngineRunning(vehicle) then
        local usage = CalculateFuelUsage(vehicle)
        local newFuel = GetFuel(vehicle) - usage
        SetFuel(vehicle, math.max(0.0, newFuel))
    end
end

-- Handle refueling from pump
local function HandlePumpRefuel(pump, ped, vehicle)
    if not pump or not vehicle then return end
    
    local vehicleFuel = GetFuel(vehicle)
    if vehicleFuel >= Config.MaxFuelTankSize then
        lib.notify({
            title = 'Fuel',
            description = Config.Locale.tank_full,
            type = 'error'
        })
        return
    end
    
    -- Start refueling animation
    TaskTurnPedToFaceEntity(ped, vehicle, 1000)
    Wait(1000)
    
    lib.progressBar({
        duration = 5000,
        label = 'Refueling...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'timetable@gardener@filling_can',
            clip = 'gar_ig_5_filling_can'
        }
    })
    
    -- Calculate cost and new fuel level
    local fuelNeeded = Config.MaxFuelTankSize - vehicleFuel
    local cost = fuelNeeded * Config.FuelPrice
    
    -- Check if player can afford
    if not ox_inventory:removeItem('money', cost) then
        lib.notify({
            title = 'Fuel',
            description = Config.Locale.not_enough_money,
            type = 'error'
        })
        return
    end
    
    -- Update fuel level
    SetFuel(vehicle, Config.MaxFuelTankSize)
    
    lib.notify({
        title = 'Fuel',
        description = string.format(Config.Locale.total_cost, cost),
        type = 'success'
    })
end

-- Export functions
function GetFuel(vehicle)
    return DecorGetFloat(vehicle, '_FUEL_LEVEL') or 0.0
end

function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0.0 and fuel <= Config.MaxFuelTankSize then
        SetVehicleFuelLevel(vehicle, fuel)
        DecorSetFloat(vehicle, '_FUEL_LEVEL', fuel)
        return true
    end
    return false
end

-- Event handlers
RegisterNetEvent('ox_fuel:refuel', function(pumpObject)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)
    
    if DoesEntityExist(vehicle) and DoesEntityExist(pumpObject) then
        HandlePumpRefuel(pumpObject, ped, vehicle)
    end
end)

-- Main thread for fuel management
CreateThread(function()
    Initialize()
    
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped)
        
        if vehicle and vehicle > 0 then
            ManageFuel(vehicle)
        end
        
        Wait(1000)
    end
end)

-- Thread for nearby pump detection
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local sleep = 1000
        
        nearbyPump = false
        
        -- Check for nearby fuel pumps
        for model in pairs(Config.PumpModels) do
            local pump = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.0, model, false, false, false)
            
            if pump and pump > 0 then
                nearbyPump = pump
                sleep = 0
                break
            end
        end
        
        Wait(sleep)
    end
end)

-- UI Thread
if Config.ShowHUD then
    CreateThread(function()
        while true do
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            
            if vehicle > 0 and not Config.BlacklistedVehicles[GetEntityModel(vehicle)] then
                local fuel = GetFuel(vehicle)
                SendNUIMessage({
                    type = 'update',
                    fuel = fuel
                })
                Wait(2000)
            else
                Wait(500)
            end
        end
    end)
end

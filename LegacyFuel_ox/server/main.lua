local ox_core = exports.ox_core
local ox_inventory = exports.ox_inventory

-- Initialize jerry can item in ox_inventory
ox_inventory:registerItem('jerrycan', {
    label = 'Jerry Can',
    weight = 2000,
    stack = false,
    close = true,
    description = 'A container for storing and transporting fuel'
})

-- Handle purchase of jerry can
lib.callback.register('ox_fuel:purchaseJerryCan', function(source)
    local player = ox_core.GetPlayer(source)
    if not player then return false end
    
    -- Check if player can afford jerry can
    if player.removeMoney('money', Config.JerryCanPrice) then
        -- Add jerry can to inventory
        return ox_inventory:addItem(source, 'jerrycan', 1)
    end
    
    return false
end)

-- Handle refilling jerry can
lib.callback.register('ox_fuel:refillJerryCan', function(source)
    local player = ox_core.GetPlayer(source)
    if not player then return false end
    
    -- Check if player has jerry can
    local jerrycan = ox_inventory:GetItem(source, 'jerrycan', nil, true)
    if not jerrycan then return false end
    
    -- Calculate refill cost based on current metadata
    local currentFuel = jerrycan.metadata?.fuel or 0
    local neededFuel = 100 - currentFuel
    local cost = math.floor(neededFuel * Config.RefillPrice)
    
    -- Check if player can afford refill
    if player.removeMoney('money', cost) then
        -- Update jerry can metadata
        return ox_inventory:SetMetadata(source, jerrycan.slot, {
            fuel = 100,
            description = 'A full jerry can'
        })
    end
    
    return false
end)

-- Handle fuel payment
lib.callback.register('ox_fuel:payFuel', function(source, cost)
    local player = ox_core.GetPlayer(source)
    if not player then return false end
    
    return player.removeMoney('money', math.floor(cost))
end)

-- Vehicle spawning system for HELIX
-- Add your downloaded vehicle blueprint assets below

-- ============================================
-- VEHICLE REGISTRY
-- Replace these with your actual Vault vehicle asset paths
-- You can find them in Build Mode > Vault > Vehicles
-- ============================================
VehicleRegistry = {
    -- Format: { name = "Display Name", asset = "package-name::BP_VehicleName" }
    -- Example entries (replace with your actual downloaded vehicles):
    { name = "Sedan",    asset = "helix-vehicles::BP_Sedan" },
    { name = "SUV",      asset = "helix-vehicles::BP_SUV" },
    { name = "Truck",    asset = "helix-vehicles::BP_Truck" },
    { name = "Sports",   asset = "helix-vehicles::BP_SportsCar" },
}

-- Active spawned vehicles tracking
SpawnedVehicles = {}

-- ============================================
-- SPAWN VEHICLE FUNCTION
-- Call: SpawnVehicle("Sedan", Vector(0, 0, 100), Rotator(0, 0, 0))
-- ============================================
function SpawnVehicle(name, location, rotation)
    for _, entry in ipairs(VehicleRegistry) do
        if entry.name == name then
            local veh = HSimpleVehicle(
                location or Vector(0, 0, 100),
                rotation or Rotator(0, 0, 0),
                entry.asset
            )
            table.insert(SpawnedVehicles, { name = name, vehicle = veh })
            print("[Vehicles] Spawned: " .. name .. " at " .. tostring(location))
            return veh
        end
    end
    print("[Vehicles] ERROR: Vehicle '" .. name .. "' not found in registry")
    return nil
end

-- ============================================
-- SPAWN VEHICLE ON COMMAND (from chat or event)
-- ============================================
-- Example: Spawn a sedan near the player when they join
Player.Subscribe("Spawn", function(player)
    Timer.SetTimeout(function()
        local char = player:GetControlledCharacter()
        if char then
            local loc = char:GetLocation()
            -- Spawn vehicle 300 units in front of the player
            local spawn_loc = Vector(loc.X + 300, loc.Y, loc.Z)
            -- Uncomment below to auto-spawn a vehicle for each player:
            -- SpawnVehicle("Sedan", spawn_loc, Rotator(0, 0, 0))
            print("[Vehicles] Player ready, vehicle spawn available")
        end
    end, 3000) -- Wait 3 seconds for character to fully load
end)

-- ============================================
-- LIST ALL REGISTERED VEHICLES
-- ============================================
function ListVehicles()
    print("[Vehicles] Registered vehicles:")
    for i, entry in ipairs(VehicleRegistry) do
        print("  " .. i .. ". " .. entry.name .. " -> " .. entry.asset)
    end
end

-- ============================================
-- DESTROY ALL SPAWNED VEHICLES
-- ============================================
function DestroyAllVehicles()
    for _, entry in ipairs(SpawnedVehicles) do
        if entry.vehicle then
            entry.vehicle:Destroy()
        end
    end
    SpawnedVehicles = {}
    print("[Vehicles] All vehicles destroyed")
end

Package.Subscribe("Load", function()
    print("[Vehicles] Vehicle system loaded with " .. #VehicleRegistry .. " vehicles registered")
    ListVehicles()
end)

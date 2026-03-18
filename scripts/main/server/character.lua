-- Character customization system for HELIX
-- Manages character mesh, animations, and appearance

-- ============================================
-- CHARACTER MESH REGISTRY
-- Replace with your actual downloaded character assets from the Vault
-- ============================================
CharacterMeshes = {
    -- Format: { name = "Display Name", asset = "package-name::SK_CharacterName" }
    { name = "Default Male",   asset = "helix::SK_Male" },
    { name = "Default Female", asset = "helix::SK_Female" },
    -- Add your downloaded character assets below:
    -- { name = "Custom Char 1", asset = "my-package::SK_CustomChar1" },
}

-- ============================================
-- SET CHARACTER MESH
-- Changes the player's character model
-- ============================================
function SetCharacterMesh(player, mesh_name)
    local char = player:GetControlledCharacter()
    if not char then
        print("[Character] ERROR: Player has no controlled character")
        return false
    end

    for _, entry in ipairs(CharacterMeshes) do
        if entry.name == mesh_name then
            char:SetMesh(entry.asset)
            print("[Character] Set " .. player:GetAccountName() .. " mesh to: " .. mesh_name)
            return true
        end
    end

    print("[Character] ERROR: Mesh '" .. mesh_name .. "' not found in registry")
    return false
end

-- ============================================
-- CHARACTER LOCATION HELPERS
-- ============================================
function TeleportPlayer(player, location)
    local char = player:GetControlledCharacter()
    if char then
        char:SetLocation(location)
        print("[Character] Teleported " .. player:GetAccountName() .. " to " .. tostring(location))
    end
end

function GetPlayerLocation(player)
    local char = player:GetControlledCharacter()
    if char then
        return char:GetLocation()
    end
    return nil
end

-- ============================================
-- CHARACTER ANIMATION
-- ============================================
function PlayPlayerAnimation(player, anim_asset)
    local char = player:GetControlledCharacter()
    if char then
        char:PlayAnimation(anim_asset)
        print("[Character] Playing animation on " .. player:GetAccountName())
    end
end

-- ============================================
-- PLAYER SPAWN SETUP
-- Customize what happens when a player's character spawns
-- ============================================
Player.Subscribe("Spawn", function(player)
    Timer.SetTimeout(function()
        local char = player:GetControlledCharacter()
        if char then
            -- Example: Set default mesh (uncomment and replace with your asset)
            -- char:SetMesh("helix::SK_Male")

            -- Example: Teleport to a spawn point
            -- char:SetLocation(Vector(0, 0, 200))

            print("[Character] Character ready for: " .. player:GetAccountName())
        end
    end, 2000)
end)

Package.Subscribe("Load", function()
    print("[Character] Character system loaded with " .. #CharacterMeshes .. " meshes registered")
end)

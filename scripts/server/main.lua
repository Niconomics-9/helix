-- Server-side Lua entry point for HELIX
-- This runs on the server and handles game logic

Package.Subscribe("Load", function()
    print("[Server] Lua server script loaded")
    
    -- Subscribe to player connection events
    Player.Subscribe("Spawn", function(player)
        print("[Server] Player spawned: " .. player:GetAccountName())
    end)
    
    Player.Subscribe("Destroy", function(player)
        print("[Server] Player left: " .. player:GetAccountName())
    end)
end)

-- Timer example
Timer.SetTimeout(function()
    print("[Server] Server has been running for 5 seconds")
end, 5000)

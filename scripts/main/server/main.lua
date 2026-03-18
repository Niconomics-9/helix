-- Server-side entry point for HELIX
-- Runs on the server, handles game logic and player events

Package.Subscribe("Load", function()
    print("[Server] Main server script loaded")

    -- Player connection events
    Player.Subscribe("Spawn", function(player)
        print("[Server] Player spawned: " .. player:GetAccountName())
    end)

    Player.Subscribe("Destroy", function(player)
        print("[Server] Player left: " .. player:GetAccountName())
    end)
end)

-- Server ready notification
Timer.SetTimeout(function()
    print("[Server] Server is ready")
end, 3000)

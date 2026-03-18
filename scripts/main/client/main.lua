-- Client-side entry point for HELIX
-- Runs on each player's client

Package.Subscribe("Load", function()
    print("[Client] Main client script loaded")
end)

-- Example: WebUI setup (uncomment when ready)
-- local my_hud = WebUI("MainHUD", "file://ui/index.html")
-- my_hud:CallEvent("init", { message = "Hello from client!" })

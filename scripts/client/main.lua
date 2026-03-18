-- Client-side Lua entry point for HELIX
-- This runs on each player's client

Package.Subscribe("Load", function()
    print("[Client] Lua client script loaded")
end)

-- Example: Create a WebUI
-- local my_ui = WebUI("MainHUD", "file://ui/index.html")
-- my_ui:CallEvent("init", { message = "Hello from Lua!" })

/**
 * @file main.js
 * @description HelixJS Server Entry Point — RPC endpoints, player events, database
 * 
 * This script runs on the HELIX server and exposes HTTP RPC endpoints
 * on port 17420 that can be called externally.
 * 
 * Endpoints available at: http://localhost:17420/rpc
 * Logs viewer at: http://localhost:17420/logs
 */

Helix.server(() => {
    console.log("[Server] HelixJS server script loaded");

    // === RPC ENDPOINTS ===
    // These can be called via HTTP POST to localhost:17420/rpc
    // Body: { "endpoint": "name", "args": [...] }

    // Health check endpoint
    Helix.endpoint("ping", () => {
        return { status: "ok", timestamp: new Date().toISOString(), server: "helix" };
    });

    // Get server info
    Helix.endpoint("serverInfo", () => {
        return {
            name: "Helix Dev Server",
            version: "1.0.0",
            uptime: process.uptime(),
            players: [] // TODO: populate with connected players
        };
    });

    // Get all registered endpoints
    Helix.endpoint("listEndpoints", () => {
        return {
            endpoints: ["ping", "serverInfo", "listEndpoints", "runLua", "getState"]
        };
    });

    // Get state data
    Helix.endpoint("getState", (key) => {
        return Helix.State.get(key);
    });

    // === PLAYER EVENTS ===
    Helix.on("PlayerJoined", (player) => {
        console.log(`[Server] Player joined: ${player}`);
    });

    console.log("[Server] RPC endpoints registered. Logs at http://localhost:17420/logs");
});

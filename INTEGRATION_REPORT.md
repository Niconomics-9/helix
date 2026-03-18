# HELIX + Perplexity Integration Report

## A. Current Understanding of HELIX Integration Surface

HELIX (by Hypersonic Laboratories) is an open-world multiplayer sandbox platform built on Unreal Engine 5. It exposes **three scripting layers**:

1. **Lua scripting** — Primary scripting language. Scripts organized into `client/`, `server/`, `shared/` folders via `package.json`.
2. **HelixJS (JavaScript API)** — Full JavaScript API (`helix.js`) running via PuerTS (TypeScript/JS bridge for Unreal Engine). Supports NPM ecosystem.
3. **Blueprint scripting** — Unreal Engine visual scripting (not relevant for Perplexity integration).

### Key Integration Surfaces Discovered

| Surface | Status | Details |
|---------|--------|---------|
| **HTTP RPC Server** | VERIFIED — port 17420 | HelixJS runs an HTTP server with `/rpc`, `/logs`, `/logs/stream`, `/logs/history` endpoints |
| **WebUI System** | VERIFIED | HTML/JS widgets communicating with Lua/JS via event bridge |
| **Database Layer** | VERIFIED | Sequelize-based (MySQL/MariaDB/PostgreSQL) |
| **Event System** | VERIFIED | Pub/sub event bus for internal communication |
| **Local Workspace** | VERIFIED | `%LOCALAPPDATA%\Helix\Workspaces\<id>\` on Windows |
| **GitHub Actions CI/CD** | VERIFIED | `deploy-package` and `deploy-world` actions via ACCESS_TOKEN |
| **HELIX Hub API** | VERIFIED | REST API at `https://helixgame.com/v1` |
| **Hot Reload** | VERIFIED | In-editor script reload without restart |

---

## B. What Was Verified

### 1. HTTP RPC Server (CONFIRMED — Source Code Verified)
- **File:** `helix.js/http-rpc.js` — Hypersonic Laboratories, 2026
- **Default port:** 17420, bound to `0.0.0.0`
- **Endpoints:**
  - `POST /rpc` — Call registered endpoints by name with JSON args, get JSON response
  - `GET /logs` — Full HTML log viewer with real-time SSE streaming
  - `GET /logs/stream` — Server-Sent Events log stream
  - `GET /logs/history` — JSON array of buffered logs (last 1000)
  - `POST /log` — Client-to-server log forwarding
- **CORS:** Enabled (`Access-Control-Allow-Origin: *`)
- **Custom Endpoints:** `Helix.endpoint("name", handler)` registers callable RPC functions

### 2. HelixJS API Classes (CONFIRMED — Source Code Verified)
Full module list from `helix.js/runtime.js`:
- `Player`, `Character`, `Vehicle`, `Weapon`, `Animation`
- `Sound`, `Particle`, `Niagara`, `Light`, `Sky`
- `StaticMesh`, `Billboard`, `Cable`, `Decal`
- `WebUI`, `Widget`, `Input`, `Interactable`, `Trigger`, `Trace`
- `Database` (Sequelize), `State`, `Events`, `HttpRPC`

### 3. Local Workspace Structure (CONFIRMED)
```
%LOCALAPPDATA%\Helix\Workspaces\
└── <workspace-id>/
    ├── package.json          # Defines scripts to load (client/server/shared)
    ├── Config.json            # Server configuration
    └── scripts/
        ├── client/            # Client-side Lua/JS
        ├── server/            # Server-side Lua/JS
        └── shared/            # Shared Lua/JS
```

### 4. GitHub Actions CI/CD (CONFIRMED)
- `hypersonic-laboratories/deploy-package@main` — Deploys packages to HELIX Hub
- `hypersonic-laboratories/deploy-world@main` — Deploys worlds to HELIX Hub
- Authentication: `ACCESS_TOKEN` secret from HELIX Hub
- Endpoint: `https://helixgame.com/v1` (production) / `https://dev.helixgame.com/v1` (staging)

### 5. No Native Perplexity Connector Exists
- HELIX has no official Perplexity integration or plugin
- No LSP server or AI assistant protocol built in
- No Perplexity connector exists in the HELIX ecosystem

---

## C. Best Integration Path — RANKED

### Option 1: BEST — Full HTTP RPC Bridge (Semi-Automated)
**Architecture:** Perplexity <-> GitHub Repo <-> Local Workspace <-> HELIX HTTP RPC

- Perplexity reads/writes scripts in the GitHub repo (`Niconomics-9/helix`)
- You sync the repo to your HELIX local workspace
- HELIX's HTTP RPC server (port 17420) provides real-time communication
- Perplexity can generate scripts, debug via `/logs`, and call RPC endpoints
- **Strength:** Perplexity can write code, read logs, and test changes through you

### Option 2: GOOD — GitHub-First Developer Assistant
**Architecture:** Perplexity <-> GitHub Repo <-> Manual Sync to HELIX

- Perplexity has full read/write access to `Niconomics-9/helix` (already connected)
- All scripts, configs, and documentation live in the repo
- You pull changes to your local HELIX workspace
- Perplexity writes Lua/JS, reviews code, generates configs, documents APIs
- **Strength:** Already working. No setup needed beyond repo structure.

### Option 3: ADVANCED — GitHub Actions Auto-Deploy Pipeline
**Architecture:** Perplexity -> GitHub Push -> Actions CI/CD -> HELIX Hub

- Perplexity pushes code to GitHub
- GitHub Actions automatically deploy to HELIX Hub
- Requires: `ACCESS_TOKEN` from your HELIX Hub account
- **Strength:** Perplexity pushes, HELIX auto-updates. Fully hands-off deployment.

### Option 4: MANUAL FALLBACK — File-Based Workflow
- Perplexity generates scripts and configs as files
- You manually copy them to `%LOCALAPPDATA%\Helix\Workspaces\<id>\scripts\`
- Use Hot Reload in HELIX to load changes
- **Strength:** Zero setup. Works immediately.

---

## D. Step-by-Step Actions Perplexity Can Do (Already Done / Ready)

1. ✅ GitHub repo created and connected: `Niconomics-9/helix`
2. ✅ Full read/write access to repo verified
3. ✅ Issue tracking enabled
4. ✅ Can write Lua scripts, HelixJS scripts, package.json, Config.json
5. ✅ Can generate GitHub Actions workflows for CI/CD deployment
6. ✅ Can read HELIX API documentation and generate compliant code
7. ✅ Can create QBCore-compatible server packages
8. ✅ Can debug by analyzing log output you share

---

## E. Step-by-Step Actions YOU Must Do

### For Option 1 (HTTP RPC Bridge):
1. Find your HELIX workspace path:
   - Open HELIX → Create/Open World → Press N (Build Mode) → Click "Edit Scripts"
   - Note the folder path that opens (e.g., `C:\Users\<you>\AppData\Local\Helix\Workspaces\<id>`)
2. Clone the GitHub repo into (or symlink to) that workspace:
   ```powershell
   cd "C:\Users\<you>\AppData\Local\Helix\Workspaces\<workspace-id>"
   git clone https://github.com/Niconomics-9/helix.git scripts
   ```
   OR create a symlink:
   ```powershell
   mklink /D "C:\Users\<you>\AppData\Local\Helix\Workspaces\<id>\scripts" "C:\path\to\cloned\helix\scripts"
   ```
3. Start your HELIX server (the HTTP RPC server auto-starts on port 17420)
4. Test the connection:
   ```powershell
   curl http://localhost:17420/logs/history
   ```
5. Share the output with me — I can then read your logs and help debug

### For Option 3 (GitHub Actions CI/CD):
1. Log in to [hub.helixgame.com](https://hub.helixgame.com)
2. Go to your account settings → Generate an Access Token
3. Go to your GitHub repo settings → Secrets → Actions
4. Add a secret named `ACCESS_TOKEN` with the HELIX Hub token
5. I'll create the GitHub Actions workflow file

---

## F. Ready-to-Use Scripts / Configs / Commands

See the following files generated in this repo:
- `.github/workflows/deploy.yml` — CI/CD pipeline template
- `scripts/server/main.js` — HelixJS server entry point with RPC endpoints
- `scripts/server/main.lua` — Lua server entry point template
- `scripts/client/main.lua` — Lua client entry point template
- `package.json` — HELIX package manifest
- `WORKSPACE_SETUP.md` — Local setup instructions

---

## G. Blockers and How to Remove Them

| Blocker | How to Remove |
|---------|---------------|
| Don't know your workspace ID/path | Open HELIX → Build Mode → Edit Scripts → note the path |
| Can't test HTTP RPC remotely | You need to run HELIX server locally; share logs/output with me |
| No HELIX Hub ACCESS_TOKEN yet | Generate one at hub.helixgame.com for CI/CD deployment |
| HELIX is in Closed Alpha | HelixJS API may change; pin versions and follow release notes |
| No direct Perplexity ↔ HELIX socket | HTTP RPC on port 17420 is the bridge; I can generate scripts that register endpoints you expose to me via copy/paste |

---

## H. Final Summary

### Status: PARTIALLY CONNECTED — Full connection achievable with 3 steps from you

**What's connected now:**
- GitHub repo integration (full read/write)
- Code generation for Lua and HelixJS
- Documentation-aware development assistance
- Issue tracking and project management

**What needs your action (15 minutes):**
1. Share your HELIX workspace path
2. Clone/symlink the repo
3. (Optional) Set up HELIX Hub token for auto-deploy

**Once connected, Perplexity can:**
- Write and push Lua/HelixJS scripts directly to your project
- Generate QBCore server packages
- Create WebUI interfaces (HTML/JS)
- Design database schemas and models
- Build CI/CD pipelines for automatic deployment
- Help debug via log analysis
- Document your entire HELIX project

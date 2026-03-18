# HELIX Workspace Setup — Connecting to Perplexity via GitHub

## Quick Start (5 minutes)

### Step 1: Find Your HELIX Workspace Path
1. Open HELIX
2. Create a World (or open an existing one)
3. Press `N` to enter Build Mode
4. Click **Edit Scripts** — this opens your workspace folder
5. Copy the folder path (e.g., `C:\Users\YourName\AppData\Local\Helix\Workspaces\abc123`)

### Step 2: Clone This Repo Into Your Workspace
Open PowerShell and run:

```powershell
# Replace <WORKSPACE_PATH> with your actual path from Step 1
cd "<WORKSPACE_PATH>"

# Clone the repo as your scripts folder
git clone https://github.com/Niconomics-9/helix.git .
```

If you already have files there, use a symlink instead:
```powershell
# Move existing scripts if needed
mv scripts scripts_backup

# Create symlink to your cloned repo's scripts folder
mklink /D scripts "C:\path\to\your\cloned\helix\scripts"
```

### Step 3: Verify HTTP RPC (When Server is Running)
With your HELIX server running, open a browser or PowerShell:

```powershell
# Check if the RPC server is running
curl http://localhost:17420/logs/history

# Call the ping endpoint
Invoke-RestMethod -Uri "http://localhost:17420/rpc" -Method POST -ContentType "application/json" -Body '{"endpoint":"ping","args":[]}'

# Open the real-time log viewer
Start-Process "http://localhost:17420/logs"
```

### Step 4 (Optional): Set Up Auto-Deploy via GitHub Actions
1. Go to [hub.helixgame.com](https://hub.helixgame.com) → Account → Access Token
2. Copy the token
3. Go to [github.com/Niconomics-9/helix/settings/secrets/actions](https://github.com/Niconomics-9/helix/settings/secrets/actions)
4. Click **New repository secret**
5. Name: `ACCESS_TOKEN`, Value: your HELIX Hub token
6. Now every push to `main` auto-deploys to HELIX Hub

## Workflow

1. Tell Perplexity what you want to build
2. Perplexity writes the code and pushes to GitHub
3. You `git pull` in your HELIX workspace (or it auto-deploys via Actions)
4. In HELIX, press **Hot Reload** to load the new scripts
5. Check logs at `http://localhost:17420/logs`
6. Share logs or issues with Perplexity for debugging

## Key Paths
- **HELIX Workspaces:** `%LOCALAPPDATA%\Helix\Workspaces\`
- **Package manifest:** `package.json` (in workspace root)
- **Server config:** `Config.json` (in workspace root)
- **HTTP RPC:** `http://localhost:17420`
- **Log viewer:** `http://localhost:17420/logs`

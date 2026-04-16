# kw-wp-factory

Kilowott's global WordPress/WooCommerce project factory.  
One command installs everything. One command starts every project.

## Install (once per machine)

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/ajajrajguruKW/kw-wp-factory/master/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/ajajrajguruKW/kw-wp-factory/master/install.ps1 | iex
```

After running either command, restart Claude Code.  
Then `/init-project` is available from any directory permanently.

### Prerequisites

The install handles most things automatically. You need these before running 
for the first time:

- **Claude Code** — [code.claude.com](https://code.claude.com)
- **Node 20+** — [nodejs.org](https://nodejs.org)
- **GitHub CLI** — installed and authenticated automatically on first run if missing

### Required MCP connections (one-time in Claude Code)

Connect these once via [claude.ai/settings](https://claude.ai/settings) → Integrations:

| MCP | Required for |
|---|---|
| **Zoho Projects** | Project creation, task tracking, QA issue logging |
| **Pencil MCP** | Block building from Pencil designs (if using Pencil workflow) |
| **Chrome DevTools MCP** | Visual QA in block build pipeline |

---

## Usage

Once installed, open Claude Code in any directory and run:
/init-project

The command will:

1. Check all prerequisites — installs GitHub CLI if missing, verifies auth
2. Ask 9 questions (takes about 60 seconds):
   - Project slug
   - Client name
   - Deal ID (from HubSpot)
   - Deal Name
   - Engagement model (Fixed Price / Retainer / T&M / Discovery)
   - WooCommerce? (yes/no)
   - PM name
   - Developer name(s)
   - ETA Kickoff date
3. Show one confirmation screen — approve or go back
4. Execute everything automatically:
   - GitHub repo created from `kw-wp-scaffold` template (private)
   - All placeholders replaced with project details
   - `PROJECT-STATUS.md` populated
   - `npm install` run
   - Hooks made executable
   - Zoho project created with all fields (Deal ID, Client Name, Engagement Model, etc.)
   - 4 Zoho tasklists created: Development, QA, Deployment, Issues & Bugs
   - Zoho IDs written back into `PROJECT-STATUS.md`
   - Initial commit pushed to GitHub

**Output:**
✅ Project ready
GitHub:  https://github.com/ajajrajguruKW/[slug]
Zoho:    https://projects.zoho.in/portal/nordicintent/...
Next: open ./[slug] in Claude Code and start building.

---

## What happens after /init-project

Open the new project directory in Claude Code. From there, the full 
command set is available:

| Command | What it does |
|---|---|
| `/wp-block [name]` | Build a Gutenberg block (Pencil or Figma → full block + QA) |
| `/wp-branch [desc]` | Create a named branch with convention |
| `/wp-task start` | Open a Zoho task, record start date |
| `/wp-task done` | Close active task, record end date |
| `/wp-task update` | Add progress note to active task |
| `/wp-review` | Code review against Kilowott standards |
| `/wp-commit` | Smart conventional commit from diff |
| `/wp-pr` | Generate and open pull request |
| `/wp-qa [fast\|full]` | 6-layer QA gate |
| `/wp-deploy staging\|production` | Deploy with all gates enforced |
| `/wp-status` | Project health snapshot from Zoho |
| `/wp-handoff` | Save session progress, prepare for context clear |

---

## How it works

This repo contains a single Claude Code skill in `.claude/skills/init-project/SKILL.md`.

The install script copies the skill into `~/.claude/skills/` on your machine. 
From that point `/init-project` is a global command available in every 
Claude Code session.

New projects are created from the **kw-wp-scaffold** template:  
[github.com/ajajrajguruKW/kw-wp-scaffold](https://github.com/ajajrajguruKW/kw-wp-scaffold)

---

## Repos

| Repo | Purpose |
|---|---|
| `ajajrajguruKW/kw-wp-factory` | This repo — global install skill |
| `ajajrajguruKW/kw-wp-scaffold` | Private GitHub Template — all new projects clone from this |

---

## Troubleshooting

**`/init-project` not found after install**  
Restart Claude Code fully after running the install script.

**GitHub CLI not authenticated**  
The skill handles this automatically — it will run `gh auth login` 
interactively if needed.

**Zoho project creation fails**  
Make sure Zoho Projects MCP is connected in Claude Code:  
claude.ai/settings → Integrations → Zoho Projects

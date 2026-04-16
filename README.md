# kw-wp-factory

Project scaffolding tool for Kilowott WordPress projects. Provides the `/init-project` skill for Claude Code that automates new project setup end-to-end.

## What it does

`/init-project` runs a guided workflow that:

1. **Preflight** — verifies `gh` CLI auth, Node.js, and GitHub account access
2. **Collects details** — project slug, client name, HubSpot deal ID/name, engagement model, WooCommerce flag, PM, developers
3. **Confirms** — single summary screen before any changes
4. **Executes**:
   - Creates a private GitHub repo from [kw-wp-scaffold](https://github.com/ajajrajguruKW/kw-wp-scaffold) template
   - Replaces all `KW_*` placeholders throughout the codebase
   - Copies `PROJECT-STATUS.md` and `.claude/settings.local.json` from templates
   - Runs `npm install`
   - Creates a Zoho Projects project (portal `60037513197`) with 4 task lists: Development, Design & Content, QA & Testing, Deployment & Launch
   - Writes Zoho IDs back into `PROJECT-STATUS.md`
   - Commits and pushes

## Setup

1. Install [Claude Code](https://claude.ai/code)
2. Clone this repo and open it in Claude Code (or add the skill globally)
3. Ensure `gh` CLI is installed and authenticated (`gh auth login`)
4. Ensure Zoho Projects MCP is connected in Claude Code

## Usage

```
/init-project
```

Follow the prompts. The skill handles everything else.

## Requirements

| Tool | Purpose |
|---|---|
| `gh` CLI | GitHub repo creation from template |
| Node.js | `npm install` in scaffolded project |
| Zoho Projects MCP | Project + task list creation |

## Template

This tool scaffolds from [ajajrajguruKW/kw-wp-scaffold](https://github.com/ajajrajguruKW/kw-wp-scaffold), which includes:

- WordPress FSE theme with Tailwind CSS + Gutenberg blocks
- Claude Code skills: `/wp-task`, `/wp-qa`, `/wp-deploy`, `/wp-status`, `/wp-block`, `/wp-branch`, `/wp-commit`, `/wp-pr`, `/wp-review`, `/wp-handoff`
- GitHub Actions CI/CD pipelines
- Security baseline with `kw-security-plugin`

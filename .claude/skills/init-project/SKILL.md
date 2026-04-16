---
name: init-project
description: Scaffold a new WordPress project from kw-wp-scaffold template, configure placeholders, create Zoho Projects project, and push to GitHub.
user-invocable: true
---

# /init-project — New WordPress Project Scaffolder

You are a project initialisation assistant. Follow every step below **in order**.
Do not skip steps. Do not assume values — always ask.

---

## Phase 1 — Preflight Checks

Run these three checks in parallel. If **any** fail, stop and tell the user what to fix.

```
gh auth status
node --version
gh api user --jq .login
```

- **gh**: must be installed and authenticated (look for "Logged in to github.com")
- **Node**: must be installed (any version)
- **GitHub account**: capture the login from `gh api user --jq .login` — store it as `$GH_USER`. Confirm the account is accessible.

If all three pass, print a green summary:

```
Preflight passed
  GitHub: $GH_USER
  Node:   vX.Y.Z
```

---

## Phase 2 — Gather Project Details

Ask the user these 8 questions using `AskUserQuestion`. Ask all 8 in a single call:

| # | Variable             | Question                                                  | Header        | Options / Notes                                                                   |
|---|----------------------|-----------------------------------------------------------|---------------|-----------------------------------------------------------------------------------|
| 1 | `PROJECT_SLUG`       | What is the project slug? (lowercase, hyphens)            | Slug          | Free text — validate: lowercase, hyphens only, no spaces                          |
| 2 | `CLIENT_NAME`        | What is the client's display name?                        | Client        | Free text                                                                         |
| 3 | `DEAL_ID`            | What is the HubSpot Deal ID?                              | Deal ID       | Free text                                                                         |
| 4 | `DEAL_NAME`          | What is the HubSpot Deal Name?                            | Deal Name     | Free text                                                                         |
| 5 | `ENGAGEMENT_MODEL`   | What is the engagement model?                             | Engagement    | Options: "Fixed Price", "Retainer", "T&M", "Discovery"                            |
| 6 | `NEEDS_WOO`          | Does this project need WooCommerce?                       | WooCommerce   | Options: "Yes", "No"                                                              |
| 7 | `PM_NAME`            | Who is the project manager?                               | PM            | Options: "Ajaj Raj Guru", "Karan Jeswani" (allow Other)                           |
| 8 | `DEV_NAMES`          | Who are the developers on this project?                   | Developers    | Options: "Ajaj Raj Guru", "Karan Jeswani" (multiSelect, allow Other)              |

After collecting answers, **validate the slug**: it must match `^[a-z][a-z0-9-]*$`. If not, ask again.

---

## Phase 3 — Confirmation Screen

Display a single confirmation block:

```
=== New Project Summary ===

  Slug:             $PROJECT_SLUG
  Client:           $CLIENT_NAME
  Deal ID:          $DEAL_ID
  Deal Name:        $DEAL_NAME
  Engagement Model: $ENGAGEMENT_MODEL
  WooCommerce:      $NEEDS_WOO
  PM:               $PM_NAME
  Developers:       $DEV_NAMES
  GitHub repo:      $GH_USER/$PROJECT_SLUG (private)
  Template:         ajajrajguruKW/kw-wp-scaffold

Proceed? (yes / no)
```

Use `AskUserQuestion` with "Yes, create it" and "No, let me change something" options.
If the user says no, go back to Phase 2.

---

## Phase 4 — Execute Setup

Run each step sequentially. If any step fails, stop and report the error.

### 4.1 — Clone from template

```bash
gh repo create $GH_USER/$PROJECT_SLUG --template ajajrajguruKW/kw-wp-scaffold --private --clone
cd $PROJECT_SLUG
```

After cloning, change the working directory into the new project folder.

### 4.2 — Replace placeholders

Search-and-replace these placeholders across **all files** in the repo (use `grep -rl` to find them, then `sed` to replace):

| Placeholder            | Replacement               |
|------------------------|---------------------------|
| `KW_PROJECT_SLUG`      | `$PROJECT_SLUG`           |
| `KW_CLIENT_NAME`       | `$CLIENT_NAME`            |
| `KW_DEAL_ID`           | `$DEAL_ID`                |
| `KW_DEAL_NAME`         | `$DEAL_NAME`              |
| `KW_ENGAGEMENT_MODEL`  | `$ENGAGEMENT_MODEL`       |
| `KW_NEEDS_WOO`         | `$NEEDS_WOO`              |
| `KW_PM_NAME`           | `$PM_NAME`                |
| `KW_DEV_NAMES`         | `$DEV_NAMES`              |
| `KW_DATE_CREATED`      | Today's date (YYYY-MM-DD) |

Use this bash pattern for each placeholder:
```bash
grep -rl 'PLACEHOLDER' . --include='*' | xargs sed -i 's/PLACEHOLDER/REPLACEMENT/g'
```

Skip `.git/` directory. Be careful with special characters in client names — escape them for sed.

### 4.3 — Copy template files

```bash
cp PROJECT-STATUS.md.template PROJECT-STATUS.md
cp .claude/settings.local.json.template .claude/settings.local.json
```

Then run the same placeholder replacement on these two new files.

### 4.4 — Install dependencies

```bash
npm install
```

### 4.5 — Make hooks executable

```bash
chmod +x .claude/hooks/*.sh 2>/dev/null || true
```

### 4.6 — Create Zoho Project

Use the Zoho Projects MCP tools (either `mcp__548d36a9-c518-4b73-9c50-a051a482c44b__ZohoProjects_*` or `mcp__de778a69-53b2-4401-b64f-c5f2ab800324__*` — whichever is connected).

**Portal ID**: `60037513197` (hardcoded — this is the Kilowott portal).

**Step 1**: Create the project:
```
createProject({
  portal_id: "60037513197",
  body: {
    name: "$CLIENT_NAME — $PROJECT_SLUG",
    description: "WordPress project for $CLIENT_NAME\n\nDeal ID: $DEAL_ID\nDeal Name: $DEAL_NAME\nEngagement Model: $ENGAGEMENT_MODEL\nProject Manager: $PM_NAME\nDevelopers: $DEV_NAMES\nWooCommerce: $NEEDS_WOO",
    start_date: "YYYY-MM-DD",  // today
    custom_fields: {
      deal_id: "$DEAL_ID",
      deal_name: "$DEAL_NAME",
      client_name: "$CLIENT_NAME",
      engagement_model: "$ENGAGEMENT_MODEL",
      project_manager: "$PM_NAME",
      project_status: "In Backlog",
      invoicing_type: "Non-Billable",
      stage: "Discovery",
      url_staging: "TBD",
      url_live: "TBD",
      seo: "NA",
      sm_engagement: "NA",
      design_adherence: "NA"
    }
  }
})
```

> **Note on custom fields**: The Zoho Projects API may use UDF (User Defined Field) keys
> like `UDF_CHAR1`, `UDF_CHAR2`, etc. instead of semantic names. Before calling createProject,
> check the project layout for the correct UDF field mappings. If the API rejects `custom_fields`,
> map each value to its corresponding `UDF_CHAR` / `UDF_LONG` / `UDF_TEXT` key based on
> the portal's field configuration. Include all fields in the `body` at the top level:
> ```
> body: {
>   name: "...",
>   UDF_CHAR1: "$DEAL_ID",
>   UDF_CHAR2: "$DEAL_NAME",
>   ...
> }
> ```

**Step 2**: Create 4 task lists in the new project:

| Task List Name       |
|----------------------|
| Development          |
| Design & Content     |
| QA & Testing         |
| Deployment & Launch  |

```
createTaskList({
  portal_id: "60037513197",
  project_id: $ZOHO_PROJECT_ID,
  body: { name: "Development", flag: "internal" }
})
// repeat for each task list
```

Capture the Zoho project ID and all 4 task list IDs.

**Step 3**: Write Zoho IDs back into `PROJECT-STATUS.md`. Add or update a section:

```markdown
## Zoho

- Portal ID: 60037513197
- Project ID: $ZOHO_PROJECT_ID
- Project URL: https://projects.zoho.in/portal/nordicintent/project/$ZOHO_PROJECT_ID
- Task Lists:
  - Development: $TL_DEV_ID
  - Design & Content: $TL_DESIGN_ID
  - QA & Testing: $TL_QA_ID
  - Deployment & Launch: $TL_DEPLOY_ID
```

### 4.7 — Commit and push

```bash
git add .
git commit -m "chore: initialise $PROJECT_SLUG"
git push origin master
```

**Important**: This is an authorised push as part of project scaffolding — the user confirmed in Phase 3.

---

## Phase 5 — Output Summary

Print a clean summary:

```
=== Project Created ===

  Repo:    https://github.com/$GH_USER/$PROJECT_SLUG
  Zoho:    https://projects.zoho.in/portal/nordicintent/project/$ZOHO_PROJECT_ID
  Local:   ./$PROJECT_SLUG

  Deal:    $DEAL_NAME ($DEAL_ID)
  Model:   $ENGAGEMENT_MODEL
  Stage:   Discovery

Next steps:
  1. cd $PROJECT_SLUG
  2. Review PROJECT-STATUS.md
  3. Start development with /plan
```

---

## Error Handling

- If `gh repo create` fails because the template doesn't exist yet, tell the user:
  "Template repo ajajrajguruKW/kw-wp-scaffold not found. Create it first or specify a different template."
- If Zoho Projects MCP is not connected, skip Phase 4.6 and note it in the summary:
  "Zoho project was not created — Zoho Projects MCP not connected. Create manually."
- If `npm install` fails, continue but warn the user.
- Never leave a half-created GitHub repo without telling the user.

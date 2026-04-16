Write-Host "Installing kw-wp-factory skills..."
$skillPath = "$env:USERPROFILE\.claude\skills\init-project"
New-Item -ItemType Directory -Force $skillPath | Out-Null
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/ajajrajguruKW/kw-wp-factory/master/.claude/skills/init-project/SKILL.md" `
  -OutFile "$skillPath\SKILL.md"
Write-Host "Done. Restart Claude Code then run /init-project"

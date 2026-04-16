#!/bin/bash
set -e
echo "Installing kw-wp-factory skills..."
mkdir -p ~/.claude/skills/init-project
curl -fsSL https://raw.githubusercontent.com/ajajrajguruKW/kw-wp-factory/master/.claude/skills/init-project/SKILL.md \
  -o ~/.claude/skills/init-project/SKILL.md
echo "✅ Done. Restart Claude Code then run /init-project"

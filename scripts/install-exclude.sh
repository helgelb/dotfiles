#!/usr/bin/env bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Because dotfiles is a *bare repo*, tracked files live in the HOME directory
TEMPLATE="$HOME/scripts/exclude-template"
BACKUP_TEMPLATE="$HOME/scripts/exclude-template.backup"

# Actual exclude file inside the bare repo
EXCLUDE_FILE="$DOTFILES_DIR/info/exclude"

if [ ! -f "$TEMPLATE" ]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

mkdir -p "$(dirname "$EXCLUDE_FILE")"

# Create backup of installed exclude if exists
if [ -f "$EXCLUDE_FILE" ]; then
  echo "Backing up current exclude to $EXCLUDE_FILE.bak"
  cp "$EXCLUDE_FILE" "$EXCLUDE_FILE.bak"
fi

cp "$TEMPLATE" "$EXCLUDE_FILE"

cp "$TEMPLATE" "$BACKUP_TEMPLATE"

echo "Exclude file has been installed from template:"
echo "  $EXCLUDE_FILE"
echo "Backup template updated:"
echo "  $BACKUP_TEMPLATE"

#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
WORK_TREE="${WORK_TREE:-$HOME}"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Dotfiles repo not found at: $DOTFILES_DIR" >&2
  echo "Clone it first, e.g.:" >&2
  echo "  git clone --bare git@github.com:<you>/<dotfiles-repo>.git \"$DOTFILES_DIR\"" >&2
  exit 1
fi

config() {
  /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$WORK_TREE" "$@"
}

echo "Checking out dotfiles into $WORK_TREE"

conflicts=$(config checkout 2>&1 || true)

if echo "$conflicts" | grep -q "would be overwritten by checkout"; then
  echo "Conflicts detected. Backing up existing files to ~/.dotfiles-backup"
  backup_dir="$HOME/.dotfiles-backup"
  mkdir -p "$backup_dir"

  echo "$conflicts" | grep "^\s" | sed 's/^\s*//' | while read -r path; do
    if [ -e "$WORK_TREE/$path" ]; then
      mkdir -p "$backup_dir/$(dirname "$path")"
      mv "$WORK_TREE/$path" "$backup_dir/$path"
      echo "  Moved $path -> $backup_dir/$path"
    fi
  done

  echo "Retrying checkout after backup"
  config checkout
fi

echo "Setting Git option: hide untracked files for this bare repo"
config config status.showUntrackedFiles no

# Install the exclude file from template
if [ -x "$DOTFILES_DIR/scripts/install-exclude.sh" ]; then
  echo "Installing exclude file from template"
  "$DOTFILES_DIR/scripts/install-exclude.sh"
fi

# Ensure the alias is in your zshrc
SHELL_RC="$HOME/.zshrc"
ALIAS_LINE="alias config='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'"

if ! grep -q "alias config=" "$SHELL_RC" 2>/dev/null; then
  echo "Adding 'config' alias to $SHELL_RC"
  printf '\n%s\n' "$ALIAS_LINE" >>"$SHELL_RC"
else
  echo "'config' alias already present in $SHELL_RC"
fi

echo "Done. Open a new shell or run: source $SHELL_RC"
echo "You can now use:  config status"

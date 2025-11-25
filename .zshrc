# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path corrections
export PATH="/opt/nvim-linux-x86_64/bin:$HOME/.local/bin:$PATH"

# Extra completions
fpath=("$HOME/.zsh-completions" $fpath)

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster_custom"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  z
  history-substring-search
  zsh-autosuggestions
  fzf
  fast-syntax-highlighting
  poetry
) 

# Use up/down arrows for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll='ls -alF'
alias l='ls -CF'

alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# History configuration
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Azure CLI completion
autoload -U +X bashcompinit && bashcompinit

if [[ -f /etc/bash_completion.d/azure-cli ]]; then
  source /etc/bash_completion.d/azure-cli
fi

# --- Quick navigation helpers ---
cproj() {
  cd "$HOME/projects" && ls
}

# Jump to a specific project (adjust path when monorepo is ready)
corigo() {
  cd "$HOME/projects/origo-mdm-platform" 2>/dev/null || {
    echo "origo-mdm-platform not found under ~/projects"
    return 1
  }
  ls
}

# Python / cleanup helpers
pyclean() {
  # Remove Python cache files and __pycache__ dirs from current tree
  find . -type d -name '__pycache__' -prune -exec rm -rf '{}' + \
    -o -type f -name '*.py[co]' -delete
}

# Run Poetry and auto-use local .venv if present
poy() {
  if [[ -d ".venv" ]]; then
    source .venv/bin/activate 2>/dev/null || true
  fi
  poetry "$@"
}

# Neovim helpers
# Open Neovim in current directory
v() {
  nvim .
}

# Open Neovim with a specific file if given, otherwise current dir
vv() {
  if [[ -n "$1" ]]; then
    nvim "$@"
  else
    nvim .
  fi
}

# --- nvm setup ---
export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
# Load nvm bash_completion (optional)
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Dotfiles management (bare repo at ~/.dotfiles)
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

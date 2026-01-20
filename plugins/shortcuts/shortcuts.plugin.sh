#!/usr/bin/env bash
# Shortcuts plugin for Oh My Dev
# Provides convenient aliases for common commands
#
# USAGE:
# Simply enable this plugin in your OMD_PLUGINS array:
#   export OMD_PLUGINS=(shortcuts)
#
# All aliases will be automatically available in your shell.

# ============================================================================
# Shell Management
# ============================================================================

# Reload current shell
alias reload="exec \$SHELL -l"

# ============================================================================
# File Listing & Navigation
# ============================================================================

# List all files including hidden
alias lsa="ls -ah"

# List with details
alias ll="lsd -l"

# List all with details
alias lla="lsd -la"

# ============================================================================
# Git Shortcuts
# ============================================================================

# Quick git operations
alias gita="git add ."
alias gitb="git branch"
alias gitc="git commit -m"
alias gitco="git checkout"
alias gitd="git diff"
alias gitl="git log --oneline --graph --decorate"
alias gitp="git pull"
alias gitpu="git push"
alias gits="git status"
alias gitr="git remote -v"

# ============================================================================
# Search Tools
# ============================================================================

# fd-find alias (works when installed as fdfind)
if command -v fdfind >/dev/null 2>&1; then
  alias fd="fdfind"
fi

# Enhanced fzf with useful flags
if command -v fzf >/dev/null 2>&1; then
  alias fzf="fzf -x --multi --cycle --reverse"
fi

# Colorful recursive grep
alias grp="grep --color=auto -Rni"

# ============================================================================
# File Operations
# ============================================================================

# Recursive copy
alias cp="cp -r"

# Force remove files/directories (use with caution!)
alias rm="rm -r"
alias rmf="rm -rf"

# ============================================================================
# Docker Shortcuts
# ============================================================================

# List all containers
alias dps="docker ps -a"

# Stop all running containers
alias dstop='docker stop $(docker ps -q)'

# Run container interactively
alias drun="docker run -it --rm"

# Remove all images (use with caution!)
alias drmall='docker rmi -f $(docker images -q)'

# Docker compose shortcut
alias dcp="docker-compose"

# ============================================================================
# System Shortcuts
# ============================================================================

# Quick system info
alias sysinfo="uname -a"

# Disk usage human-readable
alias duh="du -h --max-depth=1"

# Disk free human-readable
alias dfh="df -h"

# Process search
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# ============================================================================
# Network Shortcuts
# ============================================================================

# Show open ports
alias ports="netstat -tulanp"

# Ping with 5 packets
alias ping5="ping -c 5"

# ============================================================================
# Productivity Shortcuts
# ============================================================================

# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Quick backup of a file
backup() {
  local file="$1"
  if [[ -f "$file" ]]; then
    cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: ${file}.backup.$(date +%Y%m%d_%H%M%S)"
  else
    echo "Error: File not found: $file" >&2
    return 1
  fi
}

# ============================================================================
# History Shortcuts
# ============================================================================

# Show command history with grep
alias hg="history | grep"

# Clear history
alias hc="history -c"

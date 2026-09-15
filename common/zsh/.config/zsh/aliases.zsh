# ── Alias ───────────────────────────────────────────────────
# Fichiers
if _has eza; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -l --icons=auto --group-directories-first --git --time-style=relative'
  alias la='ll -a'
  alias lt='eza --tree --level=2 --icons=auto --git-ignore'
fi
_has bat && alias cat='bat --paging=never'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'

# Recherche (les commandes d'origine restent accessibles avec \grep, \find)

# Git (repris des alias Oh My Zsh les plus courants)
alias g='git'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gswc='git switch -c'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias glog='git log --oneline --decorate --graph'
alias grb='git rebase'
alias gsta='git stash push'
alias gstp='git stash pop'
_has lazygit && alias lg='lazygit'

# Divers
alias reload='exec zsh'
alias dotfiles='cd ~/Projets/lozit/dotfiles'
_has claude && alias claude-mem='bun "$(ls -d $HOME/.claude/plugins/cache/thedotmack/claude-mem/*/ | tail -1)scripts/worker-service.cjs"'

# macOS
if [[ $OSTYPE == darwin* ]]; then
  alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
fi

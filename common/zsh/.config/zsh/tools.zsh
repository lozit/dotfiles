# ── Outils ──────────────────────────────────────────────────
_has() { command -v "$1" >/dev/null 2>&1; }

# mise : versions de node, ruby, go, python… (remplace nvm et rbenv)
_has mise && eval "$(mise activate zsh)"

# fzf — thème Catppuccin Mocha + fd pour lister les fichiers
if _has fzf; then
  export FZF_DEFAULT_OPTS=" \
    --height=60% --layout=reverse --border=rounded --info=inline \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A,border:#6C7086,label:#CDD6F4"
  if _has fd; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=always {}'"
  source <(fzf --zsh)    # Ctrl+T fichiers · Alt+C dossiers · Ctrl+R (repris par atuin)
fi

# zoxide : navigation (z <nom>)
_has zoxide && eval "$(zoxide init zsh)"

# atuin : historique enrichi — Ctrl+R (chargé après fzf pour garder Ctrl+R)
_has atuin && eval "$(atuin init zsh --disable-up-arrow)"

# bat comme pager des pages man
if _has bat; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# Secrets depuis le trousseau macOS — voir ~/.config/shell/secrets.sh (hors dépôt)
[[ -f $HOME/.config/shell/secrets.sh ]] && source "$HOME/.config/shell/secrets.sh"

# bun
[[ -s $HOME/.bun/_bun ]] && source "$HOME/.bun/_bun"

# Prompt Starship (en dernier)
_has starship && eval "$(starship init zsh)"

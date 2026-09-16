# ── Environnement ───────────────────────────────────────────
export EDITOR="zed --wait"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R --mouse"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# PATH (sans doublons grâce à typeset -U)
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  $path
)

# Sur Linux (Omarchy), zed peut s'appeler zeditor
if [[ $OSTYPE == linux* ]] && ! command -v zed >/dev/null && command -v zeditor >/dev/null; then
  export EDITOR="zeditor --wait" VISUAL="zeditor --wait"
fi

# pnpm : commandes globales
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
path=("$PNPM_HOME/bin" "$PNPM_HOME" $path)

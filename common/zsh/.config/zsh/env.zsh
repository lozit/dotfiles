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

# macOS: ssh-askpass shows the dialog required by AddKeysToAgent confirm.
# Its brew service does not reliably set SSH_ASKPASS at login, and SIP stops
# it from restarting the launchd ssh-agent, so do both here when missing.
# Killing the agent is safe: launchd restarts it on demand with the new env.
if [[ $OSTYPE == darwin* ]] && [[ -x /opt/homebrew/opt/ssh-askpass/bin/ssh-askpass ]] \
  && [[ -z $(launchctl getenv SSH_ASKPASS) ]]; then
  launchctl setenv SSH_ASKPASS /opt/homebrew/opt/ssh-askpass/bin/ssh-askpass
  launchctl setenv SUDO_ASKPASS /opt/homebrew/opt/ssh-askpass/bin/ssh-askpass
  launchctl setenv DISPLAY ssh-askpass
  pkill -u $UID -f '^/usr/bin/ssh-agent -l$'
fi

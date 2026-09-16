# ── Point d'entrée, sourcé par ~/.zshrc ────────────────────
ZDOTCONF="${${(%):-%x}:A:h}"

for f in env options completion tools plugins aliases omarchy; do
  source "$ZDOTCONF/$f.zsh"
done

# Réglages propres à la machine, non versionnés
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"

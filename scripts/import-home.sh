#!/usr/bin/env bash
# À lancer UNE fois sur le Mac : copie ~/.zshrc, ~/.gitconfig et génère le Brewfile
# dans le dépôt, puis cherche d'éventuels secrets avant le premier commit.
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

[[ -f ~/.zshrc    && ! -L ~/.zshrc    ]] && cp ~/.zshrc    "$DOTFILES/common/zsh/.zshrc"    && echo "✓ .zshrc"
[[ -f ~/.gitconfig && ! -L ~/.gitconfig ]] && mkdir -p "$DOTFILES/common/git" && cp ~/.gitconfig "$DOTFILES/common/git/.gitconfig" && echo "✓ .gitconfig"
command -v brew >/dev/null && brew bundle dump --force --file="$DOTFILES/macos/Brewfile" && echo "✓ Brewfile"

# Chemins absolus → $HOME
sed -i '' "s|/Users/$USER|\$HOME|g" "$DOTFILES/common/zsh/.zshrc" 2>/dev/null || true

echo
echo "── Recherche de secrets potentiels (à relire !) ──"
grep -rnIE '(api[_-]?key|token|secret|passw(or)?d|bearer|sk-[a-z0-9]|ghp_|glpat-|xox[bp]-|AKIA[0-9A-Z]{12})' \
  "$DOTFILES/common" "$DOTFILES/macos" --exclude=Brewfile || echo "Rien de suspect trouvé."
if command -v gitleaks >/dev/null; then
  gitleaks dir "$DOTFILES" --no-banner || true
else
  echo "(Conseil : brew install gitleaks pour une vérification plus sérieuse)"
fi

#!/usr/bin/env bash
# Installe les dotfiles avec GNU Stow.
#   ./install.sh            → common/* + paquets de l'OS courant
#   ./install.sh --dry-run  → montre ce qui serait fait
# Les fichiers réels déjà présents sont déplacés dans ~/.dotfiles-backup/<date>/
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY=""; [[ "${1:-}" == "--dry-run" ]] && DRY="-n"

case "$OSTYPE" in
  darwin*) OS_DIR="macos" ;;
  linux*)  OS_DIR="omarchy" ;;
  *) echo "OS non géré : $OSTYPE"; exit 1 ;;
esac

if ! command -v stow >/dev/null; then
  if [[ -n $DRY ]]; then
    echo "(stow n'est pas installé : il le sera lors du vrai lancement)"
  elif [[ $OS_DIR == macos ]]; then brew install stow
  else sudo pacman -S --needed stow; fi
fi

BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

stow_dir() {
  local dir="$1"
  [[ -d "$DOTFILES/$dir" ]] || return 0
  for pkg in "$DOTFILES/$dir"/*/; do
    [[ -d "$pkg" ]] || continue
    pkg="$(basename "$pkg")"

    # Sauvegarde des vrais fichiers qui bloqueraient Stow
    while IFS= read -r -d '' f; do
      rel="${f#"$DOTFILES/$dir/$pkg/"}"
      target="$HOME/$rel"
      if [[ -e "$target" && ! -L "$target" ]]; then
        echo "  sauvegarde : ~/$rel"
        if [[ -z $DRY ]]; then
          mkdir -p "$BACKUP/$(dirname "$rel")"
          mv "$target" "$BACKUP/$rel"
        fi
      fi
    done < <(find "$DOTFILES/$dir/$pkg" -type f ! -name .gitkeep ! -name .DS_Store -print0)

    echo "→ $dir/$pkg"
    if [[ -n $DRY ]]; then
      # En aperçu rien n'est déplacé, donc stow verrait des conflits : on liste simplement les liens prévus
      while IFS= read -r -d '' f; do
        echo "  lien       : ~/${f#"$DOTFILES/$dir/$pkg/"}"
      done < <(find "$DOTFILES/$dir/$pkg" -type f ! -name .gitkeep ! -name .DS_Store -print0)
    else
      stow -d "$DOTFILES/$dir" -t "$HOME" --ignore='\.gitkeep' --ignore='\.DS_Store' "$pkg"
    fi
  done
}

stow_dir common
stow_dir "$OS_DIR"

if [[ $OS_DIR == macos && -z $DRY ]]; then
  if [[ -f "$DOTFILES/macos/Brewfile" ]] && [[ "${INSTALL_BREW:-0}" == 1 ]]; then
    brew bundle --file="$DOTFILES/macos/Brewfile"
  fi
  if [[ -f "$HOME/.config/sketchybar/helpers/next_event.swift" && ! -x "$HOME/.config/sketchybar/helpers/next_event" ]]; then
    echo "→ compilation de next_event (SketchyBar)"
    (cd "$HOME/.config/sketchybar/helpers" && swiftc -O next_event.swift -o next_event \
      -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker Info.plist)
  fi
  command -v sketchybar >/dev/null && sketchybar --reload || true
fi

[[ -d "$BACKUP" ]] && echo "Anciennes versions sauvegardées dans $BACKUP"
echo "Terminé."

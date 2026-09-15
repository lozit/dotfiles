# dotfiles

Mes fichiers de configuration pour **macOS** et **Omarchy** (Arch Linux), gérés avec [GNU Stow](https://www.gnu.org/software/stow/).

## Organisation

```
common/          # partagé entre les machines
  git/           #   ~/.gitconfig, ~/.config/git/ignore
  zsh/           #   ~/.zshrc
macos/           # uniquement sur le Mac
  sketchybar/    #   ~/.config/sketchybar
  Brewfile       #   paquets Homebrew (non stowé)
omarchy/         # uniquement sur la machine Omarchy (à remplir)
install.sh       # stow common/* + le dossier de l'OS courant
scripts/         # outils ponctuels
```

Chaque sous-dossier de `common/`, `macos/` ou `omarchy/` est un **paquet Stow** : son arborescence reproduit celle de `~`.
Ex. `macos/sketchybar/.config/sketchybar/sketchybarrc` → `~/.config/sketchybar/sketchybarrc`.

Les petites différences entre OS dans un fichier commun se gèrent directement dedans :

```sh
if [[ $OSTYPE == darwin* ]]; then
  # macOS
else
  # Linux
fi
```

## Installation

```sh
git clone git@github.com:lozit/dotfiles.git ~/Projets/lozit/dotfiles
cd ~/Projets/lozit/dotfiles
./install.sh --dry-run   # aperçu
./install.sh             # crée les liens (les fichiers existants sont sauvegardés dans ~/.dotfiles-backup/)
INSTALL_BREW=1 ./install.sh   # macOS : installe aussi le Brewfile
```

## Ajouter une config

```sh
# ex. ~/.config/aerospace/aerospace.toml sur le Mac
mkdir -p macos/aerospace/.config/aerospace
mv ~/.config/aerospace/aerospace.toml macos/aerospace/.config/aerospace/
./install.sh
```

Mettre à jour le Brewfile : `brew bundle dump --force --file=macos/Brewfile`

## SketchyBar

Barre transparente minimaliste : prochain rendez-vous (Calendrier macOS) à gauche ; CPU, RAM, réseau, volume, batterie et heure à droite ; workspaces AeroSpace si installé.

Le prochain rendez-vous est lu par un petit binaire Swift (`helpers/next_event.swift`) compilé automatiquement par `install.sh`. Au premier lancement, macOS demande l'accès au Calendrier.

## Secrets

**Aucun secret dans ce dépôt (public).** Les tokens vivent dans le trousseau macOS et sont chargés par `~/.config/shell/secrets.sh`, qui reste hors dépôt. Avant de committer : `gitleaks dir .`

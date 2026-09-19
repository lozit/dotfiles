# dotfiles

Mes fichiers de configuration pour **macOS** et **Omarchy** (Arch Linux), gérés avec [GNU Stow](https://www.gnu.org/software/stow/).

Thème partout : **Catppuccin Mocha**. Police : **JetBrains Mono Nerd Font** (terminal, code) et **iA Writer Duo** (écriture).

- [Organisation](#organisation) · [Installation](#installation) · [Ajouter une config](#ajouter-une-config)
- **[Aide-mémoire des commandes](#aide-mémoire-des-commandes)**
- [Raccourcis clavier](#raccourcis-clavier) · [Applications configurées](#applications-configurées) · [Secrets](#secrets)

---

## Organisation

```
common/            # partagé entre Mac et Omarchy
  zsh/             #   ~/.zshrc, ~/.zprofile, ~/.config/zsh/*.zsh
  git/             #   ~/.gitconfig, exclusions globales, thème delta
  starship/        #   prompt
  atuin/ bat/ btop/ mise/ nvim/ tmux/ topgrade/
macos/             # uniquement sur le Mac
  Brewfile         #   paquets Homebrew (non relié par Stow)
  sketchybar/ borders/ ghostty/ karabiner/ typora/
omarchy/           # uniquement sur Omarchy (à remplir)
scripts/           # scripts ponctuels (non reliés par Stow)
wallpapers/        # fonds d'écran (non reliés par Stow)
install.sh         # relie common/* + le dossier de l'OS courant
```

Chaque sous-dossier de `common/`, `macos/` ou `omarchy/` est un **paquet Stow** : son arborescence reproduit celle de `~`.
Ex. `macos/ghostty/.config/ghostty/config` → `~/.config/ghostty/config`.

Différences entre OS dans un fichier commun :

```sh
if [[ $OSTYPE == darwin* ]]; then
  # macOS
else
  # Linux
fi
```

Réglages propres à une machine, **non versionnés** : `~/.gitconfig.local` (adresse e-mail Git), `~/.zshrc.local`.

## Installation

```sh
git clone git@github.com:lozit/dotfiles.git ~/Projets/lozit/dotfiles
cd ~/Projets/lozit/dotfiles
./install.sh --dry-run          # aperçu
./install.sh                    # crée les liens (fichiers existants sauvegardés dans ~/.dotfiles-backup/)
INSTALL_BREW=1 ./install.sh     # macOS : installe aussi tout le Brewfile
printf '[user]\n\temail = moi@exemple.fr\n' > ~/.gitconfig.local
```

`install.sh` peut être relancé autant de fois que nécessaire.

**Mac neuf, en plus :**

```sh
./scripts/touchid-sudo.sh       # Touch ID pour sudo (y compris dans tmux)
./scripts/macos-defaults.sh     # réglages Finder, Dock, clavier… (relire le script avant)
```

**Omarchy :** installer les paquets avec `pacman`, puis `./install.sh`. Ne pas changer le shell avec `chsh` : ajouter `command = /usr/bin/zsh` dans la config du terminal.

## Ajouter une config

```sh
# ex. AeroSpace sur le Mac
mkdir -p macos/aerospace/.config/aerospace
mv ~/.config/aerospace/aerospace.toml macos/aerospace/.config/aerospace/
./install.sh
```

Mettre à jour le Brewfile après avoir installé ou supprimé quelque chose :

```sh
brew bundle dump --force --file=macos/Brewfile
```

---

## Aide-mémoire des commandes

> Astuce : `tldr <commande>` affiche des exemples concrets pour presque n'importe quelle commande.

### Maintenance

| Commande | Ce que ça fait |
|---|---|
| `topgrade` | **Met tout à jour** : Homebrew, mise, npm, plugins zsh et Neovim, App Store… puis nettoie |
| `dotfiles` | Aller dans ce dépôt |
| `reload` | Recharger la config zsh après une modification |
| `zsh-plugins-update` | Mettre à jour les plugins zsh (fzf-tab, autosuggestions, coloration) |
| `mup` | Mettre à jour les langages gérés par mise |
| `brew bundle dump --force --file=macos/Brewfile` | Enregistrer la liste des paquets installés |
| `bat cache --build` | Recharger les thèmes de bat après en avoir ajouté un |
| `flushdns` | Vider le cache DNS de macOS |

### Se déplacer

| Commande | Ce que ça fait |
|---|---|
| `cd nom` | Aller dans un dossier ; si le chemin n'existe pas, saute vers un dossier récent portant ce nom |
| `z nom` | Sauter vers un dossier récent par son nom (zoxide) |
| `zi` | Choisir un dossier récent dans une liste interactive |
| `Projets` | Taper un nom de dossier seul suffit pour y aller |
| `..`  `...`  `....` | Remonter de 1, 2 ou 3 niveaux |
| `cd -` puis `Tab` | Liste des derniers dossiers visités |
| `try nom` | Crée ou retrouve un dossier d'expérience daté dans `~/Projets/tries` |

### Fichiers

| Commande | Ce que ça fait |
|---|---|
| `ls` | Liste détaillée avec icônes (eza) |
| `lsa` | Pareil, fichiers cachés inclus |
| `ll` / `la` | Liste avec statut Git et dates relatives / avec fichiers cachés |
| `lt` / `lta` | Arborescence sur 2 niveaux / avec fichiers cachés |
| `cat fichier` | Affiche avec coloration syntaxique et numéros de ligne (bat) |
| `ff` | Chercher un fichier avec aperçu, affiche son chemin |
| `eff` | Chercher un fichier et l'ouvrir dans l'éditeur |
| `n` / `n fichier` | Ouvrir Neovim sur le dossier courant / sur un fichier |
| `dust` | Ce qui prend de la place dans le dossier courant, en arborescence |
| `compress dossier` | Créer `dossier.tar.gz` |
| `decompress archive.tar.gz` | Extraire une archive `.tar.gz` |
| `mkdir a/b/c` | Crée les dossiers intermédiaires automatiquement |

### Chercher

| Commande | Ce que ça fait |
|---|---|
| `rg motif` | Chercher du texte dans les fichiers (ignore `.git`, `node_modules`) |
| `rg -i motif -t py` | Insensible à la casse, uniquement dans les fichiers Python |
| `fd nom` | Trouver des fichiers par nom |
| `fd -e md` | Tous les fichiers `.md` |
| `\grep`, `\find` | Les commandes d'origine restent disponibles |

### Historique

| Commande / touche | Ce que ça fait |
|---|---|
| `Ctrl+R` | Recherche dans tout l'historique (atuin) ; `Ctrl+R` à nouveau change le filtre (tout / dossier / session) |
| `↑` / `↓` | Historique filtré par ce qui est déjà tapé |
| `→` ou `Ctrl+Espace` | Accepter la suggestion grisée |
| ` commande` (espace devant) | La commande n'est pas enregistrée dans l'historique |
| `atuin stats` | Les commandes que tu utilises le plus |

### Git

**Interfaces**

| Commande | Ce que ça fait |
|---|---|
| `lg` | **lazygit** : interface Git complète au clavier (`?` pour l'aide) |
| `git diff`, `git log -p`, `git show` | Diffs lisibles avec delta ; `n` / `N` pour passer d'un fichier à l'autre |

**Alias**

| Alias | Commande |
|---|---|
| `g` | `git` |
| `gst` | `git status` |
| `gaa` | `git add --all` |
| `gdf` / `gds` | `git diff` / `git diff --staged` |
| `gc` / `gca` | `git commit -v` / `git commit -v --amend` |
| `gcm "msg"` | `git commit -m "msg"` |
| `gcam "msg"` | `git commit -a -m "msg"` (tous les fichiers suivis) |
| `gcad` | `git commit -a --amend` |
| `gco` / `gsw` / `gswc nom` | `checkout` / `switch` / créer et basculer sur une branche |
| `gb` | `git branch` (branches les plus récentes en premier) |
| `gl` / `gp` / `gpf` | `pull` (rebase) / `push` / `push --force-with-lease` |
| `glog` | Historique compact en graphe |
| `grb` | `git rebase` |
| `gsta` / `gstp` | Mettre de côté / récupérer des modifications (stash) |
| `git st`, `co`, `br`, `ci` | Alias Git classiques (`status`, `checkout`, `branch`, `commit`) |

**Worktrees** (travailler sur plusieurs branches en parallèle, dans des dossiers séparés)

| Commande | Ce que ça fait |
|---|---|
| `ga ma-branche` | Crée `../projet--ma-branche` sur une nouvelle branche et s'y place |
| `gd` | Depuis ce dossier : supprime le worktree et sa branche (après confirmation) |

**Réglages automatiques** : `git pull` fait un rebase, le premier `git push` crée la branche distante, Git mémorise et réapplique les résolutions de conflits, le diff s'affiche pendant l'écriture du message de commit.

### Terminal multiple : tmux

| Commande | Ce que ça fait |
|---|---|
| `t` | Rouvrir la session tmux « Work », ou la créer |
| `tdl cx` | Disposition de travail : Neovim à gauche, Claude à droite, terminal en bas |
| `tdl cx cx` | Pareil avec deux Claude superposés |
| `tdlm cx` | Une fenêtre `tdl` par sous-dossier du dossier courant |
| `tsl 4 "commande"` | 4 panneaux en mosaïque qui lancent la même commande |
| `tmux ls` | Lister les sessions |

Raccourcis tmux : voir [plus bas](#tmux).

### Éditeur : Neovim (LazyVim)

| Commande | Ce que ça fait |
|---|---|
| `n` | Ouvrir Neovim sur le dossier courant |
| `:Lazy` | Gérer les plugins |
| `:LazyExtras` | Activer des modules prêts à l'emploi (langages, outils) |
| `:checkhealth` | Diagnostiquer un problème |

Raccourcis Neovim : voir [plus bas](#neovim-lazyvim).

### Docker (OrbStack)

| Commande | Ce que ça fait |
|---|---|
| `d` | `docker` (ex. `d ps`, `d compose up -d`) |
| `lazydocker` | Interface au clavier : conteneurs, logs, stats, redémarrage |
| `docker context ls` | Vérifier que le contexte `orbstack` est actif |
| `orb` | Commandes OrbStack (machines Linux légères : `orb create ubuntu`) |

### Réseau et SSH

| Commande | Ce que ça fait |
|---|---|
| `ssh serveur` | Comme d'habitude, mais nettoie le terminal et **se reconnecte** si la connexion tombe (`Ctrl+C` pour arrêter) |
| `fip serveur 5432 3000` | Rendre les ports distants accessibles sur `localhost` |
| `lip` | Lister les redirections actives |
| `dip 5432` | Fermer une redirection |
| `sff serveur:/tmp/` | Choisir un fichier (les plus récents en premier) et l'envoyer par `scp` |

### Système

| Commande | Ce que ça fait |
|---|---|
| `btop` | Moniteur CPU, RAM, disque, réseau, processus (`h` aide, `q` quitter) |
| `fastfetch` | Résumé visuel de la machine |
| `mise use node@22` | Fixer la version de Node pour le projet courant (idem `ruby`, `python`, `go`…) |
| `mise ls` | Versions installées |
| `sudo …` | Validation par **Touch ID**, y compris dans tmux |

### Petits outils

| Commande | Ce que ça fait |
|---|---|
| `tldr tar` | Exemples concrets d'utilisation d'une commande |
| `man git` | Pages de manuel en couleur |
| `jq '.name' fichier.json` | Lire et filtrer du JSON (`curl … \| jq`) |
| `gum confirm "Continuer ?"` | Menus, confirmations, saisies jolies dans les scripts shell |
| `op read "op://Coffre/Élément/champ"` | Lire un secret 1Password depuis le terminal |
| `magick image.heic image.jpg` | Convertir une image (ImageMagick) |
| `tesseract scan.png sortie -l fra` | Extraire le texte d'une image (OCR) |
| `cx` | Lancer Claude |
| `h` | Lancer herdr |

---

## Raccourcis clavier

### Ligne de commande (zsh)

| Touche | Action |
|---|---|
| `Ctrl+R` | Historique (atuin) |
| `Ctrl+T` | Insérer un chemin de fichier (fzf, avec aperçu) |
| `Option+C` | Aller dans un sous-dossier (fzf, avec aperçu) |
| `Tab` | Complétion avec aperçu (fzf-tab) ; `<` `>` pour changer de groupe |
| `Option+←` / `Option+→` | Mot précédent / suivant |
| `Ctrl+A` / `Ctrl+E` | Début / fin de ligne |
| `Ctrl+W` / `Ctrl+U` | Effacer le mot précédent / la ligne |

### Ghostty

| Touche | Action |
|---|---|
| `Ctrl+`\` | Terminal déroulant, depuis n'importe quelle app |
| `Cmd+D` / `Cmd+Shift+D` | Couper la fenêtre verticalement / horizontalement |
| `Cmd+Option+flèches` | Passer d'un panneau à l'autre |
| `Cmd+Shift+Entrée` | Agrandir / réduire le panneau courant |
| `Cmd+T` / `Cmd+W` | Nouvel onglet / fermer |
| Sélection à la souris | Copiée automatiquement |

### tmux

Préfixe : **`Ctrl+Espace`** (ou `Ctrl+B`). `Préfixe ?` affiche tous les raccourcis.

| Touche | Action |
|---|---|
| `Option+Entrée` / `Option+Shift+Entrée` | Couper verticalement / horizontalement |
| `Option+Échap` | Fermer le panneau |
| `Ctrl+Option+flèches` | Changer de panneau |
| `Ctrl+Option+Shift+flèches` | Redimensionner le panneau |
| `Option+1…9` | Aller à la fenêtre 1…9 |
| `Option+←` / `Option+→` | Fenêtre précédente / suivante |
| `Option+↑` / `Option+↓` | Session précédente / suivante |
| `Préfixe c` / `Préfixe k` | Nouvelle fenêtre / fermer la fenêtre |
| `Préfixe r` / `Préfixe R` | Renommer la fenêtre / la session |
| `Préfixe C` / `Préfixe K` | Nouvelle session / fermer la session |
| `Préfixe d` | Se détacher (la session continue en arrière-plan) |
| `Préfixe [` puis `v` … `y` | Mode copie : sélectionner puis copier |
| `Préfixe q` | Recharger la config |

> Dans tmux, `Option+←` / `Option+→` changent de fenêtre au lieu de sauter d'un mot.

### Neovim (LazyVim)

Touche leader : **`Espace`** (attendre une seconde affiche le menu).

| Touche | Action |
|---|---|
| `Espace Espace` | Chercher un fichier |
| `Espace s g` | Chercher dans le contenu des fichiers |
| `Espace e` | Afficher / masquer l'arborescence (`a` nouveau fichier, `A` dossier, `?` aide) |
| `Ctrl+W W` | Passer de l'arborescence à l'éditeur |
| `Shift+H` / `Shift+L` | Onglet (buffer) précédent / suivant |
| `Espace b d` / `Espace b o` | Fermer l'onglet / fermer les autres |
| `Espace g g` | lazygit dans une fenêtre flottante |
| `Espace u w` | Retour à la ligne automatique |
| `:w` / `:q` / `:wq` | Enregistrer / quitter / les deux |

Tous les raccourcis : [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps)

### lazygit

| Touche | Action |
|---|---|
| `Espace` | Ajouter / retirer un fichier de l'index |
| `Entrée` sur un fichier | Choisir des lignes précises à ajouter |
| `c` | Committer |
| `P` / `p` | Push / pull |
| `?` | Tous les raccourcis de l'écran courant |

### macOS

| Touche | Action |
|---|---|
| **Caps Lock maintenu** | **Super** (`Ctrl+Option+Cmd`) ; avec `Shift` : Super+Shift. Voir AeroSpace ci-dessous |
| Caps Lock appui court | Caps Lock normal (majuscules accentuées É È À) |
| `Espace` sur un fichier dans le Finder | Aperçu Quick Look (code coloré, Markdown rendu) |
| `Cmd+Shift+.` dans le Finder | Afficher / masquer les fichiers cachés |
| `Ctrl+Cmd+glisser` | Déplacer une fenêtre en la saisissant n'importe où |

### AeroSpace (espaces)

**Super** = Caps Lock maintenu (`Ctrl+Option+Cmd`, via Karabiner).

AeroSpace ne gère **que les espaces** : toutes les fenêtres sont flottantes. Pas de mosaïque automatique, donc les onglets natifs du Finder et de Ghostty ne sont plus comptés comme des fenêtres. Le placement des fenêtres est fait par **Tinycast** (`Ctrl+Option` + flèches).

| Raccourci | Action |
|---|---|
| `Super+1…9` | Aller à l'espace 1 à 9 |
| `Super+Shift+1…9` | Envoyer la fenêtre vers l'espace (et la suivre) |
| `Super+Tab` / `Super+Shift+Tab` | Espace suivant / précédent |
| `Super+flèches` | Focus sur la fenêtre voisine |
| `Super+W` | Fermer la fenêtre |
| `Super+Entrée` | Terminal (Ghostty) |
| `Super+Shift+Entrée` | Navigateur (Firefox Developer Edition) |
| `Super+Shift+F` | Finder |
| `Super+Shift+N` | Éditeur (Zed) |
| `Super+Shift+O` | Obsidian |
| `Super+Shift+W` | Typora |
| `Super+Shift+D` | lazydocker |
| `Super+Shift+R` | Recharger la config AeroSpace |

> Dans `aerospace.toml`, les touches portent leur nom **QWERTY** (position physique) : la touche W d'un clavier AZERTY s'appelle `z`, les touches `)` et `-` à droite du 0 s'appellent `minus` et `equal`. Pour un nouveau raccourci, éviter `a`, `z`, `q`, `w` et `m`, qui ne sont pas au même endroit.

---

## Applications configurées

| App | Config | Notes |
|---|---|---|
| **zsh** | `common/zsh` | Sans Oh My Zsh : Starship, fzf-tab, autosuggestions, coloration syntaxique. Alias : `aliases.zsh`, `omarchy.zsh` |
| **Starship** | `common/starship` | Dossier, branche et état Git, versions des langages, durée des commandes > 2 s |
| **Git + delta** | `common/git` | Adresse e-mail dans `~/.gitconfig.local` |
| **atuin** | `common/atuin` | Synchro chiffrée possible entre machines : `atuin register` / `atuin login` |
| **mise** | `common/mise` | Remplace nvm et rbenv ; lit `.nvmrc` et `.ruby-version` |
| **Neovim** | `common/nvim` | LazyVim + Catppuccin, comme sur Omarchy |
| **tmux** | `common/tmux` | Config d'Omarchy, couleurs Catppuccin |
| **btop** | `common/btop` | Config d'Omarchy, touches vim |
| **topgrade** | `common/topgrade` | Sans images Docker ni mises à jour macOS |
| **Ghostty** | `macos/ghostty` | Pas de commentaire en fin de ligne dans ce fichier |
| **AeroSpace** | `macos/aerospace` | Espaces 0 à 9 uniquement, toutes les fenêtres flottantes (`config-version = 2`). Revenir à la mosaïque : voir les commentaires en fin de `aerospace.toml` |
| **Tinycast** | — | Lanceur, presse-papiers, snippets et placement des fenêtres (remplace Raycast). Réglages dans `~/Library/Preferences/com.tinycast.app.plist` : non versionnés, à exporter depuis *Settings → Backup* |
| **SketchyBar** | `macos/sketchybar` | Prochain rendez-vous (binaire Swift compilé par `install.sh`), CPU, RAM, réseau, volume, batterie, heure, workspaces AeroSpace |
| **JankyBorders** | `macos/borders` | Bordures des fenêtres active et inactives (`bordersrc`), lancé par AeroSpace. Appliquer : `pkill borders; ~/.config/borders/bordersrc &` |
| **Karabiner** | `macos/karabiner` | Règle Super sur Caps Lock. Après toute modification : *Complex Modifications* → **Remove**, **Add predefined rule**, **Enable** |
| **Typora** | `macos/typora` | Texte en iA Writer Duo, code en JetBrains Mono |
| **Obsidian** | — | Police réglée à la main, par coffre : *Apparence → Police* |

### Scripts

| Script | Rôle |
|---|---|
| `scripts/touchid-sudo.sh` | Touch ID pour `sudo`, y compris dans tmux |
| `scripts/macos-defaults.sh` | Réglages macOS commentés ; les options en commentaire sont à activer au besoin |
| `scripts/import-home.sh` | Importer `.zshrc`, `.gitconfig` et générer le Brewfile (première mise en place) |

## Secrets

**Aucun secret dans ce dépôt (public).** Les tokens vivent dans le trousseau macOS et sont chargés par `~/.config/shell/secrets.sh`, hors dépôt. Chaque commit est vérifié par **ggshield** ; scan manuel : `ggshield secret scan path -r .`

# Tinycast — sauvegarde des réglages

Tinycast est une app native : ses réglages vivent dans `~/Library/Preferences/com.tinycast.app.plist`
(binaire, mêlé à de l'état interne) et l'historique du presse-papiers dans une base SQLite.
Rien de tout ça ne se versionne avec Stow — d'où ce dossier, qui n'est **pas** un paquet Stow.

## Où mettre l'export

L'export de Tinycast (`.tinycast`) est un **binaire** : on ne peut pas relire ce qu'il contient
avant de le publier, et il peut renfermer des snippets ou des quicklinks personnels.
Ce dépôt étant **public**, il n'y a pas sa place — d'où le `.gitignore` de ce dossier.

À ranger plutôt dans un endroit privé et sauvegardé, par exemple `~/Sync/tinycast/`
(Syncthing), Proton Drive ou un gestionnaire de mots de passe.

## Exporter (après chaque changement de réglages)

Tinycast → Settings → Backup → Export, puis enregistrer le fichier `.tinycast`
à l'endroit privé choisi ci-dessus.

## Restaurer sur une machine neuve

1. `brew trust --tap abue-ammar/tinycast && brew tap abue-ammar/tinycast`
2. `brew install --cask tinycast` (Apple Silicon, macOS 26+ ; sinon `tinycast-universal`)
3. Si macOS bloque l'app (auto-signée) : `xattr -dr com.apple.quarantine "/Applications/Tinycast.app"`
4. Settings → Backup → Import, choisir le fichier `.tinycast` sauvegardé

## Raccourcis retenus

| Raccourci | Action |
|---|---|
| (réglé dans Settings → General) | Ouvrir la palette |
| `Tab` dans la palette | Basculer Apps / Presse-papiers |
| `Ctrl+Option+V` | Historique du presse-papiers |
| `Ctrl+Option+flèches` | Moitiés d'écran |
| `Ctrl+Option+U/I/J/K` | Quarts d'écran |
| `Ctrl+Option+Entrée` | Plein écran |
| `Ctrl+Option+C` | Centrer |

Les espaces sont les Spaces natifs de macOS (`Ctrl+1…9`, à activer dans *Réglages → Clavier → Raccourcis → Mission Control*).

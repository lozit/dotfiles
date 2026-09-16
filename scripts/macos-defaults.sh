#!/usr/bin/env bash
# Réglages macOS en ligne de commande. À relancer sans risque.
# Pour annuler un réglage : defaults delete <domaine> <clé>, puis relancer l'app concernée.
# Les lignes commentées sont des options à activer si elles te conviennent.
set -euo pipefail

osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

echo "→ Clavier"
defaults write NSGlobalDomain KeyRepeat -int 2         # répétition rapide (défaut : 6)
defaults write NSGlobalDomain InitialKeyRepeat -int 15 # délai avant répétition (défaut : 25)
# Appui long sur une lettre = menu des accents (é, è, ê…). On le garde, utile en français.
# Pour que l'appui long répète la lettre à la place :
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Désactiver les guillemets et tirets « intelligents » (pratique pour le code) :
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "→ Fenêtres et panneaux"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true # « Enregistrer » déplié
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true # « Imprimer » déplié
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false  # enregistrer sur le disque, pas iCloud
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false # pas d'animation à l'ouverture
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true         # Ctrl+Cmd+glisser déplace une fenêtre (AeroSpace)
defaults write NSGlobalDomain _HIHideMenuBar -bool true                      # barre des menus masquée (SketchyBar)

echo "→ Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true     # extensions toujours visibles
defaults write com.apple.finder ShowPathbar -bool true              # barre de chemin
defaults write com.apple.finder ShowStatusBar -bool true            # barre d'état
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # chemin complet dans le titre
defaults write com.apple.finder _FXSortFoldersFirst -bool true      # dossiers en premier
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # vue liste par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # rechercher dans le dossier courant
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Fichiers cachés toujours visibles (sinon Cmd+Shift+. les affiche à la demande) :
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # pas de .DS_Store sur le réseau
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true     # ni sur les clés USB
chflags nohidden ~/Library

echo "→ Dock et Spaces"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0           # apparition immédiate
defaults write com.apple.dock autohide-time-modifier -float 0.3 # animation plus courte
defaults write com.apple.dock show-recents -bool false          # pas d'apps récentes dans le Dock
defaults write com.apple.dock mru-spaces -bool false            # ne pas réordonner les Spaces (AeroSpace)
defaults write com.apple.dock expose-group-apps -bool true      # Mission Control groupé par app (AeroSpace)

echo "→ Divers"
defaults write com.apple.TextEdit RichText -int 0 # TextEdit en texte brut
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
# Toucher pour cliquer sur le trackpad :
# defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
echo "✓ Terminé. Certains réglages (clavier) demandent de fermer la session."

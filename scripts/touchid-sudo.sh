#!/usr/bin/env bash
# Touch ID pour sudo, y compris dans tmux (pam-reattach).
# /etc/pam.d/sudo_local survit aux mises à jour de macOS. À relancer sans risque.
set -euo pipefail

command -v brew >/dev/null || { echo "Homebrew requis"; exit 1; }
brew list pam-reattach >/dev/null 2>&1 || brew install pam-reattach

REATTACH="$(brew --prefix)/lib/pam/pam_reattach.so"
[[ -f $REATTACH ]] || { echo "pam_reattach.so introuvable : $REATTACH"; exit 1; }

sudo tee /etc/pam.d/sudo_local >/dev/null <<PAM
# sudo_local — généré par dotfiles/scripts/touchid-sudo.sh
auth       optional       $REATTACH ignore_ssh
auth       sufficient     pam_tid.so
PAM

echo "✓ Touch ID activé pour sudo. Test : ouvre un nouveau terminal puis « sudo -k && sudo true »"

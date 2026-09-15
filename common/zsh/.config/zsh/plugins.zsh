# ── Plugins (sans gestionnaire) ─────────────────────────────
# Clonés automatiquement au premier lancement dans ~/.local/share/zsh/plugins
# Mise à jour : zsh-plugins-update
ZPLUGINDIR="$XDG_DATA_HOME/zsh/plugins"

_zplug() {   # _zplug <user/repo> <fichier à sourcer>
  local repo=$1 file=$2 dir="$ZPLUGINDIR/${1:t}"
  if [[ ! -d $dir ]]; then
    print -P "%F{blue}→ installation de $repo%f"
    git clone --depth=1 --quiet "https://github.com/$repo" "$dir" || return
  fi
  source "$dir/$file"
}

zsh-plugins-update() {
  for d in "$ZPLUGINDIR"/*(/); do
    print -P "%F{blue}→ ${d:t}%f"; git -C "$d" pull --ff-only --quiet
  done
}

# L'ordre compte : fzf-tab après compinit, coloration syntaxique en dernier
_zplug Aloxaf/fzf-tab                           fzf-tab.plugin.zsh
_zplug zsh-users/zsh-autosuggestions            zsh-autosuggestions.zsh
source "$ZDOTCONF/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"
_zplug zsh-users/zsh-syntax-highlighting        zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
bindkey '^ ' autosuggest-accept      # Ctrl+Espace accepte la suggestion

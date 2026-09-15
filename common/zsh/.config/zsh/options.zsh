# ── Options du shell ────────────────────────────────────────
# Historique
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY        # horodatage
setopt SHARE_HISTORY           # partagé entre terminaux ouverts
setopt HIST_IGNORE_ALL_DUPS    # pas de doublons
setopt HIST_IGNORE_SPACE       # commande précédée d'un espace = non enregistrée
setopt HIST_REDUCE_BLANKS

# Navigation
setopt AUTO_CD                 # taper un nom de dossier suffit pour y aller
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT   # cd -<Tab> pour revenir en arrière

# Divers
setopt INTERACTIVE_COMMENTS    # autorise les # dans les commandes tapées
setopt NO_BEEP
setopt GLOB_DOTS               # la complétion inclut les fichiers cachés
setopt EXTENDED_GLOB           # motifs avancés (utilisés par la complétion)

# Clavier (mode emacs + flèches qui cherchent selon le début tapé)
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[1;3D' backward-word      # Option/Alt + ←
bindkey '^[[1;3C' forward-word       # Option/Alt + →
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[[3~' delete-char          # touche Suppr

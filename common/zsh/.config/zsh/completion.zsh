# ── Complétion ──────────────────────────────────────────────
# Complétions fournies par Homebrew / paquets (ex. docker, gh, ghostty)
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)
[[ -d /opt/homebrew/share/zsh-completions ]] && fpath=(/opt/homebrew/share/zsh-completions $fpath)

autoload -Uz compinit
# Recalcul du cache une fois par jour seulement (ouverture plus rapide)
_zcomp="$XDG_CACHE_HOME/zsh/zcompdump"
[[ -d ${_zcomp:h} ]] || mkdir -p ${_zcomp:h}
if [[ -n ${_zcomp}(#qN.mh+24) ]]; then compinit -d "$_zcomp"; else compinit -C -d "$_zcomp"; fi
unset _zcomp

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'   # insensible à la casse
zstyle ':completion:*' menu no                                                 # fzf-tab s'en charge
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# fzf-tab : aperçus
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:(zed|bat|cat|less|nvim|vim):*' fzf-preview '[[ -d $realpath ]] && eza -1 --color=always --icons=always $realpath || bat --color=always --style=numbers --line-range=:200 $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --graph --color=always $word | head -50'

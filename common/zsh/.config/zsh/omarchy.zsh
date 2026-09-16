# ── Alias et fonctions repris d'Omarchy ─────────────────────
# Source : github.com/basecamp/omarchy — default/bash/aliases et default/bash/fns/
# Adaptés pour zsh et macOS (les fonctions spécifiques à Linux sont retirées).

# ── Fichiers ────────────────────────────────────────────────
if _has eza; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# ff : chercher un fichier avec aperçu · eff : l'ouvrir dans l'éditeur
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'
# sff <destination> : envoyer par scp un fichier choisi (les plus récents en premier)
sff() {
  (( $# == 0 )) && { echo "Usage: sff <destination> (ex. sff serveur:/tmp/)"; return 1; }
  local file
  file=$(fd --type f --hidden --exclude .git -X ls -t | ff) && [[ -n $file ]] && scp "$file" "$1"
}

# cd : dossier normal, sinon saut par nom avec zoxide (« cd dotfiles »)
if _has zoxide; then
  alias cd='zd'
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    else
      if ! z "$@"; then
        echo "Error: Directory not found"
        return 1
      fi
      printf "\U000F17A9 "
      pwd
    fi
  }
fi

alias ....='cd ../../..'

# ── Outils ──────────────────────────────────────────────────
alias d='docker'
alias t='tmux attach || tmux new -s Work'
alias h='herdr'
alias cx='claude'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
n() { if (( $# == 0 )); then command nvim . ; else command nvim "$@"; fi; }

# ── Git ─────────────────────────────────────────────────────
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# ga <branche> : nouveau worktree + branche, à côté du dépôt (../projet--branche)
ga() {
  [[ -z $1 ]] && { echo "Usage: ga [branch name]"; return 1; }
  local branch="$1" base="${PWD:t}"
  local wt_path="../${base}--${branch}"
  git worktree add -b "$branch" "$wt_path" || return
  _has mise && mise trust "$wt_path"
  builtin cd "$wt_path"
}

# gd : supprimer le worktree courant et sa branche (avec confirmation)
gd() {
  gum confirm "Remove worktree and branch?" || return
  local cwd="$PWD" worktree="${PWD:t}"
  local root="${worktree%%--*}" branch="${worktree#*--}"
  # Garde-fou : ne rien faire hors d'un dossier « projet--branche »
  if [[ $root != "$worktree" ]]; then
    builtin cd "../$root"
    git worktree remove "$cwd" --force || return 1
    git branch -D "$branch"
  fi
}

# ── Compression ─────────────────────────────────────────────
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# ── Redirection de ports SSH ────────────────────────────────
# fip <hôte> <port…> : ouvrir · dip <port…> : fermer · lip : lister
fip() {
  (( $# < 2 )) && { echo "Usage: fip <host> <port1> [port2] ..."; return 1; }
  local host="$1"; shift
  local port
  for port in "$@"; do
    ssh -f -N -L "${port}:localhost:${port}" "$host" && echo "Forwarding localhost:$port -> $host:$port"
  done
}
dip() {
  (( $# == 0 )) && { echo "Usage: dip <port1> [port2] ..."; return 1; }
  local port
  for port in "$@"; do
    pkill -f "ssh.*-L ${port}:localhost:${port}" && echo "Stopped forwarding port $port" || echo "No forwarding on port $port"
  done
}
lip() { pgrep -lf "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"; }

# ── tmux : dispositions de travail ──────────────────────────
# tdl <ia> [ia2] : éditeur + IA à droite + terminal en bas (ex. « tdl cx »)
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <cx|autre_ia> [<second_ia>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }
  local current_dir="$PWD" editor_pane ai_pane ai2_pane ai="$1" ai2="$2"
  editor_pane="$TMUX_PANE"
  tmux rename-window -t "$editor_pane" "${current_dir:t}"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi
  tmux send-keys -t "$ai_pane" "$ai" C-m
  tmux send-keys -t "$editor_pane" "nvim ." C-m
  tmux select-pane -t "$editor_pane"
}

# tdlm <ia> [ia2] : une fenêtre tdl par sous-dossier du dossier courant
tdlm() {
  [[ -z $1 ]] && { echo "Usage: tdlm <cx|autre_ia> [<second_ia>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }
  local ai="$1" ai2="$2" base_dir="$PWD" first=true dir pane_id
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"
  for dir in "$base_dir"/*(/N); do
    if $first; then
      tmux send-keys -t "$TMUX_PANE" "cd '$dir' && tdl $ai $ai2" C-m
      first=false
    else
      pane_id=$(tmux new-window -c "$dir" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
    fi
  done
}

# tsl <n> <commande> : n panneaux en mosaïque lançant la même commande
tsl() {
  [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }
  local count="$1" cmd="$2" current_dir="$PWD" new_pane pane
  local -a panes
  tmux rename-window -t "$TMUX_PANE" "${current_dir:t}"
  panes+=("$TMUX_PANE")
  while (( ${#panes} < count )); do
    new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[1]}" tiled
  done
  for pane in "${panes[@]}"; do tmux send-keys -t "$pane" "$cmd" C-m; done
  tmux select-pane -t "${panes[1]}"
}

# ── SSH : nettoyage du terminal et reconnexion automatique ──
# Si une session interactive tombe (tmux/herdr distant…), le terminal est remis
# en état et ssh se reconnecte (Ctrl+C pour arrêter).
ssh() {
  local rc started=$SECONDS
  command ssh "$@"
  rc=$?
  [[ -t 1 ]] || return $rc
  _ssh_disarm
  if (( rc != 255 )) || [[ ! -t 0 ]] || ! _ssh_interactive "$@" || (( SECONDS - started < 30 )); then
    return $rc
  fi
  (
    while true; do
      echo "Connection lost. Reconnecting (Ctrl-C to stop)..."
      sleep 2
      command ssh "$@"
      rc=$?
      _ssh_disarm
      (( rc != 255 )) && exit $rc
    done
  )
}
_ssh_disarm() { printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1004l\e[?1049l\e[?25h'; }
_ssh_interactive() {
  local value_opts="BbcDEeFIiJLlmOoPpQRSWw"
  local -a all_args=("$@")
  local arg letters i dest="" opts_done="" resolved
  while (( $# )); do
    arg="$1"; shift
    if [[ -z $opts_done && $arg == "--" ]]; then
      opts_done=1
    elif [[ -z $opts_done && $arg == -?* ]]; then
      letters="${arg#-}"
      for (( i = 1; i <= ${#letters}; i++ )); do
        if [[ $value_opts == *"${letters[i]}"* ]]; then
          (( i == ${#letters} )) && shift
          break
        fi
      done
    elif [[ -z $dest ]]; then
      dest="$arg"
    else
      return 1
    fi
  done
  [[ -n $dest ]] || return 1
  resolved=$(command ssh -G "${all_args[@]}" 2>/dev/null) || return 1
  ! grep -i '^remotecommand ' <<<"$resolved" | grep -qvi '^remotecommand none$'
}

# ~/.zprofile — lu par les shells de connexion (avant ~/.zshrc)

# Homebrew (macOS uniquement)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Les secrets (trousseau macOS) sont chargés dans ~/.zshrc

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

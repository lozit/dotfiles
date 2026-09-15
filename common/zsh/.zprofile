# ~/.zprofile — lu par les shells de connexion (avant ~/.zshrc)

# Homebrew (macOS uniquement)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Les secrets (trousseau macOS) sont chargés dans ~/.zshrc

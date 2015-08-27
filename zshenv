# Don't load default zshrc
setopt no_global_rcs

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"

# Move zsh config to $XDG_CONFIG_HOME
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# This .bash_profile makes loads the non-interactive login features and later
# adds the interactive login features.

# Load the non-interactive login features
[[ -f ~/.bashrc ]] && source ~/.bashrc

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/config
source ~/.bash/functions

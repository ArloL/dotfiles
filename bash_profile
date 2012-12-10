# This .bash_profile makes an interactive shell start off like a non-interactive shell
# and then adds interactive features.

# Load the non-interactive base
[[ -f ~/.bashrc ]] && source ~/.bashrc

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/config
source ~/.bash/functions

if [ "$TERM" != "dumb" ]; then
  hash dircolors 2>/dev/null
  if [ $? -eq 0 ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dir_colors`
  fi
fi

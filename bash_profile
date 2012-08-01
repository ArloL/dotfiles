# This .bash_profile makes an interactive shell start off like a non-interactive shell
# and then adds interactive features.

# Load the non-interactive base
[[ -f ~/.bashrc ]] && source ~/.bashrc

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/config
source ~/.bash/functions

if [ "$TERM" != "dumb" ]; then
  command -v dircolors >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dir_colors`
  fi
fi

# Load RVM into a shell session *as a function*
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

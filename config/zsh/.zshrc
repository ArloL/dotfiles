# powerlevel10k
if [ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

source "$XDG_CONFIG_HOME/zsh/config"
source "$XDG_CONFIG_HOME/zsh/interactive"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

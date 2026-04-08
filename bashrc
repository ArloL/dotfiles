#!/bin/sh

# Environment setup — runs once per session
if [ -z "$BASHRC_LOADED" ]; then
    export XDG_CONFIG_HOME="${HOME}/.config"

    . "${XDG_CONFIG_HOME}/bash/paths"
    . "${XDG_CONFIG_HOME}/bash/config"

    export BASHRC_LOADED=1
fi

# Interactive setup — runs whenever this shell is interactive
case $- in
    *i*)
        . "${XDG_CONFIG_HOME}/bash/paths-interactive"
        . "${XDG_CONFIG_HOME}/bash/aliases"
        . "${XDG_CONFIG_HOME}/bash/completions"
        . "${XDG_CONFIG_HOME}/bash/functions"
        ;;
esac

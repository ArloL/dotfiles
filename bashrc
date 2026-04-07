#!/bin/sh

if [ -n "${X_BASHRC_LOADED}" ]; then
    return
fi

# Environment variables
export XDG_CONFIG_HOME="${HOME}/.config"

. "${XDG_CONFIG_HOME}/bash/paths"
. "${XDG_CONFIG_HOME}/bash/config"
. "${XDG_CONFIG_HOME}/bash/aliases"
. "${XDG_CONFIG_HOME}/bash/completions"
. "${XDG_CONFIG_HOME}/bash/functions"

export X_BASHRC_LOADED=1

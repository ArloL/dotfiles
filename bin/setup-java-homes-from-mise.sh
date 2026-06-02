#!/bin/sh

set -- \
    graalvm-community-latest \
    temurin-21 \
    temurin-25 \
    temurin-latest

for jvm in "$@"; do
    echo "${jvm}"
    sudo mkdir -p "/Library/Java/JavaVirtualMachines/${jvm}"
    sudo ln -sf "${HOME}/.local/share/mise/installs/java/${jvm}/Contents" \
        "/Library/Java/JavaVirtualMachines/${jvm}/Contents"
done

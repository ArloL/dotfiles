@echo off

if exist "%HOME%/.dotfiles" (
    cd %HOME%/.dotfiles
    git pull --rebase
    git push origin main
)

if exist "%HOME%/dotfiles" (
    cd %HOME%/dotfiles
    git pull --rebase
    git push origin main
)

sudo choco upgrade all
scoop update

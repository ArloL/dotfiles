@echo off

if exist "%HOME%/.dotfiles" (
    cd %HOME%/.dotfiles
    git pull --rebase
    git push origin master
)

if exist "%HOME%/dotfiles" (
    cd %HOME%/dotfiles
    git pull --rebase
    git push origin master
)

sudo choco upgrade all
scoop update

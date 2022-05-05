#!/bin/sh

if [ $(uname) != 'Linux' ]; then
    echo "This uninstall script is designed for linux only, sorry!"
    exit 1
fi

set -e

RED='[1;31m'
GREEN='[1;32m'
YELLOW='[1;33m'
CYAN='[1;36m'
BOLD='[1m'
RESET='[0m'

printf '\n%b' $CYAN && cat << 'EOF'
█▀▀ █ ▀█▀ █ █▀▀ █▄░█ █▀█ █▀█ █▀▀ █▀▄
█▄█ █ ░█░ █ █▄█ █░▀█ █▄█ █▀▄ ██▄ █▄▀

EOF
printf '%b' $RESET

if [ $(id -u) = 0 ]; then
    printf "%bwarning:%b please don't run random scripts you find on the internet as root!\n" $YELLOW $RESET
    printf '%bsudo or doas will be used when elevated privileges are required%b\n' $BOLD $RESET
    exit 1
fi

# check if program is not in path
if ! command -v gitignored >/dev/null ; then
    printf '%berror:%b can not find %bgitignored%b in your $PATH, are you sure that it is installed?\n' $RED $RESET $BOLD $RESET
    exit 1
fi

printf "%balert!%b are you sure that you wish to remove gitignored from your system? [Y/n] " $YELLOW $RESET
while true; do
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y/y or N/n";;
    esac
done

if command -v sudo >/dev/null 2>&1; then
    PRIV_ESC='sudo'
elif command -v doas >/dev/null 2>&1; then
    PRIV_ESC='doas'
else
    printf '%berror:%b can not find %bsudo%b or %bdoas%b in your $PATH, one of these is required\n' $RED $RESET $BOLD $RESET $BOLD $RESET
    exit 1
fi

LOC=$(command -v gitignored)

printf '\n%bremoving files%b (elevated privileges are required)\n\n' $GREEN $RESET
$PRIV_ESC rm -v $LOC

CLONE_PATH="$HOME/.local/share/gitignore"

if [ -d $CLONE_PATH ]; then
    printf "%balert!%b Do you wish to remove the cloned gitignore repo at $CLONE_PATH? [Y/n] " $YELLOW $RESET
    while true; do
        read yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer Y/y or N/n";;
        esac
    done
    rm -rf $CLONE_PATH
    printf '\n%bDONE:%b done removing files!\n' $GREEN $RESET
else
    printf '\n%bNOTE:%b the cloned repository at $CLONE_PATH was not removed, you may remove it manually if needed\n' $RED $RESET
fi

#!/bin/sh

if [ $(uname) == 'Linux' ]; then
    echo "Linux system detectec! \nProceding"
    # exit 1
elif [ $(uname) == 'Darwin' ]; then
    echo "Mac system detected!! \nNeeded to install extra utilities."
    brew install gnu-getopt findutils 
    brew link --force gnu-getopt 
    echo 'export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
    echo 'export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"' >> ~/.zshrc
    echo 'export PATH="$(brew --prefix)/opt/findutils/libexec/gnubin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
else
    echo "This script is designed for linux or mac only, sorry!"
    exit 1
fi

set -e

RED='[1;31m'
GREEN='[1;32m'
YELLOW='[1;33m'
CYAN='[1;36m'
PURPLE='[0;35m'
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

if !command -v git >/dev/null 2>&1; then
    printf '%berror:%b can not find %bgit%b in your $PATH, please ensure it is correctly installed\n' $RED $RESET $BOLD $RESET
    exit 1
fi

if command -v sudo >/dev/null 2>&1; then
    PRIV_ESC='sudo'
elif command -v doas >/dev/null 2>&1; then
    PRIV_ESC='doas'
else
    printf '%berror:%b can not find %bsudo%b or %bdoas%b in your $PATH, one of these is required\n' $RED $RESET $BOLD $RESET $BOLD $RESET
    exit 1
fi

CLONE_PATH="$HOME/.local/share/"

if [ ! -d $CLONE_PATH ]; then
    echo "path: $CLONE_PATH doesn't exist so creating.."
    mkdir -p $CLONE_PATH
fi

printf '%bSTEP 1:%b %bcloning the gitignore repository%b (this may take a few seconds)\n\n' $GREEN $RESET $BOLD $RESET
# clone into .local dir
git clone https://github.com/github/gitignore.git $CLONE_PATH/gitignore

printf '\n%bSTEP 2:%b %bcopying files%b (elevated privileges are required)\n\n' $GREEN $RESET $BOLD $RESET

if [ $(uname) == 'Linux' ]; then
    $PRIV_ESC install -Dvm755 ./gitignored /usr/local/bin/gitignored
elif [ $(uname) == 'Darwin' ]; then
    $PRIV_ESC install  ./gitignored /usr/local/bin/gitignored
else
    echo "This script is designed for linux or mac only, sorry!"
    exit 1
fi

printf '\n%bDONE:%b %bthanks for installing!%b\n' $GREEN $RESET $BOLD $RESET

# gitignored

a bash script to setup default gitignore files in your projects

(Poor humour)

*Your code probably git ignored by others, it's time their code gitignored*

[![asciicast](https://asciinema.org/a/a58EkK5EVkYYuzv3kgZr9zQgs.svg)](https://asciinema.org/a/a58EkK5EVkYYuzv3kgZr9zQgs)

## dependencies

* gnu coreutils
* [fzf](https://github.com/junegunn/fzf)
* git

## usage

```
gitignored [ -u | --update ] [ -h | --help ]
```

## setup

* install using `bash install.sh`
* uninstall using `bash uninstall.sh`

## how it works

1. it creates a clone of the [gitignore](https://github.com/github/gitignore) repo in your system
2. everytime you run the script, it prepares an fzf prompt for you to select the preferred language
3. copies/replaces/merges the selected .gitignore file to your current dir

## planned features

* support for other OSes
* ensure the current dir is a project dir before copying
* [optional] automatic language selection using tools like `linguist`?

## support for other OSes

As of now it only works on linux, PRs for other OS support are welcome.

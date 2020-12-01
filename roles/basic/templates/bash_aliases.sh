#!/usr/bin/env bash

alias ll="ls -alh --color"
alias rm="rm -I"

function sf () {
    if [ -e 'app/console' ]; then
        php app/console "$@"
        return $?
    elif [ -e 'bin/console' ]; then
        php bin/console "$@"
        return $?
    fi

    echo -e "\e[91mERROR: Not symfony directory\e[0m"
    return 1
}


function sf8.0 () {
    if [ -e 'app/console' ]; then
        php8.0 app/console "$@"
        return $?
    elif [ -e 'bin/console' ]; then
        php8.0 bin/console "$@"
        return $?
    fi

    echo -e "\e[91mERROR: Not symfony directory\e[0m"
    return 1
}

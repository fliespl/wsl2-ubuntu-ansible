#!/usr/bin/env bash

ORIG_ARGS=( "$@" )

options=$(getopt -q -o d: --long working-dir: -- "$@")

eval set -- "$options"
WORKING_DIR=$(pwd)

while true; do
    case "$1" in
    -d)
        WORKING_DIR=$2
        ;;
    --working-dir)
        WORKING_DIR=$2
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

PHP_SELECTED_BINARY="$(/usr/local/bin/php-version-selector -d "$WORKING_DIR")"
COMPOSER_SELECTED_BINARY="$(/usr/local/bin/composer-version-selector -d "$WORKING_DIR")"

$PHP_SELECTED_BINARY "$COMPOSER_SELECTED_BINARY" "${ORIG_ARGS[@]}"

#!/usr/bin/env bash

PHP_SELECTED_BINARY=$(/usr/local/bin/php-version-selector)

#echo "[PHPWrapper selected: $PHP_SELECTED_BINARY]"

ORIG_ARGS=( "$@" )

$PHP_SELECTED_BINARY "${ORIG_ARGS[@]}"

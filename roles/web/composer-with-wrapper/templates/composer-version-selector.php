#!/usr/bin/php
<?php

$shortopts = 'd:';
$longopts = [
    'directory:',
];
$options = getopt($shortopts, $longopts);

$composerSelectedBinary = '/usr/local/bin/composer2.phar';

$workingDirectory = $options['d'] ?? $options['directory'] ?? getcwd();

if (!is_dir($workingDirectory)) {
    logger('Provided argument is not a valid directory: '.$workingDirectory);

    exit($composerSelectedBinary);
}

$dir = $workingDirectory;
while (!is_file($dir.'/composer.json')) {
    if ($dir === dirname($dir)) {
        $dir = null;
        break;
    }

    $dir = dirname($dir);
}

if (null === $dir || !file_exists($dir.'/composer.lock')) {
    exit($composerSelectedBinary);
}

$v = json_decode(file_get_contents($dir.'/composer.lock'), true);

if(!isset($v['plugin-api-version']) || intval($v['plugin-api-version'][0]) === 1) {
    $composerSelectedBinary = '/usr/local/bin/composer1.phar';
}
exit($composerSelectedBinary);

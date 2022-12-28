#!/usr/bin/php
<?php

$startTime = hrtime(true);

$shortopts = 'd:';
$longopts = [
    'directory:',
];
$options = getopt($shortopts, $longopts);

$phpSelectedBinary = '/usr/bin/php';

$workingDirectory = $options['d'] ?? $options['directory'] ?? getcwd();

function logger($data): void
{
    global $workingDirectory, $composerSelectedBinary;

    if (!is_array($data)) {
        $data = ['message' => $data];
    }

    file_put_contents('/tmp/php-selector.txt', json_encode(array_merge(['php' => $composerSelectedBinary, 'cwd' => $workingDirectory], $data))."\n", FILE_APPEND);
}

if (!is_dir($workingDirectory)) {
    logger('Provided argument is not a valid directory: '.$workingDirectory);

    exit($phpSelectedBinary);
}

$dir = $workingDirectory;
while (!is_file($dir.'/composer.json')) {
    if ($dir === dirname($dir)) {
        $dir = null;
        break;
    }

    $dir = dirname($dir);
}

if (null === $dir) {
    logger('composer.json not found.');
    exit($phpSelectedBinary);
}

$d = dir($workingDirectory);
while (false !== ($f = $d->read())) {
    if (preg_match('#^\.(php[7-9]\.[0-9])$#', $f, $m)) {
        $d->close();
        exit('/usr/bin/'.$m[1]);
    }
}
$d->close();

logger('composer.json found in: '.$dir);

$hash = md5($dir);

if (!is_dir('/tmp/php-cache')) {
    mkdir('/tmp/php-cache', 0777);
}

$metadata = '/tmp/php-cache/'.$hash.'.metadata';

if (file_exists($metadata) && time() - filemtime($metadata) < 600) {
    $phpSelectedBinary = file_get_contents($metadata);

    $endTime = hrtime(true);
    $eta = ($endTime - $startTime) / 1e+6 / 1000;

    logger('Returning php version from cache. Took '.sprintf('%.04f', $eta).'s to find.');
    exit($phpSelectedBinary);
}

unset($phpVersions);
exec('update-alternatives --list php | sort -r', $phpVersions);

foreach ($phpVersions as $phpVersion) {
    unset($output, $code);
    exec(sprintf('%s /usr/local/bin/composer2.phar check-platform-reqs --working-dir=%s -q', escapeshellarg($phpVersion), escapeshellarg($workingDirectory)), $output, $code);

    if (0 === intval($code)) {
        $phpSelectedBinary = $phpVersion;
        break;
    }
}

$endTime = hrtime(true);
$eta = ($endTime - $startTime) / 1e+6 / 1000;

logger('Took '.sprintf('%.04f', $eta).'s to find.');

file_put_contents($metadata, $phpSelectedBinary);

exit($phpSelectedBinary);

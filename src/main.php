<?php

namespace Zebooka;

// setup errors handling
error_reporting(-1);
set_exception_handler(
    function (\Throwable $e) {
        error_log($e);
        exit(1);
    }
);
mb_internal_encoding('UTF-8');

// autoloader
require_once dirname(__DIR__) . '/vendor/autoload.php';

// get locale
$locale = 'en';
foreach ([LC_ALL, LC_COLLATE, LC_CTYPE, LC_MESSAGES] as $lc) {
    if (preg_match('/^([a-z]{2})(_|$)/i', setlocale($lc, 0))) {
        $locale = setlocale($lc, 0);
        break;
    }
}
setlocale(LC_ALL, $locale);

define('RES_DIR', __DIR__ . '/../res');

fwrite(STDERR, "It works! Now implement your phar application.\n");
exit(0);

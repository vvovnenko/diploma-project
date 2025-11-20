<?php
use Runtime\Swoole\Runtime;

if(($_ENV['APP_RUNTIME'] ?? $_SERVER['APP_RUNTIME'] ?? '') == Runtime::class) {
    $_SERVER['APP_RUNTIME_OPTIONS'] = [
        'host'     => '0.0.0.0',
        'port'     => 80,
        'mode'     => SWOOLE_PROCESS,
        'settings' => [
            \Swoole\Constant::OPTION_LOG_LEVEL => SWOOLE_LOG_ERROR,
            \Swoole\Constant::OPTION_MAX_REQUEST => 0,
            \Swoole\Constant::OPTION_REACTOR_NUM => (int) $_ENV['SWOOLE_REACTOR_NUM'] ?? $_SERVER['SWOOLE_REACTOR_NUM'] ?? 2,
            \Swoole\Constant::OPTION_WORKER_NUM =>  (int) $_ENV['SWOOLE_WORKER_NUM'] ?? $_SERVER['SWOOLE_WORKER_NUM'] ?? 2,
        ],
    ];
}

<?php
use Runtime\Swoole\Runtime;

if(($_ENV['APP_RUNTIME'] ?? $_SERVER['APP_RUNTIME'] ?? '') == Runtime::class) {
    $_SERVER['APP_RUNTIME_OPTIONS'] = [
        'host'     => '0.0.0.0',
        'port'     => 80,
        'mode'     => SWOOLE_PROCESS,
        'settings' => [
            \Swoole\Constant::OPTION_LOG_LEVEL => SWOOLE_LOG_ERROR,
            \Swoole\Constant::OPTION_MAX_REQUEST => 500,
            \Swoole\Constant::OPTION_REACTOR_NUM => 16,
            \Swoole\Constant::OPTION_WORKER_NUM => 2,
        ],
    ];
}

<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/', name: 'app_runtime_info', methods: ['GET'])]
final class RootController extends AbstractController
{

    public function __construct(
        #[Autowire(env: 'APP_RUNTIME_TYPE')]
        readonly private string $runtimeName,
    ) {
    }

    public function __invoke(): Response
    {
        return new JsonResponse([
            'runtime' => $this->runtimeName,
            'FRANKENPHP_WORKER' => $_SERVER['FRANKENPHP_WORKER'] ?? null,
            'FRANKENPHP_LOOP_MAX' => $_ENV['FRANKENPHP_LOOP_MAX'] ?? $_SERVER['FRANKENPHP_LOOP_MAX'] ?? null,
            'FRANKENPHP_THREADS_NUM' => $_ENV['FRANKENPHP_THREADS_NUM'] ?? $_SERVER['FRANKENPHP_THREADS_NUM'] ?? null,
            'FRANKENPHP_WORKERS_NUM' => $_ENV['FRANKENPHP_WORKERS_NUM'] ?? $_SERVER['FRANKENPHP_WORKERS_NUM'] ?? null,
            'SWOOLE_REACTOR_NUM' => $_ENV['SWOOLE_REACTOR_NUM'] ?? $_SERVER['SWOOLE_REACTOR_NUM'] ?? null,
            'SWOOLE_WORKER_NUM' => $_ENV['SWOOLE_WORKER_NUM'] ?? $_SERVER['SWOOLE_WORKER_NUM'] ?? null,
            'FPM_MAX_CHILDREN' => $_ENV['FPM_MAX_CHILDREN'] ?? $_SERVER['FPM_MAX_CHILDREN'] ?? null,
        ]);
    }
}

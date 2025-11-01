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
        ]);
    }
}

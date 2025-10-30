<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/health-check', name: 'app_health_check', methods: ['GET'])]
final class HealthCheckController extends AbstractController
{
    public function __invoke(): Response
    {
        return new Response(content: 'OK', status: Response::HTTP_OK);
    }
}

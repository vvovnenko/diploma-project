<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapQueryParameter;
use Symfony\Component\Routing\Annotation\Route;

class BenchController extends AbstractController
{
    #[Route('/bench/health-check', name: 'bench_health_check', methods: ['GET'])]
    public function health(): Response
    {
        return new Response(content: 'OK', status: Response::HTTP_OK);
    }

    #[Route('/bench/io', name: 'bench_io', methods: ['GET'])]
    public function io(#[MapQueryParameter] int $ms = 5): JsonResponse
    {
        usleep($ms * 1000);

        return new JsonResponse(data: ['sleep_ms'    => $ms], status: Response::HTTP_OK);
    }
}
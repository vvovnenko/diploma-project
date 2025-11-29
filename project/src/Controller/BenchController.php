<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\MapQueryParameter;
use Symfony\Component\Routing\Annotation\Route;

class BenchController extends AbstractController
{
    /**
     * A benchmark route for the Health check scenario
     */
    #[Route('/bench/health-check', name: 'bench_health_check', methods: ['GET'])]
    public function health(): Response
    {
        return new Response(content: 'OK', status: Response::HTTP_OK);
    }

    /**
     * A benchmark route for the I/O scenario
     */
    #[Route('/bench/io', name: 'bench_io', methods: ['GET'])]
    public function io(#[MapQueryParameter] int $ms = 5): JsonResponse
    {
        usleep($ms * 1000);

        return new JsonResponse(data: ['sleep_ms'    => $ms], status: Response::HTTP_OK);
    }
}
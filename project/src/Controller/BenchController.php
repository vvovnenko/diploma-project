<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class BenchController extends AbstractController
{
    #[Route('/bench/io', name: 'bench_io', methods: ['GET'])]
    public function io(Request $req): JsonResponse
    {
        // simulation of the I/O latency (8 ms by default)
        $ms = (int) $req->query->get('ms', 8);

        usleep($ms * 1000);

        return $this->json([
            'scenario'    => 'io_sleep',
            'sleep_ms'    => $ms,
        ]);
    }
}
<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/phpinfo', name: 'app_phpinfo', methods: ['GET'])]
final class PhpInfoController extends AbstractController
{

    public function __invoke(): Response
    {
        ob_start();
        phpinfo();
        $phpinfo = ob_get_contents();
        ob_clean();
        if(php_sapi_name() === 'cli') {
            return new Response("<pre>{$phpinfo}</pre>");
        }
        return new Response($phpinfo);
    }
}

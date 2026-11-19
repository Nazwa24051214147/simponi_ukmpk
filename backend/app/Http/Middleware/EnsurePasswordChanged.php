<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsurePasswordChanged
{
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user() && $request->user()->must_change_password) {
            return response()->json([
                'success' => false,
                'message' => 'Silakan ubah password sementara Anda terlebih dahulu.',
                'must_change_password' => true,
            ], 403);
        }

        return $next($request);
    }
}
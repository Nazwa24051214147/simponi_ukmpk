<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AccountController;
use App\Http\Middleware\EnsureAccountIsActive;
use App\Http\Middleware\EnsureAdmin;
use App\Http\Middleware\EnsurePasswordChanged;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware([
    'auth:sanctum',
    EnsureAccountIsActive::class,
])->group(function () {

    // Route yang tetap bisa diakses sebelum password diganti
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/change-password', [AuthController::class, 'changePassword']);

    // Route yang hanya bisa diakses setelah password diganti
    Route::middleware(EnsurePasswordChanged::class)->group(function () {

        Route::get('/user', function (\Illuminate\Http\Request $request) {
            return $request->user()->load(['member.division', 'roles']);
        });

        // Pengelolaan akun khusus Admin
        Route::middleware(EnsureAdmin::class)
            ->prefix('admin')
            ->group(function () {
                Route::get('/accounts', [AccountController::class, 'index']);
                Route::get('/accounts/{account}', [AccountController::class, 'show']);
                Route::post('/accounts', [AccountController::class, 'store']);
                Route::put('/accounts/{account}', [AccountController::class, 'update']);
                Route::patch('/accounts/{account}/toggle-status', [AccountController::class, 'toggleStatus']);
            });
    });
});

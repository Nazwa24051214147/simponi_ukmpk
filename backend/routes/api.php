<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AccountController;
use App\Http\Middleware\EnsureAccountIsActive;
use App\Http\Middleware\EnsureAdmin;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum', EnsureAccountIsActive::class])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/user', function (\Illuminate\Http\Request $request) {
        return $request->user()->load(['member.division', 'roles']);
    });
});

Route::middleware([
    'auth:sanctum',
    EnsureAccountIsActive::class,
    EnsureAdmin::class
])->prefix('admin')->group(function () {
    // Pengelolaan akun
    Route::get('/accounts', [AccountController::class, 'index']);
});
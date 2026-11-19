<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AccountController;
use App\Http\Controllers\Api\DivisionController;
use App\Http\Controllers\Api\ProgramController;
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

        // Divisi: Akses baca untuk semua role terautentikasi (Admin, Pengurus, Anggota)
        Route::get('/divisions', [DivisionController::class, 'index']);
        Route::get('/divisions/{division}', [DivisionController::class, 'show']);

        // Program Kerja: Akses terautentikasi (Otorisasi role Admin / Pengurus / Anggota ditangani di Controller)
        Route::get('/programs', [ProgramController::class, 'index']);
        Route::get('/programs/{program}', [ProgramController::class, 'show']);
        Route::post('/programs', [ProgramController::class, 'store']);
        Route::put('/programs/{program}', [ProgramController::class, 'update']);
        Route::patch('/programs/{program}/status', [ProgramController::class, 'updateStatus']);
        Route::delete('/programs/{program}', [ProgramController::class, 'destroy']);

        // Referensi Akun/Anggota (misal: pemilihan PIC oleh Admin & Pengurus)
        Route::get('/accounts', [AccountController::class, 'index']);

        // Pengelolaan khusus Admin
        Route::middleware(EnsureAdmin::class)
            ->prefix('admin')
            ->group(function () {
                // Pengelolaan Akun
                Route::get('/accounts', [AccountController::class, 'index']);
                Route::get('/accounts/{account}', [AccountController::class, 'show']);
                Route::post('/accounts', [AccountController::class, 'store']);
                Route::put('/accounts/{account}', [AccountController::class, 'update']);
                Route::patch('/accounts/{account}/toggle-status', [AccountController::class, 'toggleStatus']);

                // Pengelolaan Divisi (CRUD Admin)
                Route::post('/divisions', [DivisionController::class, 'store']);
                Route::put('/divisions/{division}', [DivisionController::class, 'update']);
                Route::delete('/divisions/{division}', [DivisionController::class, 'destroy']);
            });
    });
});

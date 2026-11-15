<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class AccountController extends Controller
{
    // Menampilkan daftar akun
    public function index(Request $request)
    {
        $query = User::with([
            'member.division',
            'roles',
        ]);

        // Pencarian berdasarkan nama, email, atau NIM
        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($q) use ($search) {
                $q->where('name', 'ilike', "%{$search}%")
                    ->orWhere('email', 'ilike', "%{$search}%")
                    ->orWhereHas('member', function ($memberQuery) use ($search) {
                        $memberQuery->where('nim', 'ilike', "%{$search}%");
                    });
            });
        }

        $accounts = $query
            ->orderBy('name')
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => 'Daftar akun berhasil diambil.',
            'data' => $accounts,
        ]);
    }
}
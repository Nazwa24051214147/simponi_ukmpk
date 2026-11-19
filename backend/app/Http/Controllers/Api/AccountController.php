<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreAccountRequest;
use App\Http\Requests\UpdateAccountRequest;
use App\Models\Member;
use App\Models\Role;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AccountController extends Controller
{
    // ----------------------------------------------------------------
    // GET /api/admin/accounts
    // Menampilkan daftar akun dengan pencarian dan pagination
    // ----------------------------------------------------------------
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
            'data'    => $accounts,
        ]);
    }

    // ----------------------------------------------------------------
    // GET /api/admin/accounts/{account}
    // Menampilkan detail satu akun
    // ----------------------------------------------------------------
    public function show(User $account)
    {
        $account->load(['member.division', 'roles']);

        return response()->json([
            'success' => true,
            'message' => 'Detail akun berhasil diambil.',
            'data'    => $account,
        ]);
    }

    // ----------------------------------------------------------------
    // POST /api/admin/accounts
    // Membuat akun baru beserta data anggota dan role
    // ----------------------------------------------------------------
    public function store(StoreAccountRequest $request)
    {
        // Generate password sementara sebelum transaksi
        $temporaryPassword = Str::random(10);

        $user = DB::transaction(function () use ($request, $temporaryPassword) {

            // 1. Ambil role di dalam transaksi agar konsisten
            $role = Role::where('name', $request->role)->first();

            if (!$role) {
                throw new \RuntimeException('Role tidak ditemukan.');
            }

            // 2. Buat akun user
            $user = User::create([
                'name'                 => $request->name,
                'email'                => $request->email,
                'password'             => $temporaryPassword, // di-hash otomatis oleh cast 'hashed'
                'is_active'            => true,
                'must_change_password' => true,
            ]);

            // 3. Buat profil anggota
            Member::create([
                'user_id'     => $user->id,
                'nim'         => $request->nim,
                'phone'       => $request->phone,
                'division_id' => $request->division_id,
                'position'    => $request->position,
                'generation'  => $request->generation,
                'status'      => $request->status ?? 'Active',
            ]);

            // 4. Pasang role (sync memastikan hanya satu role)
            $user->roles()->sync([$role->id]);

            return $user;
        });

        // Load relasi untuk response
        $user->load(['member.division', 'roles']);

        return response()->json([
            'success'  => true,
            'message'  => 'Akun berhasil dibuat.',
            'data'     => [
                'account'            => $user,
                'temporary_password' => $temporaryPassword,
            ],
        ], 201);
    }

    // ----------------------------------------------------------------
    // PUT /api/admin/accounts/{account}
    // Memperbarui data akun dan anggota
    // ----------------------------------------------------------------
    public function update(UpdateAccountRequest $request, User $account)
    {
        // Flag untuk membedakan error "role tidak ditemukan" dari error DB lainnya
        $roleNotFound = false;

        try {
            DB::transaction(function () use ($request, $account, &$roleNotFound) {

                // 1. Perbarui data user jika ada field yang dikirim
                $userFields = $request->only(['name', 'email']);
                if (!empty($userFields)) {
                    $account->update($userFields);
                }

                // 2. Perbarui data member jika ada field yang dikirim
                $memberFields = $request->only([
                    'nim', 'phone', 'division_id', 'position', 'generation', 'status',
                ]);
                if (!empty($memberFields) && $account->member) {
                    $account->member->update($memberFields);
                }

                // 3. Perbarui role jika dikirim (sync = satu role saja)
                if ($request->filled('role')) {
                    $role = Role::where('name', $request->role)->first();

                    if (!$role) {
                        // Tandai sebagai error aplikasi (bukan error DB)
                        // lalu lempar agar transaksi rollback
                        $roleNotFound = true;
                        throw new \Exception('Role tidak ditemukan.');
                    }

                    $account->roles()->sync([$role->id]);
                }
            });
        } catch (\Exception $e) {
            if ($roleNotFound) {
                // Error terkontrol: kembalikan 422 bukan 500
                return response()->json([
                    'success' => false,
                    'message' => 'Role tidak ditemukan.',
                ], 422);
            }

            // Error tidak terduga (mis. query DB gagal): lempar kembali
            throw $e;
        }

        $account->load(['member.division', 'roles']);

        return response()->json([
            'success' => true,
            'message' => 'Akun berhasil diperbarui.',
            'data'    => $account,
        ]);
    }

    // ----------------------------------------------------------------
    // PATCH /api/admin/accounts/{account}/toggle-status
    // Mengaktifkan atau menonaktifkan akun
    // ----------------------------------------------------------------
    public function toggleStatus(Request $request, User $account)
    {
        // Mencegah Admin menonaktifkan akunnya sendiri
        if ($request->user()->id === $account->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak dapat menonaktifkan akun Anda sendiri.',
            ], 422);
        }

        // Tentukan status baru secara eksplisit sebelum update
        // agar niat kode jelas dan tidak bergantung pada urutan operasi Eloquent
        $newStatus = !$account->is_active;

        $account->update(['is_active' => $newStatus]);

        $statusLabel = $newStatus ? 'diaktifkan' : 'dinonaktifkan';

        return response()->json([
            'success' => true,
            'message' => "Akun berhasil {$statusLabel}.",
            'data'    => [
                'id'        => $account->id,
                'name'      => $account->name,
                'is_active' => $account->is_active,
            ],
        ]);
    }
}

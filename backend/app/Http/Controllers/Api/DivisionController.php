<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreDivisionRequest;
use App\Http\Requests\UpdateDivisionRequest;
use App\Models\Division;
use Illuminate\Http\Request;

class DivisionController extends Controller
{
    // ----------------------------------------------------------------
    // GET /api/divisions
    // Menampilkan daftar divisi beserta jumlah anggota
    // Akses: Semua role terautentikasi (Admin, Pengurus, Anggota)
    // ----------------------------------------------------------------
    public function index(Request $request)
    {
        $query = Division::withCount('members');

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'ilike', "%{$search}%")
                  ->orWhere('description', 'ilike', "%{$search}%");
            });
        }

        $divisions = $query->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar divisi berhasil diambil.',
            'data'    => $divisions,
        ]);
    }

    // ----------------------------------------------------------------
    // GET /api/divisions/{division}
    // Menampilkan detail satu divisi, termasuk daftar anggotanya
    // Akses: Semua role terautentikasi (Admin, Pengurus, Anggota)
    // ----------------------------------------------------------------
    public function show(Division $division)
    {
        $division->loadCount('members');
        $division->load(['members.user']);

        return response()->json([
            'success' => true,
            'message' => 'Detail divisi berhasil diambil.',
            'data'    => $division,
        ]);
    }

    // ----------------------------------------------------------------
    // POST /api/admin/divisions
    // Menambahkan divisi baru
    // Akses: Khusus Admin
    // ----------------------------------------------------------------
    public function store(StoreDivisionRequest $request)
    {
        $division = Division::create($request->validated());
        $division->loadCount('members');

        return response()->json([
            'success' => true,
            'message' => 'Divisi berhasil ditambahkan.',
            'data'    => $division,
        ], 201);
    }

    // ----------------------------------------------------------------
    // PUT /api/admin/divisions/{division}
    // Memperbarui nama dan deskripsi divisi
    // Akses: Khusus Admin
    // ----------------------------------------------------------------
    public function update(UpdateDivisionRequest $request, Division $division)
    {
        $division->update($request->validated());
        $division->loadCount('members');

        return response()->json([
            'success' => true,
            'message' => 'Divisi berhasil diperbarui.',
            'data'    => $division,
        ]);
    }

    // ----------------------------------------------------------------
    // DELETE /api/admin/divisions/{division}
    // Menghapus divisi dengan pemeriksaan relasi keamanan
    // Akses: Khusus Admin
    // ----------------------------------------------------------------
    public function destroy(Division $division)
    {
        // Pemeriksaan relasi: tidak boleh dihapus jika masih ada anggota
        if ($division->members()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Divisi tidak dapat dihapus karena masih memiliki anggota yang terdaftar.',
            ], 422);
        }

        // Pemeriksaan relasi: tidak boleh dihapus jika masih ada program kerja
        if ($division->programs()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Divisi tidak dapat dihapus karena masih terkait dengan program kerja.',
            ], 422);
        }

        $division->delete();

        return response()->json([
            'success' => true,
            'message' => 'Divisi berhasil dihapus.',
        ]);
    }
}

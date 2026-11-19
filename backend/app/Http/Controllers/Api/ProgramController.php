<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreProgramRequest;
use App\Http\Requests\UpdateProgramRequest;
use App\Models\Program;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ProgramController extends Controller
{
    // Helper untuk memeriksa kewenangan pengguna terhadap program kerja
    private function checkPermission($user, ?int $divisionId): ?array
    {
        $isAdmin = $user->roles->contains('name', 'admin');
        if ($isAdmin) {
            return null; // Admin memiliki akses penuh ke seluruh divisi
        }

        $isPengurus = $user->roles->contains('name', 'pengurus');
        if ($isPengurus) {
            $userDivisionId = $user->member?->division_id;
            if (!$userDivisionId || (int)$userDivisionId !== (int)$divisionId) {
                return [
                    'code'    => 403,
                    'message' => 'Pengurus hanya memiliki kewenangan pada program kerja divisi yang menjadi tanggung jawabnya.',
                ];
            }
            return null;
        }

        return [
            'code'    => 403,
            'message' => 'Anggota tidak memiliki kewenangan untuk mengubah atau menghapus data program kerja.',
        ];
    }

    // ----------------------------------------------------------------
    // GET /api/programs
    // Menampilkan daftar program kerja dengan filter divisi dan status
    // Akses: Semua role terautentikasi (Admin, Pengurus, Anggota)
    // ----------------------------------------------------------------
    public function index(Request $request)
    {
        $query = Program::with([
            'division',
            'pic.user',
        ])->withCount(['members', 'schedules']);

        // Filter pencarian berdasarkan nama, deskripsi, atau lokasi
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'ilike', "%{$search}%")
                  ->orWhere('description', 'ilike', "%{$search}%")
                  ->orWhere('location', 'ilike', "%{$search}%");
            });
        }

        // Filter berdasarkan divisi
        if ($request->filled('division_id')) {
            $query->where('division_id', $request->division_id);
        }

        // Filter berdasarkan status
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $programs = $query->orderBy('start_date', 'desc')
                          ->orderBy('id', 'desc')
                          ->get();

        return response()->json([
            'success' => true,
            'message' => 'Daftar program kerja berhasil diambil.',
            'data'    => $programs,
        ]);
    }

    // ----------------------------------------------------------------
    // GET /api/programs/{program}
    // Menampilkan detail program kerja beserta relasi terkait
    // Akses: Semua role terautentikasi (Admin, Pengurus, Anggota)
    // ----------------------------------------------------------------
    public function show(Program $program)
    {
        $program->load([
            'division',
            'pic.user',
            'members.user',
            'schedules',
            'materials',
            'documents',
        ])->loadCount(['members', 'schedules']);

        return response()->json([
            'success' => true,
            'message' => 'Detail program kerja berhasil diambil.',
            'data'    => $program,
        ]);
    }

    // ----------------------------------------------------------------
    // POST /api/programs
    // Menambahkan program kerja baru
    // Akses: Admin (semua divisi) dan Pengurus (divisi sendiri)
    // ----------------------------------------------------------------
    public function store(StoreProgramRequest $request)
    {
        $user = $request->user()->load(['roles', 'member']);
        $denial = $this->checkPermission($user, (int)$request->division_id);

        if ($denial) {
            return response()->json([
                'success' => false,
                'message' => $denial['message'],
            ], $denial['code']);
        }

        $data = $request->validated();
        if (empty($data['registration_type'])) {
            $data['registration_type'] = 'Internal';
        }
        if (empty($data['status'])) {
            $data['status'] = 'Planned';
        }

        $program = Program::create($data);
        $program->load(['division', 'pic.user'])->loadCount(['members', 'schedules']);

        return response()->json([
            'success' => true,
            'message' => 'Program kerja berhasil ditambahkan.',
            'data'    => $program,
        ], 201);
    }

    // ----------------------------------------------------------------
    // PUT /api/programs/{program}
    // Memperbarui informasi program kerja
    // Akses: Admin (semua divisi) dan Pengurus (divisi sendiri)
    // ----------------------------------------------------------------
    public function update(UpdateProgramRequest $request, Program $program)
    {
        $user = $request->user()->load(['roles', 'member']);

        // Periksa izin untuk divisi asal
        $denial = $this->checkPermission($user, $program->division_id);
        if ($denial) {
            return response()->json([
                'success' => false,
                'message' => $denial['message'],
            ], $denial['code']);
        }

        // Jika pengurus mencoba memindahkan program ke divisi lain, tolak
        if ($request->filled('division_id') && (int)$request->division_id !== (int)$program->division_id) {
            $isAdmin = $user->roles->contains('name', 'admin');
            if (!$isAdmin) {
                return response()->json([
                    'success' => false,
                    'message' => 'Pengurus tidak dapat memindahkan program kerja ke divisi lain.',
                ], 403);
            }
        }

        $program->update($request->validated());
        $program->load(['division', 'pic.user'])->loadCount(['members', 'schedules']);

        return response()->json([
            'success' => true,
            'message' => 'Program kerja berhasil diperbarui.',
            'data'    => $program,
        ]);
    }

    // ----------------------------------------------------------------
    // PATCH /api/programs/{program}/status
    // Mengubah status pelaksanaan program kerja
    // Akses: Admin dan Pengurus divisi terkait
    // ----------------------------------------------------------------
    public function updateStatus(Request $request, Program $program)
    {
        $request->validate([
            'status' => [
                'required',
                'string',
                Rule::in(['Planned', 'Preparation', 'Ongoing', 'Completed', 'Cancelled']),
            ],
        ], [
            'status.required' => 'Status program kerja wajib dipilih.',
            'status.in'       => 'Status harus salah satu dari: Planned, Preparation, Ongoing, Completed, Cancelled.',
        ]);

        $user = $request->user()->load(['roles', 'member']);
        $denial = $this->checkPermission($user, $program->division_id);
        if ($denial) {
            return response()->json([
                'success' => false,
                'message' => $denial['message'],
            ], $denial['code']);
        }

        $program->update(['status' => $request->status]);

        return response()->json([
            'success' => true,
            'message' => 'Status program kerja berhasil diubah.',
            'data'    => [
                'id'     => $program->id,
                'status' => $program->status,
            ],
        ]);
    }

    // ----------------------------------------------------------------
    // DELETE /api/programs/{program}
    // Menghapus program kerja dengan proteksi relasi
    // Akses: Admin dan Pengurus divisi terkait
    // ----------------------------------------------------------------
    public function destroy(Request $request, Program $program)
    {
        $user = $request->user()->load(['roles', 'member']);
        $denial = $this->checkPermission($user, $program->division_id);
        if ($denial) {
            return response()->json([
                'success' => false,
                'message' => $denial['message'],
            ], $denial['code']);
        }

        // Proteksi 1: Kepanitiaan atau peserta terdaftar
        if ($program->members()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Program kerja tidak dapat dihapus karena sudah memiliki susunan panitia atau anggota yang terdaftar. Silakan ubah status menjadi Dibatalkan jika kegiatan tidak dilanjutkan.',
            ], 422);
        }

        // Proteksi 2: Data jadwal, materi, atau dokumen
        if ($program->schedules()->exists() || $program->materials()->exists() || $program->documents()->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Program kerja tidak dapat dihapus karena sudah memiliki jadwal kegiatan, materi, atau dokumen terkait.',
            ], 422);
        }

        $program->delete();

        return response()->json([
            'success' => true,
            'message' => 'Program kerja berhasil dihapus.',
        ]);
    }
}

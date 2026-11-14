<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Attendance extends Model
{
    protected $fillable = [
        'attendance_session_id',
        'member_id',
        'status',
        'check_in_at',
        'method',
    ];

    // Relasi dengan sesi presensi
    public function attendanceSession(): BelongsTo
    {
        return $this->belongsTo(AttendanceSession::class);
    }

    // Relasi dengan anggota yang melakukan presensi
    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }

    // Konversi waktu check-in menjadi objek tanggal dan waktu
    protected function casts(): array
    {
        return [
            'check_in_at' => 'datetime',
        ];
    }
}

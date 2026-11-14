<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class AttendanceSession extends Model
{
    protected $fillable = [
        'schedule_id',
        'code',
        'qr_token',
        'opened_at',
        'closed_at',
        'status',
        'created_by',
    ];

    // Relasi dengan jadwal
    public function schedule(): BelongsTo
    {
        return $this->belongsTo(Schedule::class);
    }

    // Relasi dengan data presensi anggota
    public function attendances(): HasMany
    {
        return $this->hasMany(Attendance::class);
    }

    // Relasi dengan akun yang membuat sesi presensi
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    // Konversi waktu menjadi objek tanggal dan waktu
    protected function casts(): array
    {
        return [
            'opened_at' => 'datetime',
            'closed_at' => 'datetime',
        ];
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Schedule extends Model
{
    protected $fillable = [
        'program_id',
        'title',
        'description',
        'date',
        'schedule_type',
        'start_time',
        'end_time',
        'location',
    ];

    // Relasi dengan proker
    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    // Relasi dengan sesi presensi
    public function attendanceSession(): HasOne
    {
        return $this->hasOne(AttendanceSession::class);
    }

    // Konversi tanggal menjadi objek tanggal
    protected function casts(): array
    {
        return [
            'date' => 'date',
        ];
    }
}

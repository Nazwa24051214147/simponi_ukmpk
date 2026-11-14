<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Program extends Model
{
    protected $fillable = [
        'division_id',
        'pic_id',
        'name',
        'description',
        'quota',
        'registration_type',
        'registration_start',
        'registration_end',
        'start_date',
        'end_date',
        'location',
        'status',
    ];

    // Relasi dengan divisi penyelenggara
    public function division(): BelongsTo
    {
        return $this->belongsTo(Division::class);
    }

    // Relasi dengan Ketua Pelaksana
    public function pic(): BelongsTo
    {
        return $this->belongsTo(Member::class, 'pic_id');
    }

    // Relasi dengan anggota yang mengikuti proker
    public function members(): BelongsToMany
    {
        return $this->belongsToMany(
            Member::class,
            'program_members'
        )->withPivot([
            'id',
            'status',
            'registration_type',
            'registered_at',
            'reviewed_by',
            'reviewed_at',
            'withdrawn_at',
            'withdrawal_reason',
        ])->withTimestamps();
    }

    // Relasi dengan seksi kepanitiaan
    public function sections(): HasMany
    {
        return $this->hasMany(Section::class);
    }

    // Relasi dengan jadwal kegiatan
    public function schedules(): HasMany
    {
        return $this->hasMany(Schedule::class);
    }

    // Relasi dengan materi kegiatan
    public function materials(): HasMany
    {
        return $this->hasMany(Material::class);
    }

    // Relasi dengan dokumen administrasi
    public function documents(): HasMany
    {
        return $this->hasMany(Document::class);
    }
}

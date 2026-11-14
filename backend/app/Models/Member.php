<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Member extends Model
{
    protected $fillable = [
        'user_id',
        'nim',
        'division_id',
        'position',
        'generation',
        'status',
        'phone',
    ];

    // Relasi profil anggota dengan akun login
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Relasi profil anggota dengan divisi
    public function division(): BelongsTo
    {
        return $this->belongsTo(Division::class);
    }

    // Relasi anggota dengan proker yang diikuti
    public function programs(): BelongsToMany
    {
        return $this->belongsToMany(
            Program::class,
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
}

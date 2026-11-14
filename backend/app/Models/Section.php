<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Section extends Model
{
    protected $fillable = [
        'program_id',
        'name',
        'description',
    ];

    // Relasi dengan proker
    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    // Relasi dengan anggota yang mendapat penugasan di seksi ini
    public function assignments(): HasMany
    {
        return $this->hasMany(ProgramAssignment::class);
    }

    // Relasi dengan dokumen khusus seksi
    public function documents(): HasMany
    {
        return $this->hasMany(Document::class);
    }
}


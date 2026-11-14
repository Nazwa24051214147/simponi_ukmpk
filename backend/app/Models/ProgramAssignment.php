<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProgramAssignment extends Model
{
    protected $fillable = [
        'program_id',
        'member_id',
        'section_id',
        'assignment_name',
    ];

    // Relasi dengan proker
    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    // Relasi dengan anggota yang mendapat penugasan
    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }

    // Relasi dengan seksi kepanitiaan
    public function section(): BelongsTo
    {
        return $this->belongsTo(Section::class);
    }
}

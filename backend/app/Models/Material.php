<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Material extends Model
{
    protected $fillable = [
        'program_id',
        'title',
        'description',
        'file_path',
        'uploaded_by',
    ];

    // Relasi dengan proker
    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    // Relasi dengan akun yang mengunggah materi
    public function uploader(): BelongsTo
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }
}

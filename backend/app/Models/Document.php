<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Document extends Model
{
    protected $fillable = [
        'program_id',
        'title',
        'description',
        'category',
        'file_path',
        'uploaded_by',
        'visibility',
        'section_id',
    ];

    // Relasi dengan proker
    public function program(): BelongsTo
    {
        return $this->belongsTo(Program::class);
    }

    // Relasi dengan akun yang mengunggah dokumen
    public function uploader(): BelongsTo
    {
        return $this->belongsTo(User::class, 'uploaded_by');
    }

    // Relasi dengan seksi yang memiliki akses dokumen
    public function section(): BelongsTo
    {
        return $this->belongsTo(Section::class);
    }

    // Relasi dengan daftar anggota yang diberi akses khusus
    public function documentAccesses(): HasMany
    {
        return $this->hasMany(DocumentAccess::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DocumentAccess extends Model
{
    protected $fillable = [
        'document_id',
        'member_id',
    ];

    // Relasi dengan dokumen
    public function document(): BelongsTo
    {
        return $this->belongsTo(Document::class);
    }

    // Relasi dengan anggota yang diberikan akses
    public function member(): BelongsTo
    {
        return $this->belongsTo(Member::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Division extends Model
{
    protected $fillable = [
        'name',
        'description',
    ];

    // Satu divisi memiliki banyak anggota
    public function members(): HasMany
    {
        return $this->hasMany(Member::class);
    }

    // Satu divisi dapat menyelenggarakan banyak proker
    public function programs(): HasMany
    {
        return $this->hasMany(Program::class);
    }
}

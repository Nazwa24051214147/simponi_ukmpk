<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MemberSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function () {

            // Mengambil ID akun demo Fitria
            $userId = DB::table('users')
                ->where('email', env('DEMO_MEMBER_EMAIL'))
                ->value('id');

            // Mengambil ID divisi Pendidikan
            $divisionId = DB::table('divisions')
                ->where('name', 'Pendidikan')
                ->value('id');

            if (!$userId || !$divisionId) {
                throw new \RuntimeException(
                    'Akun demo atau divisi Pendidikan belum tersedia.'
                );
            }

            // Membuat profil anggota Fitria
            DB::table('members')->updateOrInsert(
                ['nim' => '25000000001'],
                [
                    'user_id' => $userId,
                    'division_id' => $divisionId,
                    'position' => 'Staff',
                    'generation' => '2026/2027',
                    'status' => 'Active',
                    'updated_at' => now(),
                ]
            );
        });
    }
}
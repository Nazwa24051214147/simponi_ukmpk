<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function () {
            // Membuat atau memperbarui akun Ketua Umum
            DB::table('users')->updateOrInsert(
                ['email' => env('ADMIN_EMAIL')],
                [
                    'name' => env('ADMIN_NAME'),
                    'password' => Hash::make(env('ADMIN_PASSWORD')),
                    'updated_at' => now(),
                ]
            );

            // Mengambil ID akun Ketua Umum
            $userId = DB::table('users')
                ->where('email', env('ADMIN_EMAIL'))
                ->value('id');

            // Mengambil ID divisi BPH
            $divisionId = DB::table('divisions')
                ->where('name', 'BPH')
                ->value('id');

            // Membuat profil anggota Ketua Umum
            DB::table('members')->updateOrInsert(
                ['nim' => '24051214147'],
                [
                    'user_id' => $userId,
                    'division_id' => $divisionId,
                    'position' => 'Ketua Umum',
                    'generation' => '2026/2027',
                    'status' => 'Active',
                    'updated_at' => now(),
                ]
            );

            // Mengambil ID role admin
            $roleId = DB::table('roles')
                ->where('name', 'admin')
                ->value('id');

            // Menghubungkan akun dengan role admin
            DB::table('user_roles')->updateOrInsert(
                [
                    'user_id' => $userId,
                    'role_id' => $roleId,
                ],
                [
                    'updated_at' => now(),
                ]
            );
        });
    }
}
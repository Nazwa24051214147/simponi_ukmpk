<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use RuntimeException;

class ManagerSeeder extends Seeder
{
    public function run(): void
    {
        $name = env('DEMO_MANAGER_NAME');
        $email = env('DEMO_MANAGER_EMAIL');
        $password = env('DEMO_MANAGER_PASSWORD');

        if (!$name || !$email || !$password) {
            throw new RuntimeException(
                'Konfigurasi akun pengurus belum lengkap di file .env.'
            );
        }

        DB::transaction(function () use ($name, $email, $password) {

            // Membuat atau memperbarui akun pengurus
            DB::table('users')->updateOrInsert(
                ['email' => $email],
                [
                    'name' => $name,
                    'password' => Hash::make($password),
                    'updated_at' => now(),
                ]
            );

            // Mengambil ID akun pengurus
            $userId = DB::table('users')
                ->where('email', $email)
                ->value('id');

            // Mengambil ID divisi Pendidikan
            $divisionId = DB::table('divisions')
                ->where('name', 'Pendidikan')
                ->value('id');

            // Mengambil ID role pengurus
            $roleId = DB::table('roles')
                ->where('name', 'pengurus')
                ->value('id');

            if (!$divisionId || !$roleId) {
                throw new RuntimeException(
                    'Divisi Pendidikan atau role pengurus belum tersedia.'
                );
            }

            // Membuat profil Kepala Divisi
            DB::table('members')->updateOrInsert(
                ['nim' => '24000000002'],
                [
                    'user_id' => $userId,
                    'division_id' => $divisionId,
                    'position' => 'Kepala Divisi',
                    'generation' => '2026/2027',
                    'status' => 'Active',
                    'updated_at' => now(),
                ]
            );

            // Menghubungkan akun dengan role pengurus
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
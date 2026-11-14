<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use RuntimeException;

class DemoUserSeeder extends Seeder
{
    public function run(): void
    {
        $name = env('DEMO_MEMBER_NAME');
        $email = env('DEMO_MEMBER_EMAIL');
        $password = env('DEMO_MEMBER_PASSWORD');

        if (!$name || !$email || !$password) {
            throw new RuntimeException(
                'Konfigurasi akun demo belum lengkap di file .env.'
            );
        }

        DB::transaction(function () use ($name, $email, $password) {

            // Membuat atau memperbarui akun demo
            DB::table('users')->updateOrInsert(
                ['email' => $email],
                [
                    'name' => $name,
                    'password' => Hash::make($password),
                    'updated_at' => now(),
                ]
            );

            // Mengambil ID akun demo
            $userId = DB::table('users')
                ->where('email', $email)
                ->value('id');

            // Mengambil ID role anggota
            $roleId = DB::table('roles')
                ->where('name', 'anggota')
                ->value('id');

            // Menghubungkan akun dengan role anggota
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
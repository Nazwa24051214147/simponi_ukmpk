<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            DivisionSeeder::class,
            RoleSeeder::class,
            UserSeeder::class,
            DemoUserSeeder::class,
            MemberSeeder::class,
            ManagerSeeder::class,
        ]);
    }
}
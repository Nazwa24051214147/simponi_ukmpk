<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DivisionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $divisions = [
            ['name' => 'BPH'],
            ['name' => 'Pendidikan'],
            ['name' => 'Kesehatan'],
            ['name' => 'PSDM'],
            ['name' => 'Mitigasi Bencana'],
            ['name' => 'Huminfo'],
            ['name' => 'Ekraf'],
        ];

        foreach ($divisions as $division) {
            DB::table('divisions')->updateOrInsert(
                ['name' => $division['name']],
                [
                    'name' => $division['name'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]
            );
        }
    }
}

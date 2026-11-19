<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProgramRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'division_id'        => ['required', 'integer', 'exists:divisions,id'],
            'pic_id'             => ['nullable', 'integer', 'exists:members,id'],
            'name'               => ['required', 'string', 'max:150'],
            'description'        => ['nullable', 'string'],
            'quota'              => ['nullable', 'integer', 'min:0'],
            'registration_type'  => ['nullable', 'string', 'max:20'],
            'registration_start' => ['nullable', 'date'],
            'registration_end'   => ['nullable', 'date', 'after_or_equal:registration_start'],
            'start_date'         => ['nullable', 'date'],
            'end_date'           => ['nullable', 'date', 'after_or_equal:start_date'],
            'location'           => ['nullable', 'string', 'max:255'],
            'status'             => [
                'nullable',
                'string',
                Rule::in(['Planned', 'Preparation', 'Ongoing', 'Completed', 'Cancelled']),
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'division_id.required'           => 'Divisi penyelenggara wajib dipilih.',
            'division_id.exists'             => 'Divisi tidak ditemukan.',
            'pic_id.exists'                  => 'Ketua Pelaksana (PIC) tidak valid.',
            'name.required'                  => 'Nama program kerja wajib diisi.',
            'name.max'                       => 'Nama program kerja maksimal 150 karakter.',
            'registration_end.after_or_equal'=> 'Tanggal akhir pendaftaran tidak boleh sebelum tanggal mulai pendaftaran.',
            'end_date.after_or_equal'        => 'Tanggal selesai kegiatan tidak boleh sebelum tanggal mulai.',
            'status.in'                      => 'Status harus salah satu dari: Planned, Preparation, Ongoing, Completed, Cancelled.',
        ];
    }
}

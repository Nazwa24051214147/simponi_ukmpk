<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreAccountRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            // Data akun (users)
            'name'        => ['required', 'string', 'max:255'],
            'email'       => ['required', 'email', 'max:255', Rule::unique('users', 'email')],

            // Data anggota (members)
            'nim'         => ['required', 'string', 'max:20', Rule::unique('members', 'nim')],
            'phone'       => ['nullable', 'string', 'max:20'],
            'division_id' => ['required', 'integer', 'exists:divisions,id'],
            'position'    => ['required', 'string', 'max:50'],
            'generation'  => ['required', 'string', 'max:20'],
            'status'      => ['nullable', 'string', 'in:Active,Inactive'],

            // Role aplikasi
            'role' => [
                'required',
                'string',
                Rule::in(['admin', 'pengurus', 'anggota']),
                Rule::exists('roles', 'name'),
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'name.required'        => 'Nama wajib diisi.',
            'email.required'       => 'Email wajib diisi.',
            'email.email'          => 'Format email tidak valid.',
            'email.unique'         => 'Email sudah digunakan oleh akun lain.',
            'nim.required'         => 'NIM wajib diisi.',
            'nim.unique'           => 'NIM sudah terdaftar.',
            'division_id.required' => 'Divisi wajib dipilih.',
            'division_id.exists'   => 'Divisi tidak ditemukan.',
            'position.required'    => 'Jabatan wajib diisi.',
            'generation.required'  => 'Angkatan wajib diisi.',
            'role.required'        => 'Role wajib dipilih.',
            'role.in'              => 'Role harus salah satu dari: admin, pengurus, anggota.',
            'role.exists' => 'Role tidak ditemukan di database.',
        ];
    }
}

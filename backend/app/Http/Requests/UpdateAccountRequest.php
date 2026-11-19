<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateAccountRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Normalisasi input sebelum validasi:
     * phone berupa string kosong dikonversi ke null agar konsisten dengan kolom nullable.
     */
    protected function prepareForValidation(): void
    {
        if ($this->has('phone') && $this->phone === '') {
            $this->merge(['phone' => null]);
        }
    }

    public function rules(): array
    {
        // Ambil objek User dari route model binding
        $account = $this->route('account');

        // Ambil ID user yang sedang diedit
        $userId = $account instanceof \App\Models\User
            ? $account->id
            : $account;

        // Ambil ID member berdasarkan user_id
        $memberId = \App\Models\Member::where('user_id', $userId)->value('id');

        return [
            // Data akun (users) — semua opsional pada update
            'name'  => ['sometimes', 'required', 'string', 'max:255'],
            'email' => [
                'sometimes', 'required', 'email', 'max:255',
                Rule::unique('users', 'email')->ignore($userId),
            ],

            // Data anggota (members) — semua opsional pada update
            'nim' => [
                'sometimes', 'required', 'string', 'max:20',
                Rule::unique('members', 'nim')->ignore($memberId),
            ],
            'phone'       => ['sometimes', 'nullable', 'string', 'max:20'],
            'division_id' => ['sometimes', 'required', 'integer', 'exists:divisions,id'],
            'position'    => ['sometimes', 'required', 'string', 'max:50'],
            'generation'  => ['sometimes', 'required', 'string', 'max:20'],
            'status'      => ['sometimes', 'nullable', 'string', 'in:Active,Inactive'],

            // Role aplikasi — opsional pada update
            'role' => [
                'sometimes',
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
            'nim.unique'           => 'NIM sudah terdaftar oleh anggota lain.',
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

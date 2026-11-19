class Validators {
  Validators._();

  static String? validateRequired(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi.';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }
    return null;
  }

  static String? validateNewPassword({
    required String? newPassword,
    required String currentPassword,
  }) {
    if (newPassword == null || newPassword.isEmpty) {
      return 'Password baru wajib diisi.';
    }
    if (newPassword.length < 8) {
      return 'Password baru minimal 8 karakter.';
    }
    if (newPassword == currentPassword) {
      return 'Password baru harus berbeda dengan password lama.';
    }
    return null;
  }

  static String? validatePasswordConfirmation({
    required String? confirmation,
    required String newPassword,
  }) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }
    if (confirmation != newPassword) {
      return 'Konfirmasi password tidak cocok.';
    }
    return null;
  }
}

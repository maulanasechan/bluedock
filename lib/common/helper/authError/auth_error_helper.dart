import 'package:firebase_auth/firebase_auth.dart';

String mapAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'Email sudah terdaftar. Coba login atau gunakan email lain.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'weak-password':
      return 'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
    case 'operation-not-allowed':
      return 'Pendaftaran sedang tidak diizinkan untuk saat ini.';
    default:
      return error.message ?? 'Registrasi gagal. Silakan coba lagi.';
  }
}

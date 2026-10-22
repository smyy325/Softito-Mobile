/// Form alanları için doğrulanabilir kurallar sınıfı
class Validators {
  /// E-posta adresinin boş olmaması ve geçerli formatta (@ içermesi) kontrolü
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen e-posta adresinizi giriniz.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!value.contains('@') || !emailRegex.hasMatch(value.trim())) {
      return 'Lütfen geçerli bir e-posta adresi giriniz (Örn: ad@domain.com)';
    }
    return null;
  }

  /// Şifrenin en az 6 karakter olması ve boş olmaması kontrolü
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi giriniz.';
    }
    if (value.length < 6) {
      return 'Şifreniz en az 6 karakter olmalıdır.';
    }
    return null;
  }

  /// Yeni şifre ve şifre tekrarının birbiriyle eşleşip eşleşmediği kontrolü
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi tekrar giriniz.';
    }
    if (value != originalPassword) {
      return 'Girdiğiniz şifreler birbiriyle eşleşmiyor.';
    }
    return null;
  }

  /// Genel zorunlu alan kontrolü
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Lütfen $fieldName alanını doldurunuz.';
    }
    return null;
  }
}

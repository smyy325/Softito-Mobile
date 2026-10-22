import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'login_screen.dart';

/// 5. Şifre Belirleme Ekranı (SetPasswordScreen)
/// Yeni Şifre ve Tekrar Yeni Şifre eşleşme validasyonu,
/// ValueNotifier ve ValueListenableBuilder ile bağımsız şifre görünürlüğü yönetimi.
class SetPasswordScreen extends StatefulWidget {
  final String? email;

  const SetPasswordScreen({super.key, this.email});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Şifre görünürlük durumları için ValueNotifier (setState yerine mikro-yenileme)
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Bellek temizliği
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  Future<void> _handleSavePassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text('Şifreniz başarıyla güncellendi! Yeni şifrenizle giriş yapabilirsiniz.'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Şifre Belirle'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                      ),
                      child: Icon(
                        Icons.key_rounded,
                        size: 42,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Güçlü Bir Şifre Oluştur',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Galaksi hesabının güvenliği için en az 6 karakterden oluşan yeni bir şifre belirle.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // 1. Yeni Şifre (ValueNotifier ile Görünürlük Kontrolü)
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscure, child) {
                      return CustomTextField(
                        controller: _passwordController,
                        label: 'Yeni Şifre',
                        hint: 'En az 6 karakter',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: obscure,
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _obscurePassword.value = !_obscurePassword.value;
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 2. Tekrar Yeni Şifre (ValueNotifier ile Görünürlük ve Eşleşme Kontrolü)
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, obscure, child) {
                      return CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Tekrar Yeni Şifre',
                        hint: 'Şifrenizi doğrulayın',
                        prefixIcon: Icons.lock_reset_rounded,
                        obscureText: obscure,
                        validator: (value) => Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: _isLoading ? null : _handleSavePassword,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Şifreyi Güncelle'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

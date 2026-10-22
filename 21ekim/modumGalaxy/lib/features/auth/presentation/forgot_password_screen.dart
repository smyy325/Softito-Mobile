import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'set_password_screen.dart';

/// 4. Şifremi Unuttum Ekranı (ForgotPasswordScreen)
/// E-mail tabanlı şifre sıfırlama, Form validasyonu ve
/// Şifre Belirleme Ekranına (SetPasswordScreen) yönlendirme.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mark_email_read_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_emailController.text} adresine şifre sıfırlama kodu gönderildi.',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 5. Ekran olan SetPasswordScreen'e yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SetPasswordScreen(
          email: _emailController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 42,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Galaktik Şifreni Sıfırla',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Kayıtlı e-posta adresini gir. Sana şifreni yenilemen için güvenli bir bağlantı oluşturalım.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _emailController,
                  label: 'E-Posta Adresi',
                  hint: 'ornek@modumgalaxy.com',
                  prefixIcon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),

                const SizedBox(height: 28),

                FilledButton(
                  onPressed: _isLoading ? null : _handleSendResetLink,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Şifre Sıfırlama Kodu Gönder'),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Giriş Ekranına Geri Dön'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

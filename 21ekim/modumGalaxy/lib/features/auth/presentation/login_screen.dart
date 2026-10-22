import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../../home/presentation/home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

/// 2. Giriş Ekranı (LoginScreen)
/// Textfield'lar alt alta, "Giriş Yap" ve "Üye Ol" butonları Row ve Expanded
/// ile üstteki TextField genişliğine tam %50-%50 eşit hizalanır.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: 'sumeyye@modumgalaxy.com');
    _passwordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için controller'ları ve notifier'ı temizle
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Klavye kapatma
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Lütfen formdaki eksik veya hatalı alanları düzeltiniz.')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final success = await auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text('Hoş geldiniz, ${auth.userName}! Duygu Galaksiniz yükleniyor.')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Giriş başarısız: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Küçük Logo ve Başlık
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.public,
                          size: 70,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Modum Galaxy\'e Giriş',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Bugünkü ruh halini keşfetmek için hesabına giriş yap.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // 1. E-posta TextField
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-Posta Adresi',
                    hint: 'ornek@modumgalaxy.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 20),

                  // 2. Şifre TextField (ValueNotifier ile obscure kontrolü)
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscure, child) {
                      return CustomTextField(
                        controller: _passwordController,
                        label: 'Şifre',
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

                  // Şifremi Unuttum Butonu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Şifremi Unuttum?',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🌟 UI KURALI: "Giriş Yap" ve "Üye Ol" Butonları
                  // Row ve Expanded ile üstteki TextField genişliğini %50 - %50 tam paylaşır.
                  Row(
                    children: [
                      // Giriş Yap Butonu (%50)
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Giriş Yap'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Üye Ol Butonu (%50)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterScreen(),
                                    ),
                                  );
                                },
                          child: const Text('Üye Ol'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

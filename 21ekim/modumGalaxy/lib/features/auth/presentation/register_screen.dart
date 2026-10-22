import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../../home/presentation/home_screen.dart';

/// 3. Kayıt Ekranı (RegisterScreen)
/// Ad-Soyad, E-Posta ve Şifre girişleri,
/// %50-%50 eşit genişlikte "Kayıt Ol" ve "Girişe Dön" butonları.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Bellek sızıntılarını önleme
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Lütfen formdaki tüm alanları eksiksiz doldurunuz.')),
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
      final success = await auth.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text('Tebrikler ${_nameController.text}! Galaktik hesabın açıldı.')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Doğrudan ana ekrana geçiş
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt oluşturulamadı: $e'),
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
      appBar: AppBar(
        title: const Text('Yeni Galaksi Hesabı'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Duygularının Galaksisine Katıl',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kişisel gezegenlerini yaratmak ve ruh halini takip etmek için üye ol.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Ad Soyad
                  CustomTextField(
                    controller: _nameController,
                    label: 'Adınız ve Soyadınız',
                    hint: 'Örn: Sümeyye Yıldız',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (val) => Validators.validateRequired(val, 'Adınız ve Soyadınız'),
                  ),

                  const SizedBox(height: 18),

                  // E-posta
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-Posta Adresi',
                    hint: 'ornek@modumgalaxy.com',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 18),

                  // Şifre
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

                  const SizedBox(height: 32),

                  // 🌟 UI KURALI: "Kayıt Ol" ve "Girişe Dön" butonları
                  // Row ve Expanded ile üstteki TextField genişliğini %50 - %50 eşit paylaşır.
                  Row(
                    children: [
                      // Kayıt Ol Butonu (%50)
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Üye Ol'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Girişe Dön Butonu (%50)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                          child: const Text('Giriş Yap'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

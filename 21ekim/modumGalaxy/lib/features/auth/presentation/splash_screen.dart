import 'package:flutter/material.dart';
import 'login_screen.dart';

/// 1. Karşılama Ekranı (SplashScreen)
/// Merkezde logo, altında etkileyici bir motto ve FilledButton (Giriş Yap).
/// Butona tıklandığında yumuşak bir fade transition ile kimlik doğrulama ekranına yönlendirir.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    // Yumuşak fade transition ile geçiş
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.primaryContainer.withValues(alpha: 0.3),
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Merkez Logo
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.25),
                            blurRadius: 36,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primaryContainer,
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 80,
                              color: colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Başlık
                    Text(
                      'Modum Galaxy',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Etkileyici Motto
                    Text(
                      'Duygularını birer gezegene dönüştür,\nruh halini galaksinin derinliklerinde keşfet.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    // Aksiyon Butonu (FilledButton - Giriş Yap)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _navigateToLogin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Galaksiye Giriş Yap'),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20, color: colorScheme.onPrimary),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

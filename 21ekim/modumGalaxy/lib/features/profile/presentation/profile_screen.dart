import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../notes/providers/notes_provider.dart';

/// 10. Profil ve Ayarlar Ekranı (ProfileScreen)
/// Kullanıcı bilgileri ve AlertDialog ile güvenli çıkış yapma onayı.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Çıkış Yapılsın mı?'),
            ],
          ),
          content: const Text(
            'Modum Galaxy oturumunu kapatmak istediğinden emin misin? Günlük notların güvende kalacaktır.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthProvider>().logout();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Başarıyla çıkış yapıldı.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Evet, Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final notesProvider = context.watch<NotesProvider>();

    final totalNotes = notesProvider.notes.length;
    final totalPlanets = notesProvider.planets.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galaksi Profilim'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Profil Kartı (Avatar, İsim, E-posta)
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          authProvider.userName.isNotEmpty
                              ? authProvider.userName[0].toUpperCase()
                              : 'M',
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      authProvider.userName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authProvider.userEmail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // İstatistik Kartları (Toplam Not, Aktif Gezegen)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.edit_note_rounded, color: colorScheme.primary, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '$totalNotes',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Toplam Not',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.public, color: colorScheme.secondary, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '$totalPlanets',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Duygu Gezegeni',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // 🌟 ÇIKIŞ YAP BUTONU (AlertDialog tetikler)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                  ),
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Hesaptan Çıkış Yap'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

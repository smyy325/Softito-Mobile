import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/planet_card.dart';
import '../../notes/providers/notes_provider.dart';
import '../../notes/presentation/add_note_screen.dart';
import '../../notes/presentation/assign_mood_screen.dart';
import '../../analytics/presentation/analytics_screen.dart';
import '../../profile/presentation/profile_screen.dart';

/// 6. Ana Ekran ve Not Akışı (HomeScreen)
/// Üstte AppBar (Logo, Başlık ve Tema değiştirme ikonu),
/// Altta 4 sekmeli BottomNavigationBar,
/// Geçmiş notlar Material 3 Card yapısında (PlanetCard),
/// FloatingActionButton (+) ile AddNoteScreen'e geçiş.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _confirmDeleteNote(BuildContext context, String noteId, String noteTitle) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text('Notu Sil'),
            ],
          ),
          content: Text('"$noteTitle" başlıklı notu silmek istediğinden emin misin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<NotesProvider>().deleteNote(noteId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not galaksiden silindi.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Sil'),
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
    final themeProvider = context.watch<ThemeProvider>();

    final pages = [
      _buildFeedTab(context),
      const AssignMoodScreen(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode
            ? const Color(0xFF141328)
            : const Color(0xFFFAFAFD),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/app_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.public,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Modum Galaxy',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: 0.3,
                    color: themeProvider.isDarkMode
                        ? const Color(0xFFE2DEFE)
                        : const Color(0xFF2C2A4A),
                  ),
                ),
                Text(
                  'Duygu Galaksisi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Dairesel Tema Değiştirme İkon Butonu
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              onTap: () {
                themeProvider.toggleTheme(!themeProvider.isDarkMode);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface.withValues(alpha: 0.85),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Center(
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 19,
                    color: themeProvider.isDarkMode
                        ? const Color(0xFFFDCB6E)
                        : const Color(0xFF6C5CE7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      // Aksiyon Butonu (+ ile not ekleme) - Sadece ilk ekranda (Akış) gösterilir
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddNoteScreen(),
                  ),
                );
              },
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_rounded),
            activeIcon: Icon(Icons.auto_stories),
            label: 'Akış',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public_rounded),
            activeIcon: Icon(Icons.public),
            label: 'Gezegenler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_rounded),
            activeIcon: Icon(Icons.insights),
            label: 'Analiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notesProvider = context.watch<NotesProvider>();
    final notes = notesProvider.notes;

    if (notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.nights_stay_rounded,
                size: 72,
                color: colorScheme.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'Galaksin Henüz Sessiz',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aşağıdaki + butonuna dokunarak günün ilk ruh hali notunu ekle ve galaksini aydınlat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      physics: const BouncingScrollPhysics(),
      itemCount: notes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duygu Günlüğüm',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${notes.length} Not Kayıtlı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final note = notes[index - 1];
        return PlanetCard(
          note: note,
          onDelete: () => _confirmDeleteNote(context, note.id, note.title),
          onTap: () {
            // Not detay diyaloğu
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: colorScheme.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              builder: (modalContext) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(note.planetImagePath),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.planetName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Duygu: ${note.moodLabel}',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        note.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        note.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/planet_model.dart';
import '../providers/notes_provider.dart';

/// 7. Not Ekleme Ekranı (AddNoteScreen)
/// Ekranın üst kısmında yatayda kaydırılabilir dairesel gezegen ikonları (ListView.builder - horizontal),
/// "Günün Başlığı" ve "Detaylar" için çok satırlı TextFormField ve en altta FilledButton.
class AddNoteScreen extends StatefulWidget {
  final PlanetModel? initialPlanet;

  const AddNoteScreen({super.key, this.initialPlanet});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late PlanetModel _selectedPlanet;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    final notesProvider = context.read<NotesProvider>();
    _selectedPlanet = widget.initialPlanet ?? notesProvider.planets.first;
  }

  @override
  void dispose() {
    // Bellek temizliği (Memory leak önleme)
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSaveNote() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notesProvider = context.read<NotesProvider>();
    notesProvider.addNote(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      planet: _selectedPlanet,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Notunuz "${_selectedPlanet.name}" gezegeniyle galaksinize eklendi!',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final planets = context.watch<NotesProvider>().planets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Ruh Hali Notu'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // Başlık & Açıklama
                      Text(
                        'Bugünkü Duygun Hangi Gezegene Ait?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ruh halini en iyi yansıtan gezegeni seç:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🪐 YATAY KAYDIRILABİLİR GEZEGEN LİSTESİ (ListView.builder - horizontal)
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: planets.length,
                          itemBuilder: (context, index) {
                            final planet = planets[index];
                            final isSelected = planet.id == _selectedPlanet.id;

                            return Padding(
                              padding: const EdgeInsets.only(right: 14.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedPlanet = planet;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: 90,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                                        : colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.outlineVariant.withValues(alpha: 0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: colorScheme.primary.withValues(alpha: 0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: Image.asset(
                                          planet.imagePath,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        planet.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isSelected
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        planet.moodLabel.split('&').first.trim(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Seçili Gezegenin Duygu Kartı Özeti
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Image.asset(_selectedPlanet.imagePath),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedPlanet.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    'Duygu: ${_selectedPlanet.moodLabel}',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Günün Başlığı (TextFormField)
                      CustomTextField(
                        controller: _titleController,
                        label: 'Günün Başlığı',
                        hint: 'Örn: Verimli bir çalışma günü',
                        prefixIcon: Icons.title_rounded,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) => Validators.validateRequired(value, 'Günün Başlığı'),
                      ),

                      const SizedBox(height: 20),

                      // Detaylar (Çok Satırlı TextFormField)
                      CustomTextField(
                        controller: _contentController,
                        label: 'Detaylar ve Duygular',
                        hint: 'Bugün sana ne hissettirdi? Aklından neler geçiyor...',
                        maxLines: 5,
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) => Validators.validateRequired(value, 'Detaylar'),
                      ),

                      const SizedBox(height: 28),

                      // En Altta FilledButton
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _handleSaveNote,
                          icon: const Icon(Icons.rocket_launch_rounded),
                          label: const Text('Galaksiye Kaydet'),
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

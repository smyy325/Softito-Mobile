import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/planet_model.dart';
import '../providers/notes_provider.dart';
import 'add_note_screen.dart';

/// 8. Gezegen & Duygu Eşleştirme Ekranı (AssignMoodScreen)
/// Kullanıcılar istedikleri gezegeni seçip ona kendi özel ruh hali etiketini
/// atayarak kişiselleştirilmiş bir "Duygu Galaksisi" yaratırlar.
class AssignMoodScreen extends StatefulWidget {
  const AssignMoodScreen({super.key});

  @override
  State<AssignMoodScreen> createState() => _AssignMoodScreenState();
}

class _AssignMoodScreenState extends State<AssignMoodScreen> {
  PlanetModel? _selectedPlanet;
  late final TextEditingController _moodLabelController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _moodLabelController = TextEditingController();
  }

  @override
  void dispose() {
    // Bellek temizliği
    _moodLabelController.dispose();
    super.dispose();
  }

  void _selectPlanet(PlanetModel planet) {
    setState(() {
      _selectedPlanet = planet;
      _moodLabelController.text = planet.moodLabel;
    });
  }

  void _saveMoodAssignment() {
    if (_selectedPlanet == null) return;
    if (!_formKey.currentState!.validate()) return;

    final newLabel = _moodLabelController.text.trim();
    final provider = context.read<NotesProvider>();
    provider.updatePlanetMood(_selectedPlanet!.id, newLabel);

    setState(() {
      _selectedPlanet = provider.getPlanetById(_selectedPlanet!.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${_selectedPlanet!.name} gezegeni artık "$newLabel" duygusunu temsil ediyor!',
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final planets = context.watch<NotesProvider>().planets;

    // Eğer henüz seçim yapılmadıysa ilk gezegeni seç
    if (_selectedPlanet == null && planets.isNotEmpty) {
      _selectedPlanet = planets.first;
      _moodLabelController.text = _selectedPlanet!.moodLabel;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duygu Galaksisi Eşleştirme'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Açıklama Başlığı
              Text(
                'Gezegenlerini Ruh Halinle Eşleştir',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Her bir gezegene hissettiğin duyguları ata. Galaksin senin iç dünyana göre şekillensin.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 20),

              // Gezegenler Izgarası (Grid)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: planets.length,
                itemBuilder: (context, index) {
                  final planet = planets[index];
                  final isSelected = _selectedPlanet?.id == planet.id;

                  return InkWell(
                    onTap: () => _selectPlanet(planet),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                            : colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              planet.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            planet.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              // Seçili Gezegenin Detay ve Düzenleme Kartı
              if (_selectedPlanet != null)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 72,
                                height: 72,
                                child: Image.asset(_selectedPlanet!.imagePath),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedPlanet!.name,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedPlanet!.description,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _moodLabelController,
                            label: 'Atanacak Ruh Hali & Duygu Etiketi',
                            hint: 'Örn: Sakinlik, Coşku, Dinginlik',
                            prefixIcon: Icons.psychology_rounded,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Lütfen bir duygu etiketi giriniz.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _saveMoodAssignment,
                              icon: const Icon(Icons.check_circle_rounded),
                              label: const Text('Duygu Etiketini Güncelle'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AddNoteScreen(
                                      initialPlanet: _selectedPlanet,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit_note_rounded),
                              label: const Text('Bu Gezegenle Not Yaz'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

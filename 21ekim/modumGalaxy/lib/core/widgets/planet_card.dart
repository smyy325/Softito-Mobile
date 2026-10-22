import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/notes/models/note_model.dart';

/// Notların Material 3 Card yapısında listelendiği şık bileşen.
/// Hover ve dokunma anında arkasından gezegen renginde dinamik neon aura (glow)
/// saçar ve hafifçe yukarı kabararak etkileyici bir derinlik sunar.
class PlanetCard extends StatefulWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PlanetCard({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
  });

  @override
  State<PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<PlanetCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color _getPlanetColor(String planetId) {
    switch (planetId) {
      case 'jupiter':
        return const Color(0xFFF39C12);
      case 'neptune':
        return const Color(0xFF2980B9);
      case 'earth':
        return const Color(0xFF27AE60);
      case 'saturn':
        return const Color(0xFF8E44AD);
      case 'mars':
        return const Color(0xFFE74C3C);
      case 'uranus':
        return const Color(0xFF00CEC9);
      case 'venus':
        return const Color(0xFFE84393);
      case 'mercury':
      default:
        return const Color(0xFF6C5CE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final planetColor = _getPlanetColor(widget.note.planetId);
    final isInteracting = _isHovered || _isPressed;

    String formattedDate;
    try {
      formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(widget.note.date);
    } catch (_) {
      final d = widget.note.date;
      formattedDate =
          '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, isInteracting ? -5 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: colorScheme.surface,
            // 🌟 KARTIN ARKASINDA SABİT PARILDAYAN GALAKTİK NEON HALESİ (Ambient Glow)
            boxShadow: [
              // Derinlik gölgesi
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              // Gezegenin kendi renginde canlı sabit neon aurası
              BoxShadow(
                color: planetColor.withValues(alpha: 0.35),
                blurRadius: 28,
                spreadRadius: 3,
                offset: const Offset(0, 8),
              ),
              // Dışarıya taşan geniş ve yumuşak galaktik parıltı
              BoxShadow(
                color: planetColor.withValues(alpha: 0.20),
                blurRadius: 52,
                spreadRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            // Gezegen rengiyle uyumlu sabit parıldayan çerçeve
            border: Border.all(
              color: planetColor.withValues(alpha: 0.40),
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (val) => setState(() => _isPressed = val),
            borderRadius: BorderRadius.circular(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🌟 DİKKAT ÇEKİCİ KOZMİK NEBULA & GEZEGEN ALANI
                Container(
                  height: 175,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0D0B1E),
                        planetColor.withValues(alpha: isInteracting ? 0.52 : 0.42),
                        const Color(0xFF15142B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Kozmik Yıldız Tozu ve Parıltılar
                      Positioned(
                        top: 28,
                        left: 36,
                        child: Icon(
                          Icons.star_rounded,
                          size: 10,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      Positioned(
                        bottom: 34,
                        left: 48,
                        child: Icon(
                          Icons.auto_awesome,
                          size: 14,
                          color: planetColor.withValues(alpha: 0.7),
                        ),
                      ),
                      Positioned(
                        top: 38,
                        right: 44,
                        child: Icon(
                          Icons.star_rounded,
                          size: 8,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        right: 70,
                        child: Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),

                      // 2. Çok Katmanlı Işıltılı Yörünge Halkaları (Orbital Rings)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        width: isInteracting ? 205 : 195,
                        height: isInteracting ? 205 : 195,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: planetColor.withValues(alpha: isInteracting ? 0.32 : 0.18),
                            width: 1.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 155,
                        height: 155,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                      ),

                      // 3. Gezegen Arkası Canlı Radyal Aura (Glow)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        width: isInteracting ? 160 : 140,
                        height: isInteracting ? 160 : 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              planetColor.withValues(alpha: isInteracting ? 0.80 : 0.65),
                              planetColor.withValues(alpha: 0.0),
                            ],
                            stops: const [0.2, 1.0],
                          ),
                        ),
                      ),

                      // 4. Gezegen Görseli (3D İllüstrasyon)
                      Hero(
                        tag: 'planet_img_${widget.note.id}',
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 240),
                          scale: isInteracting ? 1.06 : 1.0,
                          curve: Curves.easeOutCubic,
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              widget.note.planetImagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.public,
                                  size: 85,
                                  color: planetColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // 5. Sol Üst: Buzlu Cam (Glassmorphic) Gezegen Adı Rozeti
                      Positioned(
                        top: 14,
                        left: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 13,
                                color: planetColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.note.planetName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 6. Sağ Üst: Renkli Ruh Hali Rozeti
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                planetColor.withValues(alpha: 0.9),
                                planetColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: planetColor.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.note.moodLabel,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 11,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Alt Kısım: Not Başlığı, İçerik Özeti ve Tarih
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.note.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.1,
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.onDelete != null)
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                                color: colorScheme.error.withValues(alpha: 0.8),
                              ),
                              visualDensity: VisualDensity.compact,
                              onPressed: widget.onDelete,
                            ),
                        ],
                      ),
                      if (widget.note.content.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.note.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

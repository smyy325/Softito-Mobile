/// Kullanıcının duygu ve gezegen ile eşleştirdiği not modeli
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String planetId;
  final String planetName;
  final String moodLabel;
  final String planetImagePath;
  final DateTime date;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.planetId,
    required this.planetName,
    required this.moodLabel,
    required this.planetImagePath,
    required this.date,
  });

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? planetId,
    String? planetName,
    String? moodLabel,
    String? planetImagePath,
    DateTime? date,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      planetId: planetId ?? this.planetId,
      planetName: planetName ?? this.planetName,
      moodLabel: moodLabel ?? this.moodLabel,
      planetImagePath: planetImagePath ?? this.planetImagePath,
      date: date ?? this.date,
    );
  }
}

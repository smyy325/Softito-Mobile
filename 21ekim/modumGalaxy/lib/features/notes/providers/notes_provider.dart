import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../models/planet_model.dart';

/// Notlar ve Gezegenler için Provider
/// Aylık analiz algoritmasını ve veri yönetimini içerir.
class NotesProvider extends ChangeNotifier {
  final List<PlanetModel> _planets = List.from(PlanetModel.defaultPlanets);
  final List<NoteModel> _notes = [];

  NotesProvider() {
    _initializeMockNotes();
  }

  List<PlanetModel> get planets => List.unmodifiable(_planets);
  List<NoteModel> get notes => List.unmodifiable(_notes);

  /// Son 30 günün notları
  List<NoteModel> get recent30DaysNotes {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    return _notes.where((note) => note.date.isAfter(thirtyDaysAgo)).toList();
  }

  /// Gezegen bul
  PlanetModel? getPlanetById(String planetId) {
    try {
      return _planets.firstWhere((p) => p.id == planetId);
    } catch (_) {
      return null;
    }
  }

  /// Gezegene yeni duygu etiketi atama (AssignMood)
  void updatePlanetMood(String planetId, String newMoodLabel) {
    final index = _planets.indexWhere((p) => p.id == planetId);
    if (index != -1) {
      _planets[index] = _planets[index].copyWith(moodLabel: newMoodLabel);

      // Ayrıca geçmiş notlarda bu gezegenin etiketini de güncelle
      for (int i = 0; i < _notes.length; i++) {
        if (_notes[i].planetId == planetId) {
          _notes[i] = _notes[i].copyWith(moodLabel: newMoodLabel);
        }
      }
      notifyListeners();
    }
  }

  /// Yeni not ekleme
  void addNote({
    required String title,
    required String content,
    required PlanetModel planet,
    DateTime? date,
  }) {
    final newNote = NoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      planetId: planet.id,
      planetName: planet.name,
      moodLabel: planet.moodLabel,
      planetImagePath: planet.imagePath,
      date: date ?? DateTime.now(),
    );

    _notes.insert(0, newNote);
    notifyListeners();
  }

  /// Not silme
  void deleteNote(String noteId) {
    _notes.removeWhere((n) => n.id == noteId);
    notifyListeners();
  }

  /// 🌟 Aylık Mod Algoritması (Business Rule):
  /// Son 30 gün içinde kaydedilen notlar taranır.
  /// Gezegen ID'leri gruplanarak `Map<String, int>` ile frekansı en yüksek gezegen bulunur.
  Map<String, dynamic> calculateMonthlyAnalysis() {
    final recentNotes = recent30DaysNotes;

    if (recentNotes.isEmpty) {
      return {
        'hasData': false,
        'dominantPlanet': null,
        'dominantMood': 'Henüz veri yok',
        'frequencyMap': <String, int>{},
        'totalNotes': 0,
        'insight': 'Duygu galaksini oluşturmak için ilk notunu eklemeye başla!',
      };
    }

    // Map<String, int> frekans analizi
    final Map<String, int> freqMap = {};
    for (final note in recentNotes) {
      freqMap[note.planetId] = (freqMap[note.planetId] ?? 0) + 1;
    }

    // En yüksek frekansa sahip gezegen ID'sini bul
    String? dominantPlanetId;
    int maxCount = -1;

    freqMap.forEach((planetId, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantPlanetId = planetId;
      }
    });

    final dominantPlanet = getPlanetById(dominantPlanetId ?? '') ?? _planets.first;
    final dominantMood = dominantPlanet.moodLabel;

    // Farkındalık notu / Öneri üretimi
    String insight;
    if (dominantPlanet.id == 'jupiter') {
      insight = 'Bu ay neşen ve coşkun dorukta! Pozitif enerjin çevrene ilham saçıyor. Bu üretken dalgayı koru.';
    } else if (dominantPlanet.id == 'neptune') {
      insight = 'Zihnin berrak ve sakin bir okyanus gibi. İç huzurun, stresli anlarda bile sana rehberlik ediyor.';
    } else if (dominantPlanet.id == 'earth') {
      insight = 'Harika bir odaklanma ve denge yakaladın. Hedeflerine emin adımlarla ilerliyorsun.';
    } else if (dominantPlanet.id == 'saturn') {
      insight = 'Bu ay derin ve düşünen bir evredesin. Kendine şefkat göster, hissettiklerini yazıya dökmek sana iyi geliyor.';
    } else if (dominantPlanet.id == 'mars') {
      insight = 'Yüksek bir tempo ve stres gözleniyor. Kendine kısa molalar ver, nefes egzersizleri yapmayı unutma.';
    } else if (dominantPlanet.id == 'uranus') {
      insight = 'Yaratıcılığın zirvede! Yeni fikirler ve projeler başlatmak için muazzam bir dönemdesin.';
    } else if (dominantPlanet.id == 'venus') {
      insight = 'Kalbin sevgi ve şefkatle dolu. Sosyal bağların ve kendine olan inancın güçleniyor.';
    } else {
      insight = 'Merakın ve öğrenme isteğin seni sürekli ileri taşıyor.';
    }

    return {
      'hasData': true,
      'dominantPlanet': dominantPlanet,
      'dominantMood': dominantMood,
      'frequencyMap': freqMap,
      'totalNotes': recentNotes.length,
      'maxCount': maxCount,
      'insight': insight,
    };
  }

  /// Başlangıç için zengin örnek notlar
  void _initializeMockNotes() {
    final now = DateTime.now();

    _notes.addAll([
      NoteModel(
        id: '1',
        title: 'Harika bir sunum yaptık!',
        content: 'Ekipçe hazırladığımız galaktik tasarım projesini müşteriye sunduk ve alkış aldık. Çok gururluyum.',
        planetId: 'jupiter',
        planetName: 'Jüpiter',
        moodLabel: 'Mutlu & Coşkulu',
        planetImagePath: 'assets/images/planets/planet_jupiter.png',
        date: now.subtract(const Duration(hours: 3)),
      ),
      NoteModel(
        id: '2',
        title: 'Akşam sahil yürüyüşü ve meditasyon',
        content: 'Deniz dalgalarının sesi eşliğinde 45 dakika yürüdüm. Zihnimdeki tüm dağınıklık yerini dinginliğe bıraktı.',
        planetId: 'neptune',
        planetName: 'Neptün',
        moodLabel: 'Huzurlu & Sakin',
        planetImagePath: 'assets/images/planets/planet_neptune.png',
        date: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      NoteModel(
        id: '3',
        title: 'Flutter mimarisini tamamladım',
        content: 'Clean Architecture yapısını kurdum ve testleri çalıştırdım. Son derece üretken bir çalışma seansıydı.',
        planetId: 'earth',
        planetName: 'Dünya',
        moodLabel: 'Dengeli & Üretken',
        planetImagePath: 'assets/images/planets/planet_earth.png',
        date: now.subtract(const Duration(days: 2, hours: 5)),
      ),
      NoteModel(
        id: '4',
        title: 'Eski anılar ve nostalji',
        content: 'Eski fotoğraflara bakarken hafif bir melankoli hissettim. Bazen geçmişe dönüp bakmak içsel bir olgunluk veriyor.',
        planetId: 'saturn',
        planetName: 'Satürn',
        moodLabel: 'Melankolik & Dalgın',
        planetImagePath: 'assets/images/planets/planet_saturn.png',
        date: now.subtract(const Duration(days: 4, hours: 8)),
      ),
      NoteModel(
        id: '5',
        title: 'Yoğun teslim haftası ve telaş',
        content: 'Aynı anda birden fazla işi yetiştirmeye çalışırken stres seviyem yükseldi. Biraz derin nefes almalıyım.',
        planetId: 'mars',
        planetName: 'Mars',
        moodLabel: 'Stresli & Hareketli',
        planetImagePath: 'assets/images/planets/planet_mars.png',
        date: now.subtract(const Duration(days: 6, hours: 4)),
      ),
      NoteModel(
        id: '6',
        title: 'Yeni UI konsepti çizimleri',
        content: 'Gece aniden aklıma gelen uzay temalı arayüz eskizlerini tablet ile çizdim. İlham perisi yanımdaydı!',
        planetId: 'uranus',
        planetName: 'Uranüs',
        moodLabel: 'Yaratıcı & İlhamlı',
        planetImagePath: 'assets/images/planets/planet_uranus.png',
        date: now.subtract(const Duration(days: 8, hours: 1)),
      ),
      NoteModel(
        id: '7',
        title: 'Dostlarla sıcacık kahve sohbeti',
        content: 'Sevdiğim insanlarla bir araya gelmek ruhuma ilaç gibi geldi.',
        planetId: 'venus',
        planetName: 'Venüs',
        moodLabel: 'Sevgi Dolu & Umutlu',
        planetImagePath: 'assets/images/planets/planet_venus.png',
        date: now.subtract(const Duration(days: 11, hours: 6)),
      ),
    ]);
  }
}

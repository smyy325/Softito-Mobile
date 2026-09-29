// 1. Enum'lar (Derleme Zamanı Güvenliği)
// Enum'lar, belirli bir değişkenin sadece bizim belirlediğimiz sabit değerleri almasını sağlar.
// Bu sayede yanlış veya geçersiz bir değer girilmesinin (örn: "Kredi Karti" yerine "kredi kartı" yazılması) önüne geçilir.
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }
enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }
enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

// Danışan (Müşteri) Modeli
// Kliniğe gelen müşterilerin verilerini tuttuğumuz sınıf (class).
class Danisan {
  final String id; // Benzersiz müşteri numarası
  final String adSoyad;
  final String telefon;
  final bool vipUyeMi; // VIP müşterilere özel indirimler uygulanabilir
  final List<String> alerjiler; // Boş bir liste olabilir ama null olamaz, güvenlik için önemlidir
  final String? ozelCiltNotu; // '?' işareti bu değerin null (boş) olabileceğini gösterir

  // Constructor (Kurucu Metot): Nesne oluşturulurken gerekli bilgileri almak için kullanılır.
  const Danisan({
    required this.id, // required: Bu parametrenin girilmesi zorunludur.
    required this.adSoyad,
    required this.telefon,
    this.vipUyeMi = false, // Değer girilmezse varsayılan olarak 'false' kabul edilir.
    this.alerjiler = const [], // Varsayılan olarak boş liste.
    this.ozelCiltNotu,
  });

  // Getter (Hesaplanmış Özellik): Danışanın alerji listesi doluysa cildinin hassas olduğunu varsayıyoruz.
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  // Danışanın genel bilgilerini tek bir metin (String) olarak döndüren özet fonksiyonu.
  String get bilgiOzeti {
    // Alerji listesi boşsa "Kayıtlı Alerji Yok" yazar, doluysa listedeki elemanları virgülle birleştirir.
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";
    
    // Özel not yoksa (null ise) ?? operatörü sayesinde sağdaki varsayılan metni kullanır.
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (Randevu) Modeli
// Danışanların aldığı hizmetleri ve finansal detayları tutan sınıf.
class SeansKaydi {
  final String seansKodu;
  final Danisan danisan; // Danisan sınıfından bir nesne içerir (Kompozisyon)
  final HizmetKategorisi kategori;
  final String islemAdi;
  final double birimFiyat;
  final int seansSayisi;
  final double indirimOrani; 
  final String? sorumluUzman; // İşlemi yapacak uzman (henüz atanmamış olabilir, o yüzden nullable)
  
  // Durum ve ödeme tipi işlem sonradan değişebileceği için 'final' yapılmamıştır.
  SeansDurumu durum;
  OdemeYontemi? odemeTipi;

  SeansKaydi({
    required this.seansKodu,
    required this.danisan,
    required this.kategori,
    required this.islemAdi,
    required this.birimFiyat,
    this.seansSayisi = 1,
    this.indirimOrani = 0.0,
    this.sorumluUzman,
    this.durum = SeansDurumu.bekliyor, // Varsayılan seans durumu
    this.odemeTipi,
  });

  // Brüt Tutar: İndirim uygulanmamış ham fiyat
  double get brutTutar => birimFiyat * seansSayisi;

  // İndirim Tutarı Hesaplama
  double get indirimTutari {
    double toplamOran = indirimOrani;
    // Eğer müşteri VIP ise mevcut indirime ek olarak %10 indirim daha kazanır.
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }
    return brutTutar * (toplamOran / 100.0);
  }

  // Net Tutar: Müşterinin ödeyeceği son fiyat
  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi
// Tüm iş mantığını (kayıt, randevu, ödeme, raporlama) yöneten ana sınıf.
class KlinikYoneticisi {
  final String subeAdi;
  // Seansları ve danışanları hafızada tutan koleksiyonlar
  final List<SeansKaydi> _seanslar = [];
  final Map<String, Danisan> _danisanRehberi = {};

  KlinikYoneticisi({required this.subeAdi});

  // Sisteme yeni bir danışan kaydeder (Sözlüğe / Map'e ekler)
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan;
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  // Yeni bir randevu (seans) oluşturur ve listeye ekler
  void randevuOlustur(SeansKaydi seans) {
    _seanslar.add(seans);
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  // Seansı başarıyla sonlandırır ve ödemeyi alır.
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.tamamlandi;
        seans.odemeTipi = odeme;
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
        return; // İşlem bitince döngüden çık
      }
    }
    // Eğer seans kodu listede yoksa hata mesajı verir
    print("Hata [$seansKodu] kodlu seans bulunamadı");
  }

  // Seansı iptal eder ve varsa nedenini yazdırır.
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        seans.durum = SeansDurumu.iptalEdildi;
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return;
      }
    }
  }

  // Finansal Rapor Metotları (Fonksiyonel Dart kullanımı)
  
  // Kasaya girmiş olan kesinleşmiş net ciro
  // where: Sadece durumu 'tamamlandi' olanları filtreler.
  // fold: Filtrelenen elemanların net tutarlarını toplayarak tek bir sonuca indirger.
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Henüz işlemi devam eden veya bekleyen randevuların toplam tutarı
  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  // Hangi kategoriden kaç adet seans olduğunu hesaplayan metot
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};
    // Önce tüm kategorileri 0 ile başlatıyoruz
    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }
    // Sonra her seansın kategorisini bulup o kategorinin sayısını 1 artırıyoruz
    for (var s in _seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    return dagilim;
  }

  // Sadece atanmış uzmanların isimlerini benzersiz bir liste (Set) olarak döndürür
  Set<String> gorevliUzmanKadrosu() {
    return _seanslar
        .map((s) => s.sorumluUzman) // Uzman isimlerini çeker
        .whereType<String>()        // Null olanları (uzmanı olmayanları) eler
        .toSet();                   // Aynı ismin tekrar etmesini engeller
  }

  // Henüz sorumlu bir uzmanı olmayan randevuları filtreler
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  // Gün sonunda konsola çıktı veren genel raporlama fonksiyonu
  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi");
    print("---------------------------------------");
    print(
      "${'Kod'.padRight((10))} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("---------------------------------------");

    // Tüm seansları tek tek dönerek tablo şeklinde yazdırır
    for (var s in _seanslar) {
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor";
      
      // Dart 3.0 ile gelen switch ifadesi (Pattern matching). Duruma göre string atar.
      final String durumRozet = switch (s.durum) {
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | " // .toStringAsFixed(2) -> Virgülden sonra 2 hane gösterir
        "$durumRozet",
      );
    }

    // Finansal ve genel özetin ekrana basılması
    print("---------------------------------------");
    print("Finansal Özet:");
    print(" * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}");
    print(" * Bekleyen Potansiyel Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}");
    print(" * Toplam Seans : ${_seanslar.length} Randevu");
    
    print("---------------------------------------");
    print("Aktif Uzmanlar");
    final uzmanlar = gorevliUzmanKadrosu();
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      print(" ${uzmanlar.join(', ')}");
    }

    // Uyarı sistemi: Uzmansız randevu varsa haber verir
    final uzmansizlar = uzmansizSeanslariGetir();
    if (uzmansizlar.isNotEmpty) {
      print("Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır");
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("---------------------------------------");
  }
}

// Uygulamanın çalışmaya başladığı ana metot
void main() {
  print("Klinik yönetim sistemi başlatılıyor....");
  
  // Yönetici nesnesi oluşturuluyor
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  // 1. ADIM: Danışanların (Müşterilerin) oluşturulması
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol", "Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    alerjiler: [],
  );
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol", "Aspirin"],
  );
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  // Oluşturulan danışanlar sisteme kaydediliyor
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("\nDanışan güvenlik kontrolü");
  print(d1.bilgiOzeti);
  print(d2.bilgiOzeti);
  print("----------------------------------");

  // 2. ADIM: Randevuların (Seansların) oluşturulması
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo İşlemi",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0, // VIP olduğu için indirimTutari get metodunda ek %10 alacak
    sorumluUzman: "Sümeyye Arab",
  );
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile yüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
    sorumluUzman: null, // Bilinçli olarak uzman atanmadı (Raporda uyarı verecek)
  );
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4", // Dikkat: İptal ederken yanlış kod girilmiş (Aşağıda açıklanıyor)
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );

  // Oluşturulan randevular yöneticiye gönderiliyor
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  
  print("\nSeans İşlemleri Uygulanıyor...");

  // 3. ADIM: Seansların işlenmesi (Tamamlama / İptal)
  
  // Seans 1 kredi kartı ile tamamlandı
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );
  
  // Seans 2 nakit ile tamamlandı
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-2", 
    odeme: OdemeYontemi.nakit
  );
  
  // Seans 4 iptal edilmek isteniyor 
  // NOT: Orijinal kodda randevu oluştururken "SNS-2026-4" kullanılmış ama 
  // iptal ederken "SNS-2026-04" girilmiş. Bu yüzden bu seans bulunup iptal edilemeyecek
  // ve gün sonu raporunda 'Bekliyor' olarak kalacaktır.
  yonetici.seansiIptalEt(
    "SNS-2026-04", 
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  print("\n");
  
  // 4. ADIM: Raporlama
  // Tüm işlemler bittikten sonra gün sonu özeti ekrana bastırılıyor
  yonetici.gunSonuRaporuYazdir();
}
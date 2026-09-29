// enum (Enumeration): Birbiriyle ilişkili sabit değerleri gruplamak için kullanılır.
// Burada cihaz tiplerini güvenli ve kısıtlı bir şekilde tanımlıyoruz (örneğin rastgele bir string girilmesini önlüyor).
enum CihazTipi { sensor, gateway, edgeServer, router }

// class (Sınıf): Nesne yönelimli programlamada (OOP) bir verinin şablonudur.
class IoTCihaz {
  // final: Değeri bir kere atandıktan sonra değiştirilemez (Immutable - Değişmez). 
  // Bu, kodun güvenliğini artırır.
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  
  // Set: Listelerden farklı olarak, içinde birbirinin aynısı olan (kopya) eleman barındırmaz. Eşsiz (unique) veriler tutar.
  // Portların iki defa eklenmesini engellemek için idealdir.
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;
  final bool aktifMi;

  // const constructor: Nesnenin oluşturulma aşamasında değerlerinin sabit olmasını ve bellekte optimize edilmesini sağlar.
  // required: Bu sınıf çağrıldığında o parametrenin zorunlu olarak verilmesi gerektiğini belirtir.
  const IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    this.acikPortlar = const {}, // Verilmezse varsayılan olarak boş bir Set atanır
    this.sslSertifikasiGecerliMi = true, // Verilmezse true kabul edilir
    this.aktifMi = true, 
  });

  // get (Getter): Fonksiyon gibi hesaplama yapan ama bir değişken/özellik (property) gibi çağrılan yapılardır.
  // .contains(): Bir Set veya List koleksiyonunun içinde verdiğimiz değerin olup olmadığını kontrol eder (true/false döner).
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  // Mantıksal VEYA (||) operatörü ile iki durumdan biri bile doğruysa cihazı riskli kabul ediyoruz.
  bool get riskliMi => guvenlikAcigiVarMi || cpuYukYuzdesi > 85.0;

  String get cihazOzeti {
    // Ternary (Üçlü) Operatör (koşul ? dogruysa : yanlissa): İf-else'in tek satırlık kısa halidir.
    final durum = aktifMi ? "Online" : "Offline";
    return "[$seriNo] $cihazAdi ($durum) | CPU: %$cpuYukYuzdesi | RAM: ${bellekMb}MB";
  }
}

// Switch Expression (Dart 3): Klasik switch-case'in modern halidir. 
// Break yazmaya veya her satıra return eklemeye gerek kalmadan, eşleşen durumu doğrudan tek bir değer olarak döndürür (return switch).
String izolasyonBolgesiGetir(CihazTipi tip) {
  return switch (tip) {
    CihazTipi.sensor => "ZONE-S (Düşük Güvenlik Alanı)",
    CihazTipi.gateway => "ZONE-G (Ağ Geçidi İzolasyonu)",
    CihazTipi.edgeServer => "ZONE-E (Sınır Sunucu Alanı)",
    CihazTipi.router => "ZONE-R (Yönlendirici Omurga)",
  };
}

// implements Exception: Dart'ın yerleşik 'Exception' (Hata) sınıfını miras alarak projemize özel bir hata tipi oluşturuyoruz.
class CihazErisilemezException implements Exception {
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  // @override: Üst sınıfta (Exception) bulunan mevcut bir metodu ezip, kendi istediğimiz şekilde yeniden yazıyoruz.
  @override
  String toString() => "CihazErisilemezException: $mesaj";
}

// Ağ Yönetim Servisi 
class IotAgYoneticisi {
  // List: Elemanları sıralı bir şekilde tutan koleksiyon tipidir. Boş bir cihaz listesi ile başlıyoruz.
  final List<IoTCihaz> _cihazlar = [];

  // Ağa yeni cihaz kayıt etme metodu
  void cihazEkle(IoTCihaz cihaz) {
    // .add(): Listeye yeni bir eleman ekler.
    _cihazlar.add(cihaz);
    print("Ağa Katıldı: ${cihaz.cihazOzeti}");
  }

  // Riskli Cihazları Getirme
  List<IoTCihaz> riskliCihazlariGetir() {
    // .where(): Koleksiyon (List/Set) içindeki elemanları tek tek gezer ve içine yazdığımız mantıksal koşula (riskliMi == true) uyanları filtreler.
    // .toList(): where() fonksiyonu geriye 'Iterable' döndürdüğü için onu tekrar List yapısına çeviririz.
    return _cihazlar.where((cihaz) => cihaz.riskliMi).toList();
  }

  // Toplam Bellek Kullanımı
  int toplamBellekKullanimi() {
    // .fold(): Listedeki tüm elemanları tek bir nihai değere indirgemek (kümülatif hesaplama) için kullanılır.
    // 1. parametre (0): Başlangıç değeridir.
    // 2. parametre: Mevcut toplam ile o anki elemanı (cihaz) işleyip yeni toplamı döndüren fonksiyondur.
    return _cihazlar.fold(0, (toplam, cihaz) => toplam + cihaz.bellekMb);
  }

  // Record (Dart 3): Bir fonksiyondan aynı anda birden fazla ve farklı tipte değeri tek parça halinde döndürmemizi sağlar. Parantez () ile tanımlanır.
  (String cihazAdi, CihazTipi tip, bool alarmDurumu) cihazDurumuSorgula(String seriNo) {
    // .firstOrNull: Filtrelenen listedeki İLK elemanı alır. Eğer liste boşsa (cihaz bulunamadıysa) hata verip çökmek yerine güvenli bir şekilde 'null' döner.
    final cihaz = _cihazlar.where((c) => c.seriNo == seriNo).firstOrNull;

    if (cihaz == null) {
      print("Uyarı: [$seriNo] numaralı cihaz ağda bulunamadı!");
      return ("Bilinmeyen Cihaz", CihazTipi.sensor, false);
    }

    if (!cihaz.aktifMi) {
      // throw: Kodun normal akışını durdurup kasıtlı olarak bir hata (exception) fırlatırız.
      throw CihazErisilemezException("Kritik Hata: Cihaz ($seriNo) çevrimdışı. Bağlantı kurulamadı!");
    }

    return (cihaz.cihazAdi, cihaz.tip, cihaz.riskliMi);
  }
}

void main() {
  print("IoT Ağ Yönetim Sistemi Başlatılıyor...");
  print("==================================================");

  final yonetici = IotAgYoneticisi();

  final c1 = IoTCihaz(
    seriNo: "IOT-1001",
    cihazAdi: "Ana Kapı Sensörü",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 15.5,
    bellekMb: 128,
    acikPortlar: {"80/HTTP"},
    sslSertifikasiGecerliMi: true,
  );

  final c2 = IoTCihaz(
    seriNo: "IOT-1002",
    cihazAdi: "Merkezi Yönlendirici",
    tip: CihazTipi.router,
    cpuYukYuzdesi: 88.0, 
    bellekMb: 2048,
    acikPortlar: {"443/HTTPS", "22/SSH"},
    sslSertifikasiGecerliMi: true,
  );

  final c3 = IoTCihaz(
    seriNo: "IOT-1003",
    cihazAdi: "Eski Güvenlik Kamerası",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 45.0,
    bellekMb: 256,
    acikPortlar: {"80/HTTP", "23/TELNET"}, 
    sslSertifikasiGecerliMi: false, 
  );

  final c4 = IoTCihaz(
    seriNo: "IOT-1004",
    cihazAdi: "Veri İşleme Edge Sunucusu",
    tip: CihazTipi.edgeServer,
    cpuYukYuzdesi: 92.4,
    bellekMb: 8192,
    acikPortlar: {"443/HTTPS"},
    sslSertifikasiGecerliMi: true,
  );

  final c5 = IoTCihaz(
    seriNo: "IOT-1005",
    cihazAdi: "Depo Ağ Geçidi",
    tip: CihazTipi.gateway,
    cpuYukYuzdesi: 60.0,
    bellekMb: 1024,
    acikPortlar: {"443/HTTPS"},
    sslSertifikasiGecerliMi: true,
    aktifMi: false, 
  );

  final c6 = IoTCihaz(
    seriNo: "IOT-1006",
    cihazAdi: "Termostat Sensörü",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 5.2,
    bellekMb: 64,
    acikPortlar: {},
    sslSertifikasiGecerliMi: true,
  );

  yonetici.cihazEkle(c1);
  yonetici.cihazEkle(c2);
  yonetici.cihazEkle(c3);
  yonetici.cihazEkle(c4);
  yonetici.cihazEkle(c5);
  yonetici.cihazEkle(c6);

  print("\n--- İzolasyon Bölgeleri Dağılım Testi (Switch Expression) ---");
  print("C1 (${c1.tip.name}) -> ${izolasyonBolgesiGetir(c1.tip)}");
  print("C4 (${c4.tip.name}) -> ${izolasyonBolgesiGetir(c4.tip)}");

  print("\n--- Riskli Cihazlar Analizi (.where Kullanımı) ---");
  final riskliCihazlar = yonetici.riskliCihazlariGetir();
  print("Tespit Edilen Riskli Cihaz Sayısı: ${riskliCihazlar.length}");
  
  // for-in Döngüsü: Listedeki her bir elemanı sırayla 'cihaz' değişkenine atayarak kod bloğunu çalıştırır.
  for (var cihaz in riskliCihazlar) {
    final sebep = cihaz.guvenlikAcigiVarMi 
        ? "Güvenlik Açığı (SSL Geçersiz veya Telnet Açık)" 
        : "Aşırı CPU Yükü (> %85)";
    print(" -> [${cihaz.seriNo}] ${cihaz.cihazAdi} (Sebep: $sebep)");
  }

  print("\n--- Sistem Kaynakları Analizi (.fold Kullanımı) ---");
  final toplamRam = yonetici.toplamBellekKullanimi();
  print("Ağdaki Toplam Bellek Kullanımı: $toplamRam MB");

  print("\n--- Seri Numarası İle Cihaz Sorgulama (Dart 3 Record) ---");
  
  final sorgu1 = yonetici.cihazDurumuSorgula("IOT-1002");
  // Destructuring (Parçalama): Fonksiyondan dönen çoklu Record değerini, ayrı ayrı üç değişkene tek satırda aktarıyoruz.
  final (cihazAdi1, tip1, alarm1) = sorgu1;
  print("Sorgu [IOT-1002]: Adı: $cihazAdi1 | Tipi: ${tip1.name} | Alarm (Riskli Mi): ${alarm1 ? 'EVET' : 'HAYIR'}");

  final sorgu2 = yonetici.cihazDurumuSorgula("IOT-9999");
  // $1: Eğer Record'u yukarıdaki gibi parçalamazsak, içindeki verilere sırasıyla .$1, .$2 diyerek doğrudan ulaşabiliriz.
  print("Sorgu [IOT-9999]: ${sorgu2.$1}"); 

  print("\n--- Hata Yönetimi (Exception & try-catch) ---");
  // try: Hata fırlatma ihtimali olan, çökmeye sebep olabilecek kodları bu bloğun içine alırız.
  try {
    print("IOT-1005 numaralı cihaza erişilmeye çalışılıyor...");
    final kapaliCihaz = yonetici.cihazDurumuSorgula("IOT-1005");
    print("Bağlantı Başarılı: ${kapaliCihaz.$1}"); 
  } 
  // on [HataTipi] catch: Sadece bizim belirttiğimiz o özel hata fırlatılırsa bu blok çalışır (e = fırlatılan hatanın kendisi).
  on CihazErisilemezException catch (e) {
    print("YAKALANAN HATA: $e");
    print("AKSİYON: İlgili ağ geçidinin güç beslemesi kontrol edilmek üzere saha ekibine bildirildi.");
  } 
  // catch: Beklenmeyen, diğer tüm genel hataları yakalar ve uygulamanın çökmesini (crash) engeller.
  catch (e, stackTrace) {
    print("Beklenmeyen sistem hatası: $e");
  } 
  // finally: Hata olsun veya olmasın, try-catch işlemi tamamen bittikten sonra MUTLAKA çalıştırılan temizlik/bitiriş bloğudur.
  finally {
    print("Ping / Ağ tarama işlemi sonlandırıldı.");
  }
  
  print("\n==================================================");
  print("Kapatılıyor...");
}
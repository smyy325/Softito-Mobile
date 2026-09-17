class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);
}

abstract class IKargolanabilir {
  double kargoUcretiHesapla();
}
class FizikselUrun extends Urun implements IKargolanabilir {
  FizikselUrun(String id, String ad, double fiyat, int stok): super(id, ad, fiyat, stok, "FIZIKSEL");
  @override
  double kargoUcretiHesapla() {
    return 29.90;
  }
}
class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok): super(id, ad, fiyat, stok, "DIJITAL");
}
abstract class IVeritabani {
  void kaydet(String sql);
}
abstract class IMail {
  void mailAt(String to, String body);
}
abstract class ISms {
  void smsYolla(String gsm, String text);
}
abstract class IOdeme {
  void odemeYap(double tutar);
}
abstract class IKupon {
  double uygula(double tutar);
}

abstract class IKargo {
  void kargoGonder(String orderId, String adres);
}

abstract class IFatura {
  void faturaYazdir(String orderId);
}

class SqliteVeritabani implements IVeritabani {
  @override
  void kaydet(String sql) {
    print("DB çalıştırıldı: " + sql);
  }
}

class SmtpMailServisi implements IMail {
  @override
  void mailAt(String to, String body) {
    print("SMTP Mail gönderildi: " + to);
  }
}

class NetgsmSmsServisi implements ISms {
  @override
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}

class KrediKarti implements IOdeme {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kredi kartından POS ile çekildi.");
  }
}

class Havale implements IOdeme {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Havale kontrol edildi.");
  }
}

class KapidaOdeme implements IOdeme {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL Kapıda ödeme tahsil edilecek (Komisyon +15 TL).");
  }
}

class Crypto implements IOdeme {
  @override
  void odemeYap(double tutar) {
    print("$tutar TL USDT transferi onaylandı.");
  }
}

class Indirim10 implements IKupon {
  @override
  double uygula(double tutar) {
    return tutar * 0.90;
  }
}

class Yaz20 implements IKupon {
  @override
  double uygula(double tutar) {
    return tutar * 0.80;
  }
}

class Sepette50 implements IKupon {
  @override
  double uygula(double tutar) {
    return tutar - 50;
  }
}

class MngKargo implements IKargo {
  @override
  void kargoGonder(String orderId, String adres) {
    print("MNG Kargo takip fiş basıldı: $adres");
  }
}

class PdfFatura implements IFatura {
  @override
  void faturaYazdir(String orderId) {
    print("Fatura PDF çıkarıldı: $orderId");
  }
}

class SiparisYoneticisi {
  IVeritabani db;
  IMail mailci;
  ISms smsci;
  IKargo kargocu;
  IFatura faturaci;

  SiparisYoneticisi(
    this.db,
    this.mailci,
    this.smsci,
    this.kargocu,
    this.faturaci,
  );

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      IOdeme odemeTipi,
      String musteriAdi,
      String email,
      String tel,
      String adres,
      IKupon kuponKodu) {
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tükenmiş!");
        return;
      }

      toplam += sepet[i].fiyat;

      if (sepet[i] is IKargolanabilir) {
        toplam +=
            (sepet[i] as IKargolanabilir).kargoUcretiHesapla();
      }

      sepet[i].stok--;
    }

    toplam = kuponKodu.uygula(toplam);

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    odemeTipi.odemeYap(sonTutar);
    db.kaydet(
      "INSERT INTO siparişler VALUES ('$orderId', $sonTutar)",
    );

    faturaci.faturaYazdir(orderId);

    mailci.mailAt(
      email,
      "Sayin $musteriAdi, siparişiniz alındı. Tutar: $sonTutar TL",
    );

    smsci.smsYolla(
      tel,
      "Siparişiniz onaylandı: $orderId",
    );

    kargocu.kargoGonder(orderId, adres);
  }
}

void main() {
  var siparisci = SiparisYoneticisi(
    SqliteVeritabani(),
    SmtpMailServisi(),
    NetgsmSmsServisi(),
    MngKargo(),
    PdfFatura(),
  );

  var urun1 = FizikselUrun(
    "1",
    "Kablosuz Mouse",
    450.0,
    5,
  );

  var urun2 = DijitalUrun(
    "2",
    "Flutter Kursu E-Kitap",
    150.0,
    100,
  );

  var sepet = <Urun>[
    urun1,
    urun2,
  ];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    KrediKarti(),
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadıköy / Istanbul",
    Indirim10(),
  );
}
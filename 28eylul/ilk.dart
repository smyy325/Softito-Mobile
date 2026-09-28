/*void main(){
    
    //JSdeki gibi let x="ahmet"; x=42; kabul etmez !
    print("ilk dersimiz - dart sdk aktif olmalı");
    //1.açık berlitilen veri tipleri
    int seansSuresiDakika =45;
    double seansUcretiTL = 2750.50;
    String uzmanAdi = "DR Sümeyye Arab";
    bool aktifMi =true;

    //2.string interpolation
    // JS deki  `${} `bunun yerine sadece $degisken işlem varsa ${degisken *2} kullanılır
    print("uzman: $uzmanAdi | Süre: $seansSuresiDakika dk | ücret: $seansUcretiTL ₺");
    print("KDV dahil (%20) ${seansUcretiTL*1.20}₺");


    //3. var ile tip çıkarımı
    var tedaviAdi="kahve ile peeling";
    print(tedaviAdi);

    //4. dynamic veri tipini bağımsız kullanabilirsiniz ancak flutter da önerilmez

    dynamic serbestKutu = "Lazer Epilasyon";
    serbestKutu = 1000; // izin verilir ama ver tip güvenliğini yok eder

//const: derleme anında değeri belli olan veriler, bellekte tek bir yerde saklanır
const String KLINIK_ID = "Softito Güzellik Merkezi";
const double KDV_ORANI = 0.20;

//const DateTime suankiZaman=DateTime.now();//Hata derleme anında bunu bilemeyiz.

//final: çalışma anında hesaplanır bir kere atandıktan sonra değişmez.

final DateTime randevuZamani = DateTime.now();
final String takipKodu= "SOFT-" + randevuZamani.microsecondsSinceEpoch.toString();
print("Klinik adı: $KLINIK_ID");
print("oluşturulma Traihi: $randevuZamani | kod: $takipKodu");




// dartta bir değişken varsayılan olarak asla null olamaz bunun yerine null safety operatörleri kullanırız(?,??,!)
String zorunluDanisanAdi="Meltem Demir";
String? danisanAlerjiNotu;
print("alerji Notu: $danisanAlerjiNotu");



// ifNull operatörür: null ise varsayılan değer atama
String goruntulenecekNot= danisanAlerjiNotu?? "bilinen bir alerjisi yok";
print("Rapor: $goruntulenecekNot");

// null aware
print("alerji metin uzunluğu: ${danisanAlerjiNotu?.length}");

*/

//klasik sıralı fonksiyon
double topla(double a, double b)=> a+b;

//modern dart / flutter standartları: Named parametresi({})

void seansKaydiOlustur({
  required String danisan,
  required String tedavi,
  required double birimFiyat,
  int seansSayisi = 1, // default değer
  double indirimOrani = 0.0, // default değer
  String? uzmanHekim, // null olabilir
}) {
  final double brutTutar = birimFiyat * seansSayisi;
  final double indirimTutari = brutTutar * (indirimOrani / 100);
  final double netTutar = brutTutar - indirimTutari;

  print("""
==================================================
Softİto Seans Sözleşmesi
--------------------------------------------------
Danışan           : $danisan
Tedavi            : $tedavi (x$seansSayisi Seans)
Uzman Hekim       : ${uzmanHekim ?? "-"}
Brüt Tutar        : $brutTutar ₺
İndirim           : -$indirimTutari ₺ ($indirimOrani)
Ödenecek Tutar    : $netTutar ₺
==================================================
  """);
}

void main() {
  seansKaydiOlustur(
    danisan: "Sümeyye Muhammed",
    tedavi: "Medikal Cilt Yenileme",
    birimFiyat: 4500.0,
    seansSayisi: 3,
    uzmanHekim: "Dr. Shahd",
    indirimOrani: 15.0,
  );
}
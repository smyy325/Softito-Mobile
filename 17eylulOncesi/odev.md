GÖREV 1

BAŞLA 
Kullanıcı uygulamayı açsın
Oturum durumu kontrol edilir
EĞER kullanıcı girişi yok İSE
	Giriş ekranına yönlendir
DEĞİLSE menüyü göster
DÖNGÜ (Kullanıcı siparişi onaylayana kadar)
	Ürünleri seçip sepete ekle
DÖNGÜ bitir
Kullanıcı “Siparişi onayla” tuşuna bastığında hesaplama yap:
EĞER kullanıcının cüzdanındaki para, sepetteki toplam fiyattan daha az İSE
	Ekranda “Paranız yetersiz” uyarısı ekranda gözüksün
DEĞİLSE Siparişi kabul et ve onayla 
	kahvelerin toplam fiyatını kullanıcı cüzdanından düş (azalt)
	Siparişi hazırlamaları için arka planda sistemi bilgilendir
BİTİR


GÖREV 2

Sipariş Oluşturma Endpoint'i

{
  "kahve_adi": "Filtre",
  "boyutu": "Büyük",
  "adet": 1,
  "toplam_tutar": 185.00
}

Başarılı Sonuç HTTP Durum Kodu: 201 Created (Sipariş başarıyla oluşturuldu)
Kullanıcı Giriş Yapmamışsa Dönecek HTTP Durum Kodu: 401 Unauthorized (Yetkisiz erişim)


Cüzdan Bakiye Sorgulama Endpoint'i

{
  "bakiye": 200.00,
  "para_birimi": "TRY"
}
                    
Mülakat Sorusu
GET isteği sadece bakiye bilgisini okuduğu ve veriyi değiştirmediği için idempotenttir, ancak POST isteği her gönderildiğinde yeni bir sipariş oluşturduğu için idempotent değildir.


GÖREV 3

Bu sınıfta Single Responsibility Principle (SRP - Tek Sorumluluk) nasıl ihlal edilmiştir? Sınıfı hangi küçük parçalara bölmeliyiz?

sepet hesaplama, ödeme alma, veritabanı kaydı ve SMS gönderme gibi birbirinden tamamen farklı işleri tek başına yaptığı için Tek Sorumluluk Prensibi'ni (SRP) ihlal ediyor. Çözümü bu karmaşık yapıyı; SepetIslemleri, OdemeServisi, VeritabaniServisi ve BildirimServisi gibi sadece tek bir işten sorumlu olan küçük sınıflara bölmeliyiz.

indirimHesapla fonksiyonunda yarın yeni bir müşteri tipi (örneğin "DOKTOR" geldiğinde if-else kodunu değiştirmek zorunda kalmak hangi SOLID prensibine aykırıdır?

Yeni bir müşteri tipi ("DOKTOR") eklendiği zaman mevcut if-else kodunu değiştirmek zorunda kalmak Açık/Kapalı Prensibi'ne (Open/Closed Principle - OCP) aykırı. Çünkü bu prensibe göre kodlar yeni özellikler eklenmesine açık, ancak mevcut kodların değiştirilmesine kapalı olmalı.


# 🌌 Modum Galaxy - Duygu Galaksisi (Project Specification)

## 1. Proje Özeti ve Amacı
Bu proje, kullanıcıların günlük ruh hallerini birer gezegen olarak görselleştirdikleri, notlarını bu gezegenlerle eşleştirerek zihinsel farkındalık kazandıkları yenilikçi bir mod takip platformudur. 

Uygulama; **Material Design 3** standartlarına tam uyumlu, **Açık/Koyu (Light/Dark) Tema** destekli, karmaşadan uzak, ferah (fresh) ve pastel tonların hakim olduğu dikkat çekici bir kullanıcı deneyimi (UX) sunar.

---

## 2. Temel Özellikler ve İş Kuralları (Business Logic)

### 2.1. Gezegen ve Ruh Hali Eşleştirmesi
- Sistemde farklı duyguları (mutlu, üzgün, stresli, üretken vb.) temsil eden özel tasarım gezegen görselleri bulunur.
- Kullanıcılar, istedikleri gezegeni seçip ona kendi ruh hali etiketini atayarak kişiselleştirilmiş bir "Duygu Galaksisi" yaratır.

### 2.2. Günlük ve Not Yönetimi
- Kullanıcılar günün özetini yazarken, o günkü baskın duygularına karşılık gelen gezegeni seçerek notlarını görsel bir kart yapısına dönüştürürler.

### 2.3. Aylık Duygu Analizi (Algoritma)
- Sistem, kullanıcının girdiği notlardaki gezegen verilerini toplayarak aylık bazda bir frekans analizi yapar. 
- O ay en çok hangi duygu/gezegen ağırlıklıysa, kullanıcıya bu duruma özel bir geri bildirim veya farkındalık notu sunulur.

### 2.4. Güvenlik ve Şifreleme
- E-mail tabanlı şifre sıfırlama ve belirleme işlemleri güvenli form yapılarıyla yönetilir. Şifrelerin görünürlük durumları anlık olarak kullanıcı tarafından kontrol edilebilir.

---

## 3. Ekranlar, UI Elemanları ve Etkileşim Akışı

### 1. Karşılama Ekranı (`SplashScreen`)
- **UI Elemanları:** Ekranın merkezinde logo, altında etkileyici bir motto ve `FilledButton` (Giriş Yap).
- **Etkileşim:** Butona tıklandığında yumuşak bir geçişle (fade transition) kimlik doğrulama ekranına yönlendirilir.

### 2. Giriş ve Kayıt Ekranları (`LoginScreen` & `RegisterScreen`)
- **Form Yönetimi & Validasyon:** `Form` ve `TextFormField` kullanılarak veri alınır. E-posta formatı (`@` kontrolü) ve şifre uzunluğu validasyonları uygulanır. 
- **Düzen (Layout):** Kullanıcı adı ve şifre kutuları alt alta, "Giriş Yap" ve "Üye Ol" butonları ise `Row` ve `Expanded` kullanılarak üstteki Textfield'lar ile birebir aynı genişlikte (yan yana) hizalanır.
- **Etkileşim:** Hatalı girişlerde `SnackBar` ile geri bildirim verilir.

### 3. Şifre İşlemleri Ekranları (`ForgotPasswordScreen` & `SetPasswordScreen`)
- **Görünürlük Kontrolü:** Şifre belirleme ekranında `obscureText` özelliği ve bir `IconButton` (Göz ikonu) kullanılarak şifrenin gizlenip/gösterilmesi sağlanır.
- **Validasyon:** "Yeni Şifre" ve "Tekrar Yeni Şifre" alanlarının eşleşip eşleşmediği form bazlı kontrol edilir.

### 4. Ana Ekran ve Not Akışı (`HomeScreen`)
- **Temel UI Elemanları:** Üstte `AppBar` (Logo, Başlık ve Tema değiştirme ikonu). Altta 4 sekmeli `BottomNavigationBar`.
- **Kart Tasarımı:** Geçmiş notlar, Material 3 `Card` yapısında gösterilir. Kartın üst kısmında gezegen görseli (`Image.asset`), alt kısmında not başlığı ve tarihi yer alır.
- **Aksiyon Butonu:** Sayfanın ortasında (veya FloatingActionButton olarak) yer alan `+` butonu ile not ekleme sayfasına geçilir.

### 5. Not Ekleme ve Gezegen Seçimi (`AddNoteScreen` & `AssignMoodScreen`)
- **Yatay Kaydırma:** Not eklerken gezegen seçimi için ekranın üst kısmında yatayda kaydırılabilir (`ListView.builder` - scrollDirection: horizontal) dairesel gezegen ikonları sunulur.
- **Veri Girişi:** "Günün Başlığı" ve "Detaylar" için çok satırlı `TextFormField` kullanılır. En altta `FilledButton` ile kayıt işlemi tamamlanır.

### 6. Profil ve Analiz Ekranları (`ProfileScreen` & `AnalyticsScreen`)
- **Tema Yönetimi:** Profil ekranındaki `SwitchListTile` üzerinden uygulama anlık olarak Açık (Light) veya Koyu (Dark) moda geçirilebilir.
- **Analiz Çıktısı:** Aylık analiz ekranında, veritabanından çekilen en yoğun gezegen verisi görsel bir grafik veya baskın gezegen illüstrasyonu ile sergilenir.
- **Çıkış Diyaloğu:** Hesaptan çıkış yapılırken `AlertDialog` ile onay istenir.
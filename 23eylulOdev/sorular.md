1. Flexbox ile CSS Grid arasındaki mimari fark nedir ve ne zaman hangisi seçilmelidir?

Flexbox, tek boyutlu (1D) eksende, yani sadece yatay (satır) veya sadece dikey (sütun) olarak içerik hizalamak için tasarlanmıştır. CSS Grid ise iki boyutlu (2D) bir yapıdır ve aynı anda hem satırları hem de sütunları yönetebilir. Sayfanın genel iskeletini ve büyük kolon yapılarını oluştururken CSS Grid, bileşen seviyesindeki (örneğin bir menü içindeki butonlar) mikro hizalamalarda ise Flexbox seçilmelidir.

CSS Grid'deki fr (fractional unit) birimi, geleneksel yüzde ( % ) birimine göre neden daha güvenlidir?

Yüzde (%) birimi, ebeveyn elemanın toplam genişliğini temel alır ve aralara gap (boşluk) veya padding eklendiğinde toplam alan %100'ü aşarak taşmalara (overflow) sebep olabilir. fr birimi ise ızgara içerisindeki gap gibi değerler hesaplandıktan sonra kalan boş alanı dinamik olarak böler. Bu sayede matematiksel hesaplama hatalarını ortadan kaldırır ve taşmaları önler.

Neden "Desktop-First" ( max-width ) yerine "Mobile-First" ( min-width ) mimarisi tercih edilir?

Mobil cihazların işlem güçleri ve ağ kapasiteleri genellikle masaüstü cihazlara göre daha düşüktür. "Mobile-First" yaklaşımında, tarayıcı ilk olarak hafif ve sade mobil CSS kodlarını işler, ekran büyüdükçe (min-width) karmaşık kuralları devreye sokar. Desktop-First yaklaşımdaysa tarayıcı ağır masaüstü kodlarını yükleyip mobil cihazlar için bunları ezmeye (override) çalışır; bu da gereksiz kod yüküne ve performans kaybına neden olur.

CSS3'te transition ve animation yazarken neden top , left , width yerine transform ve opacity tercih
edilmelidir?

CSS'te top, left veya width gibi özelliklerin anime edilmesi, tarayıcının render motorunda "Layout" (yeniden hesaplama) ve "Paint" (yeniden boyama) süreçlerini sürekli tetikleyerek işlemciyi (CPU) yorar. transform ve opacity ise doğrudan GPU (Grafik İşlemci) donanım hızlandırmasını kullanarak çalışır. Bu sayede 60fps akıcılığında, kasmayan (jank-free) animasyonlar elde edilir.

CSS Grid'de auto-fit ile minmax() birleşimi nasıl çalışır ve responsive tasarım açısından ne avantaj sağlar?

auto-fit, mevcut kapsayıcı genişliğine sığabilecek en fazla sütunu otomatik olarak hesaplayıp oluşturur. minmax(minimum, maksimum) ile kullanıldığında (örneğin: repeat(auto-fit, minmax(250px, 1fr))), elemanların en fazla ne kadar daralabileceğini ve uygun yer varsa kalan alanı kaplamak için nasıl genişleyeceğini belirler. Bu yöntem, hiçbir @media sorgusu yazmaya gerek kalmadan tamamen akışkan ve responsive (esnek) bir ızgara kurulmasını sağlar.

grid-template-areas özelliğinin sağladığı en büyük kurumsal avantaj nedir?

DOM (HTML) elemanlarının sayfa hiyerarşisindeki sırasından bağımsız olarak ekranda konumlandırılabilmesini sağlar. Sadece CSS'teki kelimelerin (örneğin header, sidebar, main) yerlerini değiştirerek HTML yapısını hiç bozmadan devasa arayüz güncellemeleri yapılabilir. Bu durum, takım çalışmasında kodun okunabilirliğini ve sürdürülebilirliğini büyük ölçüde artırır.

CSS'te clamp() fonksiyonunun 3 parametresi ne anlama gelir?

clamp(minimum_değer, tercih_edilen_değer, maksimum_değer) şeklinde çalışır. Minimum Değer: Ekran ne kadar küçülürse küçülsün, boyutun inebileceği en küçük sınır (örneğin: 1.5rem). Tercih Edilen Değer: İdeal koşullarda dinamik olarak çalışacak değerdir; genellikle vw (viewport width) birimi kullanılır (örneğin: 4vw). Maksimum Değer: Ekran ne kadar büyürse büyüsün, boyutun aşamayacağı en üst sınır (örneğin: 3rem).

Bir CSS animasyonunun sonsuza kadar kesintisiz çalışması için hangi CSS kuralı kullanılır?

Bir CSS animasyonunun kesintisiz olarak sonsuza kadar tekrarlanması için animation-iteration-count: infinite; kuralı kullanılır.

Flutter'da CSS Grid'in ve Flexbox'ın doğrudan karşılığı olan widget'lar nelerdir?

Flutter'da Flexbox mimarisinin yerini, yatay hizalamalar için Row ve dikey hizalamalar için Column widget'ları alır (her ikisi de Flex widget'ından türetilmiştir). CSS Grid'in çok boyutlu ızgara mantığının karşılığı ise GridView (özellikle GridView.builder veya GridView.count) widget'ıdır.

React Native'de CSS Grid kullanılabilir mi? Kullanılamıyorsa çok sütunlu ızgara yapısı nasıl oluşturulabilir?

React Native'de CSS Grid kullanılamaz; düzenler Yoga layout motoru üzerinden çalışır ve bu motor yalnızca Flexbox mimarisini destekler. Çok sütunlu ızgara görünümü elde etmek için FlatList bileşeni numColumns={2} gibi bir parametre ile kullanılır. Alternatif olarak, kapsayıcı bir Flex kutusuna flexDirection: 'row' ve flexWrap: 'wrap' verilerek ızgara illüzyonu yaratılır.
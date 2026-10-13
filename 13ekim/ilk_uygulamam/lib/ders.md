1. Widget Tree
*İskelet
*Immutable(değişmez)
*Çok ucuz (hafif)
*saniyede 60-120 kez ÇÖPE atılıp yeniden üretilir
*Ekranda çizim Yapmaz
*Sadece Şablon sunar
2. Element Tree
*Yönetici & Yaşayan Omurga
*Mutable (durumu ve referansı hafızada canlı tutar değişir)
*widget ile renderobject arasındaki koordinatördür(organizasyonu sunar)

oyun sektörü en çok flutter kullanır 

//canUpdate

static bool canUpdate (Widget oldWidget, widget newWidget){
    return oldWidget.runtimeType=newWidget.runtimeType && oldWidget.key==newWidget.key;

}

Stat yaşam döngüsü
*statefulWidget immutable (olarak değişmez) her rebuild'de yeniden oluştururlur

*State mutable (durumu saklar) rebuild sırasında çöpe atılmaz element tarafında devam eder.
eğer iki bileşik olsaydı her rebuild esnasında kullanıcı girdiler yayaçlar controllerlar vb. sıfırlanırdı.

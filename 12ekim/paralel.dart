/*
Future<void> fetchDashboardData() async{
    try{
        final result=await Future.wait([
            fetchUserProfile(),
            fetchAccountBalance(),
            fetchNotification(),

        ], eagerError:true);
        print("tüm veriler geldi $result");

    }catch(e){
        print("isteklerden biri başarısız oldu $e");
    }
}
*/

//Future: tek bir kere veri çekileceği zaman kullanılır ya hata ya değer dönüp bitirir
//stream: bir boru hattı şeklinde çalışır (pipe), zaman içinde 1 10 100 yada sonsuz sayıda veri akışı sağlanabilir (borsa fiyatları GPS konum güncelleme, firebase canlı dinleme)

import 'dart:async';
void main(){
    // controller oluşturma
    final controller=StreamController<int>();
    //dinleyici (listelenir) bağlama
    final subscription =controller.stream.listen(
        (data)=>print("yeni veri: $data"),
        onError: (err)=>print("Hata oluştu: $err"),
        onDone:()=>print("yayın tamamlandı"),
    );

    controller.sink.add(10);
    controller.sink.add(20);
    controller.sink.add(30);



    final broadcastStream =controller.stream.asBroadcastStream();
    broadcastStream.listen((d)=>print("UI ekranı: $d"));
    broadcastStream.listen((d)=> print("Analitik servis ekranı: $d"));






    controller.close();

}


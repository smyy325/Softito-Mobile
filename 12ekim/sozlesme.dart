/*// Soyutlama Abstraction Kavramı

//1. Adım (sözleşmeler) Contract
abstract class AutReposity{
  Future<String>login(String email,String password);
  Future<void>logout();
  bool get isAuth;
}

//canlı uygulama
class FirebaseAuthReposity implements AutReposity{
  @override
  Future<String> login(String email, String password) async{
    //gercek firebase SDK çağrısı
    return "firebase_token_xyz_123";
  }

  @override
  Future<void> logout() async{
    // firebase logout 
  }

  @override
  bool get isAuth => true;
}
  


//test ve offline simülasyonu
class MockAuthReposity implements AutReposity{
  @override
  Future<String> login(String email, String password) async{
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_123";
  }
  @override
  Future<void> logout() async{}
  @override
  bool get isAuth => true;
}


mixin logger{
  void log(String message)=> print("LOG: $message");
}

mixin analytics{
  void track(String event)=> print("TRACK: $event");
}

class PaymentService with logger,analytics{
  void pay(){
    log("Ödeme yapıldı");
  }
}

abstract class BaseWidget{
}
mixin LifeLogger on BaseWidget{
  void logInit()=> print("Widget Başlatıldı");
}

extension StringExtension on String{
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

//kullanımı
void main() {
  String email = "sumeyye@gmail.com";
  if(email.isValidEmail){
    print("Geçerli email");
  }else{
    print("Geçersiz email");
  }  
}*/

abstract class Identifiable{
  String get id;
}
//T tipi mutlaka Identifiable arayüzü uygulamak zorundadır.
class GenericCache<T extends Identifiable>{
  final Map<String,T> _storage = {};

  void save(T item){
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı.");
}
//tip güvenliğini burda sağlıyoruz. tipi string değilse çalıştırma. number gelirse çalıştırma yazdırma. burası ekstra güvenlik sağlıyor.
T? getById(String id)=> _storage[id];
}
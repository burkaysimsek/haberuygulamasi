import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  //Shared preferences nesnesi oluşmuşsa aynı nesneyi tekrar çağırıyoruz yoksa sıfırdan oluşturuyoruz
  static SharedPreferences _prefs;
  static initialize() async {
    if (_prefs != null) {
      return _prefs;
    } else {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  //Shared prefs üzerine mail adresini kayıt ediyoruz
  static Future<void> saveMail(String mail) async {
    return _prefs.setString('mail', mail);
  }

  static Future<void> saveName(String name) async {
    return _prefs.setString('name', name);
  }

  static Future<void> savePhoto(String name) async {
    return _prefs.setString('photo', name);
  }

  //Shared prefs üzerine şifreyi kayıt ediyoruz
  static Future<void> savePassword(String password) async {
    return _prefs.setString("password", password);
  }

  static Future<void> saveId(String id) async {
    return _prefs.setString("id", id);
  }

  static Future<void> saveloginId(String id) async {
    return _prefs.setString("id", id);
  }

  static Future<void> saveTheme(bool theme) async {
    return _prefs.setBool("theme", theme);
  }

  //Shared üzerinde kayıtlı olan bütün verileri siler
  static Future<void> sharedClear() async {
    return _prefs.clear();
  }

  //Login bilgisini tutar
  static Future<void> login() async {
    return _prefs.setBool('login', true);
  }

  //Kayıtlı veri varsa alıyoruz yoksa boş değer atıyoruz
  static String get getMail => _prefs.getString("mail") ?? null;
  static String get getName => _prefs.getString("name") ?? null;
  static bool get getTheme => _prefs.getBool("theme") ?? false;
  static String get getId => _prefs.getString("id") ?? null;
  static String get getloginId => _prefs.getString("id") ?? null;
  static String get getPhoto =>
      _prefs.getString("photo") ??
      "https://upload.wikimedia.org/wikipedia/commons/7/70/User_icon_BLACK-01.png";
  static bool get getLogin => _prefs.getBool('login') ?? false;
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._privateConstructor();
  static final SharedPrefs _instance = SharedPrefs._privateConstructor();
  static SharedPreferences? _prefs;

  factory SharedPrefs() {
    return _instance;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('SharedPreferences is not initialized');
    }
    return _prefs!;
  }
}

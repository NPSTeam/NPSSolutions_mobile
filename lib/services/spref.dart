import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  static final SPref instance = SPref._internal();

  SPref._internal();

  static SharedPreferences? _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> set(String key, String value) async {
    late SharedPreferences prefs;
    prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  String? get(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> remove(String key) async {
    late SharedPreferences prefs;
    prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  Future<bool?> clearAll() async {
    await _prefs?.clear();
  }
}

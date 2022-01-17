import 'package:shared_preferences/shared_preferences.dart';

class ShopCacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
     sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) {
    if (value is String) return sharedPreferences!.setString(key, value);
    if (value is bool) return sharedPreferences!.setBool(key, value);
    if (value is int) return sharedPreferences!.setInt(key, value);
    return sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return  sharedPreferences!.remove(key);
  }
}

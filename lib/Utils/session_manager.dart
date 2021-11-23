import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<SharedPreferences> get _instance async => await SharedPreferences.getInstance();
  static late SharedPreferences _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String getString(String key) {
    return _prefsInstance.getString(key) ?? "";
  }

  static int getInt(String key) {
    return _prefsInstance.getInt(key) ?? 0;
  }

  static double getDouble(String key) {
    return _prefsInstance.getDouble(key) ?? 0.0;
  }

  static bool getBool(String key) {
    return _prefsInstance.getBool(key) ?? false;
  }

  static void ClearAllPREF() {
    _prefsInstance.clear();
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    var prefs = await _instance;
    return prefs.setDouble(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }



}
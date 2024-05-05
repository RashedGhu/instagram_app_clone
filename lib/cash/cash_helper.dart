import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? sharedPref;

  static Future<bool> saveDataInCash(
      {required String key, required dynamic value}) async {
    if (value is String) return await sharedPref!.setString(key, value);
    if (value is bool) return await sharedPref!.setBool(key, value);
    if (value is int) return await sharedPref!.setInt(key, value);
    return await sharedPref!.setDouble(key, value);
  }

  static dynamic getSavedCashData({required String key}) {
    return sharedPref!.get(key);
  }

  static Future<void> removeCashData({required String key}) async {
     await sharedPref!.remove(key);
  }

 static Future<void> clearCashImages() async {
    await DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
  }
}

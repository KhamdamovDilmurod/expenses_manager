import 'dart:convert';

import 'package:expenses_manager/model/employee_model.dart';
import 'package:expenses_manager/model/saved_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _singleton;

  static const PREF_BDM_ITEMS = "bdm_items";//qoldi
  static const PREF_FAVORITES = "favorites";
  static const PREF_MAIN_IPADDRESS = "main_ipaddress";
  static const PREF_HOST = "main_host";
  static const PREF_USER = "pref_user";
  static const PREF_BASE_URL = "base_url";//qoldi
  static const PREF_BASE_IMAGE_URL = "base_image_url";//qoldi
  static const PREF_FCM_TOKEN = "fcm_token";//qoldi
  static const PREF_REGION = "pref_region";//qoldi
  static const PREF_TOKEN = "token";
  static const PREF_BASKET = "basket";

  static SharedPreferences? getInstance() {
    return _singleton;
  }

  static initInstance() async {
    _singleton = await SharedPreferences.getInstance();
  }

  static void clearLogout() async{
    _singleton!.remove(PREF_FAVORITES);
    _singleton!.remove(PREF_TOKEN);
    _singleton!.remove(PREF_BASKET);
  }

  static void clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();

  }

  static String getBaseUrl() {
    return _singleton?.getString(PREF_BASE_URL) ?? "";
  }

  static Future<bool> setBaseUrl(String value) async {
    return _singleton!.setString(PREF_BASE_URL, value);
  }

  static String getToken() {
    return _singleton?.getString(PREF_TOKEN) ?? "";
  }

  static Future<bool> setToken(String value) async {
    return _singleton!.setString(PREF_TOKEN, value);
  }

  static String getMainIpaddress() {
    return _singleton?.getString(PREF_MAIN_IPADDRESS) ?? "";
  }

  static Future<bool> setMainIpaddress(String value) async {
    return _singleton!.setString(PREF_MAIN_IPADDRESS, value);
  }
  static String getHost() {
    return _singleton?.getString(PREF_HOST) ?? "";
  }

  static Future<bool> setHost(String value) async {
    return _singleton!.setString(PREF_HOST, value);
  }

  static SavedUserModel? getEmployee() {
    var json = _singleton?.getString(PREF_USER);

    return json == null ? null : SavedUserModel.fromJson(jsonDecode(json));
  }

  static Future<bool> setEmployee(SavedUserModel value) async {
    return _singleton!.setString(PREF_USER, jsonEncode(value.toJson()));
  }


}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

class HiveServices {
  late Box box;

  static Future<void> createBox() async {
    final getIt = GetIt.instance;
    getIt.registerSingleton<HiveServices>(HiveServices());
    await getIt<HiveServices>()._openBox();
  }

  Future<void> _openBox() async {
    box = await Hive.openBox("perfectum");
    log("Hive open Box");
  }


  // Theme settings
  void setTheme(ThemeMode theme) async {
    int indicator = ThemeMode.values.indexOf(theme);
    await box.put(MyKeys.theme, indicator);
  }

  ThemeMode getTheme(){
    return ThemeMode.values.elementAt(
      (box.get(MyKeys.theme) ?? 1) as int,
    );
  }


  // Password settings
  Future<void> setPassword(String data) async {
    await box.put(MyKeys.password, data);
  }

  String getPassword(){
    return box.get(MyKeys.password) ?? "";
  }

  // Token settings
  Future<void> setUserToken(String token) async {
    await box.put(MyKeys.userToken, token);
  }

  String getToken(){
    final token = box.get(MyKeys.userToken) ?? "";
    return token;
  }

  Future<String> setUserRefreshToken(String token) async {
    await box.put(MyKeys.userToken, token);
    log("$token set new Token");
    return token;
  }

  String getUserRefreshToken() {
    final token = box.get(MyKeys.userToken) ?? "";
    log("$token get existing Token");
    return token;
  }

  Future<List<Map<String, dynamic>>> getCachedMap(String dataKey) async {
    return await box.get(dataKey) as List<Map<String, dynamic>>;
  }

  Future<void> putCachedMap(String dataKey, List<Map<String, dynamic>> data) async {
    await box.put(dataKey, data);
  }

  Future<void> setUserMainNumer(String userNumber) async {
    await box.put(MyKeys.userMainNumer, userNumber);
  }

  String getUserMainNumber() {
    return box.get(MyKeys.userMainNumer) ?? "";
  }

  //? Language settings
  void setLanguage(String lang) async {
    await box.put(MyKeys.lang, lang);
  }
  
  String getLanguage() {
    return box.get(MyKeys.lang) ?? "";
  }

  //? Set MyId code
  void setMyIdCode(String code) async {
    await box.put(MyKeys.code, code);
  }

  String getMyIdCode() {
    return box.get(MyKeys.code) ?? "";
  }

  void setGlobalFontScale(double scale) {
    box.put(MyKeys.globalFontScale, scale);
  }

  double getGlobalFontScale() {
    return (box.get(MyKeys.globalFontScale) ?? 1.0) as double;
  }
}

class MyKeys {
  //? Home page keys
  static const String offers = "offers";
  static const String addons = "addons";

  static const String password = "userPassword";
  static const String globalFontScale = "GlobalFontScale";

  static const String lang = "language";
  static const String theme = "Theme";
  static const String code = "MyIdCode";
  static const String userToken = "userToken";
  static const String userMainNumer = "userMainNumber";
}

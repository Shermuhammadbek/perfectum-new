import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:perfectum_new/logic/models/auth_model.dart';

class SecureStorage {

  static const String guestAccessKey = "guestAccessKey";
  static const String userAccessKey = "userAccessKey";
  static const String userPinKey = "userPinKey";

  // ignore: unused_field
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'perfectum_prefs',
      preferencesKeyPrefix: 'perfectum_',
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      groupId: null,
      accountName: 'perfectum_secure_storage',
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),

  );

  static Future<void> saveAuthResponse({required AuthResponse response,}) async {
    await _storage.write(
      key: response.type == UserType.guest ? guestAccessKey : userAccessKey, 
      value: jsonEncode(response.toJson()),
    );
  }

  
  static Future<AuthResponse?> getAuthResponse({required UserType type}) async {
    try {
      String? result = await _storage.read(
        key: type == UserType.guest ? guestAccessKey : userAccessKey,
      );
      if (result != null) {
        return AuthResponse.fromJson(jsonDecode(result));
      }
    } catch (e) {log("$e getAuthResponse error");}
    return null;
  }


  static Future<void> saveUserPin({required String pin}) async {
    try {
      await _storage.write(key: userPinKey, value: pin);
    } catch (e) {
      log("$e userPin error");
    }
  }

  static Future<String?> getUserPin() async {
    try {
      return await _storage.read(key: userPinKey);
    } catch (e) {
      log("$e getUserPin error");
      return null;
    }
  }



  static Future<void> clear({UserType? type}) async {
    try {
      switch (type) {
        case UserType.guest:
          await _storage.delete(key: guestAccessKey);
          break;
        case UserType.user:
          await _storage.delete(key: userAccessKey);
          break;
        default:
          await _storage.deleteAll();
      }
     } catch (e) {
      log("$e clearAll error");
    }
  }
}
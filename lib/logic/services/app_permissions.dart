import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class MyPermissions {

  static Future<void> notification() async {
    if (await Permission.notification.isGranted) {
      log("Notification allowed");
    } else {
      await Permission.notification.request();
    }
  }

  static Future<bool> sms() async {
    if(await Permission.sms.isGranted){
      log("Sms allowed");
    } else {
      await Permission.sms.request();
    }
    return Permission.sms.isGranted;
  }
 
}

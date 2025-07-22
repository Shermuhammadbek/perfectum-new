import 'dart:developer';
import 'dart:math' show Random;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/hive_services.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/root_services.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

class ImeiIccFormController extends GetxController {
  late final TextEditingController imeiController;
  late final TextEditingController iccController;
  final Dio dio = Dio();
  final HiveServices hive = RootService.hiveServices;
  
  // Reactive text counts
  final imeiCount = 0.obs;
  final iccCount = 0.obs;
  late int imeiIndicator;
  late int iccIndicator;

  Rx<ItemStatusEnum> imeiStatus = ItemStatusEnum.empty.obs;
  Rx<ItemStatusEnum> iccStatus = ItemStatusEnum.empty.obs;

  void initController() {
    imeiController = TextEditingController()
      ..addListener(imeiLisener);
    
    iccController = TextEditingController()
      ..addListener(iccLisener);
  }

  void imeiLisener() async {
    final indicator = Random().nextInt(9999);
    imeiIndicator = indicator;
    if(imeiCount.value != imeiController.text.length) {
      imeiCount.value = imeiController.text.length;
      if(imeiCount.value >= 15 && indicator == imeiIndicator) {
        imeiStatus.value = ItemStatusEnum.loading;
        final result = await checkDeviceStatus(imei: imeiController.text);
        if(indicator == imeiIndicator) {
          imeiStatus.value = result ? ItemStatusEnum.available : ItemStatusEnum.inUse;
        }
      } else {
        if(indicator == imeiIndicator) {
          imeiStatus.value = ItemStatusEnum.empty;
        }
      }
    }
  }

  void iccLisener() async {
    final indicator = Random().nextInt(9999);
    iccIndicator = indicator;
    if(iccController.text.length != iccCount.value) {
      iccCount.value = iccController.text.length;
      if(iccCount.value == 19 && iccIndicator == indicator) {
        iccStatus.value = ItemStatusEnum.loading;
        final result = await checkIccStatus(icc: iccController.text);
        if(iccIndicator == indicator) {
          iccStatus.value = result ? ItemStatusEnum.available : ItemStatusEnum.inUse;
        }
      } else {
        if(iccIndicator == indicator) {
          iccStatus.value = ItemStatusEnum.empty;
        }
      }
    }
  }



  Future<bool> checkIccStatus({required String icc}) async {
    log("$icc icc");
    try {
      final respHttp = await dio.post(
        MyApiKeys.main + MyApiKeys.checkSim, 
        options: Options(headers: 
          {"Authorization" : "Bearer ${hive.getToken()}",},
        ),
        data: {"data" : {"icc" : icc}},
      );
      log("${respHttp.realUri} icc url");

      log("check icc Status: ${respHttp.data}",);
      return (respHttp.data["success"] ?? respHttp.data["data"]["success"]);
    } catch (e) {
      log("$e check sim error");
    }
    return false;
  }


  Future<bool> checkDeviceStatus({required String imei}) async {
    try {
      final respHttp = await dio.post(
        MyApiKeys.main + MyApiKeys.checkDevice, 
        options: Options(headers: 
          {"Authorization" : "Bearer ${hive.getToken()}",}
        ),
        data: {"data" : {"identifier" : imei}},
      );
      log(
        "check imei Status: ${respHttp.data}",
      );
      log("${respHttp.realUri} url");
      return (respHttp.data["success"] ?? respHttp.data["data"]["success"]);
    } catch (e) {
      log("$e check device error");
    }
    return false;
  }



  @override
  void onClose() {
    imeiController.dispose();
    iccController.dispose();
    super.onClose();
  }
}


enum ItemStatusEnum {
  loading,
  inUse,
  empty,
  available;
}
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'hive_services.dart';

class RootService {
  static final _getIt = GetIt.instance;

  static Future init() async {
    await Hive.initFlutter();
    if (!_getIt.isRegistered<RootService>()) {
      _getIt.registerSingleton<RootService>(RootService());
      await _getIt<RootService>().initServices();
    }
  }

  Future<void> initServices() async {
    await HiveServices.createBox();
  }

  static HiveServices get hiveServices => _getIt.get<HiveServices>();
}
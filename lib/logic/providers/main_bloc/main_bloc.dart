import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/hive_services.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/root_services.dart';
import 'package:perfectum_new/presentation/main_screens/app_news_screen/news_screen.dart';
import 'package:perfectum_new/presentation/main_screens/expenses_screen/expenses_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/home_screen.dart';
import 'package:perfectum_new/presentation/main_screens/user_settings/user_settings_screen.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

import 'main_event.dart';
import 'main_state.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'main_event.dart';
export 'main_state.dart';


class MainBloc extends Bloc<MainEvent, MainState> {
  HiveServices hive = RootService.hiveServices;
  final Dio dio = Dio();
  String userToken = "";
  String userNumber = "";
  ThemeMode theme = ThemeMode.light;

  bool userLoggedIn = false;

  List<Widget> mainPages = [
    const HomeScreen(), const ExpensesScreen(),
    const NewsScreen(), const UserSettingsScreen(),
  ];
  int currentPageIndex = 0;

  MainBloc() : super(MainInitial()){

    //? Main bloc start
    on<StartMainBloc>((event, emit) async {
      
      log("MainBloc: StartMainBloc");

      emit(MainDataLoading());

      //? Get theme
      theme = hive.getTheme();

      //? Get user token
      userToken = hive.getToken();
      log("user token: $userToken");
      if(userToken.isEmpty){
        userToken = await getToken(); 
      }

      await hive.setUserToken(userToken);

      userNumber = hive.getUserMainNumber();

      if(userNumber.isNotEmpty) {
        userLoggedIn = true;
      }

      emit(MainDataLoaded());
    },);

    //? Theme changing
    on<MainBlocChangeTheme>((event, emit) {
      theme = event.theme;
      hive.setTheme(theme);
      emit(MainBlocThemeChanged(theme: theme));
    },);

    on<MainUserLoggedIn>((event, emit) {
      userLoggedIn = true;
      userNumber = event.userNumber;
      hive.setUserMainNumer(event.userNumber);
      emit(MainUserLoggedInFinished());
    },);

    //? Font scale changing
    on<MainBlocChangeFontScale>((event, emit) {
      hive.setGlobalFontScale(event.scale);
      emit(MainBlocFontScaleChanged(scale: event.scale));
    },);

    //? Main pages production
    on<ChangeMainPage>((event, emit) {
      currentPageIndex = event.index;
      emit(MainPageChanged(
        index: event.index, page: mainPages[currentPageIndex]
      ));
    },);  

    on<MainRefreshToken>((event, emit) async {
      log("refresh token event");
      final newToken = await getToken();
      if (newToken.isNotEmpty) {
        userToken = newToken;
        hive.setUserToken(userToken);
        emit(MainUserLoggedInFinished());
      }
    });

  }

  Future<void> refreshToken() async {
    const api = MyApiKeys.main + MyApiKeys.refreshToken;

    final resp = dio.post(api, 
      options: Options(headers: {"Authorization" : "Bearer $userToken",}),
      data: {"refresh_token" : hive.getUserRefreshToken(),},
    );

  }

  Future<String> getToken() async {
    try {
      final device = await getDeviceInfo();
      log("device: $device");
      final resp = await dio.post(
        MyApiKeys.main + MyApiKeys.getToken,
        data: await getDeviceInfo(),
      );
      log("${resp.data} new token");
      return resp.data["access_token"];
    } on DioException catch (e) {
      log("${e.response?.data} get token error");
      log("${e.response?.statusCode} get token error");
      log("${e.response?.statusMessage} get token error");
      log("${e.response?.realUri} get token error");
      log("$e error");
    }
    return "";
  }


}

Future<String> getUdid() async {
  String _id = ""; _id = await FlutterUdid.consistentUdid;
  return _id;
}

Future<Map<String, dynamic>> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> deviceDetails = {};

  final String uId = await getUdid();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceDetails = {
      "user_devices_uuid" : await getUdid(),
      "device_model" : androidInfo.model,
      "os_id" : 2,
    };

  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceDetails = {
      "user_devices_uuid" : await getUdid(),
      "device_model" : iosInfo.name,
      "os_id" : 1,
    };
 
  }
  return deviceDetails;
}


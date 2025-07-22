import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/logic/services/storage_services/hive/root_services.dart';
import 'package:perfectum_new/presentation/enterance/login/splash_screen.dart';
import 'package:perfectum_new/source/material/my_blocs.dart';
import 'package:perfectum_new/source/material/my_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RootService.init();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if(mounted) {
        log("${MediaQuery.of(context).size}");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyBlocs(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white
            ),
          ),
          routes: myRoutes,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
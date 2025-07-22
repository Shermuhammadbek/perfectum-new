

import 'package:flutter/material.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';

abstract class MainEvent {}

class StartMainBloc extends MainEvent {
  final BuildContext ctx;
  final AuthBloc authBloc;

  StartMainBloc({
    required this.ctx, required this.authBloc,
  });
}


class ChangeMainPage extends MainEvent {
  final int index;
  ChangeMainPage({required this.index});
}

class MainUserLoggedIn extends MainEvent {
  final String userNumber;

  MainUserLoggedIn({required this.userNumber});
}


//? Theme
class MainBlocChangeTheme extends MainEvent {
  final ThemeMode theme;

  MainBlocChangeTheme({required this.theme});
}

//? Font scale

class MainBlocChangeFontScale extends MainEvent {
  final double scale;

  MainBlocChangeFontScale({required this.scale});
}

class MainRefreshToken extends MainEvent {}

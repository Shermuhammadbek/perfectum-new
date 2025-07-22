import 'package:flutter/material.dart';

abstract class MainState {}

class MainInitial extends MainState {}

class MainPageChanged extends MainState {
  final int index; final Widget page;

  MainPageChanged({
    required this.page, required this.index
  });
}

class MainUserLoggedInFinished extends MainState {}

//? Main data
class MainDataLoaded extends MainState {}
class MainDataLoading extends MainState {}

//? Notifications
class NotificationPageLoading extends MainState {}
class NotificationPageLoaded extends MainState {}

//? Theme
class MainBlocThemeChanged extends MainState {
  final ThemeMode theme;

  MainBlocThemeChanged({required this.theme});
}

//? Font scale
class MainBlocFontScaleChanged extends MainState {
  final double scale;

  MainBlocFontScaleChanged({required this.scale});
}
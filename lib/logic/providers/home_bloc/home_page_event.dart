part of 'home_page_bloc.dart';

abstract class HomePageEvent {}

class HomePageInit extends HomePageEvent {}


class HomeLoadOffers extends HomePageEvent {}
class HomeLoadAddons extends HomePageEvent {}

//? numbers section
class HomeLoadNumbers extends HomePageEvent {
  final int pageIndex;
  HomeLoadNumbers({required this.pageIndex});
}


class HomeLoadUserBalance extends HomePageEvent {}
class HomeLoadPaymentHistory extends HomePageEvent {}
class HomeLoadChargeHistory extends HomePageEvent {}


// class HomeStartMyId extends HomePageEvent {}

// class HomeBasketCommit extends HomePageEvent {
// }

// class HomeGetBasketDetail extends HomePageEvent {}

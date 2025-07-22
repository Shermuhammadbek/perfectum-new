part of 'home_page_bloc.dart';


abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

//? Offers Section =>
class HomeOffersLoading extends HomePageState {}
class HomeOffersLoaded extends HomePageState {
  final List<ProductOffering> offers;
  HomeOffersLoaded({required this.offers});
}
// on error
class HomeOffersError extends HomePageState {}



//? numbers section
class HomeNumbersLoading extends HomePageState {}
class HomeNumbersLoadingNextPage extends HomePageState {}
class HomeNumbersLoaded extends HomePageState {
  final List<PhoneNumber> numbers;
  HomeNumbersLoaded({required this.numbers});
}
// on error
class HomeNumbersLoadingError extends HomePageState {}


//? UserBalance

class HomeUserBalanceLoading extends HomePageState {}
class HomeUserBalanceLoaded extends HomePageState {
  final double balance;
  HomeUserBalanceLoaded({required this.balance});
}

//? payment history
class HomePaymentHistoryLoading extends HomePageState {}
class HomePaymentHistoryLoaded extends HomePageState {
  final List<PaymentRecord> paymentHistory;
  HomePaymentHistoryLoaded({required this.paymentHistory});
}
class HomePayementHistoryError extends HomePageState {}

//? charge history
class HomeChargeHistoryLoading extends HomePageState {}
class HomeChargeHistoryLoaded extends HomePageState {
  final List<BundleTransaction> chargeHistory;
  HomeChargeHistoryLoaded({required this.chargeHistory});
}
class HomeChargeHistoryError extends HomePageState {}
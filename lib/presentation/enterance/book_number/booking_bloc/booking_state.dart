part of 'booking_bloc.dart';


abstract class BookingState {}

final class BookingInitial extends BookingState {}

//? Backet Create Section =>
class BookingCreateBacketLoading extends BookingState {}
class BookingCreateBacketSuccess extends BookingState {}
class BookingCreateBacketError extends BookingState {}


//! Collect items
class BookingAddItemsLoading extends BookingState {}
class BookingAddItemsSuccess extends BookingState {}
class BookingAddItemsError extends BookingState {}


//! MyId Section =>
class BookingMyIdReady extends BookingState {}
// on Error
class BookingMyIdError extends BookingState {
  final String errorText;
  BookingMyIdError({required this.errorText});
}

//! Set user contact number
class BookingSetContactNumberLoading extends BookingState {}
class BookingSetContactNumberSuccess extends BookingState {}
class BookingSetContactNumberError extends BookingState {}



//? Collect backet Items =>
// on Loading
class BookingCollectBacketLoading extends BookingState {}

class BookingIccAlreadyExist extends BookingState {}
class BookingCollectBasketSuccess extends BookingState {}
// on Error
class BookingCollectBasketError extends BookingState {}

//? Agreement Section =>
class BookingAgreementLoading extends BookingState {}
class BookingAgreementSuccess extends BookingState {}
// on Error
class BookingAgreementError extends BookingState {}




class BookingBasketDetailLoading extends BookingState {}
class BookingBasketDetailLoaded extends BookingState {
  final List<Map<String, dynamic>> basketDetail;
  BookingBasketDetailLoaded({required this.basketDetail});
}
// on Error
class BookingBasketDetailError extends BookingState {}

class BookingBasketCommitLoading extends BookingState {}
class BookingBasketCommitSuccess extends BookingState {}
class BookingBasketCommitError extends BookingState {}


enum BookingCheckStatus {
  loading, error, inUse, success, empty,
}
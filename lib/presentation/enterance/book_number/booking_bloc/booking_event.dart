part of 'booking_bloc.dart';

abstract class BookingEvent {}

class BookingNumberSelected extends BookingEvent {
  final PhoneNumber selectedNumber;

  BookingNumberSelected({required this.selectedNumber});
}

class BookingCreateBasket extends BookingEvent {
  final String productId;
  BookingCreateBasket({
    required this.productId,
  });
}

class BookingCancelBasket extends BookingEvent {}


class BookingAddItems extends BookingEvent {
  final String icc; final String imei;

  BookingAddItems({required this.icc, required this.imei});
}

class BookingStartMyId extends BookingEvent {}

class BookingSetUserPhoneNumber extends BookingEvent {
  final String contactNumber;
  final String contactMail;

  BookingSetUserPhoneNumber({
    required this.contactNumber, required this.contactMail
  });
}

class BookingGetBasketDetail extends BookingEvent {}

class BookingBacketClose extends BookingEvent {}


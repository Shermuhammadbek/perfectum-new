import 'dart:developer' show log;
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:myid/enums.dart';
import 'package:myid/myid.dart';
import 'package:myid/myid_config.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_models/myid_token_model.dart';
import 'package:perfectum_new/logic/models/phone_number_model.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_models/subscription_data.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/logic/providers/home_bloc/home_page_bloc.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final HomePageBloc homeBloc;
  final MainBloc mainBloc;
  final Dio dio = Dio();

  late String icc;
  late PhoneNumber userSelectedNumber;

  late SubscriptionData subscriptionData;
  late String basketIndividualId;

  late MyIdToken myIdToken;

  BookingBloc({
    required this.homeBloc,
    required this.mainBloc,
  }) : super(BookingInitial()) {

    on<BookingNumberSelected>((event, emit) {
      userSelectedNumber = event.selectedNumber;
    },);

    on<BookingCreateBasket>((event, emit) async {
      emit(BookingCreateBacketLoading());
      try {
        final result = await createBasket(
          msisdn: userSelectedNumber.number, 
          offerId: event.productId,
        );
        if(result != null){
          subscriptionData = SubscriptionData.fromJson(
            result["data"],
          );
          emit(BookingCreateBacketSuccess());
        } else {
          emit(BookingCreateBacketError());
        }

      } catch (e) {
        log("$e create basket error");
      }
    },);

    on<BookingCancelBasket>((event, emit) {
      
    },);


    on<BookingAddItems>((event, emit) async {
      emit(BookingAddItemsLoading());
      final resp = await collectBasketAgrement(
        thisData: subscriptionData, thisIcc: event.icc,
        thisImei: event.imei
      );

      await Future.delayed(const Duration(seconds: 2), () {});
      emit(BookingAddItemsSuccess());
    },);


    on<BookingStartMyId>((event, emit)  async {
      Map<String, dynamic> result = {};
      late String _code = "";
      final MyIdResult _result = await initMyId(event, emit);
      if(_result.code != null){
        _code = _result.code ?? "";
      }

      if(_code.isEmpty){
        emit(BookingMyIdError(errorText: "My id error. Code is empty"));
      }

      try {
        myIdToken = await getMyIdToken(_code);
        result = await getUserFullData(myIdToken);
        
        final setinfo = await myIdSetInfo(userData: result["profile"],);
        if(setinfo != null && setinfo){
          log("Set info error none");
          emit(BookingAddItemsSuccess());
        } else {
          log("Set info error 500");
          emit(BookingMyIdError(errorText: "My id error. Set info error 500"));
        }
      } catch (e) {
        log("$e get user full data error");
        emit(BookingMyIdError(errorText: "My id error. Get user full data error"));
      }
      log("$result");
    },); 


    on<BookingSetUserPhoneNumber>((event, emit) async {
      emit(BookingSetContactNumberLoading());
      final resp = await setUserPhoneNumber(thisNumber: event.contactNumber);

      emit(resp ? BookingSetContactNumberSuccess() : BookingSetContactNumberError());

    },);


    on<BookingGetBasketDetail>((event, emit) async {
      emit(BookingBasketDetailLoading());
      final result = await getBasketDetail();
      if(result != null){
        emit(BookingBasketDetailLoaded(basketDetail: result));
      } else {
        emit(BookingBasketDetailError());
      }
      add(BookingBacketClose());
    },);


    on<BookingBacketClose> ((event, emit) async {
      final result = await basketClose();
      if(result != null && result){
        emit(BookingBasketCommitSuccess());
      } else {
        emit(BookingBasketCommitError());
      }
    });

  }

  Future<bool> setUserPhoneNumber({required String thisNumber,}) async {
    try {
      final resp = await dio.post(
        MyApiKeys.main + MyApiKeys.basketContactMedia,
        options: Options(headers: homeBloc.headerToken(),),
        data: {
          "data": {
            "type": "basket-contact-media",
            "attributes": {
              "role": "primary",
              "lifecycle-status": "confirmed",
              "medium-type": "telephone-number",
              "medium": {
                  "meta": {
                      "type": "telephone-number"
                  },
                  "number": thisNumber,
                  "number-type":"mobile"
              }
            },
            "relationships": {
              "basket-party": {
                "data": {
                    "type": "basket-individuals",
                    "id": basketIndividualId
                }
              }
            }
          }
        }
      );

      log("${resp.data} contact media");
      return true;
    } on DioException catch (e) {
      log("${e.response!.data} add contact media error");
      return false;
    }
  }

  Future<Map<String, dynamic>?> createBasket({required int msisdn, required String offerId}) async {
    const String api = MyApiKeys.main + MyApiKeys.basketCreate;
    try {
      final resp = await dio.post(api, 
      options: Options(headers: homeBloc.headerToken(),),
      data: {
        "data": {
          "product-offering" : "PO_Asl_5G",
          "msisdn" : msisdn.toString(),
        }
      },
    );
    log("createBasket ${resp.data}",);
    return resp.data;
    } on DioException catch (e) {
      log("$e createBasket error");
      log("${e.message} message");
      log("${e.response!.statusMessage} message");
      log("${e.response!.headers} headers");
      log("${e.response!.realUri} real uri");
    }
    return null;
  }


  Future<bool?> checkIccStatus({required String icc}) async {
    try {
      final respHttp = await dio.post(
        MyApiKeys.main + MyApiKeys.checkSim, 
        options: Options(headers: homeBloc.headerToken(),),
        data: {"data" : {"icc" : icc}},
      );
      log(
        "check Number Status: ${respHttp.data}",
      );
      return (respHttp.data["success"] ?? respHttp.data["data"]["success"]);
    } catch (e) {
      log("$e check sim error");
    }
    return null;
  }



  Future<bool?> checkDeviceStatus({required String imei}) async {
    try {
      final respHttp = await dio.post(
        MyApiKeys.main + MyApiKeys.checkDevice, 
        options: Options(headers: homeBloc.headerToken(),),
        data: {"data" : {"identifier" : imei}},
      );
      log(
        "check device Status: ${respHttp.data}",
      );
      log("${respHttp.realUri} url");
      return (respHttp.data["success"] ?? respHttp.data["data"]["success"]);
    } catch (e) {
      log("$e check device error");
    }
    return null;
  }


  Future<bool> collectBasketAgrement({
    required SubscriptionData thisData, required String thisImei, 
    required String thisIcc,
  }) async {
    late bool addIccResult;
    late bool addImeiResult;
    try {
      final resp = await dio.post(
        MyApiKeys.main + MyApiKeys.basketAddIcc,
        options: Options(headers: homeBloc.headerToken()),
        data: {
          "data" : {
            "basket-id" : thisData.basketId,
            "subscription-item-id" : thisData.subscriptionItemId,
            "subscription-product-id" : thisData.subscriptionProductId,
            "reservation-id-msisdn" : thisData.reservationIdMsisdn,
            "end-time" : thisData.endTime.toIso8601String(),
            "icc-id" : thisIcc,
            "msisdn" : userSelectedNumber.number.toString()
          }
        }
      );
      log("${resp.data} icc result");
      addIccResult = true;
    } on DioException catch (e) {
      log("${e.response!.data} baskets add icc error error");
      addIccResult = false;
    }

    if(addIccResult) {
      try {
        final resp = await dio.post(
          MyApiKeys.main + MyApiKeys.basketAddDevice,
          options: Options(headers: homeBloc.headerToken()),
          data: {
            "data" : {
              "basket-id" : thisData.basketId,
              "subscription-item-id" : thisData.subscriptionItemId,
              "reservation-id-msisdn" : thisData.reservationIdMsisdn,
              "end-time" : thisData.endTime.toIso8601String(),
              "imei" : thisImei,
              "offer-id" : thisData.offerId
            }
          }
        );
        log("${resp.data} imei result");
        addImeiResult = true;
      } on DioException catch (e) {
        log("${e.response?.data} baskets add imei error error");
        addImeiResult = false;
      }
    }

    return (addIccResult && addImeiResult);
  }

  
  Future<void> cancelBasket() async {
    final resp = await dio.post(
      MyApiKeys.main + MyApiKeys.basketsDiscard,
      data: {
        "data": {
          "type": "baskets-discard",
          "relationships": {
            "instance": {
              "data": {
                "type" : "baskets",
                "id" : subscriptionData.basketId,
              }
            }
          }
        }
      }
    );

    log("${resp.data} ");
  }


  //? My id section
  Future<MyIdResult> initMyId(BookingEvent event, Emitter<BookingState> emit) async {
    MyIdResult? result;
    try {
      result = await MyIdClient.start(
        config: MyIdConfig(
          clientId: MyId.clientId,
          clientHash: MyId.clientHash,
          clientHashId: MyId.clientHashId,
          environment: MyIdEnvironment.DEBUG,
          entryType: MyIdEntryType.IDENTIFICATION,
          locale: MyIdLocale.RUSSIAN,
        ),
      );
    } catch (e) {
      log("MyId $e");
      emit(BookingMyIdError(errorText: e.toString()));
    }

    return result!;
  }

  Future<MyIdToken> getMyIdToken(String code) async {
    const String api = "https://devmyid.uz/api/v1/oauth2/access-token";
    late MyIdToken myIdToken;

    try {
      final resp = await dio.post(api, 
        options: Options(headers: {
          "Content-type" : "application/x-www-form-urlencoded",
        },),
        data: {
          "grant_type" : "authorization_code",
          "code" : code, "client_id" : MyId.clientId,
          "client_secret" : MyId.clientSecret
        }
      );
      myIdToken = MyIdToken.toObject(resp.data);
    } catch (e) {
      log("$e get MyId token error");
    }
    return myIdToken; 
  }

  Future<bool?> myIdSetInfo({
    required Map<String, dynamic> userData,
  }) async {
    log("$userData myIdSetInfo");
    const String api = MyApiKeys.main + MyApiKeys.basketCustomerCreate;
    try {
      final resp = await dio.post(
        api,
        options: Options(headers: homeBloc.headerToken()),
        data: {
          "data" : {
            "basket-id" : subscriptionData.basketId,
            "customer-info": {
              "language": "rus",
              "nationality": "UZ",
              "country": "UZ"
            },
            "myid-info" : {
              "common_data": {
                  "first_name": "SHERMUHAMMAD OK",
                  "first_name_en": "SHERMUKHAMMAD",
                  "middle_name": "NODIRBEK O‘G‘LI",
                  "last_name": "ABDUOLIMOV",
                  "last_name_en": "ABDUOLIMOV",
                  "pinfl": "5280603708${math.Random().nextInt(999)}",
                  "gender": 1,
                  "birth_place": "MARG‘ILON SHAHRI",
                  "birth_country": "УЗБЕКИСТАН",
                  "birth_country_id": 182,
                  "birth_country_id_cbu": 860,
                  "birth_date": "28.06.2003",
                  "nationality": "УЗБЕК/УЗБЕЧКА",
                  "nationality_id": 44,
                  "nationality_id_cbu": "01",
                  "citizenship": "УЗБЕКИСТАН",
                  "citizenship_id": 182,
                  "citizenship_id_cbu": 860,
                  "doc_type": "БИОМЕТРИЧЕСКИЙ ПАСПОРТ ГРАЖДАНИНА РЕСПУБЛИКИ УЗБЕКИСТАН",
                  "doc_type_id": 46,
                  "doc_type_id_cbu": 6,
                  "sdk_hash": "35993f57b58d38ea9464db5fdad1d838",
                  "last_update_pass_data": "2024-11-21T08:41:40.617286+00:00",
                  "last_update_address": "2024-11-21T08:41:40.617307+00:00"
              },
              "doc_data": {
                  "pass_data": "AC2747${math.Random().nextInt(999)}",
                  "issued_by": "МАРГИЛАНСКИЙ ГОВД ФЕРГАНСКОЙ ОБЛАСТИ",
                  "issued_by_id": 30412,
                  "issued_date": "2020-02-25",
                  "expiry_date": "2030-02-24",
                  "doc_type": "БИОМЕТРИЧЕСКИЙ ПАСПОРТ ГРАЖДАНИНА РЕСПУБЛИКИ УЗБЕКИСТАН",
                  "doc_type_id": 46,
                  "doc_type_id_cbu": 6
              },
              "contacts": {
                  "phone": null,
                  "email": null
              },
              "address": {
                  "permanent_address": "Янги обод МФЙ, Болтакул кучаси, 41-уй",
                  "temporary_address": "Окибат МФЙ, Ц-1 Буюк Ипак йули мавзеси, 45г-уй, 12-хонадон",
                  "permanent_registration": {
                      "region": "ФАРҒОНА ВИЛОЯТИ",
                      "address": "Янги обод МФЙ, Болтакул кучаси, 41-уй",
                      "country": "ЎЗБЕКИСТОН",
                      "cadastre": "15:19:02:03:01:1129",
                      "district": "МАРҒИЛОН ШАҲРИ",
                      "region_id": 15,
                      "country_id": 182,
                      "district_id": 1520,
                      "region_id_cbu": 30,
                      "country_id_cbu": 860,
                      "district_id_cbu": 149,
                      "registration_date": "2020-03-07T00:00:00"
                  },
                  "temporary_registration": {
                      "region": "TOSHKENT SHAHRI",
                      "address": "Окибат МФЙ, Ц-1 Буюк Ипак йули мавзеси, 45г-уй, 12-хонадон",
                      "country": null,
                      "cadastre": "10:09:01:02:01:5288:0001:012",
                      "district": "MIRZO ULUG‘BEK TUMANI",
                      "date_from": "2024-09-04T00:00:00",
                      "date_till": "2025-09-04T00:00:00",
                      "region_id": 10,
                      "country_id": null,
                      "district_id": 1003,
                      "region_id_cbu": 26,
                      "country_id_cbu": null,
                      "district_id_cbu": 201
                  }
              },
            }
          }
        }
      );

      log("${resp.data} myIdSetInfo body");
      log("${resp.statusCode} myIdSetInfo status code");
      if(resp.data['data']['individual-id'] != null){
        basketIndividualId = resp.data['data']['individual-id'];
        return true;
      }
    } on DioException catch (e) {
      log("${e.response!.data} myIdSetInfo error");
    }
    return false;
  }


  Future<Map<String, dynamic>> getUserFullData(MyIdToken data) async {
    String api = "https://devmyid.uz/api/v1/users/me";
    late Map<String, dynamic> result;
    try {
      final resp = await dio.get(
        api, options: Options(
          headers: {"Authorization" : "Bearer ${data.accessToken}"}
        )
      );
      result = resp.data;
    } catch (e) {
      log("$e get user full data error");
    }
    return result;
  }

  Future<List<Map<String, dynamic>>?> getBasketDetail() async {
    List<Map<String, dynamic>> result = [];
    try {
      log("${subscriptionData.basketId}basket id");
      final resp = await dio.get(
        "${MyApiKeys.main}${MyApiKeys.basketDetail}${subscriptionData.basketId}", 
          options: Options(headers: homeBloc.headerToken(),
        ),
      );
      result = resp.data.cast<Map<String,dynamic>>();
      log("${resp.data} basket detail");
      return result;
    } catch (e) {
      log("$e check basket detail error");
    }
    return null;
  }

  Future<bool?> basketClose() async {
    log("${MyApiKeys.main}${MyApiKeys.basketCommit} close api");
    try {
      final resp = await dio.post(
        "${MyApiKeys.main}${MyApiKeys.basketCommit}", 
        options: Options(headers: homeBloc.headerToken()),
        data: {
          "data" : {
            "basket-id" : subscriptionData.basketId,
            "msisdn" : userSelectedNumber.number.toString() 
          }
        }
      );
      log("${resp.data} ${resp.realUri} check basket close");
    } catch (e) {
      log("$e check basket commit error");
    }
    return null;
  }
}

//? MyId keys
class MyId {
  static const String clientHashId = "e3f5da1d-482f-4510-86af-aec9e5c8e78c";
  static const String clientId = "perfectum_sdk-GqcTuOcUCK4SmWYuJQNqUPkTKsrbhUMYibvNiSlG";
  static const String clientSecret = "KUH0UWEdrEKpp8Xpjp2t6MJavd0ciykaeCB04fJeyWSSiQrOciZvHutG83IRwJwkmwbuzsmzAElWECeOrnl9cEFrav8EwAd8jckQ";
  static const String clientHash = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5JC5WFY6LgTY19Iz5T5XMWgdHBbpP6rsLwRFzD/3gK03QgXx/o5ie+/LgbKLHpZbyZyTM5j374ijt6lI1lkS8HK+6wj5q+burf2XLhMYqyWp/PQIUZYPXRgCjRysmha/fqicPg+3Ntx7Os9uzOrnrIStNiIXPRjyMEI9E5PCPgv25HFYkiYXQUxJbbleyLpX6oVhDSOiYuAT3sjn4PqWQ5W8QM3sa2XSIZwtbauNcxkcQ0CllC9LCL9KX+Dok7Le97/xPOa6ji3ItZzP9pMw6EbADVgyCdb2vDdvlJSiGpraGnuxwlJN2ZegsXf+URKVtoVtgvj5Gk3Ekrkcu55bGwIDAQAB";
}
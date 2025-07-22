
import 'dart:developer';
import 'package:perfectum_new/logic/models/charging_record_model.dart';
import 'package:perfectum_new/logic/models/payment_record_model.dart';
import 'package:perfectum_new/logic/models/phone_number_model.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/source/material/my_api_keys.dart';

import '../../../../../logic/models/offer_model.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';


part 'home_page_event.dart';
part 'home_page_state.dart';


class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  final MainBloc mainBloc;

  //? Header token
  Map<String, String> headerToken(){
    return {"Authorization" : "Bearer ${mainBloc.userToken}",};
  }
  
  HomePageBloc({required this.mainBloc}) : super(HomePageInitial()) {

    on<HomeLoadOffers>((event, emit) async {
      emit(HomeOffersLoading());
      final result = await getProductCatalog();
      if(result != null) {
        final offers = ProductOfferingsResponse.fromJson(result);
        emit(HomeOffersLoaded(offers: offers.data));
      } else {
        emit(HomeOffersError());
      }

    },);

    on<HomeLoadNumbers>((event, emit) async {
      emit(event.pageIndex == 1 ? HomeNumbersLoading() : HomeNumbersLoadingNextPage());
      final result = await getAvailableNumbersByPage(index: event.pageIndex);
      if(result == null){
        emit(HomeNumbersLoadingError());
      } else {
        final numbers = PhoneNumberResponse.fromJson(result);
        emit(HomeNumbersLoaded(numbers: numbers.data));
      }
    },);

    on<HomeLoadUserBalance>((event, emit) async {
      emit(HomeUserBalanceLoading());
      final resp = await getUserBalance();
      if(resp != null){
        emit(HomeUserBalanceLoaded(balance: resp));
      } else {
        emit(HomeNumbersLoadingError());
      }
    },);

    on<HomeLoadPaymentHistory>((event, emit) async {
      emit(HomePaymentHistoryLoading());
      final resp = await loadPaymentHistory();
      if(resp != null){
        emit(HomePaymentHistoryLoaded(paymentHistory: resp));
      } else {
        emit(HomePayementHistoryError());
      }
    });

    on<HomeLoadChargeHistory>((event, emit) async {
      emit(HomeChargeHistoryLoading());
      final resp = await loadChargeHistory();
      if(resp != null){
        emit(HomeChargeHistoryLoaded(chargeHistory: resp.data));
      } else {
        emit(HomeChargeHistoryError());
      }
    });

  }

  Future<BundleTransactionResponse?> loadChargeHistory() async {
    const api = MyApiKeys.main + MyApiKeys.chargeHistory;
    try {
      final resp = await dio.get(api, 
        options: Options(headers: headerToken(),),
      );
      log("${resp.data} getChargeHistory response");
      return BundleTransactionResponse.fromJson(resp.data);
    } catch (e) {
      log("$e getChargeHistory error");
      return null;
    }
  }

  Future<List<PaymentRecord>?> loadPaymentHistory() async {
    const api = MyApiKeys.main + MyApiKeys.paymentHistory;
    try {
      final resp = await dio.get(api, 
        options: Options(headers: headerToken(),),
      );
      log("${resp.data} getPaymentHistory response");
      return PaymentHistoryResponse.fromJson(resp.data).data;
    } catch (e) {
      log("$e getPaymentHistory error");
      return null;
    }
  }

  Future<double?> getUserBalance() async {
    const api = MyApiKeys.main + MyApiKeys.userBalance;
    try {
      final resp = await dio.get(api, 
        options: Options(headers: headerToken(),),
      );
      log("${resp.data} getUserBalance response");
      return double.tryParse(resp.data["data"]["balanceafter"].toString());
    }  catch (e) {
      log("$e getUserBalance error");
      return null;
    }
  }


  Future<Map<String, dynamic>?> getAvailableNumbersByPage({required int index, int pageSize = 30}) async {
    const api = MyApiKeys.main + MyApiKeys.availableNumbers;
    try {
      final resp = await dio.post(api, 
        options: Options(headers: headerToken(),),
        data: {"page" : {"number" : index, "size" : pageSize}},
      );
      log("${resp.data} numbers");
      return resp.data;
    } catch (e) {
      log("$e getAvailableNumbersByPage error");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getProductCatalog() async {
    String api = MyApiKeys.main + MyApiKeys.offers;
    try {
      final resp = await dio.get(api,
        options: Options(headers: headerToken(),),
      );

      return resp.data['data'].cast<Map<String,dynamic>>();
    } on DioException catch (e)  {

      // if (e.type == DioExceptionType.connectionTimeout ||
      //   e.type == DioExceptionType.receiveTimeout ||
      //   e.error is SocketException) {
      //   await Get.offAllNamed(ConnectionTimeOut.routeName);
      // }   

      log("${e.type}  get product catalog error");

      log("${e.error}  get product catalog error");

      log("${e.message}  get product catalog error");

      log("${e.requestOptions.persistentConnection} persistentConnection get product catalog error");

      log("${e.response?.statusMessage}  get product catalog error");
      log("${e.response?.data}  get product catalog error");
      log("${e.response?.statusCode}  get product catalog error");
      log("${e.response?.realUri}  get product catalog error");
      if(e.response?.statusCode == 401){
        // Get.offAllNamed(LoginScreen.routeName);
        // throw Exception("401 error");
      }
      return null;
    } catch (e) {
      log("$e");
      return null;
    }
  }



} 





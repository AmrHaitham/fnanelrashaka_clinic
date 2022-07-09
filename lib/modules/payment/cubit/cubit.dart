import 'package:fanan_elrashaka_clinic/Network/dio.dart';
import 'package:fanan_elrashaka_clinic/models/first_token.dart';
import 'package:fanan_elrashaka_clinic/modules/payment/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fanan_elrashaka_clinic/PaymentConstants.dart';

class PaymentCubit extends Cubit<PaymentStates>{
  PaymentCubit() : super(PaymentInitalState());

  static PaymentCubit get(context) => BlocProvider.of(context);

  FirstToken? firstToken;

  Future getFirstToken(String price,String email,String phone,String name,String lastname)async{
    DioHelperPayment.postData(url: 'auth/tokens', data: {
      "api_key":PaymobApiKey
    }).then((value){
      PaymobToken = value.data['token'];
      print('First token : ${PaymobToken}');
      getOrderId(price, email, phone, name,lastname);
      print("all api's are called");
      emit(PaymentSuccessState());
    }).catchError((error){
      emit(PaymentErrorState(error));
    });
  }

  Future getOrderId(String price,String email,String phone,String name,String lastname)async{
    DioHelperPayment.postData(url: 'ecommerce/orders', data: {
      "auth_token":PaymobToken,
      "delivery_needed": "false",
      "amount_cents": price,
      "currency": "EGP",
      "items":[],
    }).then((value){
      PaymobOrderId = value.data['id'].toString();
      print('Order Id : ${PaymobOrderId}');
      getFinalTokenCard(price, email, phone, name,lastname);
      emit(PaymentOrderIDSuccessState());
    }).catchError((error){
      emit(PaymentOrderIDErrorState(error));
    });
  }

  Future getFinalTokenCard(String price,String email,String phone,String name,String lastname)async{
    print("IntegrationIDCard is :- ${IntegrationIDCard}");
    DioHelperPayment.postData(url: 'acceptance/payment_keys', data:
    {
      "auth_token": PaymobToken,
      "amount_cents": price,
      "expiration": 300,
      "order_id": PaymobOrderId,
      "billing_data": {
        "apartment": "NA",
        "email":email,
        "floor": "NA",
        "first_name": name,
        "street": "NA",
        "building": "NA",
        "phone_number": phone,
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": lastname,
        "state": "NA"
      },
      "currency": "EGP",
      "integration_id": IntegrationIDCard,
      "lock_order_when_paid": "false"
    }
    ).then((value){
      PaymobFinalTokenCard = value.data['token'].toString();
      print('Final token card : ${PaymobFinalTokenCard}');
      emit(PaymentRequestTokenSuccessState());
    }).catchError((error){
      emit(PaymentRequestTokenErrorState(error));
    });
  }

  Future getWallet(String price,String email,String phone,String name,String lastname)async{
    DioHelperPayment.postData(url: 'auth/tokens', data: {
      "api_key":PaymobApiKey
    }).then((value){
      PaymobToken = value.data['token'];
      print('First token : ${PaymobToken}');
      DioHelperPayment.postData(url: 'ecommerce/orders', data: {
        "auth_token":PaymobToken,
        "delivery_needed": "false",
        "amount_cents": price,
        "currency": "EGP",
        "items":[],
      }).then((value){
        PaymobOrderId = value.data['id'].toString();
        print('Order Id : ${PaymobOrderId}');
        DioHelperPayment.postData(url: 'acceptance/payment_keys', data:
        {
          "auth_token": PaymobToken,
          "amount_cents": price,
          "expiration": 300,
          "order_id": PaymobOrderId,
          "billing_data": {
            "apartment": "NA",
            "email":email,
            "floor": "NA",
            "first_name": name,
            "street": "NA",
            "building": "NA",
            "phone_number": phone,
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "last_name": lastname,
            "state": "NA"
          },
          "currency": "EGP",
          "integration_id": IntegrationIDCardMobileWallet,
          "lock_order_when_paid": "false"
        }
        ).then((value){
          PaymobFinalTokenCard = value.data['token'].toString();
          print('Final token card : ${PaymobFinalTokenCard}');
          DioHelperPayment.postData(url: 'https://accept.paymob.com/api/acceptance/payments/pay', data: {
            "source": {
              "identifier": phone,
              "subtype": "WALLET"
            },
            "payment_token": PaymobFinalTokenCard// token obtained in step 3
          }).then((value){
            PaymobWalletUrl = value.data["redirect_url"].toString();
            print('PaymobWalletUrl : ${PaymobWalletUrl}');
            emit(PaymentRequestWalletTokenSuccessState());
          }).catchError((error){
            emit(PaymentRequestWalletTokenErrorState(error));
          });
        });
      });
    });

  }
}
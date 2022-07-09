import 'dart:convert';
import 'package:fanan_elrashaka_clinic/Network/ApisEndPoint.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Bookings{

  getBookings(token,email)async{
    var response =await http.get(Uri.parse("${Apis.userBookingsEndPoint}${email}/"),headers: {
      'authorization': "Token ${token}",
    });

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      list.sort((a, b) => b['date'].compareTo(a['date']));
      print(list);
      return list;
    }
    else {
      print("error");
      print(jsonDecode(response.body)['error']);
      return jsonDecode(response.body) as List<dynamic>;
    }
  }

  applyPromo(clinic_service_id,code,token)async{
    var response =await http.get(
        Uri.parse("${Apis.bookingPromoCodeEndPoint}${clinic_service_id}/${code}/"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return response;
  }

  newBooking(token,transaction_id, email, payment_method, promocode, clinic_time, clinic_services,time_slot_id)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse(Apis.newBookingEndPoint));
    request.fields.addAll({
      'clinic_services': clinic_services, // clinic_services_id
      'clinic_time': clinic_time, // calendar id
      'promocode': promocode, // promocode if any is used
      'payment_method': payment_method, // 1: for credit card, 2: cash, 3:kiosk
      'email': email,
      'transaction_id': transaction_id,
      'using_time_slot': time_slot_id,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }
  holdTillPay(token,transaction_id, email, payment_method, promocode, clinic_time, clinic_services,is_package,description,using_time_slot)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('POST', Uri.parse(Apis.holdTillPayEndPoint));
    request.fields.addAll({
      'clinic_services': clinic_services, // clinic_services_id
      'clinic_time': clinic_time, // calendar id
      'promocode': promocode, // promocode if any is used
      'payment_method': payment_method, // 1: for credit card, 2: cash, 3:kiosk
      'email': email,
      'transaction_id': transaction_id,
      'is_package': is_package, // 1: for its a package, 0: normal service not a package
      'description': description, // when user enter custom price in packages
      'using_time_slot': using_time_slot, // when user using time slots return the id of the time slot
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }
}
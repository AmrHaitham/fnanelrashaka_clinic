import 'dart:convert';

import 'package:fanan_elrashaka_clinic/Network/ApisEndPoint.dart';
import 'package:http/http.dart' as http;

class Clinics{

  getClinics(token)async{
    var response =await http.get(
        Uri.parse("${Apis.allClinicsEndPoint}"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getClinicsServices(token,id)async{
    var response =await http.get(
        Uri.parse("${Apis.allClinicsServicesEndPoint}${id}/"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getClinicsCalendar(token,id,email)async{
    var response =await http.get(
        Uri.parse("${Apis.clinicCalendarEndPoint}${id}/${email}/"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(response.body);
  }

  getAllPackges(token)async{
    var response = await http.get(
      Uri.parse(Apis.allPackgesEndPoint),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  getTimeSlots(token,id,clinic_time_id)async{
    var response = await http.get(
        Uri.parse("${Apis.timeSlotsEndPoint}${id}/${clinic_time_id}"),
        headers: {
          'authorization': 'Token ${token}'
        }
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

}
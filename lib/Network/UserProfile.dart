import 'dart:convert';

import 'package:fanan_elrashaka_clinic/Network/ApisEndPoint.dart';
import 'package:http/http.dart' as http;


class UserProfile{

  getUserProfileData(email,token)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('GET', Uri.parse('${Apis.userProfileEndPoint}${email}/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return jsonDecode(await response.stream.bytesToString());

  }

  updateUserPassword(email,token,oldPassword,newPassword)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.changeUserPasswordEndPoint}${email}/'));
    request.fields.addAll({
      'new_password': newPassword,
      'old_password': oldPassword
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

  updateUserProfile(email,token,name,lastname,phone,birthday,gender,address)async{
    var headers = {
      'authorization': 'Token ${token}'
    };
    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.userProfileEndPoint}${email}/'));
    request.fields.addAll({
      'email': email,
      'first_name': name,
      'last_name': lastname,
      'phone': phone,
      'birthday': birthday,
      'gender': gender,
      'address': address,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

  updateProfilePic(email,token,image,name,phone,gender)async{
    var headers = {
      'authorization': 'Token ${token}'
    };

    var request = http.MultipartRequest('PUT', Uri.parse('${Apis.userProfileEndPoint}${email}/'));
    request.fields.addAll({
      'email': email,
      'name': name,
      'phone': phone,
      'gender': gender,
    });
    request.files.add(await http.MultipartFile.fromPath('image',image));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return jsonDecode(await response.stream.bytesToString());
  }

}
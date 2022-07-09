import 'package:fanan_elrashaka_clinic/Network/ApisEndPoint.dart';
import 'package:http/http.dart' as http;


class Auth{

  login(userName ,password)async{
    var response =await http.get(Uri.parse("${Apis.loginEndPoint}${userName}/${password}/"));
    return response;
  }

  register(email,name,lastname,password,phone,birthday,gender)async {
      var request = http.MultipartRequest('POST', Uri.parse(Apis.registerEndPoint));
      request.fields.addAll({
        'email': email,
        'first_name': name,
        'last_name': lastname,
        'password': password,
        'phone': phone,
        'birthday': birthday,
        'gender': gender // or 'F' for female
      });
      // request.files.add(await http.MultipartFile.fromPath('image', '/C:/Users/Ahmed/Desktop/inspiration/ready/artical.png'));
      http.StreamedResponse response = await request.send();
      return response;

  }
}
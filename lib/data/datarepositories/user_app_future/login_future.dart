import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:zoro_legal/domain/entities/user_app_model/login_model.dart';





Future login(String phone, String password) async {

  try {
    print("lofu");
    print(password);
    final response = await http.post("https://zorolegal.com/api/Loginnew", body: {
      "phone": phone,
      "password": password,
    });

    print(response.body);
    
 var decoded=jsonDecode(response.body);
  
  if(decoded['staus'].toString()=='false'){
 
return Loginmodel(staus: decoded['staus'],message: decoded['message']);
  }else {
    return Loginmodel.fromJson(json.decode(response.body));
  }
  } catch (e) {}
}

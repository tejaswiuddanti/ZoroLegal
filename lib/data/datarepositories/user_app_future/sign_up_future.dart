import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_city_list_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_state_list_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/otp_verify_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/sign_up_model.dart';

import 'package:zoro_legal/domain/entities/vendor_app_model/vendor_sign_up_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'country_getting_model.dart';

Future signup(
    String firstname,
    //  String lastname,
    String phone,
    String country,
    String password,
    //  String email,
    String character) async {
  try {
    print("signup");
    print(country+password+phone+firstname+character);
       final response = await http.post("https://zorolegal.com/api/SignUp", body: {
      "f_name": firstname,
      // "l_name": "lastname",
      // "email": "email",
      "password": password,
      "country_id": country,
      "role": character,
      "phone": phone
    });

    print(response.body);
    var decoded = jsonDecode(response.body);

    if (decoded['staus'].toString() == 'false') {
      return Signupmodel(staus: decoded['staus'], message: decoded['message']);
    } else {
      return Signupmodel.fromJson(json.decode(response.body));
    }
  } catch (e) {}
}

Future otpverify(
  String otp,
) async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var userid = storageInstance.getFromDisk("userId");
    print("otp:" + otp);
    print("userid: " + userid);
    final response = await http.post("https://zorolegal.com/api/otp_verify",
        body: {"otp": otp, "userid": userid});
    if (response.statusCode == 200) {
      print(response.body);

      return Otpmodel.fromJson(json.decode(response.body));
    } else {
      print('error ' + response.statusCode.toString());
      return Strings.somethingWentWrongError;
    }
  } on SocketException {
    return Strings.noNetworkMessage;
  } on TimeoutException {
    return Strings.poorNetworkMessage;
  } on TypeError {
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}
Future countryList() async {
  try {
  
    final response = await http.get("https://zorolegal.com/Api/get_country"
       );
    if (response.statusCode == 200) {
      print(response.body);

      return GetCountrymodel.fromJson(json.decode(response.body));
    } else {
      print('error ' + response.statusCode.toString());
      return Strings.somethingWentWrongError;
    }
  } on SocketException {
    return Strings.noNetworkMessage;
  } on TimeoutException {
    return Strings.poorNetworkMessage;
  } on TypeError {
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}

Future getStateList(String countryid) async {
  try {
  
    final response = await http.post("https://zorolegal.com/api/get_state_by_country",
    body:{
      "country_id":countryid
    }
       );
    if (response.statusCode == 200) {
      print(response.body);

      return GetStatemodel.fromJson(json.decode(response.body));
    } else {
      print('error ' + response.statusCode.toString());
      return Strings.somethingWentWrongError;
    }
  } on SocketException {
    return Strings.noNetworkMessage;
  } on TimeoutException {
    return Strings.poorNetworkMessage;
  } on TypeError {
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}

Future getCityList(String stateid) async {
  try {
  
    final response = await http.post("https://zorolegal.com/api/get_city_by_state",
    body:{
      "state_id":stateid
    }
       );
    if (response.statusCode == 200) {
      print(response.body);

      return GetCitymodel.fromJson(json.decode(response.body));
    } else {
      print('error ' + response.statusCode.toString());
      return Strings.somethingWentWrongError;
    }
  } on SocketException {
    return Strings.noNetworkMessage;
  } on TimeoutException {
    return Strings.poorNetworkMessage;
  } on TypeError {
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}




Future vendorSignup(
    String firstname,
    
    String phone,
    String country,
    String password,
    String stateId,String cityId,
    String character) async {
  try {
    print("vendorsignup");
    print(country+password+phone+firstname+character+stateId+cityId);
  
    final response = await http.post("https://zorolegal.com/Api/partnerSignUp", body: {
      "f_name": firstname,
      "password": password,
      "country_id": country,
      "role": character,
      "phone": phone,
      "state_id": stateId,
      "city_id": cityId,
    });

    print(response.body);
    var decoded = jsonDecode(response.body);

    if (decoded['staus'].toString() == 'false') {
      return VendorSignUpmodel(staus: decoded['staus'], message: decoded['message']);
    } else {
      return VendorSignUpmodel.fromJson(json.decode(response.body));
    }
  } catch (e) {}
}
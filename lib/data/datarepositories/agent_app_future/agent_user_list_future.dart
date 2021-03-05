import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/agent_app_model/agent_user_list_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/forgot_password_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future getUsersList() async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");
    final response = await http.post("https://zorolegal.com/api/users", body: {
      "country_id": country
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("getuserlist" + response.body);

      return vendorassignFromJson(response.body);
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

Future addUsers(String name, phone,country) async {
  print(name+phone);
  try {
    var storageInstance = locator<LocalStorageService>();
    
    var userId = storageInstance.getFromDisk("userId");
    final response =
        await http.post("https://zorolegal.com/api/add_user", body: {
      "country": country,
      "f_name": name,
      // "password": password,
      "phone": phone,
      "agent_id": userId
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("addusers" + response.body);

      return forgotPasswordmodelFromJson(response.body);
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


Future searchUsers(String keyword) async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");
    final response = await http.post("https://zorolegal.com/api/users", body: {
      "country_id": country,
      "keyword":keyword
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("getuserlist" + response.body);

      return vendorassignFromJson(response.body);
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

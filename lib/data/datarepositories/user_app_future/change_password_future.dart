import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:zoro_legal/data/helpers/helper.dart';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/domain/entities/user_app_model/forgot_password_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future changePassword(String oldpassword, String newpassword) async {
  var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
  try {
    print("Change Password");
    final response = await http.post("https://zorolegal.com/api/changepassword",
        body: {
          "userid": userid,
          "oldpassword": oldpassword,
          "newpassword": newpassword
        }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print(response.body);
      return ForgotPasswordmodel.fromJson(json.decode(response.body));
    } else {
      print('error ' + response.statusCode.toString());
      return Strings.somethingWentWrongError;
    }
  } on SocketException {
    return Strings.noNetworkMessage;
  } on TimeoutException {
    return Strings.poorNetworkMessage;
  } on TypeError {
    // print(response.body);
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}
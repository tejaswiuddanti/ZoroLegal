import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_orders_model.dart';
import 'package:zoro_legal/domain/entities/vendor_app_model/close_discussion_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
import 'package:http/http.dart' as http;

Future vorders() async {
  try {
    print("vorders");
    var storageInstance = locator<LocalStorageService>();
var country = storageInstance.getFromDisk("country");
  var userId = storageInstance.getFromDisk("userId");
    print(userId);
    final response =
        await http.post("https://zorolegal.com/api/get_vendor_order_list", body: {
     "country_id":country,
        "vendor_id":userId
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
     print("vorders" + response.body);

    return Getordersmodel.fromJson(json.decode(response.body));
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

Future closeDiscussion(String orderId) async {
  try {
    print("closeDiscuss");
    var storageInstance = locator<LocalStorageService>();

  var role = storageInstance.getFromDisk("role");
    print(orderId+role);
    final response =
        await http.post("https://zorolegal.com/api/vendorCloseDiscussion", body: {
     "order_id":orderId,
        "role":role
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
     print("close discussion" + response.body);

    return CloseDiscussion.fromJson(json.decode(response.body));
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
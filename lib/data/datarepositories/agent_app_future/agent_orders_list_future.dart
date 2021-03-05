import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/agent_app_model/orders_get_customer_details_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_orders_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future aorders() async {
  var storageInstance = locator<LocalStorageService>();
 var country = storageInstance.getFromDisk("country");
  var userId = storageInstance.getFromDisk("userId");
  try {
    print("Aorders");
    final response = await http.post("https://zorolegal.com/api/agent_orders",
        body: {"country_id":country,
        "agent_id":userId
        }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
  print("aorders" + response.body);

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

Future getCustomerDetails(userId) async {
 
  try {
    print("cust details");
    final response = await http.post("https://zorolegal.com/api/customer_details",
        body: {
        "user_id":userId
        }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
  print("customer details" + response.body);

      return GetCustomerDetails.fromJson(json.decode(response.body));
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get-order_details_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_order_chat_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get_orders_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/otp_verify_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future orders() async {
  var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
  print(userid);
  try {
    print("orders");
    final response = await http.post("https://zorolegal.com/api/get_order_list",
        body: {"user_id": userid});

    print("orders" + response.body);

    return Getordersmodel.fromJson(json.decode(response.body));
  } catch (e) {}
}



Future getuserorders(String orderid) async {
  print("userorder" + orderid);
  try {
    print("orders");
    final response = await http.post(
        "https://zorolegal.com/api/get_user_order_details",
        body: {"order_id": orderid});
    print("@@");
    print("getorderdetails" + response.body);

    return GetOrderDetailsModel.fromJson(json.decode(response.body));
  } catch (e) {}
}

Future getorderchat(String orderid) async {
  print(orderid);
  try {
    print("getorderchat");
    final response = await http.post("https://zorolegal.com/api/get_order_chat",
        body: {"order_id": orderid});

    print("getorderchat" + response.body);

    return GetOrderChatmodel.fromJson(json.decode(response.body));
  } catch (e) {}
}

Future saveFeedback(double feedback, String orderid) async {
  try {
    var uri = Uri.parse("https://zorolegal.com/api/rating");

    var request = http.MultipartRequest("POST", uri);
    request.fields['rate'] = feedback.toString();
    request.fields['orderid'] = orderid;
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(responseString);
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

Future sendorderchat(String orderid, String image, String message) async {
  var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
  print(userid);
  print(orderid);
  print("sendmesaage" + message);
  print(image);
  var uri = Uri.parse("https://zorolegal.com/api/send_order_Chat");

  var request = http.MultipartRequest("POST", uri);

  request.fields['order_id'] = orderid;
  request.fields['user_id'] = userid;
  request.fields['message'] = message;
  image != null
      ? request.files.add(await http.MultipartFile.fromPath("files", image))
      : request.fields['files'] = image.toString();
  // var pic = await http.MultipartFile.fromPath("files", image);

  // request.files.add(pic);
  var response = await request.send();
  print(response);
  var responseString = await response.stream.bytesToString();
  print(responseString);
  return otpmodelFromJson(responseString);
}

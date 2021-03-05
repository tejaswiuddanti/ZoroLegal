import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/wallet_payment_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';




Future walletpayment(String orderId,String transactionId,String price) async {
  var storageInstance = locator<LocalStorageService>();

    var userid = storageInstance.getFromDisk("userId");
    print(userid);
    print(price);
  try {
    print("wallet payment");
    final response = await http.post("https://zorolegal.com/api/wallet_payment", body: {
      
      "user_id":userid,
"order_id":orderId,
"transId":transactionId,
"amount":price,
"vendor_id":"null",
    }).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
    });
if (response.statusCode == 200) {
 print(response.body);
    return Walletpaymentmodel.fromJson(json.decode(response.body));
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




Future onlinepayment(String price,String orderId,String paymentId) async {
    var storageInstance = locator<LocalStorageService>();
 var name = storageInstance.getFromDisk("name");
  var email = storageInstance.getFromDisk("email");
   var mobile = storageInstance.getFromDisk("mobile");
    
    // print(name+email+mobile+orderId+paymentId);
  try {
    print("online payment");
    final response = await http.post("https://zorolegal.com/api/form_razor_payment", body: {
      
     "name":name,
"email":email,
"contact":mobile,
"payable_amount":price,
"order_id":orderId,
"razorpay_order_id":paymentId
    }).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
    });
if (response.statusCode == 200) {
 print(response.body);
    return Walletpaymentmodel.fromJson(json.decode(response.body));
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
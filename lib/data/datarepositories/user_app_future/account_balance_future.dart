import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/account_balance_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/wallet_payment_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
import 'package:http/http.dart' as http;

Future accountbalance() async {
  var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
  print(userid);
  try {
    print("Account");
    final response =
        await http.post("https://zorolegal.com/api/view_alltransaction", body: {
      "user_id": userid,
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });

    if (response.statusCode == 200) {
      print("Account" + response.body);

      return AccountBalancemodel.fromJson(json.decode(response.body));
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

Future accountwalletpayment(String transactionId, String price) async {
  var storageInstance = locator<LocalStorageService>();
  var name = storageInstance.getFromDisk("name");
  var email = storageInstance.getFromDisk("email");
  var mobile = storageInstance.getFromDisk("mobile");
  var userid = storageInstance.getFromDisk("userId");
  print(userid + price + transactionId);
  try {
    print("Account wallet payment");
    final response = await http
        .post("https://zorolegal.com/api/wallet_razor_payment", body: {
      "name": name,
      "email": email,
      "contact": mobile,
      "payable_amount": price,
      "user_id": userid,
      "razorpay_order_id": transactionId
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("hai" + response.body);
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

Future accountDetails(String walletId) async {
  var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
  print(userid + walletId);
  try {
    print("Account Details");
    final response = await http
        .post("https://zorolegal.com/api/transaction_details", body: {
      "user_id": userid,
      "id": walletId
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print(response.body);
      return AccountBalancemodel.fromJson(json.decode(response.body));
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

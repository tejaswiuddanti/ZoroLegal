import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/category_stage_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
Future searchStage1(String id,String keyword) async {
  try {
    print("stage1search");
    print(id);
     var storageInstance = locator<LocalStorageService>();
var country = storageInstance.getFromDisk("country");
    final response =
        await http.post("https://zorolegal.com/api/search_stage_1", body: {
      
      "id": id ,
      "country_id":country ,
      "keyword":keyword 
    }).timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(Strings.poorNetworkMessage);
      });
 if (response.statusCode == 200) {
    print(response.body);

    return Categorystagemodel.fromJson(json.decode(response.body));
  }else {
        print('error ' + response.statusCode.toString());
        return Strings.somethingWentWrongError;
      } }on SocketException {
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
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/home_category_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/home_image_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/home_search_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future homeimages() async {
  try {
    print("Images");
    final response = await http.get("https://zorolegal.com/api/view_slider").timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
    print(response.body);

    return Imagemodel.fromJson(json.decode(response.body));
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


Future homecategories() async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");

    // print("Images" + country);
    final response = await http.post(
        "https://zorolegal.com/api/get_maincategory",
        body: {"country_id": country}).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
    print("home" + response.body);

    return homecategorymodelFromJson(response.body);
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
Future homeSearch() async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");

    
    final response = await http.post(
        "https://zorolegal.com/api/servicesearch",
        body: {"country_id": country}).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {

    print("homesearch11" + response.body);

    return homeSearchmodelFromJson(response.body);
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


  Future getlist(String keyword) async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");
print("keyword"+keyword);
    // print("Images" + country);
    final response = await http.post(
        "https://zorolegal.com/api/servicesearch",
        body: {"country_id": country,
        "keyword":keyword
        
        }).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
  
    print("homesearchList" + response.body);

    return homeSearchmodelFromJson(response.body);
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
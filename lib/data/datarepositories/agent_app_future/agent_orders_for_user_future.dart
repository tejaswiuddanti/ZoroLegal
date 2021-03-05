import 'dart:async';
import 'dart:io';

import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/submit_form_model.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
import 'package:http/http.dart' as http;
Future submitUserForm(Map textData, Map files, String stageid, String id,user) async {
  print("submit");
  print(stageid + "   " + id);

  print(textData);

  var storageInstance = locator<LocalStorageService>();
  var userid = storageInstance.getFromDisk("userId");
  var country = storageInstance.getFromDisk("country");

  print(textData);

  print("Fieldsss");

  print("imageFile.toString()");
try{
  var uri = Uri.parse("https://zorolegal.com/api/submit_form_data");

  var request = http.MultipartRequest("POST", uri);
  request.fields['last_stage'] = stageid;
  request.fields['last_id'] = id;
  request.fields['vendor_id'] = userid;
  request.fields['user_id'] = user;
  request.fields['country_id'] = country;
  request.fields['state_id'] = "null";
  request.fields['city_id'] = "null";
  request.fields.addAll(textData);

//  var pic = await http.MultipartFile.fromPath(imageFile);
//   request.files.add(pic);

  var response = await request.send();
  var responseString = await response.stream.bytesToString();
  if (response.statusCode == 200) {
  print(responseString);
  return submitformmodelFromJson(responseString);
}else {
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




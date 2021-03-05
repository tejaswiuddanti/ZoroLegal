import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';

import 'package:zoro_legal/domain/entities/user_app_model/get_profile_model.dart';

import 'package:zoro_legal/domain/entities/user_app_model/update_profile_model.dart';
import 'package:zoro_legal/domain/entities/vendor_app_model/vendor_profile_get_categories_model.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future getprofile() async {
  try {
    print("profile");
    var storageInstance = locator<LocalStorageService>();

    var userid = storageInstance.getFromDisk("userId");
    print(userid);
    final response =
        await http.post("https://zorolegal.com/api/fetch_profile", body: {
      "user_id": userid,
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print(response.body);

      return GetProfilemodel.fromJson(json.decode(response.body));
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

Future upload(
    String imageFile, String fname, lname, email, password, mobile) async {
  var storageInstance = locator<LocalStorageService>();
  var pic;
  var userid = storageInstance.getFromDisk("userId");
  var country = storageInstance.getFromDisk("country");
  var role = storageInstance.getFromDisk("role");
  print(userid);
  print("updated");
  print(mobile);
  print(role);
  print(imageFile);
  try {
    var uri = Uri.parse("https://zorolegal.com/api/update_profile");

    var request = http.MultipartRequest("POST", uri);
    request.fields['f_name'] = fname;
    request.fields['l_name'] = lname;
    request.fields['email'] = email;
    // request.fields['phone'] = mobile;
    request.fields['password'] = password;
    request.fields['phone'] = mobile;
    request.fields['user_id'] = userid;
    request.fields['country'] = country;
    request.fields['role'] = role;
    //  pic = await http.MultipartFile.fromPath("image", imageFile);

    imageFile != null
        ? request.files
            .add(await http.MultipartFile.fromPath("image", imageFile))
        : null;
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(responseString);
      return updateprofilemodelFromJson(responseString);
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

Future updateVendorProfile(String imageFile, String fname, lname, email,
stageids,image,password, mobile, education, experience) async {
  var storageInstance = locator<LocalStorageService>();
  var pic;
  var userid = storageInstance.getFromDisk("userId");
  var country = storageInstance.getFromDisk("country");
  var role = storageInstance.getFromDisk("role");
  print(userid);
  print("updated");
  print(mobile);
  print(role);
  print(stageids);
  print('hai  ' + education + experience);
  print(image);
  try {
    var uri = Uri.parse("https://zorolegal.com/api/update_profile");

    var request = http.MultipartRequest("POST", uri);
    request.fields['f_name'] = fname;
    request.fields['l_name'] = lname;
    request.fields['email'] = email;
    request.fields['stage_2_ids'] = stageids;
    request.fields['password'] = password;
    request.fields['phone'] = mobile;
    request.fields['user_id'] = userid;
    request.fields['country'] = country;
    request.fields['role'] = role;
    request.fields['education'] = education;
    request.fields['experience'] = experience;
    imageFile != null
        ? request.files
            .add(await http.MultipartFile.fromPath("image", imageFile))
        : null;
        image != null?request.files
            .add(await http.MultipartFile.fromPath("certificates", image)):null;
    var response = await request.send();

    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print("!!!!");
      print(responseString);
      return updateprofilemodelFromJson(responseString);
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



Future getProfileCategories() async {
  try {
    var storageInstance = locator<LocalStorageService>();
    var country = storageInstance.getFromDisk("country");

    
    final response = await http.post(
        "https://zorolegal.com/api/stage_2_services",
        body: {"country_id": country}).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {

    print("getcategories1" + response.body);

    return getProfileCategoryFromJson(response.body);
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

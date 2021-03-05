import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/user_app_model/delete_document_vault_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/document_vault_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/forgot_password_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/get-search_trans_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/save_document_vault_model.dart';


import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

Future documentvault() async {
 var storageInstance = locator<LocalStorageService>();

    var userid = storageInstance.getFromDisk("userId");
    print(userid);
  try {
    print("doc");
    final response = await http.post("https://zorolegal.com/api/get_documents",
        body: {"user_id": userid,}).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
    print("doc" + response.body);

    return GetDocumentVaultmodel.fromJson(json.decode(response.body));
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

Future savedocumentvault(
   String image) async {
  var storageInstance = locator<LocalStorageService>();
  
  var userid = storageInstance.getFromDisk("userId");
 
  print(userid);
  print("savedocs");
  print(image);
 
  try {
    var uri = Uri.parse("https://zorolegal.com/api/save_document");

    var request = http.MultipartRequest("POST", uri);
   
    request.fields['user_id'] = userid;
  
   

    request.files
            .add(await http.MultipartFile.fromPath("files", image));
       
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      print(responseString);
      return saveDocumentmodelFromJson(responseString);
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




//  Future savedocumentvault(
   
//       String image) async {
//         var storageInstance = locator<LocalStorageService>();

//     var userid = storageInstance.getFromDisk("userId");
//     print(userid);
//     print("savedoc");
//     print(image);
//     try{
//     var uri = Uri.parse("https://zorolegal.com/api/save_document");
//     var request = http.MultipartRequest("POST", uri);
   
//     request.fields['user_id'] = userid;
    
//     var pic = await http.MultipartFile.fromPath("files", image);

  
//     request.files.add(pic);
//     var response = await request.send();
//     print(response);
//     var responseString = await response.stream.bytesToString();
//     if (response.statusCode == 200) {
//     print(responseString);
//     return saveDocumentmodelFromJson(responseString);
//   }else {
//         print('error ' + response.statusCode.toString());
//         return Strings.somethingWentWrongError;
//       }
//     } on SocketException {
//       return Strings.noNetworkMessage;
//     } on TimeoutException {
//       return Strings.poorNetworkMessage;
//     } on TypeError {
//       print('typeCasting went wrong');
//       return Strings.somethingWentWrongError;
//     } catch (exception) {
//       print(exception);
//       return Strings.somethingWentWrongError;
//     }
// }


Future deletedocument(String docid) async {
  
  try {
    print("docid");
    final response = await http.post("https://zorolegal.com/api/deletedocument",
        body: {"document_id": docid,}).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
    print("doc" + response.body);

    return DeleteDocumentmodel.fromJson(json.decode(response.body));
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

Future searchOrderId(String keyword) async {
   var storageInstance = locator<LocalStorageService>();
var country = storageInstance.getFromDisk("country");
  var userid = storageInstance.getFromDisk("userId");

  print(userid);
  try {
    print("search");
    final response =
        await http.post("https://zorolegal.com/Api/orderid_search", body: {
      "user_id": userid,
      "country_id":country,
      "transaction_id":keyword
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("search" + response.body);

      return SearchOrderidmodel.fromJson(json.decode(response.body));
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



Future assignOrders(String orderid,String docName) async {
   var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");
var role=storageInstance.getFromDisk("role");
  print(userid);
  try {
    print("assign");
    final response =
        await http.post("https://zorolegal.com/Api/assign_to_order", body: {
      "user_id": userid,
      "order_id":orderid,
      "file_name":docName,
     "role":role
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("assignorders" + response.body);

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
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}

Future searchImage(String keyword) async {
   var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");

  print(userid);
  try {
    print("searchimage");
    final response =
        await http.post("https://zorolegal.com/Api/image_search", body: {
      "user_id": userid,
      
      "file_name":keyword,
     
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("searchimage" + response.body);

      return GetDocumentVaultmodel.fromJson(json.decode(response.body));
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


Future editName(String docName,oldName) async {
   var storageInstance = locator<LocalStorageService>();

  var userid = storageInstance.getFromDisk("userId");

  print(userid);
  try {
    print("Edit name");
    print(docName+" "+oldName);
    final response =
        await http.post("https://zorolegal.com/api/edit_doc_name", body: {
      "user_id": userid,
      
      "doc_name":docName,
      "doc_old":oldName
     
    }).timeout(Duration(seconds: 20), onTimeout: () {
      throw TimeoutException(Strings.poorNetworkMessage);
    });
    if (response.statusCode == 200) {
      print("searchimage" + response.body);

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
    print('typeCasting went wrong');
    return Strings.somethingWentWrongError;
  } catch (exception) {
    print(exception);
    return Strings.somethingWentWrongError;
  }
}

 
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:zoro_legal/data/helpers/helper.dart';
import 'package:zoro_legal/domain/entities/agent_app_model/assign_vendors_model.dart';
import 'package:zoro_legal/domain/entities/agent_app_model/orders_get_vendors_list_model.dart';


// Future getVendorList(String orderid) async {
//   try {
//     print("get vendor" +" "+orderid);
//     final response = await http.post(
//         "https://zorolegal.com/api/get_vendor_list_by_order",
//         body: {"order_id": orderid}).timeout(Duration(seconds: 20), onTimeout: () {
//             throw TimeoutException(Strings.poorNetworkMessage);
//         });
// if (response.statusCode == 200) {

//     print("agentordervendor" + response.body);

//     return getVendorListFromJson(response.body);
//   } else {
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


  Future  assignVendor(String vendorid,orderid) async {
  try {
   final response = await http.post(
        "https://zorolegal.com/api/assign_vender_to_order",
        body: {"order_id": orderid,
        "vendor_id":vendorid
        
        }).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {
  
    print("asssignvendor" + response.body);

    return vendorassignFromJson(response.body);
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

Future getVendorList(String orderid,keyword) async {
  try {
    
    final response = await http.post(
        "https://zorolegal.com/api/get_vendor_list_by_order",
        body: {"order_id": orderid,
        "keyword":keyword
        }).timeout(Duration(seconds: 20), onTimeout: () {
            throw TimeoutException(Strings.poorNetworkMessage);
        });
if (response.statusCode == 200) {

    print("agentordervendor" + response.body);

    return getVendorListFromJson(response.body);
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

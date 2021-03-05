import 'package:flutter/material.dart';


import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'Profile.dart';
import 'account_balance.dart';

import 'document_vault.dart';

import 'home.dart';

import 'orders.dart';

class HomeDrawer extends StatelessWidget {
  static var _country = "India";
  // static var countries = [
  //   "India",
  //   // "Singapore",
  // ];
  @override
  Widget build(BuildContext context) {
    var storageInstance = locator<LocalStorageService>();
var image=storageInstance.getFromDisk("image");
print("@@@");
print(image==""?"1":"2");
    var imagelocation = image==""?"https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png":image;
  print("!!!!");
  print(imagelocation);
    var name = storageInstance.getFromDisk("name");
     var country = storageInstance.getFromDisk("country");
    return Drawer(
        child: Container(
      color: MyColor.appcolor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:50),
              height: 150,
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          // (imagelocation == "")
                          //   ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                             imagelocation),
                      ),
                      Text(_country,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17))
                    ],
                  ),
                  Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize:17),
                    )
                ],
              )
              ),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                    },
                    child: customListTile(Icons.home, "HOME")),
                // Divider(
                //   color: Colors.white,
                // ),
                
                Divider(
                  color: Colors.white,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Orders()));
                    },
                    child: customListTile(Icons.shopping_cart, "ORDERS")),
                Divider(
                  color: Colors.white,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountBalance()));
                    },
                    child: customListTile(
                        Icons.account_balance_wallet, "ACCOUNT BALANCE")),
                Divider(
                  color: Colors.white,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocumentVault()));
                    },
                    child: customListTile(Icons.filter, "DOCUMENT VAULT")),
                    
                Divider(
                  color: Colors.white,
                ),
                InkWell(
                    child: customListTile(Icons.person, "PROFILE"),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    }),
                     Divider(
                  color: Colors.white,
                ),
//                 InkWell(
//                     onTap: () async {
//  Navigator.of(context).pop();
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => ChangePassword()));
//                     },
//                     child: customListTile(Icons.visibility, "CHANGE PASSWORD")),
//                 Divider(
//                   color: Colors.white,
//                 ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget customListTile(icon, title) {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoro_legal/app/pages/user_app/Profile.dart';
import 'package:zoro_legal/app/pages/user_app/account_balance.dart';
import 'package:zoro_legal/app/pages/user_app/document_vault.dart';
import 'package:zoro_legal/app/pages/user_app/orders.dart';
import 'package:zoro_legal/app/pages/vendor_app/vendor_home.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

class VendorDrawer extends StatelessWidget {
  static var _country = "India";
  // static var countries = [
  //   "India",
  //   // "Singapore",
  // ];
  @override
  Widget build(BuildContext context) {
    var storageInstance = locator<LocalStorageService>();
    var image = storageInstance.getFromDisk("image");
    var imagelocation = image == ""
        ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
        : image;
    var name = storageInstance.getFromDisk("name");
    return Drawer(
        child: Container(
      color: MyColor.appcolor,
      child: Column(
        children: [
          Container(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(imagelocation),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(_country,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              children: [
                InkWell(
                    onTap: () { Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => VendorHomePage()),(Route<dynamic> route)=>false);},
                    child: customListTile(Icons.home, "DASHBOARD")),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Orders()));
                    },
                    child: customListTile(Icons.shopping_cart, "MY ORDER")),
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
                    Divider( color: Colors.white,)
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

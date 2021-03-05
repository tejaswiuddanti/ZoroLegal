import 'package:flutter/material.dart';
import 'package:zoro_legal/app/pages/Agent_app/Agent_home.dart';
import 'dart:async';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'app/pages/user_app/home.dart';
import 'app/pages/user_app/login.dart';
import 'app/pages/vendor_app/vendor_home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future future;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    var storageInstance = locator<LocalStorageService>();
    var login = storageInstance.getFromDisk("login_status");
    var role = storageInstance.getFromDisk("role");
    print(login);
    if (login == "true") {
      role == "U"
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false)
          : role == "A"
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AgentHomePage()),
                  (Route<dynamic> route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => VendorHomePage()),
                  (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      //this is the main container having decoration and and inside decoartion are having image on background
      decoration: new BoxDecoration(
        color: Colors.white,
        image: new DecorationImage(
          image: new AssetImage('assets/Splash screen.png'),
        ),
      ),
    );
  }
}

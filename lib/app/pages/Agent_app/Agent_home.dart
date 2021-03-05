import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoro_legal/app/pages/Agent_app/Agent_drawer.dart';
import 'package:zoro_legal/app/pages/user_app/login.dart';

import 'package:zoro_legal/data/helpers/colors.dart';

class AgentHomePage extends StatefulWidget {
  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  TextEditingController _password = TextEditingController();
  bool flag = true;
  var icon = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AgentDrawer(),
        appBar: AppBar(
          backgroundColor: MyColor.appcolor,
          centerTitle: true,
          title: Text("Agent"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(60),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CupertinoButton(
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  } else {
                    print("no-conn");

                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please check your Internet Connection"),
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.all(10),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                },
              ),
            ),
          ],
        ),
        body:
            /*Container(
        height: MediaQuery.of(context).size.height / 2,
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),*/
            Container());
  }
}

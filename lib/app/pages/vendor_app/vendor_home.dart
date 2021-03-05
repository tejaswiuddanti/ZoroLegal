import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoro_legal/app/pages/user_app/login.dart';
import 'package:zoro_legal/app/pages/vendor_app/chartModel.dart';
import 'package:zoro_legal/app/pages/vendor_app/vendor_drawer.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VendorHomePage extends StatefulWidget {
  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  TextEditingController _password = TextEditingController();
  bool flag = true;
  var icon = Icon(Icons.visibility_off);
  final List<chartModal> data = [
    chartModal(month: "Jan", orders: 20),
    chartModal(month: "Feb", orders: 10),
    chartModal(month: "Mar", orders: 10),
    chartModal(month: "Apr", orders: 10),
    chartModal(month: "May", orders: 10),
    chartModal(month: "Jun", orders: 10),
    chartModal(month: "Jul", orders: 10),
    chartModal(month: "Aug", orders: 10),
    chartModal(month: "Sep", orders: 10),
    chartModal(month: "Oct", orders: 10),
    chartModal(month: "Nov", orders: 10),
    chartModal(month: "Dec", orders: 10),
  ];
  @override
  Widget build(BuildContext context) {
    List<charts.Series<chartModal, String>> series = [
      charts.Series(
        id: "12",
        data: data,
        domainFn: (chartModal series, _) => series.month,
        measureFn: (chartModal series, _) => series.orders,
      )
    ];
    return Scaffold(
      drawer: VendorDrawer(),
      appBar: AppBar(
        backgroundColor: MyColor.appcolor,
        centerTitle: true,
        title: Text("Dashboard"),
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
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }
}

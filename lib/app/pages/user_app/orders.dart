import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/Agent_app/Agent_home.dart';
import 'package:zoro_legal/data/datarepositories/agent_app_future/agent_orders_list_future.dart';
import 'package:zoro_legal/data/datarepositories/agent_app_future/orders_get_vendors_list_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/orders_future.dart';
import 'package:zoro_legal/data/datarepositories/vendor_app_future/vendor_orders_list_future.dart';

import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
import 'get_user_order_details.dart';

class Orders extends StatefulWidget {
  static const routeName = '/orders';
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future future;
  var _vendorList;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var searchvendorList;
  @override
  void initState() {
    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    print("role" + role);
    future = role == "A"
        ? aorders()
        : role == "U"
            ? orders()
            : vorders();
    super.initState();
  }

  Future _refresh(role) async {
    setState(() {
     future = role == "A"
        ? aorders()
        : role == "U"
            ? orders()
            : vorders();
    });
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    print("role" + role);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.appcolor,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 35),
            child: Text("My Orders"),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => _refresh(role),
          child: Container(
            child: FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return retryWiget(role);

                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());

                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return retryWiget(role);
                    } else if (snapshot.data is String) {
                      return Center(child: Text("${snapshot.data}"));
                      // }else if (snapshot.data==null) {
                      //   return Center(child: Text("No Data"));
                    }
                    // print("@@");

                    var orders = snapshot.data.data;
                    print(orders.length);
                    return orders.length <= 0
                        ? Container()
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () async {
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GetUserorderDetails(
                                                    orderid: orders[index]
                                                        .orderId)));
                                  } else {
                                    print("no-conn");

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Please check your Internet Connection"),
                                      duration: Duration(seconds: 3),
                                      margin: EdgeInsets.all(10),
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  }
                                },
                                child: Card(
                                  elevation: 5,
                                  shadowColor: orders[index].paymentStatus ==
                                          "Payment Failed"
                                      ? _colorfromhex("#D14040")
                                      : orders[index].paymentStatus ==
                                              "Payment Successfull"
                                          ? _colorfromhex("#17BB00")
                                          : _colorfromhex("#FEBA00"),
                                  margin: EdgeInsets.only(
                                      left: size * 0.0483091787439614,
                                      right: size * 0.0483091787439614,
                                      top: 20),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: size * 0.0483091787439614,
                                        top: 8,
                                        bottom: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: index == 0 ? 5 : 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: index == 0 ? 5 : 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: Text(
                                                '${orders[index].formName}',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    color: _colorfromhex(
                                                        "#474747")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Date',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: Text(
                                                '${orders[index].paymentDate}',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    color: _colorfromhex(
                                                        "#474747")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: Text(
                                                '${orders[index].orderStatus}',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    fontWeight: FontWeight.bold,
                                                    color: orders[index]
                                                                .orderStatus ==
                                                            "pending"
                                                        ? _colorfromhex(
                                                            "#FEBA00")
                                                        : orders[index]
                                                                    .orderStatus ==
                                                                "success"
                                                            ? Colors.green
                                                            : _colorfromhex(
                                                                "#D14040")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Amount',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: Text(
                                                '${orders[index].price}',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    color: _colorfromhex(
                                                        "#474747")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Payment',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: Text(
                                                orders[index].paymentStatus ==
                                                        "Payment Failed"
                                                    ? 'Failed'
                                                    : orders[index]
                                                                .paymentStatus ==
                                                            "Payment Successfull"
                                                        ? 'Success'
                                                        : 'Pending',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    fontWeight: FontWeight.bold,
                                                    color: orders[index]
                                                                .paymentStatus ==
                                                            "Payment Failed"
                                                        ? _colorfromhex(
                                                            "#D14040")
                                                        : orders[index]
                                                                    .paymentStatus ==
                                                                "Payment Successfull"
                                                            ? _colorfromhex(
                                                                "#17BB00")
                                                            : _colorfromhex(
                                                                "#FEBA00")),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: size * 0.2884541062801932,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Order Id',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                  Text(
                                                    ':    ',
                                                    style: TextStyle(
                                                        fontSize: size *
                                                            0.038231884057971,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747")),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 12),
                                              width: (size *
                                                      0.6449275362318841) -
                                                  (size * 0.0483091787439614) -
                                                  20,
                                              child: orders[index]
                                                          .paymentTransactionId
                                                          .length >
                                                      20
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${orders[index].paymentTransactionId.substring(0, 20)}',
                                                          style: TextStyle(
                                                              fontSize: size *
                                                                  0.038231884057971,
                                                              color:
                                                                  _colorfromhex(
                                                                      "#474747")),
                                                        ),
                                                        Text(
                                                          '${orders[index].paymentTransactionId.substring(20, orders[index].paymentTransactionId.length - 1)}',
                                                          style: TextStyle(
                                                              fontSize: size *
                                                                  0.038231884057971,
                                                              color:
                                                                  _colorfromhex(
                                                                      "#474747")),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      '${orders[index].paymentTransactionId}',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          color: _colorfromhex(
                                                              "#474747")),
                                                    ),
                                            ),
                                          ],
                                        ),
                                        role == "A"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: size / 6),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          getCustomerDetails(orders[index]
                                                                .userId)
                                                              .then((response) {
                                                            if (response
                                                                    .staus ==
                                                                "1") {
                                                                  print(response.details[0].resId);
                                                                  var details=response.details[0];
                                                                  return showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return StatefulBuilder(
                                                                    builder: (context,
                                                                        StateSetter
                                                                            setState) {
                                                                  return Dialog(
                                                                     
                                                                      child: Container(
                                                                          height: MediaQuery.of(context).size.height / 3,
                                                                          child: Column(
                                                                            children: [
                                                                              Container(
                                                                                
                                                                                  width: size - 100,
                                                                                  margin: EdgeInsets.all(10),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(10.0),
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      "Customer Profile",
                                                                                      style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: Colors.white),
                                                                                    )),
                                                                                  ),
                                                                                  decoration: BoxDecoration(color: MyColor.appcolor, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(30))),
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: size * 0.2884541062801932,
                                                                                    margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "User Name",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                        Text(
                                                                                          ":",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                      margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                      child: Text(
                                                                                        "${details.fName}",
                                                                                        style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: size * 0.2884541062801932,
                                                                                    margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "User mobile",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                        Text(
                                                                                          ":",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                      margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                      child: Text(
                                                                                        "${details.phone}",
                                                                                        style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    width: size * 0.2884541062801932,
                                                                                    margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "User Email",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                        Text(
                                                                                          ":",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                        margin: EdgeInsets.only(top: 20, left: 20, right: 12),
                                                                                        child: Text(
                                                                                          "${details.email}",
                                                                                          style: TextStyle(fontSize: size * 0.038231884057971, fontWeight: FontWeight.bold, color: _colorfromhex("#474747")),
                                                                                        )),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )));
                                                                });
                                                              });
                                                            } else {
                                                              Toast.show(
                                                                  "No Details",
                                                                  context,
                                                                  gravity: Toast
                                                                      .CENTER);
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            "Customer Details",
                                                            style: TextStyle(
                                                                fontSize: size *
                                                                    0.035231884057971,
                                                                color: MyColor
                                                                    .appcolor),
                                                          ),
                                                        ),
                                                      ),
                                                      orders[index]
                                                                  .vendorName !=
                                                              null
                                                          ? Container(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      orders[index]
                                                                          .vendorName,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  MaterialButton(
                                                                    height: 30,
                                                                    minWidth:
                                                                        20,
                                                                    color: MyColor
                                                                        .appcolor,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    onPressed:
                                                                        () {
                                                                      getVendorList(orders[index]
                                                                              .orderId,"")
                                                                          .then(
                                                                              (response) {
                                                                        if (response.error ==
                                                                            false) {
                                                                          _vendorList =
                                                                              response.data;
                                                                          return buildShowDialog(
                                                                              context,
                                                                              orders[index].orderId,
                                                                              future);
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      "Reassign",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : MaterialButton(
                                                              height: 30,
                                                              minWidth: 20,
                                                              color: MyColor
                                                                  .appcolor,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              onPressed: () {
                                                                getVendorList(orders[
                                                                            index]
                                                                        .orderId,"")
                                                                    .then(
                                                                        (response) {
                                                                  if (response
                                                                          .error ==
                                                                      false) {
                                                                    _vendorList =
                                                                        response
                                                                            .data;
                                                                    return buildShowDialog(
                                                                        context,
                                                                        orders[index]
                                                                            .orderId,
                                                                        future);
                                                                  }
                                                                });
                                                              },
                                                              child: Text(
                                                                "Assign",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });

                  default:
                    return Text("error");
                }
              },
            ),
          ),
        ));
  }

  Center retryWiget(role) {
    return Center(
        child: Column(
      children: <Widget>[
        Text('Something Went Wrong Try Again'),
        RaisedButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.refresh),
              Text('Retry'),
            ],
          ),
          onPressed: () {
            setState(() {
          future = role == "A"
        ? aorders()
        : role == "U"
            ? orders()
            : vorders();
            });
          },
        )
      ],
    ));
  }

  Future buildShowDialog(BuildContext context, orderId, Future future) {
    return showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _controller = new TextEditingController();
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                elevation: 16,
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: MyColor.appcolor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(child: Text("Assign Vendor")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18, right: 18, bottom: 10),
                      child: Container(
                        height: 50,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.white)),
                              hintText: "Search....",
                              suffixIcon: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Color(0xFF53549D),
                                  child: Icon(Icons.search))),
                          controller: _controller,
                          onChanged: (String value) {
                            print(orderId + " " + value);
                            getVendorList(orderId, value).then((response) {
                              setState(() {
                                searchvendorList = response.data;
                              });
                              print(searchvendorList);
                            });
                          },
                          onFieldSubmitted: (String value) {
                            getVendorList(orderId, value).then((response) {
                              setState(() {
                                searchvendorList = response.data;
                              });
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: (_controller.text.isEmpty)
                          ? ListView.builder(
                              itemCount: _vendorList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AssignList(
                                  translist: _vendorList[index],
                                  orderid: orderId,
                                  future: future,
                                );
                              },
                            )
                          : searchvendorList.isEmpty
                              ? Text(
                                  "No Data",
                                  style: TextStyle(fontSize: 15),
                                )
                              : ListView.builder(
                                  itemCount: searchvendorList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AssignList(
                                      translist: searchvendorList[index],
                                      orderid: orderId,
                                      future: future,
                                    );
                                  },
                                ),
                    )),
                  ],
                )));
          });
        });
  }
}

class AssignList extends StatefulWidget {
  AssignList({this.translist, this.orderid, this.future});
  final translist;
  final orderid;
  Future future;
  @override
  _AssignListState createState() => _AssignListState();
}

class _AssignListState extends State<AssignList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        print(widget.translist.vendorId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
                  new Text("Do you want to assign this order to this vendor"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    // print(widget.translist.orderId);

                    assignVendor(widget.translist.vendorId, widget.orderid)
                        .then((response) {
                      if (response.error == false) {
                        print("@@!!");
                        Toast.show(response.message, context,
                            gravity: Toast.CENTER);
                        // setState(() {
                        //                widget.future=aorders();
                        //                       });
                        Navigator.of(context).pop();
                        //
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AgentHomePage()),
                            (Route<dynamic> route) => false);
                      } else {
                        Toast.show(response.message, context,
                            gravity: Toast.CENTER);

                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vendor Name",
                                ),
                                Text(
                                  " :",
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Text("${widget.translist.vendorName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Vendor Email",
                                ),
                                Text(
                                  " :",
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Text("${widget.translist.vendorEmail}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.blue,
                )
              ],
            )),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

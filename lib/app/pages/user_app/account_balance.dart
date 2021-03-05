import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/account_balance_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'account_balance_details.dart';
import 'home.dart';

class AccountBalance extends StatefulWidget {
  static const routeName = '/accountBalance';
  @override
  _AccountBalanceState createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalance> {
  Future future;
  var totalamount;
  var _formkey = GlobalKey<FormState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController addamount = TextEditingController();
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    future = accountbalance();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future _refresh() async {
    setState(() {
      future = accountbalance();
    });
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    var size = MediaQuery.of(context).size.width;
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
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 60),
            child: Text("Account Balance"),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return retryWiget();

                case ConnectionState.active:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());

                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return retryWiget();
                  } else if (snapshot.data is String) {
                    return Center(child: Text("${snapshot.data}"));
                  }
                  // print(snapshot.data.walletdata[0].walletId);
                  var balance = snapshot.data;
                  print(balance);
                  // print(balance.currentAmount);
                  var account = snapshot.data.walletdata;
                  return Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(
                              left: size * 0.0857487922705314,
                              right: size * 0.0857487922705314,
                              top: 25,
                              bottom: 25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _colorfromhex("#FFFFFF"),
                                _colorfromhex("#B2E5F5")
                              ],
                              tileMode: TileMode.repeated,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Balance',
                                    style: TextStyle(
                                      color: _colorfromhex("#474747"),
                                      fontSize: size * 0.0483091787439614,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  balance.currentAmount == null
                                      ? Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text: '${balance.currency}'),
                                              TextSpan(
                                                text: '0',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${balance.currency} ',
                                                style: TextStyle(
                                                  color:
                                                      _colorfromhex("#474747"),
                                                  fontSize:
                                                      size * 0.032231884057971,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${balance.currentAmount}',
                                                style: TextStyle(
                                                  color:
                                                      _colorfromhex("#474747"),
                                                  fontSize:
                                                      size * 0.044231884057971,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                              Image.asset(
                                'assets/app_icon1.png',
                                width: size * 0.13,
                              )
                            ],
                          ),
                        ),
                     role=="U"?   Card(
                          elevation: 5,
                          margin: EdgeInsets.only(
                            bottom: 15,
                            left: size * 0.0857487922705314,
                          ),
                          child: GestureDetector(
                            onTap: () => _showDialog(balance.currency),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: _colorfromhex("#474747"),
                                  fontSize: size * 0.046231884057971,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ):Container(),
                        Container(
                          padding: EdgeInsets.only(
                            left: size * 0.0657487922705314,
                            right: size * 0.0657487922705314,
                          ),
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width:
                                    (size - (size * 0.0857487922705314) - 10) /
                                        2,
                                child: Text('Transactions',
                                    style: TextStyle(
                                        fontSize: size * 0.0434782608695652,
                                        fontWeight: FontWeight.bold,
                                        color: _colorfromhex("#474747"))),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(left: 10, right: 15),
                                width:
                                    (size - (size * 0.0857487922705314) - 90) /
                                        2,
                                child: Text("Ac / wallet",
                                    style: TextStyle(
                                        fontSize: size * 0.0434782608695652,
                                        fontWeight: FontWeight.bold,
                                        color: _colorfromhex("#474747"))),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(
                                left: size * 0.0657487922705314,
                                right: size * 0.0657487922705314,
                              ),
                              child: ListView.builder(
                                itemCount: account.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: (size -
                                                        (size *
                                                            0.0857487922705314) -
                                                        10) /
                                                    2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      account[index]
                                                                  .paymentMethod !=
                                                              null
                                                          ? '${account[index]
                                                                  .paymentMethod}'
                                                          : "online",
                                                      style: TextStyle(
                                                        fontSize: size *
                                                            0.0454782608695652,
                                                        fontWeight: FontWeight.bold,
                                                        color: _colorfromhex(
                                                            "#474747"),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${account[index].date}',
                                                      style: TextStyle(
                                                        fontSize: size *
                                                            0.0394782608695652,
                                                       
                                                        color: _colorfromhex(
                                                            "#474747"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: (size -
                                                        (size *
                                                            0.0857487922705314) -
                                                        80) /
                                                    2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    account[index]
                                                                .transactionType ==
                                                            "credit"
                                                            ?Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${balance.currency}  ',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                  fontSize:
                                                      size * 0.032231884057971,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "+" +
                                                                "${account[index].ammount}",
                                                            style: TextStyle(
                                                              color: Colors.green,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: size *
                                                                  0.0394782608695652,
                                                ),
                                              ),
                                            ],
                                          ))

:Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${balance.currency}  ',
                                                style: TextStyle(
                                                 color:
                                                                  Colors.redAccent,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                  fontSize:
                                                      size * 0.032231884057971,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                   "-" +
                                                                "${account[index].ammount}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.redAccent,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: size *
                                                                  0.0394782608695652,
                                                ),
                                              ),
                                            ],
                                          )),

                                                       
                                                        // : Text(
                                                        //     "-" +
                                                        //         "${account[index].ammount}",
                                                        //     style: TextStyle(
                                                        //       color:
                                                        //           Colors.redAccent,
                                                        //       fontWeight:
                                                        //           FontWeight.bold,
                                                        //       fontSize: size *
                                                        //           0.0394782608695652,
                                                        //     ),
                                                        //   ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AccountBalanceDetails(
                                                                        walletData:
                                                                            account[
                                                                                index],currency:balance.currency)));
                                                      },
                                                      child: Icon(
                                                        Icons.keyboard_arrow_right,
                                                        color: Colors.black
                                                            .withOpacity(0.75),
                                                        size: 40,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                      Divider(thickness:1)
                                    ],
                                  );

                                  //
                                },
                              )),
                        ),
                        
                      // SizedBox(height: 19,)
                      ],
                    ),
                  );
                default:
                  return Text("error");
              }
            },
          ),
        ));
  }

  Center retryWiget() {
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
              future = accountbalance();
            });
          },
        )
      ],
    ));
  }

  _showDialog(currency) async {
    await showDialog<String>(
      // barrierDismissible: false,
      context: context,
      child: Form(
        key: _formkey,
        child: Container(
          child: AlertDialog(
            contentPadding: EdgeInsets.all(16.0),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixText: currency + " ",
                        prefixStyle: TextStyle(fontSize: 12),
                        labelText: 'Enter the Amount',
                      ),
                      keyboardType: TextInputType.number,
                      controller: addamount,
                      autofocus: true,
                      validator: (addamount) {
                        print(addamount);
                        if (addamount.isEmpty) {
                          return 'Enter Amount';
                        }

                        return null;
                      },
                    ),
                  )
                ],
              );
            }),
            actions: <Widget>[
              FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Pay'),
                  onPressed: () async {
                    print(addamount.text);

                    if (_formkey.currentState.validate()) {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        setState(() {
                          totalamount = num.parse(addamount.text);

                          openCheckout();
                        });
                      } else {
                        print("no-conn");

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Please check your Internet Connection"),
                          duration: Duration(seconds: 3),
                          margin: EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void openCheckout() async {
    addamount.clear();
    Navigator.pop(context);
    print(totalamount * 100);
    var storageInstance = locator<LocalStorageService>();
    var email = storageInstance.getFromDisk("email");
    var mobile = storageInstance.getFromDisk("mobile");
    var options = {
      'key': 'rzp_live_NKpLCjgq5Vd7gW',
      'amount': totalamount * 100,
      'description': 'Zoro Legal',
      'image': 'https://zorolegal.com/resources/img/logo04.png',
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);

    Toast.show("SUCCESS: +${response.paymentId}", context);
    print(response);
    accountwalletpayment(response.paymentId, totalamount.toString())
        .then((response) => {
              print(response),
              if (response.success.toString() == "1")
                {
                  Toast.show("Payment Sucessfully", context),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false)
                }
              else
                {
                  Toast.show("Payment Failed", context),
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (Route<dynamic> route) => false)
                }
            });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast.show("ERROR: +${response.code.toString() + " - " + response.message}",
        context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Toast.show("EXTERNAL_WALLET: + ${response.walletName}", context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }
}


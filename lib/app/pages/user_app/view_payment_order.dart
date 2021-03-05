import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/Agent_app/Agent_home.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/payment_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';
import 'home.dart';


class ViewPaymentOrder extends StatefulWidget {
  
  final String serviceName,
      orderId,
      transactionId,
      walletBalance,
      price,
      country;
  ViewPaymentOrder(this.serviceName, this.orderId, this.transactionId,
      this.walletBalance, this.price, this.country);
      static const routeName = '/viewpaymentOrder';
  @override
  _ViewPaymentOrderState createState() => _ViewPaymentOrderState();
}

class _ViewPaymentOrderState extends State<ViewPaymentOrder> {
  var payments = [
    "Online Payment",
    "Wallet Payment",
  ];
  var _paymenttype;
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
   
    print(widget.transactionId);
    print("@@@@@" + widget.price);
    var size=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:MyColor.appcolor,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:Container(
          
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 35),
          child: Text("Payment")),
      ),
      body: Container(
          margin: const EdgeInsets.fromLTRB(10, 55, 10, 40),
          child: Center(
            child: Card(
                elevation: 5,
                child: ListView(
                  children: [
                    ListTile(
                      title: Center(
                          child: Text("Confirm Order",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      tileColor: Colors.black26,
                    ),
                    ListTile(
                      title: Text("Service name      :  ${widget.serviceName} "),
                    ),
                    ListTile(
                      title: Text("Country                :  ${widget.country} "),
                    ),
                    ListTile(
                      title: Text("Payable Amount :  ${widget.price}"),
                    ),
                    ListTile(
                      title: Center(
                          child: Text("Payment Option",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      tileColor: Colors.black26,
                    ),
                    ListTile(
                      title: Center(
                          child: Text(
                              "Wallet Balance :   ${widget.walletBalance} ")),
                    ),
                    ListTile(
                      title: Column(mainAxisAlignment: MainAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 200,
                              child: ListView(
                                children: payments.map((paymentname) {
                                  return RadioListTile(
                                      title: Text(paymentname),
                                      value: paymentname,
                                      groupValue: _paymenttype,
                                      onChanged: (payment) {
                                        setState(() {
                                          _paymenttype = payment;
                                        });
                                      });
                                }).toList(),
                              ),
                            ),
                          ]),
                    ),
                    Center(
                        child: MaterialButton(
                      minWidth: 150,
                      color: MyColor.appcolor,
                      child: Text("Pay Now",style:TextStyle(color: Colors.white)),
                      onPressed: () async{


                        print(_paymenttype);
                        if (_paymenttype != null) {


                        var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {  
                          if (_paymenttype == "Online Payment") {
                            openCheckout(widget.price);
                          } else {
                       
if(int.parse(widget.walletBalance)>double.parse(widget.price).toInt()){
                           
                            walletpayment(widget.orderId, widget.transactionId,
                                    widget.price)
                                .then((response) => {
                                      if (response.success.toString() == "1")
                                        {
                                          Toast.show(
                                              "Payment Sucessfully", context),
                                             
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false)
                                        }
                                      else
                                        {
                                          Toast.show("Payment Failed", context),
                                        Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false)
                                        }
                                    });
}
else{
Toast.show("Insufficient Balance",context);

                                               Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false);
}
                          }}
                          else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
             margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
          }
                        } else {
                          Toast.show("select payment Type", context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ))
                  ],
                )),
          )),
    );
  }

  void openCheckout(String price) async {
    print("122334");
    print(num.parse(price));

    var storageInstance = locator<LocalStorageService>();
    var email = storageInstance.getFromDisk("email");
    var mobile = storageInstance.getFromDisk("mobile");
    var options = {
      'key': 'rzp_live_NKpLCjgq5Vd7gW',
      'amount':num.parse(price)*100,
      // 'name': 'Acme Corp.',
      'description': 'Zoro Legal',
      'image':
          'https://zorolegal.com/resources/img/logo04.png',
      
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      print("^^^^^pp"+mobile);
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);
   
    print(response.orderId);
    Toast.show("SUCCESS: +${response.paymentId}", context);
    print(response);
   
    onlinepayment(widget.price, widget.orderId, response.paymentId)
        .then((response) => {
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
    
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }
}

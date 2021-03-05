import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:toast/toast.dart';

import 'package:zoro_legal/app/widgets/clip_path.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/sign_up_future.dart';

import 'package:zoro_legal/data/helpers/colors.dart';

import 'login.dart';

class Otp extends StatefulWidget {
  static const routeName = '/otp';
  @override
  OtpState createState() => OtpState();
}

class OtpState extends State<Otp> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: MyColor.appcolor),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (BuildContext context) {
          return Stack(children: [
            clipPath(context,"OTP","Please enter otp"),
             clipimage(),
            Container(
              margin: EdgeInsets.only(top: 280),
              child: SingleChildScrollView(
                child: Column(
                
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Verification Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          child: Text(
                              "Please type the verification code sent to registered mobile number",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(20.0),
                      child: PinPut(
                          fieldsCount: 4,
                          onSubmit: (String pin) => otpverify(pin).then((response){
                            if(response.status==1){
                              Toast.show("Register Sucessfully",context,gravity:Toast.BOTTOM);
                               Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => Login()),(Route<dynamic> route) => false);
                            }
                            else{
                              Toast.show("Enter a valid otp",context);
                            }
                          }),
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          submittedFieldDecoration: _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.green)),
                          selectedFieldDecoration: _pinPutDecoration,
                          followingFieldDecoration: _pinPutDecoration
                      )
                    ),
                    
                  ],
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

}
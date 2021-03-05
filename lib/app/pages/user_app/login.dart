import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/Agent_app/Agent_home.dart';

import 'package:zoro_legal/app/pages/user_app/home.dart';
import 'package:zoro_legal/app/pages/user_app/sign_up.dart';
import 'package:zoro_legal/app/pages/vendor_app/vendor_home.dart';
import 'package:zoro_legal/app/widgets/clip_path.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/login_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var storageInstance;
  var _formkey = GlobalKey<FormState>();
  bool flag = true;
  bool _isLoading = true;
  var country;
  bool _isswitched = false;
  var icon = Icon(Icons.visibility_off);
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (BuildContext context) {
        return Stack(children: [
          clipPath(context, "Login", "Please login to using app"),
          clipimage(),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Form(
                key: _formkey,
                child: Container(
                    margin: EdgeInsets.only(top: 300, left: 10, right: 10),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 55, right: 55),
                            alignment: Alignment.center,
                            child: Material(
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.black54,
                                    hintColor: Colors.black),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  controller: _phone,
                                  validator: (_phone) {
                                    if (_phone.isEmpty) {
                                      return "Enter Mobile Number";
                                    }
                                    if (10 > _phone.length) {
                                      return 'Mobile number must have 10 digits';
                                    }
                                    String patttern =
                                        r'(^(?:[+,0,4&6-9])[0-9]*$)';

                                    RegExp regExp = new RegExp(patttern);

                                    if (!regExp.hasMatch(_phone.toString())) {
                                      return 'Please enter valid number';
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: buildInputDecoration(
                                      "Mobile Number", "9999999999"),
                                ),
                              ),
                            )),
                        Container(
                            margin:
                                EdgeInsets.only(left: 55, right: 55, top: 10),
                            alignment: Alignment.center,
                            child: Material(
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.black54,
                                    hintColor: Colors.black),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _password,
                                  validator: (_password) {
                                    if (_password.isEmpty) {
                                      return "Enter Password";
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  obscureText: flag,
                                  decoration:
                                      buildInputDecoration("Password", "abc123")
                                          .copyWith(
                                    suffixIcon: IconButton(
                                      icon: icon,
                                      onPressed: () {
                                        if (flag == true) {
                                          setState(() {
                                            flag = false;
                                            icon = Icon(Icons.visibility);
                                          });
                                        } else {
                                          setState(() {
                                            flag = true;
                                            icon = Icon(Icons.visibility_off);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 40, bottom: 20),
                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          // Row(
                          //   children: [
                          //     Switch(
                          //       value: _isswitched,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           _isswitched = value;
                          //         });
                          //       },
                          //     ),
                          //     Text("Remember me")
                          //   ],
                          // ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          // child: MaterialButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   ForgotPassword()));
                          //     },
                          //     child: Text("Forgot password ?")),
                          //   ],
                          // ),
                        ),
                        _isLoading
                            ? Container(
                                child: MaterialButton(
                                  minWidth: 100,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  color: MyColor.appcolor,
                                  child: Text("Login",
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    // print(_phone.text);
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());

                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        login(_phone.text, _password.text)
                                            .then((response) {
                                          if (response.staus == "true") {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            // print(response.data[0].image);

                                            storageInstance =
                                                locator<LocalStorageService>();
                                            storageInstance.saveStringToDisk(
                                                "userId",
                                                response.data[0].resId);
                                            storageInstance.saveStringToDisk(
                                                "name", response.data[0].fName);
                                            storageInstance.saveStringToDisk(
                                                "email",
                                                response.data[0].email);
                                            storageInstance.saveStringToDisk(
                                                "mobile",
                                                response.data[0].phone);
                                            storageInstance.saveStringToDisk(
                                                "country",
                                                response.data[0].country);
                                            storageInstance.saveStringToDisk(
                                                "image",
                                                response.data[0].image);

                                            // if (_isswitched == true) {
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //   content:
                                            //       Text("Logged in sucessfully"),
                                            //   duration: Duration(seconds: 1),
                                            //   margin: EdgeInsets.all(10),
                                            //   behavior:
                                            //       SnackBarBehavior.floating,
                                            // ));
                                            Toast.show("logged in sucessfully ",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.CENTER);

                                            storageInstance =
                                                locator<LocalStorageService>();
                                            storageInstance.saveStringToDisk(
                                                "login_status", response.staus);
                                            storageInstance.saveStringToDisk(
                                                "role", response.data[0].role);

                                            print(response.data[0].role +
                                                " @@@@");
                                            response.data[0].role == "U"
                                                ? Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage()),
                                                    (Route<dynamic> route) =>
                                                        false)
                                                : response.data[0].role == "A"
                                                    ? Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AgentHomePage()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false)
                                                    : Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                VendorHomePage()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                            // Navigator.pushAndRemoveUntil(
                                            // context,
                                            // MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         VendorHomePage()),
                                            // (Route<dynamic> route) =>
                                            //     false);
                                            // } else {
                                            //   Toast.show("logged in ", context,
                                            //       duration: Toast.LENGTH_LONG);
                                            //   Navigator.pushAndRemoveUntil(
                                            //       context,
                                            //       MaterialPageRoute(builder: (context) => HomePage()),
                                            //       (Route<dynamic> route) => false);
                                            // }
                                          } else {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //   content: Text(response.message),
                                            //   duration: Duration(seconds: 3),
                                            //   margin: EdgeInsets.all(10),
                                            //   behavior:
                                            //       SnackBarBehavior.floating,
                                            // ));
                                            Toast.show(
                                                response.message, context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.CENTER);
                                          }
                                        });
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
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                    }
                                  },
                                ),
                              )
                            : CircularProgressIndicator(),
                        Container(
                            margin: EdgeInsets.only(bottom: 60, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                 "Do not have Account?   ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          color: MyColor.appcolor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ))
                      ],
                    ))),
              ),
            ),
          )
        ]);
      }),
    );
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

import 'package:zoro_legal/app/widgets/clip_path.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/forgot_password_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgotPassword';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();

  TextEditingController _confirmPassword = TextEditingController();
  bool flag = true;
  bool flag1 = true;
  bool _isLoading = true;
  var _formkey = GlobalKey<FormState>();
  var icon = Icon(Icons.visibility_off);
  var icon1 = Icon(Icons.visibility_off);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Builder(builder: (BuildContext context) {
          return Stack(children: [
            clipPath(
                context, "Forgot Password", "Create Password to using app"),
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

                                        if (!regExp
                                            .hasMatch(_phone.toString())) {
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
                                margin: EdgeInsets.only(
                                    left: 55, right: 55, top: 10),
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
                                      decoration: buildInputDecoration(
                                              "Password", "abc123")
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
                                                icon =
                                                    Icon(Icons.visibility_off);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 55, right: 55, top: 10),
                                alignment: Alignment.center,
                                child: Material(
                                  child: Theme(
                                    data: ThemeData(
                                        primaryColor: Colors.black54,
                                        hintColor: Colors.black),
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      controller: _confirmPassword,
                                      validator: (_confirmPassword) {
                                        if (_confirmPassword.isEmpty) {
                                          return "Enter Confirm Password";
                                        }
                                        return null;
                                      },
                                      textAlign: TextAlign.center,
                                      obscureText: flag1,
                                      decoration: buildInputDecoration(
                                              "Confirm Password", "abc123")
                                          .copyWith(
                                        suffixIcon: IconButton(
                                          icon: icon1,
                                          onPressed: () {
                                            if (flag1 == true) {
                                              setState(() {
                                                flag1 = false;
                                                icon1 = Icon(Icons.visibility);
                                              });
                                            } else {
                                              setState(() {
                                                flag1 = true;
                                                icon1 =
                                                    Icon(Icons.visibility_off);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: MaterialButton(
                                minWidth: 100,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: MyColor.appcolor,
                                child: Text("Submit",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  print(_confirmPassword.text.toString());
                                  print(_password.text.toString());
                                  // if (_password.text== _confirmPassword.text) {
                                  //     Toast.show("Password and confirm Password doesnot match", context,
                                  //                 duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                  // }

                                  if (_formkey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (_password.text.toString() ==
                                        _confirmPassword.text.toString()) {
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());

                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        forgotPassword(
                                                _phone.text, _password.text)
                                            .then((response) {
                                          if (response.status == "true") {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            //     //   // if (_isswitched == true) {
                                            //                                                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text("Password changed sucessfully "),
                                            //   duration: Duration(seconds: 1),
                                            //  margin: EdgeInsets.all(10),
                                            //   behavior: SnackBarBehavior.floating,
                                            // ));
                                            Toast.show(
                                                "Password changed sucessfully ",
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.CENTER);

                                            //     storageInstance = locator<LocalStorageService>();
                                            //     storageInstance.saveStringToDisk(
                                            //         "login_status", response.staus);

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()),
                                                (Route<dynamic> route) =>
                                                    false);
                                            //   // } else {
                                            //   //   Toast.show("logged in ", context,
                                            //   //       duration: Toast.LENGTH_LONG);
                                            //   //   Navigator.pushAndRemoveUntil(
                                            //   //       context,
                                            //   //       MaterialPageRoute(builder: (context) => HomePage()),
                                            //   //       (Route<dynamic> route) => false);
                                            //   // }
                                          } else {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            //                                                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            //   content: Text(response.message),
                                            //   duration: Duration(seconds: 3),
                                            //  margin: EdgeInsets.all(10),
                                            //   behavior: SnackBarBehavior.floating,
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
                                    } else {
                                      //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //   content: Text("Password and confirm Password doesnot match"),
                                      //   duration: Duration(seconds: 3),
                                      //  margin: EdgeInsets.all(10),
                                      //   behavior: SnackBarBehavior.floating,
                                      // ));
                                      Toast.show(
                                          "Password and confirm Password doesnot match",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ]);
        }));
  }
}

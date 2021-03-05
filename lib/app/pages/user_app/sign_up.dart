import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:toast/toast.dart';

import 'package:zoro_legal/app/widgets/clip_path.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/sign_up_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _formkey = GlobalKey<FormState>();
  var _character;
  bool _add = false;
  bool _isLoading = true;
  var _country;
  var _state;
  var _city;

  List stateList = [];
  List cityList = [];
  Future future;
  var validation = false;
  TextEditingController _firstname = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  void initState() {
    future = countryList();
    _country = "select country";
    _state = "select state";
    _city = "select city";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        clipPath(context, "Sign Up", "Please enter your details"),
        clipimage(),
        Form(
          key: _formkey,
          child: Container(
              margin: EdgeInsets.only(top: 270),
              child: FutureBuilder(
                  future: future,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                          return retryWiget(message: snapshot.data);
                        } else if (snapshot.data.country == null) {
                          return retryWiget(message: 'Nodata');
                        }
                        // print("country::" + snapshot.data.country.toString());
                        return ListView(
                          children: [
                            buildCountry(context, snapshot.data),
                            _add ? buildColumn(context, stateList) : SizedBox(),
                            buildName(),
                            buildmobilenumber(),

                            buildPassword(),

                            buildRadio(),
                            SizedBox(height: 50),
                            //  buildBottombuttons(context, _country)
                            buildBottombuttons(context, _country, _state, _city)
                          ],
                        );
                    }
                    return retryWiget();
                  })),
        ),
      ]),

      //  bottomSheet: buildBottombuttons(context, _country,_state,_city)
      // bottomSheet: buildBottombuttons(context, _country),
    );
  }

  Container buildBottombuttons(BuildContext context, _country, _state, _city) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // MaterialButton(
          //   minWidth: MediaQuery.of(context).size.width / 3,
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //   color: MyColor.appcolor,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Text("Login", style: TextStyle(color: Colors.white)),
          // ),
          _isLoading
              ? MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: MyColor.appcolor,
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());

                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      if (validation == false)
                        setState(() {
                          validation = true;
                        });
                      if (_formkey.currentState.validate()) {
                        print(_country);
                        print(_state);
                        print(_city);

                        if (_character == null) {
                          Toast.show("select Type", context,
                              gravity: Toast.CENTER);
                        } else {
                          if (_country == "select country") {
                            Toast.show("select country", context,
                                gravity: Toast.CENTER);
                          } else {
                            if (_character == "L") {
                              if (_state == "select state") {
                                Toast.show("select state", context,
                                    gravity: Toast.CENTER);
                              } else if (_city == "select city") {
                                Toast.show("select city", context,
                                    gravity: Toast.CENTER);
                              } else
                                setState(() {
                                  _isLoading = false;
                                });
                            } else
                              setState(() {
                                _isLoading = false;
                              });
                          }

                          print("_character" + _character);
                          _character == "U"
                              ? signup(_firstname.text, _phone.text, _country,
                                      _password.text, _character)
                                  .then((response) async {
                                  if (response.staus == "true") {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    print(response.data[0].resId);
                                    var userid =
                                        (response.data[0].resId).toString();
                                    print(userid);
                                    //
                                    Toast.show(
                                        "Registered Successfully", context,
                                        gravity: Toast.CENTER);
                                    var storageInstance =
                                        locator<LocalStorageService>();
                                    storageInstance.saveStringToDisk(
                                        "userId", userid);

                                    print("Otp Page");

                                    // Navigator.pushAndRemoveUntil(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => Otp()),
                                    //     (Route<dynamic> route) => false);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    Toast.show(
                                        "Mobile Number is already registered",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    print("Please enter correct details");
                                  }
                                })
                              : vendorSignup(
                                      _firstname.text,
                                      _phone.text,
                                      _country,
                                      _password.text,
                                      _state,
                                      _city,
                                      _character)
                                  .then((response) {
                                  print(response.staus);
                                  if (response.staus == "true") {
                                    Toast.show(
                                        "Registered Successfully", context,
                                        gravity: Toast.CENTER);
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (Route<dynamic> route) => false);
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Toast.show(
                                        "Mobile Number is already registered",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    print("Please enter correct details");
                                  }
                                });
                        }
                      }
                    } else {
                      print("no-conn");
                      setState(() {
                        _isLoading = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please check your Internet Connection"),
                        duration: Duration(seconds: 3),
                        margin:
                            EdgeInsets.only(bottom: 60, left: 10, right: 10),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                  child: Text("Sign up", style: TextStyle(color: Colors.white)),
                )
              : CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have Account :   ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: MyColor.appcolor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Row buildRadio() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text('Register as User'),
            leading: Radio(
              value: "U",
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                  _add = false;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Register as Provider'),
            leading: Radio(
              value: "L",
              groupValue: _character,
              onChanged: (value) {
                setState(() {
                  _character = value;
                  _add = true;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  ListTile buildPassword() {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Container(
          child: Material(
            child: Theme(
              data: ThemeData(
                  hintColor: Colors.black, primaryColor: Colors.black54),
              child: TextFormField(
                  validator: (_password) {
                    if (_password.isEmpty && validation == true) {
                      return 'Enter valid Password';
                    } else if (4 > _password.length && validation == true) {
                      return 'Minimum four letter password is needed';
                    }

                    return null;
                  },
                  controller: _password,
                  // textAlign: TextAlign.center,
                  decoration: buildInputDecoration("Password", "Password")),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildCountry(context, countrylist) {
    return ListTile(
        title: Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Material(
        child: Theme(
            data: ThemeData(
                hintColor: Colors.black, primaryColor: Colors.black54),
            // child: DropdownButtonFormField(
            //   decoration: InputDecoration(
            //     contentPadding: EdgeInsets.all(13),
            //     border: OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.black),
            //         borderRadius: BorderRadius.circular(10)),
            //   ),
            //   hint: Text("Country"),
            //   value: _country,
            //   items: countrylist.country.map((country) {
            //     return DropdownMenuItem(
            //       value: country,
            //       child: Text(country.toString()),
            //     );
            //   }).toList(),
            //   onChanged: (value) {

            //     setState(() {
            //       _country = value;
            //     });
            //   },
            // ),

            child: DropdownButtonFormField<String>(
              isDense: true,
              decoration:
                  buildInputDecoration("Select Country", "select Country"),
              // hint: Text(_country),
              onChanged: (String newValue) {
                print("newValue" + newValue);
                setState(() {
                  _country = newValue;
                  getStateList(_country).then((response) {
                    print(response.states);
                    if (response.success.toString() == "1") {
                      setState(() {
                        stateList = response.states;
                      });
                    } else {
                      print("mmnm");
                    }
                  });
                });

                print(_country);
              },
              items:
                  countrylist.country.map<DropdownMenuItem<String>>((values) {
                return new DropdownMenuItem<String>(
                  value: values.id.toString(),
                  child: new Text(
                    values.country,
                  ),
                );
              }).toList(),
            )),
      ),
    ));
  }

  ListTile buildmobilenumber() {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Container(
          child: Material(
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.black54, hintColor: Colors.black),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (_phone) {
                    if (_phone.isEmpty && validation == true) {
                      return 'Enter valid Number';
                    }
                    if (10 > _phone.length) {
                      return 'Phone number must have 10 digits';
                    }
                    String patttern = r'(^(?:[+,0,4&6-9])[0-9]*$)';

                    RegExp regExp = new RegExp(patttern);

                    if (!regExp.hasMatch(_phone.toString()) &&
                        validation == true) {
                      return 'Please enter valid number';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: _phone,
                  // textAlign: TextAlign.center,
                  decoration: buildInputDecoration("Phone", "9999999999")),
            ),
          ),
        ),
      ),
    );
  }

  ListTile buildName() {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Container(
          child: Material(
            child: Theme(
                data: ThemeData(
                    primaryColor: Colors.black54, hintColor: Colors.black),
                child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _firstname,
                    validator: (_firstname) {
                      if (_firstname.isEmpty && validation == true) {
                        return "Enter Name";
                      }
                      String patttern = r'(^(?:[a-z,A-Z])[a-z,A-Z, .]*$)';
                      RegExp regExp = new RegExp(patttern);
                      if (!regExp.hasMatch(_firstname) && validation == true)
                        return "Enter proper name";
                      return null;
                    },
                    // textAlign: TextAlign.center,
                    decoration: buildInputDecoration("Name", "Name"))),
          ),
        ),
      ),
    );
  }

  buildColumn(context, stateList) {
    return Column(
      children: [
        ListTile(
            title: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: Material(
            child: Theme(
              data: ThemeData(
                  hintColor: Colors.black, primaryColor: Colors.black54),
              child: DropdownButtonFormField<String>(
                isDense: true,
                decoration:
                    buildInputDecoration("Select State", "select State"),
                onChanged: (String newValue) {
                  print("newValue" + newValue);
                  setState(() {
                    _state = newValue;
                    getCityList(_state).then((response) {
                      print(response.cities);
                      if (response.success.toString() == "1") {
                        setState(() {
                          cityList = response.cities;
                        });
                      } else {
                        print("mmnm");
                      }
                    });
                  });

                  print(_state);
                },
                items: stateList.map<DropdownMenuItem<String>>((values) {
                  return new DropdownMenuItem<String>(
                    value: values.stateId.toString(),
                    child: new Text(
                      values.stateName,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )),
        ListTile(
            title: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: Material(
            child: Theme(
              data: ThemeData(
                  hintColor: Colors.black, primaryColor: Colors.black54),
              child: DropdownButtonFormField<String>(
                isDense: true,
                decoration: buildInputDecoration("Select City", "select City"),
                onChanged: (String newValue) {
                  print("newValue" + newValue);
                  setState(() {
                    _city = newValue;
                  });

                  print(_city);
                },
                items: cityList.map<DropdownMenuItem<String>>((values) {
                  return new DropdownMenuItem<String>(
                    value: values.cityId.toString(),
                    child: new Text(
                      values.cityName,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget retryWiget({String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message ?? 'Something Went Wrong Try Again'),
          ),
          CupertinoButton.filled(
            child: Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                future = countryList();
              });
            },
          )
        ],
      ),
    );
  }
}

// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:toast/toast.dart';

// import 'package:zoro_legal/app/widgets/clip_path.dart';
// import 'package:zoro_legal/app/widgets/decoration.dart';
// import 'package:zoro_legal/data/datarepositories/sign_up_future.dart';
// import 'package:zoro_legal/data/helpers/colors.dart';
// import 'package:zoro_legal/provider/country_provider.dart';
// import 'package:zoro_legal/services/service_locator.dart';
// import 'package:zoro_legal/services/storage.dart';

// import 'login.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   var _formkey = GlobalKey<FormState>();
//   var _character;
//   bool _add=false;
//   bool _loading=false;
//   var countries = [
//     "India",
//     // "Singapore",
//   ];
//   var validation = false;
//   TextEditingController _firstname = TextEditingController();
//   TextEditingController _phone = TextEditingController();
//   TextEditingController _password = TextEditingController();
// @override
// void initState() {
//   countryList();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//      final countryProvider=Provider.of<CountryProvider>(context);
//     return Scaffold(
//       body: Stack(children: [
//         clipPath(context, "Sign Up", "Please enter your details"),
//         clipimage(),
//         Form(
//           key: _formkey,
//           child: Container(
//               margin: EdgeInsets.only(top: 270),
//               child: ListView(
//                 children: [
//                   buildName(),
//                   // ListTile(
//                   //   title: Padding(
//                   //     padding: const EdgeInsets.only(left: 30, right: 30),
//                   //     child: Container(
//                   //       child: Material(
//                   //         child: Theme(
//                   //           data: ThemeData(
//                   //               primaryColor: Colors.black54,
//                   //               hintColor: Colors.black),
//                   //           child: TextFormField(
//                   //               keyboardType: TextInputType.name,
//                   //               validator: (_lastname) {
//                   //                 // if (_lastname.isEmpty && validation == true) {
//                   //                 //   return "Enter LastName";
//                   //                 // }
//                   //                 String patttern =
//                   //                     r'(^(?:[a-z,A-Z])[a-z,A-Z, .]*$)';
//                   //                 RegExp regExp = new RegExp(patttern);
//                   //                 // if (!regExp.hasMatch(_lastname) &&
//                   //                 //     validation == true) {
//                   //                 //   return "Enter proper name";
//                   //                 // }
//                   //                 return null;
//                   //               },
//                   //               controller: _lastname,
//                   //               textAlign: TextAlign.center,
//                   //               decoration: InputDecoration(
//                   //                   border: OutlineInputBorder(
//                   //                       borderSide:
//                   //                           BorderSide(color: Colors.black),
//                   //                       borderRadius:
//                   //                           BorderRadius.circular(10)),
//                   //                   // prefixIcon: Icon(Icons.person),
//                   //                   hintText: "Last Name",
//                   //                   labelText: "Last Name")),
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   buildmobilenumber(),
//                   // ListTile(
//                   //   title: Padding(
//                   //     padding: const EdgeInsets.only(left: 30, right: 30),
//                   //     child: Container(
//                   //       child: Material(
//                   //         child: Theme(
//                   //           data: ThemeData(
//                   //               primaryColor: Colors.black54,
//                   //               hintColor: Colors.black),
//                   //           child: TextFormField(
//                   //               keyboardType: TextInputType.emailAddress,
//                   //               validator: (_email) {
//                   //                 // if (_email.isEmpty && validation == true) {
//                   //                 //   return "Enter Email";
//                   //                 // }
//                   //                 Pattern pattern =
//                   //                     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//                   //                 RegExp regExp = new RegExp(pattern);
//                   //                 // if (!regExp.hasMatch(_email.toString()) &&
//                   //                 //     validation == true) {
//                   //                 //   return 'Please enter valid email';
//                   //                 // }
//                   //                 return null;
//                   //               },
//                   //               controller: _email,
//                   //               textAlign: TextAlign.center,
//                   //               decoration: InputDecoration(
//                   //                   border: OutlineInputBorder(
//                   //                       borderSide:
//                   //                           BorderSide(color: Colors.black),
//                   //                       borderRadius:
//                   //                           BorderRadius.circular(10)),
//                   //                   // prefixIcon: Icon(Icons.mail),
//                   //                   hintText: "Email",
//                   //                   labelText: "Email")),
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   // ListTile(
//                   //     title: Padding(
//                   //       padding: const EdgeInsets.only(left: 30,right: 30),
//                   //       child: Container(
//                   //         child: Material(
//                   //                                 child: Theme(
//                   //                                   data:ThemeData(primaryColor: Colors.black54,
//                   //                                   hintColor: Colors.black),
//                   //                                                                                   child: TextFormField(
//                   //               controller: TextEditingController(text: _country),

//                   //               textAlign: TextAlign.center,
//                   //               decoration: InputDecoration(
//                   //                 border:OutlineInputBorder(borderSide: BorderSide(color: Colors.black),
//                   //               borderRadius: BorderRadius.circular(30)
//                   //               ),
//                   //                   // prefixIcon: Icon(Icons.code_sharp),
//                   //                   hintText: "Country"),
//                   //               onTap: () {
//                   //                 FocusScope.of(context).requestFocus(FocusNode());
//                   //                 return showDialog(
//                   //                     builder: (context) {
//                   //                       return AlertDialog(
//                   //                           title: Text("Select Country"),
//                   //                           content: StatefulBuilder(builder:
//                   //                               (BuildContext context,
//                   //                                     StateSetter setState) {
//                   //                             return Column(
//                   //                                   mainAxisSize: MainAxisSize.min,
//                   //                                   children: <Widget>[
//                   //                                     Container(
//                   //                                       height: 100,
//                   //                                       width: 200,
//                   //                                       child: ListView(
//                   //                                         children: countries
//                   //                                             .map((countryname) {
//                   //                                           return RadioListTile(
//                   //                                               title:
//                   //                                                   Text(countryname),
//                   //                                               value: countryname,
//                   //                                               groupValue: _country,
//                   //                                               onChanged: (country) {
//                   //                                                 setState(() {
//                   //                                                   _country = country;
//                   //                                                   Navigator.pop(
//                   //                                                       context);
//                   //                                                 });
//                   //                                               });
//                   //                                         }).toList(),
//                   //                                       ),
//                   //                                     ),
//                   //                                   ]);
//                   //                           }));
//                   //                     },
//                   //                     context: context);
//                   //               }),
//                   //                                 ),
//                   //         ),
//                   //       ),
//                   //     )),
//                   buildCountry(context,countryProvider),
//                   buildPassword(),
//                   _add?buildColumn(context,countryProvider):SizedBox(),
//                                     buildRadio(),
//                                     SizedBox(height: 50)
//                                   ],
//                                 )),
//                           ),
//                         ]),
//                         bottomSheet: buildBottombuttons(context,countryProvider),
//                       );
//                     }

//                     Container buildBottombuttons(BuildContext context,countryProvider) {
//                       return Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             MaterialButton(
//                               minWidth: MediaQuery.of(context).size.width / 3,
//                               shape:
//                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                               color: MyColor.appcolor,
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text("Login", style: TextStyle(color: Colors.white)),
//                             ),
//                             MaterialButton(
//                               minWidth: MediaQuery.of(context).size.width / 3,
//                               shape:
//                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                               color: MyColor.appcolor,
//                               onPressed: ()async {
//                                 var connectivityResult = await (Connectivity().checkConnectivity());

//                             if (connectivityResult == ConnectivityResult.mobile ||
//                                 connectivityResult == ConnectivityResult.wifi) {
//                                 if (validation == false)
//                                   setState(() {
//                                     validation = true;
//                                   });
//                                 if (_formkey.currentState.validate()) {
//                                  print( countryProvider.getCountry);
//                                 print(countryProvider.getCountry=="India"?"1":"2");
//                                   print( _character);
//                                   if (countryProvider.getCountry == null) {
//                                     Toast.show("select country", context, gravity: Toast.BOTTOM);
//                                   } else if (_character == null) {
//                                     Toast.show("select Type", context, gravity: Toast.BOTTOM);
//                                   }
//                                   _character=="U"?
//                                   signup(_firstname.text, _phone.text, countryProvider.getCountry, _password.text,
//                                           _character)
//                                       .then((response) async {

//                                     if (response.staus == "true") {
//                                        print(response.data[0].resId);
//                                     var userid = (response.data[0].resId).toString();
//                                     print(userid);
//                                         Toast.show("Register Sucessfully",context,gravity:Toast.BOTTOM);
//                                       var storageInstance = locator<LocalStorageService>();
//                                       storageInstance.saveStringToDisk("userId", userid);

//                                       print("Otp Page");

//                                       // Navigator.pushAndRemoveUntil(
//                                       //     context,
//                                       //     MaterialPageRoute(builder: (context) => Otp()),
//                                       //     (Route<dynamic> route) => false);
//                     Navigator.pushAndRemoveUntil(context,
//                                           MaterialPageRoute(builder: (context) => Login()),(Route<dynamic> route) => false);

//                                     } else {
//                                       Toast.show(response.message,context,duration: Toast.LENGTH_LONG);
//                                       print("Please enter correct details");
//                                     }
//                                   }):

//                                    print("hhjg");
//                                    setState(() {
//                                      _add=true;
//                                    });
//                                 }}else {
//                               print("no-conn");

//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text("Please check your Internet Connection"),
//                                 duration: Duration(seconds: 3),
//                                   margin: EdgeInsets.only(bottom:60,left: 10,right: 10),
//                                 behavior: SnackBarBehavior.floating,
//                               ));
//                             }
//                               },
//                               child: Text("Sign up", style: TextStyle(color: Colors.white)),
//                             )
//                           ],
//                         ),
//                       );
//                     }

//                     Row buildRadio() {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               title: Text('Register as User'),
//                               leading: Radio(
//                                 value: "U",
//                                 groupValue: _character,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _character = value;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: ListTile(
//                               title: const Text('Register as Provider'),
//                               leading: Radio(
//                                 value: "L",
//                                 groupValue: _character,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _character = value;
//                                   });
//                                 },
//                               ),
//                             ),
//                           )
//                         ],
//                       );
//                     }

//                     ListTile buildPassword() {
//                       return ListTile(
//                         title: Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: Container(
//                             child: Material(
//                               child: Theme(
//                                 data: ThemeData(
//                                     hintColor: Colors.black, primaryColor: Colors.black54),
//                                 child: TextFormField(
//                                     validator: (_password) {
//                                       if (_password.isEmpty && validation == true) {
//                                         return 'Enter valid Password';
//                                       }

//                                       return null;
//                                     },
//                                     controller: _password,
//                                     textAlign: TextAlign.center,
//                                     decoration: buildInputDecoration("Password", "Password")),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                     ListTile buildCountry(context,countryProvider) {

//                       return ListTile(
//                           title: Container(
//                         margin: EdgeInsets.only(left: 40, right: 40),
//                         child: Material(
//                           child: Theme(
//                             data:
//                                 ThemeData(hintColor: Colors.black, primaryColor: Colors.black54),
//                             child: DropdownButtonFormField(
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.all(13),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                               hint: Text("Country"),
//                               value: countryProvider.getCountry,
//                               items: countries.map((String country) {
//                                 return DropdownMenuItem(
//                                   value: country,
//                                   child: Text(country),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                               countryProvider.setCountry(value);
//                                 // setState(() {
//                                 //   _country = value;
//                                 // });
//                               },
//                             ),
//                           ),
//                         ),
//                       ));
//                     }

//                     ListTile buildmobilenumber() {
//                       return ListTile(
//                         title: Padding(
//                           padding: const EdgeInsets.only(left: 40, right: 40),
//                           child: Container(
//                             child: Material(
//                               child: Theme(
//                                 data: ThemeData(
//                                     primaryColor: Colors.black54, hintColor: Colors.black),
//                                 child: TextFormField(
//                                     keyboardType: TextInputType.number,
//                                     validator: (_phone) {
//                                       if (_phone.isEmpty && validation == true) {
//                                         return 'Enter valid Number';
//                                       }
//                                       if (10 > _phone.length) {
//                                         return 'Phone number must have 10 digits';
//                                       }
//                                       String patttern = r'(^(?:[+,0,4&6-9])[0-9]*$)';

//                                       RegExp regExp = new RegExp(patttern);

//                                       if (!regExp.hasMatch(_phone.toString()) &&
//                                           validation == true) {
//                                         return 'Please enter valid number';
//                                       }
//                                       return null;
//                                     },
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(10),
//                                     ],
//                                     controller: _phone,
//                                     textAlign: TextAlign.center,
//                                     decoration: buildInputDecoration("Phone", "9999999999")),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                     ListTile buildName() {
//                       return ListTile(
//                         title: Padding(
//                           padding: EdgeInsets.only(left: 40, right: 40),
//                           child: Container(
//                             child: Material(
//                               child: Theme(
//                                   data: ThemeData(
//                                       primaryColor: Colors.black54, hintColor: Colors.black),
//                                   child: TextFormField(
//                                       keyboardType: TextInputType.name,
//                                       controller: _firstname,
//                                       validator: (_firstname) {
//                                         if (_firstname.isEmpty && validation == true) {
//                                           return "Enter Name";
//                                         }
//                                         String patttern = r'(^(?:[a-z,A-Z])[a-z,A-Z, .]*$)';
//                                         RegExp regExp = new RegExp(patttern);
//                                         if (!regExp.hasMatch(_firstname) && validation == true)
//                                           return "Enter proper name";
//                                         return null;
//                                       },
//                                       textAlign: TextAlign.center,
//                                       decoration: buildInputDecoration("Name", "Name"))),
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                      buildColumn(context,countryProvider) {

//                       return Column(
//                         children: [
//                           ListTile(
//                               title: Container(
//                             margin: EdgeInsets.only(left: 40, right: 40),
//                             child: Material(
//                               child: Theme(
//                                 data:
//                                     ThemeData(hintColor: Colors.black, primaryColor: Colors.black54),
//                                 child: DropdownButtonFormField(
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.all(13),
//                                     border: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black),
//                                         borderRadius: BorderRadius.circular(10)),
//                                   ),
//                                   hint: Text("State"),
//                                   value: countryProvider.getCountry,
//                                   items: countries.map((String country) {
//                                     return DropdownMenuItem(
//                                       value: country,
//                                       child: Text(country),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                   countryProvider.setCountry(value);
//                                     // setState(() {
//                                     //   _country = value;
//                                     // });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           )),
//                            ListTile(
//                               title: Container(
//                             margin: EdgeInsets.only(left: 40, right: 40),
//                             child: Material(
//                               child: Theme(
//                                 data:
//                                     ThemeData(hintColor: Colors.black, primaryColor: Colors.black54),
//                                 child: DropdownButtonFormField(
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.all(13),
//                                     border: OutlineInputBorder(
//                                         borderSide: BorderSide(color: Colors.black),
//                                         borderRadius: BorderRadius.circular(10)),
//                                   ),
//                                   hint: Text("City"),
//                                   value: countryProvider.getCountry,
//                                   items: countries.map((String country) {
//                                     return DropdownMenuItem(
//                                       value: country,
//                                       child: Text(country),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                   countryProvider.setCountry(value);
//                                     // setState(() {
//                                     //   _country = value;
//                                     // });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           )),
//                         ],
//                       );
//                     }
// }

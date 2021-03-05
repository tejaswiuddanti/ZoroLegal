import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';
import 'package:zoro_legal/data/datarepositories/agent_app_future/agent_user_list_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/sign_up_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future future;
  var countrylist;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var _country;

  @override
  void initState() {
    future = Future.wait([getUsersList(), countryList()]);
    _country = "select country";

    super.initState();
  }

  Future _refresh() async {
    setState(() {
      future = Future.wait([getUsersList(), countryList()]);
    });
  }

 

  @override
  Widget build(BuildContext context) {
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
          title: Center(child: Text("Users"))),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child:  FutureBuilder(
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
                  } else if (snapshot.data[0] is String) {
                    return Center(child: Text("${snapshot.data[0]}"));
                  }
                     var users = snapshot.data[0].users;
                      countrylist = snapshot.data[1];
                    return 
                      Stage1(
                        users: users,
                        );
                  

              }
              return retryWiget();
            }),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          return showDialog(
              context: context,
              builder: (context) {
                String responseText = "";
                _country = "select country";
                bool flag = true;
                TextEditingController _firstname = TextEditingController();
                TextEditingController _phone = TextEditingController();
                TextEditingController _newPassword = TextEditingController();
                bool _isLoading = true;
                var icon = Icon(Icons.visibility_off);
                var _formkey = GlobalKey<FormState>();

                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                  return Dialog(
                      elevation: 16,
                      child: Form(
                        key: _formkey,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 25, right: 25, bottom: 15),
                                      alignment: Alignment.center,
                                      child: Material(
                                        color: Colors.white,
                                        child: Theme(
                                          data: ThemeData(
                                              primaryColor: Colors.black54,
                                              hintColor: Colors.black),
                                          child: TextFormField(
                                              cursorColor: Colors.black,
                                              controller: _firstname,
                                              validator: (_firstname) {
                                                if (_firstname.isEmpty) {
                                                  return "Enter Name";
                                                }
                                                return null;
                                              },
                                              decoration: buildInputDecoration(
                                                  "Name", "Name")),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 25, right: 25, bottom: 15),
                                      alignment: Alignment.center,
                                      child: Material(
                                        color: Colors.white,
                                        child: Theme(
                                          data: ThemeData(
                                              primaryColor: Colors.black54,
                                              hintColor: Colors.black),
                                          child: TextFormField(
                                              cursorColor: Colors.black,
                                              controller: _phone,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (_phone) {
                                                if (_phone.isEmpty) {
                                                  return 'Enter valid Number';
                                                }
                                                if (10 > _phone.length) {
                                                  return 'Mobile number must have 10 digits';
                                                }
                                                String patttern =
                                                    r'(^(?:[+,0,4&6-9])[0-9]*$)';

                                                RegExp regExp =
                                                    new RegExp(patttern);

                                                if (!regExp.hasMatch(
                                                    _phone.toString())) {
                                                  return 'Please enter valid number';
                                                }
                                                return null;
                                              },
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                              ],
                                              decoration: buildInputDecoration(
                                                  "Mobile Number",
                                                  "999999999")),
                                        ),
                                      )),
                                  // Container(
                                  //     margin: EdgeInsets.only(
                                  //         left: 25, right: 25, bottom: 15),
                                  //     alignment: Alignment.center,
                                  //     child: Material(
                                  //       color: Colors.white,
                                  //       child: Theme(
                                  //         data: ThemeData(
                                  //             primaryColor: Colors.black54,
                                  //             hintColor: Colors.black),
                                  //         child: TextFormField(
                                  //           cursorColor: Colors.black,
                                  //           controller: _newPassword,
                                  //           validator: (_newpassword) {
                                  //             if (_newpassword.isEmpty) {
                                  //               return "Enter Password";
                                  //             } else if (4 >
                                  //                 _newpassword.length) {
                                  //               return 'Minimum four letter password is needed';
                                  //             }
                                  //             return null;
                                  //           },
                                  //           obscureText: flag,
                                  //           decoration: buildInputDecoration(
                                  //                   "password", "abc123")
                                  //               .copyWith(
                                  //             suffixIcon: IconButton(
                                  //               icon: icon,
                                  //               onPressed: () {
                                  //                 if (flag == true) {
                                  //                   setState(() {
                                  //                     flag = false;
                                  //                     icon = Icon(
                                  //                         Icons.visibility);
                                  //                   });
                                  //                 } else {
                                  //                   setState(() {
                                  //                     flag = true;
                                  //                     icon = Icon(
                                  //                         Icons.visibility_off);
                                  //                   });
                                  //                 }
                                  //               },
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 25, right: 25, bottom: 15),
                                      alignment: Alignment.center,
                                      child: Material(
                                        color: Colors.white,
                                        child: Theme(
                                            data: ThemeData(
                                                hintColor: Colors.black,
                                                primaryColor: Colors.black54),
                                            child:
                                                DropdownButtonFormField<String>(
                                              isDense: true,
                                              decoration: buildInputDecoration(
                                                  "Select Country",
                                                  "select Country"),
                                              onChanged: (String newValue) {
                                                print("newValue" + newValue);
                                                setState(() {
                                                  _country = newValue;
                                                });
                                                print(_country);
                                              },
                                              items: countrylist.country.map<
                                                      DropdownMenuItem<String>>(
                                                  (values) {
                                                return new DropdownMenuItem<
                                                    String>(
                                                  value: values.id.toString(),
                                                  child: new Text(
                                                    values.country,
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                      )),
                                  responseText == ""
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 60, top: 5, bottom: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            responseText,
                                            style: TextStyle(color: Colors.red),
                                          )),
                                  _isLoading
                                      ? MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          color: MyColor.appcolor,
                                          child: Text("Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          onPressed: () async {
                                            print(_newPassword.text.toString());
                                            print(_phone.text.toString());
                                            print(_firstname.text.toString());
                                            print(_country);
                                            if (_formkey.currentState
                                                .validate()) {
                                              if (_country ==
                                                  "select country") {
                                                Toast.show(
                                                    "select country", context,
                                                    gravity: Toast.CENTER);
                                              } else {
                                                setState(() {
                                                  _isLoading = false;
                                                });

                                                var connectivityResult =
                                                    await (Connectivity()
                                                        .checkConnectivity());

                                                if (connectivityResult ==
                                                        ConnectivityResult
                                                            .mobile ||
                                                    connectivityResult ==
                                                        ConnectivityResult
                                                            .wifi) {
                                                  addUsers(
                                                          _firstname.text,
                                                          _phone.text,
                                                          // _newPassword.text,
                                                          _country)
                                                      .then((response) => {
                                                            if (response
                                                                    .status ==
                                                                "1")
                                                              {
                                                                setState(() {
                                                                  _isLoading =
                                                                      true;

                                                                
                                                                }),
                                                                Toast.show(
                                                                    response
                                                                        .message,
                                                                    context,
                                                                    gravity: Toast
                                                                        .CENTER),
                                                                Navigator.pop(
                                                                    context),
                                                                setState((){  future = Future
                                                                      .wait([
                                                                    getUsersList(),
                                                                    countryList()
                                                                  ]);})
                                                                
                                                              }
                                                            else
                                                              {
                                                                setState(() {
                                                    _isLoading = true;
                                                  }),
                                                                Toast.show(
                                                                    response
                                                                        .message,
                                                                    context,
                                                                    gravity: Toast
                                                                        .CENTER),
                                                                         Navigator.pop(
                                                                    context),
                                                              }
                                                          });
                                                } else {
                                                  print("no-conn");

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Please check your Internet Connection"),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    margin: EdgeInsets.all(10),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                  
                                                }
                                              }
                                            }
                                          },
                                        )
                                      : CircularProgressIndicator(),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                });
              });
        },
        child: Image.asset('assets/add.png'),
      ),
    
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
               future = Future.wait([getUsersList(), countryList()]);
              });
            },
          )
        ],
      ),
    );
  }
}

class Stage1 extends StatefulWidget {
  final List users;
 
  const Stage1(
      {Key key,
      @required this.users,
      })
      : super(key: key);

  @override
  _Stage1State createState() => _Stage1State();
}

class _Stage1State extends State<Stage1> {
  final TextEditingController _controller = TextEditingController();
  var usersList;
  @override
  Widget build(BuildContext context) {
    List users = widget.users;
    print("@@@##@");
    print(users);
    return (users.length==0)
        ? Center(child: Text("No data "))
        : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 55,
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
                      searchUsers(value).then((response) {
                        print("!!!!");
                        print(response.users);
                        setState(() {
                         usersList = response.users;
                        });
                        print(usersList.isEmpty?"1":"2");
                      });
                    },
                    onFieldSubmitted: (String value) {
                      searchUsers(value).then((response) {
                        setState(() {
                          usersList = response.users;
                        });
                      });
                    },
                  ),
                ),
              ),

             
              Expanded(
                child: (_controller.text.isEmpty)?ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UsersList(
                      users: users[index],
                    );
                  },
                ) :usersList.isEmpty
                  ? Text("No Data",style: TextStyle(fontSize: 15),):
                  ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UsersList(
                      users: usersList[index],
                    );
                  },
                )
              ),
            ],
          );
  }
}

class SearchStage1 extends SearchDelegate {
  SearchStage1(this.stage1);
  List stage1;

  @override
  List<Widget> buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
        children: stage1
            .where((st1) => st1.name.toLowerCase().contains(query))
            .map((f) => UsersList(
                  users: f,
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
        children: stage1
            .where((st1) => st1.name.toLowerCase().contains(query))
            .map((f) =>UsersList(
                  users: f,
                ))
            .toList());
  }
}

class UsersList extends StatelessWidget {
  UsersList({@required this.users});
  final users;
 Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size.width;
  return Card(
                                    elevation: 5,
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
                                                    top: 12),
                                                width:
                                                    size * 0.3584541062801932,
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
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                    Text(
                                                      ':    ',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top:  12),
                                                width: (size *
                                                        0.5449275362318841) -
                                                    (size *
                                                        0.043091787439614) -
                                                    20,
                                                child: Text(
                                                  '${users.fName}',
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
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                width:
                                                    size * 0.3584541062801932,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Email',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                    Text(
                                                      ':    ',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                width: (size *
                                                        0.5449275362318841) -
                                                    (size *
                                                        0.0483091787439614) -
                                                    20,
                                                child: Text(
                                                  '${users.email}',
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
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                width:
                                                    size * 0.3584541062801932,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Mobile Number',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                    Text(
                                                      ':    ',
                                                      style: TextStyle(
                                                          fontSize: size *
                                                              0.038231884057971,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _colorfromhex(
                                                                  "#474747")),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                width: (size *
                                                        0.5449275362318841) -
                                                    (size *
                                                        0.0483091787439614) -
                                                    20,
                                                child: Text(
                                                  '${users.phone}',
                                                  style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.start,
                                          //   children: [
                                          //     Container(
                                          //       margin:
                                          //           EdgeInsets.only(top: 12),
                                          //       width:
                                          //           size * 0.3584541062801932,
                                          //       child: Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .spaceBetween,
                                          //         children: [
                                          //           Text(
                                          //             'Password',
                                          //             style: TextStyle(
                                          //                 fontSize: size *
                                          //                     0.038231884057971,
                                          //                 fontWeight:
                                          //                     FontWeight.bold,
                                          //                 color:
                                          //                     _colorfromhex(
                                          //                         "#474747")),
                                          //           ),
                                          //           Text(
                                          //             ':    ',
                                          //             style: TextStyle(
                                          //                 fontSize: size *
                                          //                     0.038231884057971,
                                          //                 fontWeight:
                                          //                     FontWeight.bold,
                                          //                 color:
                                          //                     _colorfromhex(
                                          //                         "#474747")),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin:
                                          //           EdgeInsets.only(top: 12),
                                          //       width: (size *
                                          //               0.5449275362318841) -
                                          //           (size *
                                          //               0.0483091787439614) -
                                          //           20,
                                          //       child: Text(
                                          //         '${users.password}',
                                          //         style: TextStyle(
                                          //             fontSize: size *
                                          //                 0.038231884057971,
                                          //             color: _colorfromhex(
                                          //                 "#474747")),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                               
                          
  }
}












//     var size = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColor.appcolor,
//         leading: IconButton(
//           icon: Icon(
//             Icons.keyboard_arrow_left,
//             size: 40,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Container(
//           margin: EdgeInsets.only(left: size * 0.28743961352657 - 35),
//           child: Text("Users"),
//         ),
//       ),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: () => _refresh(),
//         child: Container(
//           child: FutureBuilder(
//             future: future,
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                   return retryWiget();

//                 case ConnectionState.active:
//                   return Center(child: CircularProgressIndicator());
//                 case ConnectionState.waiting:
//                   return Center(child: CircularProgressIndicator());

//                 case ConnectionState.done:
//                   if (snapshot.hasError) {
//                     return retryWiget();
//                   } else if (snapshot.data[0] is String) {
//                     return Center(child: Text("${snapshot.data[0]}"));
//                   }

//                   var users = snapshot.data[0].users;
//                   countrylist = snapshot.data[1];
//                   print(users.length);
//                   return users.length <= 0
//                       ? Container()
//                       : Column(
//                           children: [
//                             InkWell(
//                                 onTap: () {
//                                   // return showSearch(
//                                   //     context: context,delegate: SearchStage1(stage1list));
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         border: Border.all(
//                                             color: Color(0xFF53549D)),
//                                       ),
//                                       child: Center(
//                                           child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               'Search.....',
//                                               style: TextStyle(fontSize: 18),
//                                             ),
//                                           ),
//                                           CircleAvatar(
//                                               radius: 23,
//                                               backgroundColor:
//                                                   Color(0xFF53549D),
//                                               child: Icon(Icons.search))
//                                         ],
//                                       ))),
//                                 )),


//                             Expanded(
//                               child: ListView.builder(
//                                   itemCount: users.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return Card(
//                                       elevation: 5,
//                                       margin: EdgeInsets.only(
//                                           left: size * 0.0483091787439614,
//                                           right: size * 0.0483091787439614,
//                                           top: 20),
//                                       child: Container(
//                                         margin: EdgeInsets.only(
//                                             left: size * 0.0483091787439614,
//                                             top: 8,
//                                             bottom: 15),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       top: index == 0 ? 5 : 12),
//                                                   width:
//                                                       size * 0.3584541062801932,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         'Name',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                       Text(
//                                                         ':    ',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin: EdgeInsets.only(
//                                                       top: index == 0 ? 5 : 12),
//                                                   width: (size *
//                                                           0.5449275362318841) -
//                                                       (size *
//                                                           0.043091787439614) -
//                                                       20,
//                                                   child: Text(
//                                                     '${users[index].fName}',
//                                                     style: TextStyle(
//                                                         fontSize: size *
//                                                             0.038231884057971,
//                                                         color: _colorfromhex(
//                                                             "#474747")),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width:
//                                                       size * 0.3584541062801932,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         'Email',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                       Text(
//                                                         ':    ',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width: (size *
//                                                           0.5449275362318841) -
//                                                       (size *
//                                                           0.0483091787439614) -
//                                                       20,
//                                                   child: Text(
//                                                     '${users[index].email}',
//                                                     style: TextStyle(
//                                                         fontSize: size *
//                                                             0.038231884057971,
//                                                         color: _colorfromhex(
//                                                             "#474747")),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width:
//                                                       size * 0.3584541062801932,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         'Mobile Number',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                       Text(
//                                                         ':    ',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width: (size *
//                                                           0.5449275362318841) -
//                                                       (size *
//                                                           0.0483091787439614) -
//                                                       20,
//                                                   child: Text(
//                                                     '${users[index].phone}',
//                                                     style: TextStyle(
//                                                       fontSize: size *
//                                                           0.038231884057971,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width:
//                                                       size * 0.3584541062801932,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         'Password',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                       Text(
//                                                         ':    ',
//                                                         style: TextStyle(
//                                                             fontSize: size *
//                                                                 0.038231884057971,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             color:
//                                                                 _colorfromhex(
//                                                                     "#474747")),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   margin:
//                                                       EdgeInsets.only(top: 12),
//                                                   width: (size *
//                                                           0.5449275362318841) -
//                                                       (size *
//                                                           0.0483091787439614) -
//                                                       20,
//                                                   child: Text(
//                                                     '${users[index].password}',
//                                                     style: TextStyle(
//                                                         fontSize: size *
//                                                             0.038231884057971,
//                                                         color: _colorfromhex(
//                                                             "#474747")),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                             ),
//                           ],
//                         );

//                 default:
//                   return Text("error");
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: InkWell(
//         onTap: () {
//           return showDialog(
//               context: context,
//               builder: (context) {
//                 String responseText = "";
//                 _country = "select country";
//                 bool flag = true;
//                 TextEditingController _firstname = TextEditingController();
//                 TextEditingController _phone = TextEditingController();
//                 TextEditingController _newPassword = TextEditingController();
//                 bool _isLoading = true;
//                 var icon = Icon(Icons.visibility_off);
//                 var _formkey = GlobalKey<FormState>();

//                 return StatefulBuilder(
//                     builder: (context, StateSetter setState) {
//                   return Dialog(
//                       elevation: 16,
//                       child: Form(
//                         key: _formkey,
//                         child: Container(
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 top: MediaQuery.of(context).size.height * 0.05),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.only(
//                                           left: 25, right: 25, bottom: 15),
//                                       alignment: Alignment.center,
//                                       child: Material(
//                                         color: Colors.white,
//                                         child: Theme(
//                                           data: ThemeData(
//                                               primaryColor: Colors.black54,
//                                               hintColor: Colors.black),
//                                           child: TextFormField(
//                                               cursorColor: Colors.black,
//                                               controller: _firstname,
//                                               validator: (_firstname) {
//                                                 if (_firstname.isEmpty) {
//                                                   return "Enter Name";
//                                                 }
//                                                 return null;
//                                               },
//                                               decoration: buildInputDecoration(
//                                                   "Name", "Name")),
//                                         ),
//                                       )),
//                                   Container(
//                                       margin: EdgeInsets.only(
//                                           left: 25, right: 25, bottom: 15),
//                                       alignment: Alignment.center,
//                                       child: Material(
//                                         color: Colors.white,
//                                         child: Theme(
//                                           data: ThemeData(
//                                               primaryColor: Colors.black54,
//                                               hintColor: Colors.black),
//                                           child: TextFormField(
//                                               cursorColor: Colors.black,
//                                               controller: _phone,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               validator: (_phone) {
//                                                 if (_phone.isEmpty) {
//                                                   return 'Enter valid Number';
//                                                 }
//                                                 if (10 > _phone.length) {
//                                                   return 'Mobile number must have 10 digits';
//                                                 }
//                                                 String patttern =
//                                                     r'(^(?:[+,0,4&6-9])[0-9]*$)';

//                                                 RegExp regExp =
//                                                     new RegExp(patttern);

//                                                 if (!regExp.hasMatch(
//                                                     _phone.toString())) {
//                                                   return 'Please enter valid number';
//                                                 }
//                                                 return null;
//                                               },
//                                               inputFormatters: [
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                               ],
//                                               decoration: buildInputDecoration(
//                                                   "Mobile Number",
//                                                   "999999999")),
//                                         ),
//                                       )),
//                                   // Container(
//                                   //     margin: EdgeInsets.only(
//                                   //         left: 25, right: 25, bottom: 15),
//                                   //     alignment: Alignment.center,
//                                   //     child: Material(
//                                   //       color: Colors.white,
//                                   //       child: Theme(
//                                   //         data: ThemeData(
//                                   //             primaryColor: Colors.black54,
//                                   //             hintColor: Colors.black),
//                                   //         child: TextFormField(
//                                   //           cursorColor: Colors.black,
//                                   //           controller: _newPassword,
//                                   //           validator: (_newpassword) {
//                                   //             if (_newpassword.isEmpty) {
//                                   //               return "Enter Password";
//                                   //             } else if (4 >
//                                   //                 _newpassword.length) {
//                                   //               return 'Minimum four letter password is needed';
//                                   //             }
//                                   //             return null;
//                                   //           },
//                                   //           obscureText: flag,
//                                   //           decoration: buildInputDecoration(
//                                   //                   "password", "abc123")
//                                   //               .copyWith(
//                                   //             suffixIcon: IconButton(
//                                   //               icon: icon,
//                                   //               onPressed: () {
//                                   //                 if (flag == true) {
//                                   //                   setState(() {
//                                   //                     flag = false;
//                                   //                     icon = Icon(
//                                   //                         Icons.visibility);
//                                   //                   });
//                                   //                 } else {
//                                   //                   setState(() {
//                                   //                     flag = true;
//                                   //                     icon = Icon(
//                                   //                         Icons.visibility_off);
//                                   //                   });
//                                   //                 }
//                                   //               },
//                                   //             ),
//                                   //           ),
//                                   //         ),
//                                   //       ),
//                                   //     )),
//                                   Container(
//                                       margin: EdgeInsets.only(
//                                           left: 25, right: 25, bottom: 15),
//                                       alignment: Alignment.center,
//                                       child: Material(
//                                         color: Colors.white,
//                                         child: Theme(
//                                             data: ThemeData(
//                                                 hintColor: Colors.black,
//                                                 primaryColor: Colors.black54),
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               isDense: true,
//                                               decoration: buildInputDecoration(
//                                                   "Select Country",
//                                                   "select Country"),
//                                               onChanged: (String newValue) {
//                                                 print("newValue" + newValue);
//                                                 setState(() {
//                                                   _country = newValue;
//                                                 });
//                                                 print(_country);
//                                               },
//                                               items: countrylist.country.map<
//                                                       DropdownMenuItem<String>>(
//                                                   (values) {
//                                                 return new DropdownMenuItem<
//                                                     String>(
//                                                   value: values.id.toString(),
//                                                   child: new Text(
//                                                     values.country,
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                             )),
//                                       )),
//                                   responseText == ""
//                                       ? Container()
//                                       : Container(
//                                           padding: EdgeInsets.only(
//                                               left: 60, top: 5, bottom: 10),
//                                           alignment: Alignment.centerLeft,
//                                           child: Text(
//                                             responseText,
//                                             style: TextStyle(color: Colors.red),
//                                           )),
//                                   _isLoading
//                                       ? MaterialButton(
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           color: MyColor.appcolor,
//                                           child: Text("Submit",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                               )),
//                                           onPressed: () async {
//                                             print(_newPassword.text.toString());
//                                             print(_phone.text.toString());
//                                             print(_firstname.text.toString());
//                                             print(_country);
//                                             if (_formkey.currentState
//                                                 .validate()) {
//                                               if (_country ==
//                                                   "select country") {
//                                                 Toast.show(
//                                                     "select country", context,
//                                                     gravity: Toast.CENTER);
//                                               } else {
//                                                 setState(() {
//                                                   _isLoading = false;
//                                                 });

//                                                 var connectivityResult =
//                                                     await (Connectivity()
//                                                         .checkConnectivity());

//                                                 if (connectivityResult ==
//                                                         ConnectivityResult
//                                                             .mobile ||
//                                                     connectivityResult ==
//                                                         ConnectivityResult
//                                                             .wifi) {
//                                                   addUsers(
//                                                           _firstname.text,
//                                                           _phone.text,
//                                                           // _newPassword.text,
//                                                           _country)
//                                                       .then((response) => {
//                                                             if (response
//                                                                     .status ==
//                                                                 "1")
//                                                               {
//                                                                 Toast.show(
//                                                                     response
//                                                                         .message,
//                                                                     context,
//                                                                     gravity: Toast
//                                                                         .CENTER),
//                                                                 Navigator.pop(
//                                                                     context),
//                                                                 setState(() {
//                                                                   _isLoading =
//                                                                       true;
//                                                                   future = Future
//                                                                       .wait([
//                                                                     getUsersList(),
//                                                                     countryList()
//                                                                   ]);
//                                                                 }),
//                                                               }
//                                                             else
//                                                               {
//                                                                 Toast.show(
//                                                                     response
//                                                                         .message,
//                                                                     context,
//                                                                     gravity: Toast
//                                                                         .CENTER)
//                                                               }
//                                                           });
//                                                 } else {
//                                                   print("no-conn");

//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(SnackBar(
//                                                     content: Text(
//                                                         "Please check your Internet Connection"),
//                                                     duration:
//                                                         Duration(seconds: 3),
//                                                     margin: EdgeInsets.all(10),
//                                                     behavior: SnackBarBehavior
//                                                         .floating,
//                                                   ));
//                                                   setState(() {
//                                                     _isLoading = true;
//                                                   });
//                                                 }
//                                               }
//                                             }
//                                           },
//                                         )
//                                       : CircularProgressIndicator(),
//                                   SizedBox(height: 10)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ));
//                 });
//               });
//         },
//         child: Image.asset('assets/add.png'),
//       ),
//     );
//   }

//   Center retryWiget() {
//     return Center(
//         child: Column(
//       children: <Widget>[
//         Text('Something Went Wrong Try Again'),
//         RaisedButton(
//           child: Row(
//             children: <Widget>[
//               Icon(Icons.refresh),
//               Text('Retry'),
//             ],
//           ),
//           onPressed: () {
//             setState(() {
//               future = getUsersList();
//             });
//           },
//         )
//       ],
//     ));
//   }
// }


// // class UserList extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     // return  ListView.builder(
// //     //     itemCount: users.length,
// //     //     itemBuilder:
// //     //         (BuildContext context, int index) {
// //           return Card(
// //             elevation: 5,
// //             margin: EdgeInsets.only(
// //                 left: size * 0.0483091787439614,
// //                 right: size * 0.0483091787439614,
// //                 top: 20),
// //             child: Container(
// //               margin: EdgeInsets.only(
// //                   left: size * 0.0483091787439614,
// //                   top: 8,
// //                   bottom: 15),
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         margin: EdgeInsets.only(
// //                             top: index == 0 ? 5 : 12),
// //                         width:
// //                             size * 0.3584541062801932,
// //                         child: Row(
// //                           mainAxisAlignment:
// //                               MainAxisAlignment
// //                                   .spaceBetween,
// //                           children: [
// //                             Text(
// //                               'Name',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                             Text(
// //                               ':    ',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Container(
// //                         margin: EdgeInsets.only(
// //                             top: index == 0 ? 5 : 12),
// //                         width: (size *
// //                                 0.5449275362318841) -
// //                             (size *
// //                                 0.043091787439614) -
// //                             20,
// //                         child: Text(
// //                           '${users[index].fName}',
// //                           style: TextStyle(
// //                               fontSize: size *
// //                                   0.038231884057971,
// //                               color: _colorfromhex(
// //                                   "#474747")),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   Row(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width:
// //                             size * 0.3584541062801932,
// //                         child: Row(
// //                           mainAxisAlignment:
// //                               MainAxisAlignment
// //                                   .spaceBetween,
// //                           children: [
// //                             Text(
// //                               'Email',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                             Text(
// //                               ':    ',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width: (size *
// //                                 0.5449275362318841) -
// //                             (size *
// //                                 0.0483091787439614) -
// //                             20,
// //                         child: Text(
// //                           '${users[index].email}',
// //                           style: TextStyle(
// //                               fontSize: size *
// //                                   0.038231884057971,
// //                               color: _colorfromhex(
// //                                   "#474747")),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   Row(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width:
// //                             size * 0.3584541062801932,
// //                         child: Row(
// //                           mainAxisAlignment:
// //                               MainAxisAlignment
// //                                   .spaceBetween,
// //                           children: [
// //                             Text(
// //                               'Mobile Number',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                             Text(
// //                               ':    ',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width: (size *
// //                                 0.5449275362318841) -
// //                             (size *
// //                                 0.0483091787439614) -
// //                             20,
// //                         child: Text(
// //                           '${users[index].phone}',
// //                           style: TextStyle(
// //                             fontSize: size *
// //                                 0.038231884057971,
// //                             fontWeight:
// //                                 FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   Row(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width:
// //                             size * 0.3584541062801932,
// //                         child: Row(
// //                           mainAxisAlignment:
// //                               MainAxisAlignment
// //                                   .spaceBetween,
// //                           children: [
// //                             Text(
// //                               'Password',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                             Text(
// //                               ':    ',
// //                               style: TextStyle(
// //                                   fontSize: size *
// //                                       0.038231884057971,
// //                                   fontWeight:
// //                                       FontWeight.bold,
// //                                   color:
// //                                       _colorfromhex(
// //                                           "#474747")),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Container(
// //                         margin:
// //                             EdgeInsets.only(top: 12),
// //                         width: (size *
// //                                 0.5449275362318841) -
// //                             (size *
// //                                 0.0483091787439614) -
// //                             20,
// //                         child: Text(
// //                           '${users[index].password}',
// //                           style: TextStyle(
// //                               fontSize: size *
// //                                   0.038231884057971,
// //                               color: _colorfromhex(
// //                                   "#474747")),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         // });
// //   }
// // }
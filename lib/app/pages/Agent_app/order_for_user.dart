import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/user_app/get_form_details.dart';
import 'package:zoro_legal/app/pages/user_app/view_payment_order.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';
import 'package:zoro_legal/data/datarepositories/agent_app_future/agent_orders_for_user_future.dart';
import 'package:zoro_legal/data/datarepositories/agent_app_future/agent_user_list_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/get_form_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/home_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/domain/entities/agent_app_model/agent_user_list_model.dart';
import 'package:zoro_legal/domain/entities/user_app_model/home_search_model.dart'
    as hs;

import 'Agent_home.dart';

class OrderForUser extends StatefulWidget {
  @override
  _OrderForUserState createState() => _OrderForUserState();
}

class _OrderForUserState extends State<OrderForUser> {
  var category1;
  Future future;
  User selectedUser;
  hs.Service selectedService;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _controllers;
  var controller;
  String _file;
  File image;
  var z = Map<String, String>();
  var z1 = Map<String, String>();
  var price;
  @override
  void initState() {
    future = Future.wait([homeSearch(), getUsersList()]);
    super.initState();
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
            title: Center(child: Text("Order For User"))),
        body: Container(
          margin: EdgeInsets.all(10),
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
                    } else if (snapshot.data[0] is String) {
                      return Center(child: Text("${snapshot.data[0]}"));
                    } else if (snapshot.data[1] is String) {
                      return Center(child: Text("${snapshot.data[1]}"));
                    } else if (snapshot.data[0] == null) {
                      return Center(child: Text("No Data"));
                    } else if (snapshot.data[1] == null) {
                      return Center(child: Text("No Data"));
                    }

                    var services = snapshot.data[0].services;

                    var users = snapshot.data[1].users;

                    return Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text("Select User",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 18, left: 37, top: 10, bottom: 15),
                                decoration: BoxDecoration(border: Border.all()),
                                child: SearchableDropdown(
                                  underline: Padding(
                                    padding: EdgeInsets.all(0),
                                  ),
                                  hint: Text('Select User'),
                                  items:
                                      users.map<DropdownMenuItem<User>>((item) {
                                    return new DropdownMenuItem<User>(
                                        child: Text(item.phone), value: item);
                                  }).toList(),
                                  isExpanded: true,
                                  value: selectedUser,
                                  isCaseSensitiveSearch: true,
                                  // searchHint: new Text(
                                  //   'Select ',
                                  //   style: new TextStyle(fontSize: 20),
                                  // ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedUser = value;
                                      print(selectedUser);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Select Service",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 15, left: 20, right: 18, bottom: 15),
                                decoration: BoxDecoration(border: Border.all()),
                                child: SearchableDropdown(
                                  underline: Padding(
                                    padding: EdgeInsets.all(0),
                                  ),
                                  hint: Text('Select Service'),
                                  items: services
                                      .map<DropdownMenuItem<hs.Service>>(
                                          (item) {
                                    return new DropdownMenuItem<hs.Service>(
                                        child: Text(item.stageName),
                                        value: item);
                                  }).toList(),
                                  isExpanded: true,
                                  value: selectedService,
                                  isCaseSensitiveSearch: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedService = value;
                                      print(selectedService);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        selectedService == null
                            ? Container()
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: getform(selectedService.stageId,
                                        selectedService.stage),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                          return retryWiget();

                                        case ConnectionState.active:
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        case ConnectionState.waiting:
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());

                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            return retryWiget();
                                          } else if (snapshot.data is String) {
                                            return Center(
                                                child:
                                                    Text("${snapshot.data}"));
                                          } else if (snapshot.data == null) {
                                            return Center(
                                                child: Text("No Data"));
                                          }
                                          print("stage1" +
                                              snapshot.data.data[0].fields[0]
                                                  .formFieldName
                                                  .toString());
                                          _controllers = List();
                                          category1 =
                                              snapshot.data.data[0].fields;
                                          print(category1);

                                          return ListView.builder(
                                            itemCount: category1.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              _controllers
                                                  .add(TextEditingController());

                                              return category1[index]
                                                          .formFieldDatatype ==
                                                      "select"
                                                  ? buildDropdown(
                                                      category1,
                                                      index,
                                                      _controllers[index],
                                                    )
                                                  : category1[index]
                                                              .formFieldDatatype ==
                                                          "file"
                                                      ? buildImages(
                                                          category1,
                                                          index,
                                                          _controllers[index],
                                                        )
                                                      : buildText(
                                                          category1,
                                                          index,
                                                          _controllers[index],
                                                        );
                                            },
                                          );

                                        default:
                                          return Text("error");
                                      }
                                    },
                                  ),
                                ),
                              ),
                        selectedService == null
                            ? Container()
                            : Container(
                                child: MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  color: MyColor.appcolor,
                                  onPressed: () async {
                                    if (category1 == null) {
                                      Toast.show("No data", context);
                                    } else {
                                      for (var i = 0;
                                          i < category1.length;
                                          i++) {
                                        if (_controllers[i].text.isEmpty) {
                                          print("nndd");
                                        } else {
                                          if (category1[i].formFieldDatatype ==
                                              "select") {
                                            z[category1[i].formFieldName] =
                                                _controllers[i].text;
                                          } else if (category1[i]
                                                  .formFieldDatatype ==
                                              "file") {
                                            z1[category1[i].formFieldName] =
                                                _controllers[i].text;
                                          } else {
                                            z[category1[i].formFieldName] =
                                                _controllers[i].text;
                                          }
                                        }
                                        print("nnn");
                                      }

                                      print("hhh");
                                      print(z);
                                      print(category1.length);

                                      print(z.length == 0 ? "1" : "2");
                                      if (z.length == 0) {
                                        print("3444");

                                        Toast.show(
                                            "Please fill all fields", context,
                                            gravity: Toast.CENTER);
                                      } else if (selectedUser == null) {
                                        Toast.show("Select User", context,
                                            gravity: Toast.CENTER);
                                      } else {
                                        var connectivityResult =
                                            await (Connectivity()
                                                .checkConnectivity());

                                        if (connectivityResult ==
                                                ConnectivityResult.mobile ||
                                            connectivityResult ==
                                                ConnectivityResult.wifi) {
                                          print("8888");
                                          print(selectedUser.resId);
                                          submitUserForm(
                                                  z,
                                                  z1,
                                                  selectedService.stage,
                                                  selectedService.stageId,
                                                  selectedUser.resId)
                                              .then((response) => {
                                                    if (response.staus ==
                                                        "true")
                                                      {
                                                        print(response
                                                            .newData.serviceId),
                                                        print(response
                                                            .data.length),
                                                        price = response
                                                                    .newData
                                                                    .price
                                                                    .length >
                                                                0
                                                            ? response
                                                                .newData.price
                                                            : "0",
                                                             Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AgentHomePage()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false),
                                                            Toast.show(
                                                                "Order Added Sucessfully",
                                                                context),
                                                        // if (price == "0")
                                                        //   {
                                                        //     Navigator.pushAndRemoveUntil(
                                                        //         context,
                                                        //         MaterialPageRoute(
                                                        //             builder:
                                                        //                 (context) =>
                                                        //                     AgentHomePage()),
                                                        //         (Route<dynamic>
                                                        //                 route) =>
                                                        //             false),
                                                        //     Toast.show(
                                                        //         "Low Balance",
                                                        //         context),
                                                        //   }
                                                        
                                                      }
                                                  });
                                        } else {
                                          print("no-conn");

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Please check your Internet Connection"),
                                            duration: Duration(seconds: 3),
                                            margin: EdgeInsets.all(30),
                                            behavior: SnackBarBehavior.floating,
                                          ));
                                        }
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Submit",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                ),
                              ),
                      ],
                    );
                  default:
                    return Text("error");
                }
              }),
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
              future = getform(selectedService.stageId, selectedService.stage);
            });
          },
        )
      ],
    ));
  }

  Container buildText(
      category1, int index, TextEditingController controllertxt) {
    print("@#@####");

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Theme(
          data: ThemeData(
              primaryColor: Colors.black54, hintColor: Colors.black45),
          child: TextFormField(
            controller: controllertxt,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                hintMaxLines: 10,
                suffixIcon: Icon(Icons.edit_outlined),
                hintText: category1[index].formFieldName),
          ),
        ));
  }

  Container buildDropdown(
      category1, int index, TextEditingController controllertxt) {
    print("@#");
    print(category1[index].formFieldSubValue.length);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Material(
        child: Theme(
          data:
              ThemeData(hintColor: Colors.black, primaryColor: Colors.black54),
          child: DropdownButtonFormField(
            hint: Text(category1[index].formFieldSubValue[0].optionValue),
            items: category1[index]
                .formFieldSubValue
                .map<DropdownMenuItem<String>>((country) {
              return DropdownMenuItem<String>(
                value: country.optionValue,
                child: Text(country.optionValue),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                controllertxt.text = value;
              });
              _controllers.add(controller.text());
            },
          ),
        ),
      ),
    );
  }

  buildImages(category1, int index, TextEditingController controllertxt) {
    return GestureDetector(
      onTap: () {
        print("ontap");

        return gallery(controllertxt);
      },
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Theme(
            data: ThemeData(
                primaryColor: Colors.black54, hintColor: Colors.black45),
            child: TextFormField(
              controller: controllertxt,
              enabled: false,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.cloud_upload_outlined),
                  hintText: category1[index].formFieldName),
            ),
          )),
    );
  }

  Future gallery(controller) async {
    print("gggg");
    print(controller);
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    print("jhhghgxhs");
    print(pickedFile.path);
    final File file = File(pickedFile.path);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        _file = file.path.split('/').last;
        print(_file);
        controller.value = TextEditingValue(text: _file.toString());

        print("#####");

        _controllers.add(controller.text);
      }
    });
  }
}

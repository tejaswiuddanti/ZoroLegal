import 'dart:io';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'package:zoro_legal/app/widgets/decoration.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/change_password_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/home_future.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/profile_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/domain/entities/user_app_model/home_category_model.dart';

import 'package:zoro_legal/provider/profile_provider.dart';
import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future future;
  var imagelocation = " ";
  String editname,
      editlname,
      editspec,
      editpassword,
      editcountry,
      editexp,
      editemail,
      editmobile,
      editeducation;
  String imagefile = "";
  String imageselect = "";
  var _items;
  String filename;
  bool flag = true;
  bool _isLoading = true;
  final _formkey = GlobalKey<FormState>();

  ProfileProvider profileimage;
  var icon = Icon(Icons.visibility_off);
  PickedFile pickedFile;
  @override
  void initState() {
    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    role == "U"
        ? future = Future.wait([
            getprofile(),
            getprofile(),
          ])
        : future = Future.wait([
            getprofile(),
            getProfileCategories(),
          ]);
    imagelocation = " ";

    super.initState();
  }

  TextEditingController fname;
  TextEditingController lname;
  TextEditingController email;
  TextEditingController mobile;
  TextEditingController education;
  TextEditingController country;
  TextEditingController experience;
  TextEditingController password;
  TextEditingController specialization;

  @override
  Widget build(BuildContext context) {
    List _selectedCategory = [];
    var _selectedCategory2 = [];
    var _selectedCategory1;
    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    // var size = MediaQuery.of(context).size.width;
    profileimage = Provider.of<ProfileProvider>(context);
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
              margin: EdgeInsets.only(left: 85), child: Text("Profile"))),
      body: Form(
        key: _formkey,
        child: Container(
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
                  // print(snapshot.data[0]);
                  if (snapshot.hasError) {
                    return retryWiget();
                  } else if (snapshot.data[0] is String) {
                    return Center(child: Text("${snapshot.data[0]}"));
                  }
                  var profile = snapshot.data[0].data;
                  editname = profile[0].fName;
                  fname = TextEditingController(text: editname);

                  editlname = profile[0].lName;
                  lname = TextEditingController(text: editlname);
                  editemail = profile[0].email;
                  email = TextEditingController(text: editemail);
                  editmobile = profile[0].phone;
                  mobile = TextEditingController(text: editmobile);
                  editeducation = profile[0].education;
                  education = TextEditingController(text: editeducation);
                  editexp = profile[0].experience;
                  experience = TextEditingController(text: editexp);
                  editcountry =
                      profile[0].country == "2" ? "India" : "Singapore";
                  country = TextEditingController(text: editcountry);
                  editpassword = profile[0].password;
                  password = TextEditingController(text: editpassword);
                  editspec = profile[0].specialization;
                  specialization = TextEditingController(text: editspec);
                  imagelocation =
                      profile[0].image == "" ? null : profile[0].image;

                  var image1 = profile[0].certificates == ""
                      ? null
                      : profile[0].certificates;

                  var storageInstance = locator<LocalStorageService>();
                  storageInstance.saveStringToDisk("role", profile[0].role);
                  print("@@@");
                  if (role == "L") {
                    _selectedCategory2 = profile[0].services;
                    _selectedCategory1 = profile[0]
                        .services
                        .map<MultiSelectItem>(
                            (m) => MultiSelectItem(m, m.stage2Name.toString()))
                        .toList();

                    _items = snapshot.data[1].services
                        .map<MultiSelectItem>((category) => MultiSelectItem(
                            category, category.stage2Name.toString()))
                        .toList();
                  }
                  String dir = (getApplicationDocumentsDirectory().toString());
                  File f = new File('$dir/$imagelocation');
                  return Container(
                      child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: MyColor.appcolor,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      // onTap: () {
                                      //   chooseOption(context, profileimage);
                                      // },
                                      child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.white,
                                    // child: Selector<ProfileProvider, String>(
                                    //     builder: (context, imagefile,_) {
                                    //       print(profileimage.getImage);
                                    child: Consumer<ProfileProvider>(
                                      builder: (context, profileimage, _) {
                                        return (profileimage.getImage != null)
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          profileimage
                                                              .getImage)),
                                                      fit: BoxFit.fill),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                      (imagelocation == null)
                                                          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                                          : imagelocation,
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                      // selector: (context, ch) =>
                                      //     ch.imagefile
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 35,
                              right: 140,
                              child: Container(
                                width: 40,
                                height: 40,
                                child: FloatingActionButton(
                                  backgroundColor: const Color(0xFF26A69A),
                                  child: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    chooseOption(context, profileimage, role);
                                  },
                                ),
                              ))
                        ],
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: ListView(children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 25,
                                    ),
                                    Text(
                                      "First Name *",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: fname,
                                          onChanged: (String name) {
                                            editname = name;
                                          },
                                          validator: (fname) {
                                            if (fname.isEmpty) {
                                              return "Enter First Name";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 25,
                                    ),
                                    Text(
                                      "Last Name",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 50,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: lname,
                                          onChanged: (String lname) {
                                            editlname = lname;
                                          },
                                          // validator: (lname) {
                                          //   return null;
                                          // },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone_in_talk,
                                      size: 25,
                                    ),
                                    Text(
                                      "Mobile *",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 70,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          readOnly: true,
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: mobile,
                                          onChanged: (String mobile) {
                                            editmobile = mobile;
                                          },
                                          validator: (mobile) {
                                            if (mobile.isEmpty) {
                                              return "enter valid Mobile Number";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 25,
                                    ),
                                    Text(
                                      "Email",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 90,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: email,
                                          onChanged: (String email) {
                                            editemail = email;
                                          },
                                          // validator: (email) {
                                          //   return null;
                                          // },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.visibility_off,
                                      size: 25,
                                    ),
                                    Text(
                                      "Password *",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 10),
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: icon,
                                              onPressed: () {
                                                if (flag == true) {
                                                  setState(() {
                                                    flag = false;
                                                    icon =
                                                        Icon(Icons.visibility);
                                                  });
                                                } else {
                                                  setState(() {
                                                    flag = true;
                                                    icon = Icon(
                                                        Icons.visibility_off);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          obscureText: flag,
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: password,
                                          onChanged: (String password) {
                                            editpassword = password;
                                          },
                                          validator: (password) {
                                            if (password.isEmpty) {
                                              return "enter password";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              role == "L"
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 12),
                                              child: Image.asset(
                                                'assets/skills.png',
                                                width: 25,
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Text(
                                              "Skills",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 83, right: 10),
                                              child: TextFormField(
                                                style: TextStyle(
                                                    color: Color(0xFF002A60),
                                                    fontSize: 16),
                                                controller: specialization,
                                                onChanged: (String spec) {
                                                  editspec = spec;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              role == "L"
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 12),
                                              child: Image.asset(
                                                'assets/certificate.png',
                                                width: 25,
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Text(
                                              "Certifications ",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 23,
                                                    right: 10,
                                                    top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    RaisedButton(
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        gallery(profileimage,
                                                            "role");
                                                      },
                                                      child: Text(
                                                        "Choose File",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Selector<
                                                              ProfileProvider,
                                                              String>(
                                                          builder: (context,
                                                              imageSelect, _) {
                                                            print("{[[[[[");
                                                            print(profileimage
                                                                .getImage1);
                                                            return profileimage
                                                                        .getImage1 !=
                                                                    null
                                                                ? Container(
                                                                    height: 50,
                                                                    width: 50,
                                                                    child: Image.file(File(
                                                                        profileimage
                                                                            .getImage1)))
                                                                : image1 != null
                                                                    ? Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        child: Image
                                                                            .network(
                                                                          image1,
                                                                        ))
                                                                    : Container();
                                                          },
                                                          selector: (context,
                                                                  ch) =>
                                                              ch.imageSelect),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              role == "L"
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(top: 12),
                                              child: Image.asset(
                                                'assets/certificate.png',
                                                width: 25,
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Text(
                                              "Categories *",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 43,
                                                    right: 5,
                                                    top: 10),
                                                child: Column(
                                                  children: [
                                                    MultiSelectDialogField(
                                                      title: Text(
                                                          "Select Category"),
                                                      selectedColor:
                                                          MyColor.appcolor,
                                                      buttonIcon: Icon(Icons
                                                          .arrow_drop_down),
                                                      searchable: true,
                                                      items: _items,
                                                      onConfirm: (results) {
                                                        _selectedCategory =
                                                            (results);
                                                      },
                                                      chipDisplay:
                                                          MultiSelectChipDisplay(
                                                        chipWidth: 50,
                                                        // chipColor: Colors.grey[300],
                                                        icon:
                                                            Icon(Icons.cancel),
                                                        onTap: (value) {
                                                          print(value.stage2Id);
                                                          setState(() {
                                                            _selectedCategory
                                                                .remove(value);
                                                          });
                                                        },
                                                        items:
                                                            _selectedCategory1,
                                                      ),
                                                    ),
                                                    MultiSelectChipDisplay(
                                                        chipWidth: 50,
                                                        // chipColor: Colors.grey,
                                                        icon:
                                                            Icon(Icons.cancel),
                                                        onTap: (value) {
                                                          print("00");
                                                          print(value);
                                                          setState(() {
                                                            _selectedCategory2
                                                                .remove(value);
                                                          });
                                                        },
                                                        items:
                                                            _selectedCategory1)
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language_sharp,
                                      size: 25,
                                    ),
                                    Text(
                                      "Country",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, right: 10),
                                        child: TextFormField(
                                          readOnly: true,
                                          style: TextStyle(
                                              color: Color(0xFF002A60),
                                              fontSize: 16),
                                          controller: country,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            TextEditingController _oldPassword =
                                                TextEditingController();
                                            TextEditingController _newPassword =
                                                TextEditingController();
                                            TextEditingController
                                                _confirmPassword =
                                                TextEditingController();
                                            var _formkey =
                                                GlobalKey<FormState>();
                                            String responseText = "";
                                            bool flag = true;
                                            bool flag1 = true;
                                            bool flag2 = true;
                                            bool _isLoading = true;
                                            var icon =
                                                Icon(Icons.visibility_off);
                                            var icon1 =
                                                Icon(Icons.visibility_off);
                                            var icon2 =
                                                Icon(Icons.visibility_off);

                                            return StatefulBuilder(builder:
                                                (context,
                                                    StateSetter setState) {
                                              return Dialog(
                                                  elevation: 16,
                                                  child: Form(
                                                    key: _formkey,
                                                    child: Container(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              25,
                                                                          right:
                                                                              25,
                                                                          bottom:
                                                                              15),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Theme(
                                                                      data: ThemeData(
                                                                          primaryColor: Colors
                                                                              .black54,
                                                                          hintColor:
                                                                              Colors.black),
                                                                      child:
                                                                          TextFormField(
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        controller:
                                                                            _oldPassword,
                                                                        validator:
                                                                            (_oldpassword) {
                                                                          if (_oldpassword
                                                                              .isEmpty) {
                                                                            return "Enter Old Password";
                                                                          } else if (4 >
                                                                              _oldpassword.length) {
                                                                            return 'Minimum four letter password is needed';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        obscureText:
                                                                            flag,
                                                                        decoration:
                                                                            buildInputDecoration("Old password", "abc123").copyWith(
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            icon:
                                                                                icon,
                                                                            onPressed:
                                                                                () {
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
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              25,
                                                                          right:
                                                                              25,
                                                                          bottom:
                                                                              15),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Theme(
                                                                      data: ThemeData(
                                                                          primaryColor: Colors
                                                                              .black54,
                                                                          hintColor:
                                                                              Colors.black),
                                                                      child:
                                                                          TextFormField(
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        controller:
                                                                            _newPassword,
                                                                        validator:
                                                                            (_newpassword) {
                                                                          if (_newpassword
                                                                              .isEmpty) {
                                                                            return "Enter New Password";
                                                                          } else if (4 >
                                                                              _newpassword.length) {
                                                                            return 'Minimum four letter password is needed';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        obscureText:
                                                                            flag1,
                                                                        decoration:
                                                                            buildInputDecoration("New password", "abc123").copyWith(
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            icon:
                                                                                icon1,
                                                                            onPressed:
                                                                                () {
                                                                              if (flag1 == true) {
                                                                                setState(() {
                                                                                  flag1 = false;
                                                                                  icon1 = Icon(Icons.visibility);
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  flag1 = true;
                                                                                  icon1 = Icon(Icons.visibility_off);
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              25,
                                                                          right:
                                                                              25,
                                                                          bottom:
                                                                              15),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .white,
                                                                    child:
                                                                        Theme(
                                                                      data: ThemeData(
                                                                          primaryColor: Colors
                                                                              .black54,
                                                                          hintColor:
                                                                              Colors.black),
                                                                      child:
                                                                          TextFormField(
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        controller:
                                                                            _confirmPassword,
                                                                        validator:
                                                                            (_confirmpassword) {
                                                                          if (_confirmpassword
                                                                              .isEmpty) {
                                                                            return "Enter Confirm Password";
                                                                          } else if (4 >
                                                                              _confirmpassword.length) {
                                                                            return 'Minimum four letter password is needed';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        obscureText:
                                                                            flag2,
                                                                        decoration:
                                                                            buildInputDecoration("Confirm password", "abc123").copyWith(
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            icon:
                                                                                icon2,
                                                                            onPressed:
                                                                                () {
                                                                              if (flag2 == true) {
                                                                                setState(() {
                                                                                  flag2 = false;
                                                                                  icon2 = Icon(Icons.visibility);
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  flag2 = true;
                                                                                  icon2 = Icon(Icons.visibility_off);
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                              responseText == ""
                                                                  ? Container()
                                                                  : Container(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              60,
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              10),
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Text(
                                                                        responseText,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                              _isLoading
                                                                  ? MaterialButton(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30)),
                                                                      color: MyColor
                                                                          .appcolor,
                                                                      child: Text(
                                                                          "Save",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                      onPressed:
                                                                          () async {
                                                                        print(_confirmPassword
                                                                            .text
                                                                            .toString());
                                                                        print(_newPassword
                                                                            .text
                                                                            .toString());

                                                                        if (_formkey
                                                                            .currentState
                                                                            .validate()) {
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                false;
                                                                          });
                                                                          if (_newPassword.text.toString() ==
                                                                              _confirmPassword.text.toString()) {
                                                                            var connectivityResult =
                                                                                await (Connectivity().checkConnectivity());

                                                                            if (connectivityResult == ConnectivityResult.mobile ||
                                                                                connectivityResult == ConnectivityResult.wifi) {
                                                                              changePassword(_oldPassword.text, _newPassword.text).then((response) {
                                                                                if (response.status == "1") {
                                                                                  setState(() {
                                                                                    _isLoading = true;
                                                                                  });

                                                                                  Toast.show(response.message, context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                                                                  Navigator.pop(context);
                                                                                  setState(() {
                                                                                    future = getprofile();
                                                                                  });
                                                                                  //   Navigator.pushAndRemoveUntil(
                                                                                  // context,
                                                                                  // MaterialPageRoute(builder: (context) => HomePage()),
                                                                                  // (Route<dynamic> route) => false);

                                                                                } else {
                                                                                  setState(() {
                                                                                    _isLoading = true;
                                                                                    responseText = response.message;
                                                                                  });

                                                                                  // Toast.show(response.message, context,
                                                                                  //     duration: Toast.LENGTH_LONG,
                                                                                  //     gravity: Toast.CENTER);
                                                                                }
                                                                              });
                                                                            } else {
                                                                              print("no-conn");

                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text("Please check your Internet Connection"),
                                                                                duration: Duration(seconds: 3),
                                                                                margin: EdgeInsets.all(10),
                                                                                behavior: SnackBarBehavior.floating,
                                                                              ));
                                                                              setState(() {
                                                                                _isLoading = true;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            //   content: Text("Password and confirm Password doesnot match"),
                                                                            //   duration: Duration(seconds: 3),
                                                                            //  margin: EdgeInsets.all(10),
                                                                            //   behavior: SnackBarBehavior.floating,
                                                                            // ));
                                                                            Toast.show("Password and confirm Password doesnot match",
                                                                                context,
                                                                                duration: Toast.LENGTH_LONG,
                                                                                gravity: Toast.CENTER);
                                                                          }
                                                                        }
                                                                      },
                                                                    )
                                                                  : CircularProgressIndicator(),
                                                              SizedBox(
                                                                  height: 10)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            });
                                          });
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    color: MyColor.appcolor,
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ),
                                  _isLoading
                                      ? RaisedButton(
                                          padding: EdgeInsets.only(
                                              left: 50, right: 50),
                                          onPressed: () async {
                                            print(profileimage.getImage1 == null
                                                ? "1"
                                                : "2");
                                            print("*****");
                                            //   print(image==null?"1":"2");
                                            if (_formkey.currentState
                                                .validate()) {
                                              // print(fname.text +
                                              //     password.text +
                                              //     mobile.text);
                                              // print(imagelocation);
                                              // print(profileimage.getImage);
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
                                                      ConnectivityResult.wifi) {
                                                if (role != "L") {
                                                  upload(
                                                    profileimage.getImage ==
                                                            null
                                                        ? null
                                                        : profileimage.getImage,
                                                    fname.text,
                                                    lname.text,
                                                    email.text,
                                                    password.text,
                                                    mobile.text,
                                                  ).then((response) {
                                                    print(response);
                                                    if (response.staus ==
                                                        "true") {
                                                      var storageInstance = locator<
                                                          LocalStorageService>();
                                                      setState(() {
                                                        _isLoading = true;
                                                      });

                                                      storageInstance
                                                          .saveStringToDisk(
                                                              "name",
                                                              response
                                                                  .data.fName);

                                                      storageInstance
                                                          .saveStringToDisk(
                                                              "mobile",
                                                              response
                                                                  .data.phone);
                                                      storageInstance
                                                          .saveStringToDisk(
                                                              "email",
                                                              response
                                                                  .data.email);
                                                      storageInstance
                                                          .saveStringToDisk(
                                                              "image",
                                                              response
                                                                  .data.image);
                                                      Toast.show(
                                                          "Profile Updated",
                                                          context,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                      setState(() {
                                                        future = Future.wait([
                                                          getprofile(),
                                                          getprofile()
                                                        ]);
                                                      });
                                                    } else {
                                                      Toast.show(
                                                          "Invalid Credentials",
                                                          context,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                    }
                                                  });
                                                } else {
                                                  // print(_selectedCategory.isEmpty?"1":"2");
                                                  List categories =
                                                      _selectedCategory
                                                          .map(
                                                              (m) => m.stage2Id)
                                                          .toList();
                                                  print("vendor pro");

                                                  List categories1 =
                                                      _selectedCategory2
                                                          .map(
                                                              (m) => m.stage2Id)
                                                          .toList();

                                                  categories
                                                      .addAll(categories1);
                                                  print(fname.text);
                                                  // if(fname.text!=null){

                                                  if (categories.isNotEmpty) {
                                                    print("__");
                                                    print(categories);
                                                    updateVendorProfile(
                                                            profileimage.getImage ==
                                                                    null
                                                                ? null
                                                                : profileimage
                                                                    .getImage,
                                                            fname.text,
                                                            lname.text,
                                                            email.text,
                                                            categories == []
                                                                ? null
                                                                : categories
                                                                    .join(','),
                                                            profileimage.getImage1 ==
                                                                    null
                                                                ? null
                                                                : profileimage
                                                                    .getImage1,
                                                            password.text,
                                                            mobile.text,
                                                            education.text,
                                                            experience.text)
                                                        .then((response) {
                                                      print(response);
                                                      if (response.staus ==
                                                          "true") {
                                                        var storageInstance =
                                                            locator<
                                                                LocalStorageService>();
                                                        setState(() {
                                                          _isLoading = true;
                                                        });

                                                        storageInstance
                                                            .saveStringToDisk(
                                                                "name",
                                                                response.data
                                                                    .fName);

                                                        storageInstance
                                                            .saveStringToDisk(
                                                                "mobile",
                                                                response.data
                                                                    .phone);
                                                        storageInstance
                                                            .saveStringToDisk(
                                                                "email",
                                                                response.data
                                                                    .email);
                                                        storageInstance
                                                            .saveStringToDisk(
                                                                "image",
                                                                response.data
                                                                    .image);
                                                        Toast.show(
                                                            "Profile Updated",
                                                            context,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                        setState(() {
                                                          future = Future.wait([
                                                            getprofile(),
                                                            getProfileCategories(),
                                                          ]);
                                                        });
                                                      } else {
                                                        Toast.show(
                                                            "Invalid Credentials",
                                                            context,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    Toast.show(
                                                        "Please Select Categories",
                                                        context,
                                                        gravity: Toast.CENTER);
                                                  }
                                                }

                                                print("object");
                                              } else {
                                                print("no-conn");

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please check your Internet Connection"),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  margin: EdgeInsets.all(10),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ));
                                              }
                                            } else {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              Toast.show(
                                                  "Please Enter First Name",
                                                  context,
                                                  gravity: Toast.CENTER);
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          color: MyColor.appcolor,
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ))
                                      : CircularProgressIndicator(),
                                ],
                              )
                            ])),
                      ),
                    ],
                  ));

                default:
                  return Text("error");
              }
            },
          ),
        ),
      ),
    );
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
              future = getprofile();
            });
          },
        )
      ],
    ));
  }

  chooseOption(context, var profileimage, role) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              Container(
                width: 20,
                height: 50,
                child: SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, camera(profileimage)),
                  child: const Text(
                    'Camera',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () =>
                    Navigator.pop(context, gallery(profileimage, "null")),
                child: const Text('Gallery', style: TextStyle(fontSize: 15)),
              ),
            ],
          );
        });
  }

  Future camera(var profileimage) async {
    PickedFile pickedFile;

    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    profileimage.setImage(pickedFile.path);
  }

  Future gallery(var profileimage, role) async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imagelocation = pickedFile.path;
    });

    role == "role" ? null : profileimage.setImage(imagelocation);
    role == "null" ? null : profileimage.setImage1(imagelocation);
  }
}

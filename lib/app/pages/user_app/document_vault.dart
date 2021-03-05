import 'dart:ui';

import 'package:connectivity/connectivity.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

import 'package:image_picker/image_picker.dart';

import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/user_app/view_document_vault.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/document_vault_future.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/orders_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

class DocumentVault extends StatefulWidget {
  static const routeName = '/documentVault';
  @override
  _DocumentVaultState createState() => _DocumentVaultState();
}

class _DocumentVaultState extends State<DocumentVault> {
  Future future;
  String image;
  PickedFile pickedFile;
  String filename;
  List mainList = new List();
  // TextEditingController _name = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController name = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  var _list;
  var searchImageList;
  var searchList;
  var docId;
  var docPath;
  var docName;
  int selectedIndex;
  int selectText;

  @override
  void initState() {
    future = documentvault();
    filename = "No File selected";
    selectedIndex = null;
    super.initState();
  }

//   void _download(String _url) async {
//     /* var imageId = await ImageDownloader.downloadImage(_url);
//     var path = await ImageDownloader.findPath(imageId);
//     print(path);*/
//     final externalDir = await getExternalStorageDirectory();
//     print(externalDir.path);
//     FlutterDownloader.enqueue(
//       url: _url,
//       savedDir: externalDir.path,
//       showNotification:
//           true, // show download progress in status bar (for Android)
//       openFileFromNotification:
//           true, // click on notification to open downloaded file (for Android)
//     );
// // await ImageDownloader.open(path);
//   }

  Future _refresh() async {
    setState(() {
      future = documentvault();
      filename = "No File selected";
      selectedIndex = null;
    });
  }

  // void selectAll() {
  //   setState(() {
  //     controller.toggleAll();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
          margin: EdgeInsets.only(left: size * 0.28743961352657 - 45),
          child: (selectedIndex == null)
              ? Text("Document Vault")
              : Text(' Selected  '),
        ),
        actions: (selectedIndex != null)
            ? <Widget>[
                Center(
                  child: InkWell(
                      onTap: () {
                        print("@@");
                        orders().then((response) {
                          print(response.staus);
                          if (response.staus == "true") {
                            setState(() {
                              selectedIndex = null;
                            });

                            _list = response.data;
                            return buildShowDialog(context, docName.toString());
                          } else {
                            setState(() {
                              selectedIndex = null;
                            });

                            Toast.show(response.message, context,
                                gravity: Toast.CENTER);
                          }
                        });
                      },
                      child: Text("Assign")),
                ),
                // IconButton(
                //   icon: Image.asset('assets/assign.png'),
                //   onPressed: () {
                //     print("@@");
                //     orders().then((response) {
                //       print(response.staus);
                //       if (response.staus == "true") {
                //         setState(() {
                //           selectedIndex = null;
                //         });

                //         _list = response.data;
                //         return buildShowDialog(context, docName.toString());
                //       } else {
                //         setState(() {
                //           selectedIndex = null;
                //         });

                //         Toast.show(response.message, context,
                //             gravity: Toast.CENTER);
                //       }
                //     });
                //   },
                // ),
                SizedBox(
                  width: 14,
                ),
                InkWell(
                    child: Center(child: Text("Delete")),
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        deletedocument(docId.toString()).then((response) {
                          print(response.staus);
                          if (response.staus == "true") {
                            print("true");
                            Toast.show(response.message, context,
                                gravity: Toast.CENTER);
                            setState(() {
                              future = documentvault();
                            });
                          } else {
                            print("nbbbb");
                            Toast.show(response.message, context,
                                gravity: Toast.CENTER);
                          }
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
                    }),
                // IconButton(
                //     icon: Icon(Icons.delete),
                //     onPressed: () async {
                //       var connectivityResult =
                //           await (Connectivity().checkConnectivity());

                //       if (connectivityResult == ConnectivityResult.mobile ||
                //           connectivityResult == ConnectivityResult.wifi) {
                //         deletedocument(docId.toString()).then((response) {
                //           print(response.staus);
                //           if (response.staus == "true") {
                //             print("true");
                //             Toast.show(response.message, context,
                //                 gravity: Toast.CENTER);
                //             setState(() {
                //               future = documentvault();
                //             });
                //           } else {
                //             print("nbbbb");
                //             Toast.show(response.message, context,
                //                 gravity: Toast.CENTER);
                //           }
                //         });
                //       } else {
                //         print("no-conn");

                //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //           content:
                //               Text("Please check your Internet Connection"),
                //           duration: Duration(seconds: 3),
                //           margin: EdgeInsets.all(10),
                //           behavior: SnackBarBehavior.floating,
                //         ));
                //       }
                //     })
              ]
            : <Widget>[],
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

                var documents = snapshot.data.documents;
                print(documents.length == 0 ? 1 : 2);
                // print(documents[1].docName.toString().split("."));

                return Container(
                    margin: EdgeInsets.only(top: 10),
                    width: size,
                    child: documents.length == 0
                        ? Center(child: Text("No Data"))
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 30, bottom: 10),
                                child: Container(
                                  height: 50,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        hintText: "Search....",
                                        suffixIcon: CircleAvatar(
                                            radius: 23,
                                            backgroundColor: Color(0xFF53549D),
                                            child: Icon(Icons.search))),
                                    controller: _controller1,
                                    onChanged: (String value) {
                                      searchImage(value).then((response) {
                                        setState(() {
                                          searchImageList = response.documents;
                                        });
                                      });
                                    },
                                    onFieldSubmitted: (String value) {
                                      searchImage(value).then((response) {
                                        setState(() {
                                          searchImageList = response.documents;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      width: size * 0.120772947,
                                      child: Text("")),
                                  Container(
                                      // width: size * 0.115942029,
                                      width: size * 0.215942029,
                                      child: Text("Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))),
                                  Container(
                                      width: size * 0.094202899,
                                      //  width: size * 0.094203699,
                                      child: Text("Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15))),
                                  Container(
                                      width: size * 0.074879227,
                                      child: Text("Edit",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)))
                                ],
                              ),
                              Divider(),
                              Expanded(
                                  child: (_controller1.text.isEmpty)
                                      ? ListView.builder(
                                          itemCount: documents.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return buildInkWell(documents,
                                                index, context, size);
                                          },
                                        )
                                      : searchImageList.isEmpty
                                          ? Text(
                                              "No Data",
                                              style: TextStyle(fontSize: 15),
                                            )
                                          : ListView.builder(
                                              itemCount: searchImageList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return buildInkWell(
                                                    searchImageList,
                                                    index,
                                                    context,
                                                    size);
                                              },
                                            ))
                            ],
                          ));
              default:
                return Text("error");
            }
          },
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () => chooseOption(context),
        child: Image.asset('assets/add.png'),
      ),
    );
  }

  InkWell buildInkWell(
      documents, int index, BuildContext context, double size) {
    var doc = documents[index].docName.split(".");
    var _name = TextEditingController(text: doc[0].toString());
    return InkWell(
      onLongPress: () {
        print("2222");
        print(documents[index].docId);
        if (selectedIndex == index) {
          setState(() {
            selectedIndex = null;
          });
        } else {
          setState(() {
            docId = documents[index].docId;
            docPath = documents[index].docPath;
            docName = documents[index].docName;
            selectedIndex = index;
          });
        }
      },
      child: Container(
        decoration: selectedIndex == index
            ? new BoxDecoration(color: MyColor.appcolor)
            : new BoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    print("11");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewDocumentVault(
                                image: documents[index].docPath.toString(),
                                name: "Document Vault")));
                  },
                  child: Container(
                      width: size * 0.120772947,
                      height: 50,
                      child: Image.network(
                        documents[index].docPath.toString(),
                        fit: BoxFit.fill,
                      )),
                ),
                Container(
                  width: size * 0.215942029,
                  child: selectText == index
                      ? Theme(
                          data: ThemeData(
                            primaryColor: Colors.white,
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            controller: _name,
                            cursorColor: Colors.black,
                            onFieldSubmitted: (value) {
                              print(value);
                              if (value.isNotEmpty) {
                                editName(value + "." + documents[index].docType,
                                        doc[0] + "." + documents[index].docType)
                                    .then((response) {
                                  if (response.status == "true") {
                                    setState(() {
                                      selectText = null;
                                      future = documentvault();
                                    });
                                  }
                                });
                              }
                            },
                          ),
                        )
                      : Text(doc[0]),
                ),
                Container(
                    width: size * 0.094202899,
                    child: Text(documents[index].docType)),
                Container(
                    width: size * 0.074879227,
                    child: InkWell(
                        onTap: () {
                          print("ll");
                          if (selectText == index) {
                            setState(() {
                              selectText = null;
                            });
                          } else {
                            setState(() {
                              selectText = index;
                            });
                          }
                        },
                        child: Image.asset('assets/Icon feather-edit.png',
                            width: 15, height: 15))),
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context, docName) {
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
                      padding: const EdgeInsets.all(18.0),
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
                            searchOrderId(value).then((response) {
                              setState(() {
                                searchList = response.data;
                              });
                            });
                          },
                          onFieldSubmitted: (String value) {
                            searchOrderId(value).then((response) {
                              setState(() {
                                searchList = response.data;
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
                              itemCount: _list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AssignList(
                                    translist: _list[index], docName: docName);
                              },
                            )
                          : searchList == null
                              ? Text(
                                  "No Data",
                                  style: TextStyle(fontSize: 15),
                                )
                              : ListView.builder(
                                  itemCount: searchList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AssignList(
                                        translist: searchList[index],
                                        docName: docName);
                                  },
                                ),
                    )),
                  ],
                )));
          });
        });
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
              future = documentvault();
            });
          },
        )
      ],
    ));
  }

  gallery() async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      image = (pickedFile.path);
      savedocumentvault(image).then((response) {
        print(response.status);
        if (response.status == 200) {
          print("true");
          Toast.show(response.message, context, gravity: Toast.CENTER);
          setState(() {
            future = documentvault();
          });
        } else {
          print("docvaultss");
          print(response.message);
          Toast.show(response.message, context, gravity: Toast.CENTER);
        }
      });
      filename = pickedFile.path.split('/').last;
    });
  }

  camera() async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      image = (pickedFile.path);
      savedocumentvault(image).then((response) {
        print(response.status);
        if (response.status == 200) {
          print("true");
          Toast.show(response.message, context, gravity: Toast.CENTER);
          setState(() {
            future = documentvault();
          });
        } else {
          print("nbbbb");
          Toast.show(response.message, context, gravity: Toast.CENTER);
        }
      });
      filename = pickedFile.path.split('/').last;
    });
  }

  chooseOption(context) {
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
                  onPressed: () => Navigator.pop(context, camera()),
                  child: const Text(
                    'Camera',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, gallery()),
                child: const Text('Gallery', style: TextStyle(fontSize: 15)),
              ),
            ],
          );
        });
  }
}

class AssignList extends StatefulWidget {
  AssignList({this.translist, this.docName});
  final translist;
  final docName;
  @override
  _AssignListState createState() => _AssignListState();
}

class _AssignListState extends State<AssignList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        print(widget.translist.orderId);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
                  new Text("Do you want to assign this document to this order"),
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
                    print(widget.translist.orderId);

                    assignOrders(widget.translist.orderId, widget.docName)
                        .then((response) {
                      print(response.status);
                      if (response.status == "true") {
                        print("@@!!");
                        Toast.show(response.message, context,
                            gravity: Toast.CENTER);

                        Navigator.of(context).pop();
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
                Expanded(child: Text(widget.translist.paymentTransactionId)),
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

// child: Container(
//                                                                       padding: EdgeInsets.all(10),
//                                                                       height: MediaQuery.of(context).size.height - 200,
//                                                                       width: MediaQuery.of(context).size.width - 50,
//                                                                       child: Stack(
//                                                                         children: [
//                                                                           ListView(
//                                                                             children: <Widget>[
//                                                                               Padding(
//                                                                                 padding: const EdgeInsets.all(8.0),
//                                                                                 child: Container(
//                                                                                   child: Material(
//                                                                                     child: Theme(
//                                                                                       data: ThemeData(primaryColor: Colors.black54, hintColor: Colors.black),
//                                                                                       child: TextFormField(
//                                                                                         decoration: InputDecoration(
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(30),
// borderSide: BorderSide(color: Colors.white)),
//  hintText: "Search....",
// suffixIcon: CircleAvatar(
// radius: 23, backgroundColor: Color(0xFF53549D), child: Icon(Icons.search))),
//                                                                                         controller: _controller,
//                                                                                         onFieldSubmitted: (String value) {
//                                                                                           searchOrderId(value).then((response) {
//                                                                                             if (response.staus == "true") {
//                                                                                               setState(() {
//                                                                                                 _list = response.data;
//                                                                                               });
//                                                                                             } else {
//                                                                                               setState(() {
//                                                                                                 _list = response.data;
//                                                                                               });
//                                                                                             }
//                                                                                           });
//                                                                                         },
//                                                                                         onChanged: (String value) {
//                                                                                           searchOrderId(value).then((response) {
//                                                                                             setState(() {
//                                                                                               _list = response.data;
//                                                                                             });
//                                                                                           });
//                                                                                         },
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),

//                                                                               //  ListView(children: [
//                                                                               // _list.length == 0
//                                                                               //     ? Text("No Data")
//                                                                                Expanded(child:

//                                                                                   _list
//                                                                                       .map<Widget>((f) => AssignList(
//                                                                                             translist: f,
//                                                                                           ))
//                                                                                       .toList(),
//                                                                               // ]),
//                                                                                ),
//                                                                               Divider(
//                                                                                 height: 100,
//                                                                               )
//                                                                             ],
//                                                                           ),
//                                                                           Positioned(
//                                                                               child: MaterialButton(
//                                                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                                                                 color: MyColor.appcolor,
//                                                                                 child: Icon(Icons.done),
//                                                                                 onPressed: () {},
//                                                                               ),
//                                                                               bottom: 30,
//                                                                               right: 10)
//                                                                         ],
//                                                                       )
//                                                                       )

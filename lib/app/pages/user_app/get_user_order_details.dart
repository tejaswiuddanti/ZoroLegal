import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'package:toast/toast.dart';
import 'package:zoro_legal/app/pages/user_app/view_document_vault.dart';
import 'package:zoro_legal/app/widgets/decoration.dart';
import 'package:zoro_legal/data/datarepositories/user_app_future/orders_future.dart';
import 'package:zoro_legal/data/datarepositories/vendor_app_future/vendor_orders_list_future.dart';

import 'package:zoro_legal/data/helpers/colors.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/services/storage.dart';

import 'draggable_scroll_bar.dart';

class GetUserorderDetails extends StatefulWidget {
  static const routeName = '/getUserOrderDetails';
  GetUserorderDetails({this.orderid});
  final String orderid;
  @override
  _GetUserorderDetailsState createState() => _GetUserorderDetailsState();
}

class _GetUserorderDetailsState extends State<GetUserorderDetails> {
  Future future, future1;
  ScrollController _scrollController;
  ScrollController _scrollController2;
  String image;
  PickedFile pickedFile;
  String filename;
  double ratingValue;
  var _formkey = GlobalKey<FormState>();
  void _toEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();
  void _toStart() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _toStart2() {
    _scrollController2.animateTo(
      _scrollController2.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _toEnd2() {
    _scrollController2.animateTo(
      _scrollController2.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    // future = getuserorders(widget.orderid);
    // future1 = getorderchat(widget.orderid);
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _scrollController2 = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    future = Future.wait(
        [getuserorders(widget.orderid), getorderchat(widget.orderid)]);
    filename = "No File selected";
    super.initState();
  }

  // void _download(String _url) async {
  //   var _localPath;
  //   String dir;

  //   if (Platform.isAndroid) {
  //     dir = (await getExternalStorageDirectory()).path;
  //   } else if (Platform.isIOS) {
  //     dir = (await getApplicationDocumentsDirectory()).path;
  //   }
  //   print(dir);

  //   final download = await FlutterDownloader.enqueue(
  //     url: _url,
  //     savedDir: dir,
  //     showNotification: true,
  //     openFileFromNotification: true,
  //   );
  // }

  Future<String> findLocalPath() async {
    final directory =
        // (MyGlobals.platform == "android")
        // ?
        await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var storageInstance = locator<LocalStorageService>();

    var storageInstance1 = locator<LocalStorageService>();
    var role = storageInstance1.getFromDisk("role");
    var imagelocation = storageInstance.getFromDisk("image");
    // String image;
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
            margin: EdgeInsets.only(left: size * 0.25743961352657 - 35),
            child: Text("Order Details"),
          ),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
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
                          return Center(child: Text("No Data"));
                        } else if (snapshot.data.isEmpty) {
                          return Center(child: Text("No Data"));
                        }
                        print("@@@");

                        var orderbookdate = snapshot.data[0];
                        print(orderbookdate);

                        var documents = snapshot.data[1].data;
                       
                        return Container(
                          width: double.infinity,
                          child: Wrap(
                            children: [
                              role == "L"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:orderbookdate.disClosedRow==null? Container(
                                        alignment: Alignment.centerRight,
                                        child: MaterialButton(
                                            color: MyColor.appcolor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () {
                                              closeDiscussion(widget.orderid)
                                                  .then((response) {
                                                if (response.staus == "1") {
                                                  Toast.show(
                                                      response.message, context,
                                                      gravity: Toast.CENTER);
                                                      setState(() {
                                                         future = Future.wait(
        [getuserorders(widget.orderid), getorderchat(widget.orderid)]);
                                                      });
                                                      
                                                }
                                              });
                                            },
                                            child: Text(
                                              "Close Discussion",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            )),
                                      ):Container(
                                        alignment: Alignment.centerRight,
                                        child: MaterialButton(
                                            color: MyColor.appcolor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () {
                                             
                                            },
                                            child: Text(
                                              "Closed By Vendor",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            )),
                                      ),
                                    )
                                  : Container(),
                              Card(
                                elevation: 5,
                                margin: EdgeInsets.only(
                                  left: size * 0.0483091787439614,
                                  right: size * 0.0483091787439614,
                                  top: 10,
                                ),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 12,
                                          left: size * 0.0483091787439614,
                                        ),
                                        width: size * 0.3084541062801932,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Name',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                            Text(
                                              ':   ',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 12),
                                        width: (size * 0.6449275362318841) -
                                            (size * 0.0483091787439614) -
                                            42,
                                        child:
                                            orderbookdate==null?Text(""): Text(
                                                '${orderbookdate.bookDate.formName}',
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
                                        margin: EdgeInsets.only(
                                          top: 12,
                                          left: size * 0.0483091787439614,
                                        ),
                                        width: size * 0.3084541062801932,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Date',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                            Text(
                                              ':   ',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 12),
                                        width: (size * 0.6449275362318841) -
                                            (size * 0.0483091787439614) -
                                            42,
                                        child:orderbookdate==null?Text(""): Text(
                                                '${orderbookdate.bookDate.bookingDate}',
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
                                        margin: EdgeInsets.only(
                                          top: 12,
                                          left: size * 0.0483091787439614,
                                        ),
                                        width: size * 0.3084541062801932,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Status',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                            Text(
                                              ':   ',
                                              style: TextStyle(
                                                  fontSize:
                                                      size * 0.038231884057971,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      _colorfromhex("#474747")),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 12),
                                        width: (size * 0.6449275362318841) -
                                            (size * 0.0483091787439614) -
                                            42,
                                        child:orderbookdate==null?Text(""):Text(
                                                '${orderbookdate.bookDate.orderStatus}',
                                                style: TextStyle(
                                                    fontSize: size *
                                                        0.038231884057971,
                                                    color: _colorfromhex(
                                                        "#474747")),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: size * 0.0483091787439614,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 25, right: 10),
                                          width: (size / 2) -
                                              (size * 0.0483091787439614),
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Item',
                                            style: TextStyle(
                                                fontSize:
                                                    size * 0.038231884057971,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    _colorfromhex("#474747")),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 25),
                                          width: (size / 2) -
                                              (size * 0.0483091787439614) -
                                              (size * 0.0483091787439614) -
                                              10,
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    size * 0.038231884057971,
                                                color:
                                                    _colorfromhex("#474747")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                               Container(
                                    height: 150,
                                    child: DraggableScrollbar(
                                        controller: _controller2,
                                        heightScrollThumb: 100,
                                        child:orderbookdate==null?Container(): ListView.builder(
                                            controller: _controller2,
                                            itemCount:
                                                orderbookdate.filed.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return 
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                        left: size *
                                                            0.0483091787439614,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 15,
                                                                    right: 10),
                                                            width: (size / 2) -
                                                                (size *
                                                                    0.0483091787439614),
                                                            child: Text(
                                                              '${orderbookdate.filed[index].filedName}',
                                                              style: TextStyle(
                                                                  fontSize: size *
                                                                      0.038231884057971,
                                                                  color: _colorfromhex(
                                                                      "#474747")),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            width: (size / 2) -
                                                                (size *
                                                                    0.0483091787439614) -
                                                                (size *
                                                                    0.0483091787439614) -
                                                                10,
                                                            child: Text(
                                                              '${orderbookdate.filed[index].fieldValue}',
                                                              style: TextStyle(
                                                                  fontSize: size *
                                                                      0.038231884057971,
                                                                  color: _colorfromhex(
                                                                      "#474747")),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            })),
                                  ),
                                ]),
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(
                              //       right: size * 0.0483091787439614, top: 10),
                              //   alignment: Alignment.centerRight,
                              //   child: MaterialButton(
                              //       color: MyColor.appcolor,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(10)),
                              //       onPressed: () => buildShowDialog(context),
                              //       child: Text(
                              //         "Custom Form Fields",
                              //         style: TextStyle(color: Colors.white),
                              //       )),
                              // ),
                              Card(
                                elevation: 5,
                                margin: EdgeInsets.only(
                                  left: size * 0.0483091787439614,
                                  right: size * 0.0483091787439614,
                                  top: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: size * 0.0483091787439614,
                                        ),
                                        child: Text(
                                          "User Documents",
                                          style: TextStyle(
                                              fontSize:
                                                  size * 0.0434782608695652,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 20, left: 40, right: 50),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: documents.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return
                                                  //  documents[index].role ==
                                                  //             "U" &&
                                                  documents[index]
                                                              .shared
                                                              .length >
                                                          0
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Column(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  print("hai");
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ViewDocumentVault(
                                                                              image: documents[index].shared[0].docPath.toString(),
                                                                              name: "Document View")));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: size *
                                                                      0.1207729468599034,
                                                                  height: size *
                                                                      0.0803864734299517,
                                                                  child: Image
                                                                      .network(
                                                                    '${documents[index].shared[0].docPath}',
                                                                    // fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                '${documents[index].fName}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size *
                                                                      0.0354782608695652,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container();
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: size * 0.065,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _toEnd();
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.black
                                                  .withOpacity(0.75),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: size * 0.065,
                                          left: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _toStart();
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: Colors.black
                                                  .withOpacity(0.75),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: size * 0.0483091787439614,
                                        ),
                                        child: Text(
                                          "Vendor Documents",
                                          style: TextStyle(
                                              fontSize:
                                                  size * 0.0434782608695652,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 20,
                                            left: 40,
                                            right: 50,
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: ListView.builder(
                                            controller: _scrollController2,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: documents.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return documents[index]
                                                              .shared
                                                              .length >
                                                          0 &&
                                                      documents[index]
                                                              .shared
                                                              .length >
                                                          0
                                                  ? documents[index].role != "U"
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Column(
                                                            children: [
                                                              documents[index]
                                                                          .shared
                                                                          .length >
                                                                      0
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            "hai");
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => ViewDocumentVault(image: documents[index].shared[0].docPath.toString())));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: size *
                                                                            0.1207729468599034,
                                                                        height: size *
                                                                            0.0803864734299517,
                                                                        child: Image
                                                                            .network(
                                                                          '${documents[index].shared[0].docPath}',
                                                                          // fit: BoxFit.fill,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              documents[index]
                                                                          .shared
                                                                          .length >
                                                                      0
                                                                  ? Text(
                                                                      '${documents[index].fName}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            size *
                                                                                0.0354782608695652,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                  : Container();
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: size * 0.062,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _toEnd2();
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              color: Colors.black
                                                  .withOpacity(0.75),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: size * 0.062,
                                          left: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _toStart2();
                                            },
                                            child: Icon(
                                              Icons.keyboard_arrow_left,
                                              color: Colors.black
                                                  .withOpacity(0.75),
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 5,
                                margin: EdgeInsets.only(
                                  left: size * 0.0483091787439614,
                                  right: size * 0.0483091787439614,
                                  top: 20,
                                  bottom: 30,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Messages",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _colorfromhex("#474747"),
                                          fontSize: size * 0.0434782608695652,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin:
                                            EdgeInsets.only(top: 25, right: 15),
                                        child: DraggableScrollbar(
                                          controller: _controller,
                                          heightScrollThumb: 50,
                                          child: ListView.builder(
                                            controller: _controller,
                                            itemCount: documents.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return documents[index].message !=
                                                      ""
                                                  ? Align(
                                                      alignment:
                                                          documents[index]
                                                                      .role ==
                                                                  "U"
                                                              ? Alignment
                                                                  .centerRight
                                                              : Alignment
                                                                  .centerLeft,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 8,
                                                            right: 15),
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 10,
                                                          right: 18,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blueAccent)),
                                                        child: Text(
                                                          '${documents[index].message}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size * 0.048,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: size / 1.8,
                                            child: Card(
                                              elevation: 5,
                                              margin: EdgeInsets.only(
                                                  top: 20, bottom: 10),
                                              child: TextFormField(
                                                cursorColor: Colors.black,
                                                validator: (_message) {
                                                  if (_message.isEmpty) {
                                                    return "Enter Message";
                                                  }

                                                  return null;
                                                },
                                                controller: _message,
                                                decoration: InputDecoration(
                                                  hintText: "Type a message...",
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 8, top: 13),
                                                  border: InputBorder.none,
                                                  suffixIcon: IconButton(
                                                    onPressed: () =>
                                                        {gallery()},
                                                    icon:
                                                        Icon(Icons.attach_file),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          MaterialButton(
                                              /*shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(
                                                                                            30)),*/
                                              color: MyColor.appcolor,
                                              child: Text("Send",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                              onPressed: () {
                                                print("gfgggf");
                                                // print(image);
                                                print("gfgggf" + _message.text);

                                                sendorderchat(widget.orderid,
                                                        image, _message.text)
                                                    .then((response) {
                                                  print(response.status);
                                                  if (response.status == 200) {
                                                    print("true");
                                                    Toast.show(
                                                        "Send Sucessfully",
                                                        context);

                                                    setState(() {
                                                      _message.text = "";
                                                      future = Future.wait([
                                                        getuserorders(
                                                            widget.orderid),
                                                        getorderchat(
                                                            widget.orderid)
                                                      ]);
                                                      filename =
                                                          "No File selected";
                                                      image = null;
                                                    });
                                                  } else {
                                                    Toast.show(response.message,
                                                        context);
                                                    setState(() {
                                                      filename =
                                                          "No File selected";
                                                      image = null;
                                                    });
                                                  }
                                                });
                                              }),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          '$filename',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                      default:
                        return Text("error");
                    }
                  },
                ),
              ),
            ],
          ),
        )));
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
            setState(() {});
          },
        )
      ],
    ));
  }

  gallery() async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      image = (pickedFile.path);

      filename = pickedFile.path.split('/').last;
    });
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var selectedField;
          var users = [
            User(vid: "1", vn: "abc"),
            User(vid: "2", vn: "def"),
            User(vid: "3", vn: "dgg"),
          ];
          List<String> _locations = ['Yes', 'No'];
          String _selectedLocation;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                elevation: 16,
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: MyColor.appcolor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(child: Text("Custom Fields")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text("Field Name"),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: SearchableDropdown(
                                      underline: Padding(
                                        padding: EdgeInsets.all(0),
                                      ),
                                      hint: Text('Select User'),
                                      items: users
                                          .map<DropdownMenuItem<User>>((item) {
                                        return new DropdownMenuItem<User>(
                                            child: Text(item.vn), value: item);
                                      }).toList(),
                                      isExpanded: true,
                                      value: selectedField,
                                      isCaseSensitiveSearch: true,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedField = value;
                                          print(selectedField);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Field Type"),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: DropdownButton(
                                      isDense: true,
                                      isExpanded: true,
                                      hint: Text(
                                          'Select Type'), // Not necessary for Option 1
                                      value: _selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedLocation = newValue;
                                        });
                                      },
                                      items: ["File", "Text"].map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("Is Required"),
                                Expanded(
                                  child: DropdownButton(
                                    hint: Text(
                                        'Please choose a location'), // Not necessary for Option 1
                                    value: _selectedLocation,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedLocation = newValue;
                                      });
                                    },
                                    items: _locations.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: MaterialButton(
                                color: MyColor.appcolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {},
                                child: Text("Add",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
          });
        });
  }
}

class User {
  String vn;
  String vid;

  User({this.vn, this.vid});

  @override
  String toString() {
    return '${vn} ${vid}';
  }
}

// return  Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: DataTable(
//                                 // columnSpacing: MediaQuery.of(context).size.width/2 ,
//                                 columns: [
//                                   DataColumn(
//                                       label: Text(
//                                     'Vendor Shared Documents',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15),
//                                   )),
//                                   DataColumn(
//                                       label: Text('User Shared Documents',
//                                           style: TextStyle(
//                                               fontWeight:
//                                                   FontWeight.bold,
//                                               fontSize: 15))),
//                                 ],
//                                 rows: getchat == null
//                                     ? []
//                                     // : List.generate(
//                                     //     getchat.shared.length,
//                                     //     (index) =>
//                                           :  DataRow(cells: <DataCell>[
//                                               DataCell(Text(
//                                                 //  getchat
//                                                 //       .shared[index]
//                                                 //       .docName)),
//                                                  getchat
//                                                       .shared
//                                                       .docName)),
//                                               DataCell(
//                                                getchat
//                                                .shared
//                                                             // .shared[
//                                                             //     index]
//                                                             .docType ==
//                                                         "text"
//                                                     ? Text(getchat
//                                                         .shared
//                                                         .docPath)
//                                                     : InkWell(
//                                                         onTap:
//                                                             () async {
//                                                           var url = getchat
//                                                               .shared
//                                                               .docPath;

//                                                           print(url);
//                                                         },
//                                                         child: Text(
//                                                           "download",
//                                                           style: TextStyle(
//                                                               color: MyColor
//                                                                   .appcolor),
//                                                         )),
//                                               )
//                                             ]))),
//                           // )
//                           );

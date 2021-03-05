// import 'dart:io';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:toast/toast.dart';
// import 'package:zoro_legal/app/pages/home.dart';
// import 'package:zoro_legal/app/pages/view_payment_order.dart';
// import 'package:zoro_legal/data/datarepositories/get_form_future.dart';
// import 'package:zoro_legal/data/helpers/colors.dart';



// class GetFormDetails extends StatefulWidget {
  
//   GetFormDetails(this.id, this.name, this.stageid);
//   final String id, 
//    name, stageid;
//    static const routeName = '/getFormDetails';
//   @override
//   _GetFormDetailsState createState() => _GetFormDetailsState();
// }

// class _GetFormDetailsState extends State<GetFormDetails> {
//   Future future;
//   List<bool> validationList = [];
// final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       new GlobalKey<RefreshIndicatorState>();
//   List images = [];
//   File image;
//   String path;
//   var z = Map<String, String>();
//   var z1 = Map<String, String>();
//   var result;
//   var category1;
//   String _file;
//   var controller;
//   var _controllers = List();
//   var _controllers1 = [];
//   var price;
//   String pathimage;

//   @override
//   void initState() {
//     future = getform(widget.id, widget.stageid);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     TextEditingController().dispose();
//     super.dispose();
//   }
// Future _refresh() async {
//     setState(() {
//      future = getform(widget.id, widget.stageid);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.stageid);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: Icon(
//             Icons.keyboard_arrow_left,
//             size: 40,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(widget.name),
//       ),
//       body:RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: _refresh,
//         child: Stack(
//         children: [
//           FutureBuilder(
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
//                   } else if (snapshot.data is String) {
//                     return Center(child: Text("${snapshot.data}"));
//                   } else if (snapshot.data == null) {
//                     return Center(child: Text("No Data"));
//                   }
//                   print("stage1" +
//                       snapshot.data.data[0].fields[0].formFieldName.toString());

//                   category1 = snapshot.data.data[0].fields;
//                   print(category1);

//                   return ListView.builder(
//                     itemCount: category1.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       result = category1[index];
//                       validationList = List.from(validationList)..add(false);
//                       _controllers.add(TextEditingController());
//                       // _controllers1.add(images);

//                       return category1[index].formFieldDatatype == "select"
//                           ?
//                           // Text(category1[index].formFieldSubValue[0].optionValue)
//                           buildDropdown(category1, index, _controllers[index],
//                               validationList[index])
//                           // ? buildText(category1, index, _controllers[index])
//                           : category1[index].formFieldDatatype == "file"
//                               ? buildImages(
//                                   category1,
//                                   index,
//                                   _controllers[index],
//                                   // _controllers1[index],
//                                   validationList[index])
//                               : buildText(category1, index, _controllers[index],
//                                   validationList[index]);
//                     },
//                   );

//                 default:
//                   return Text("error");
//               }
//             },
//           ),
//         ],
//       ),),
//       bottomSheet: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             MaterialButton(
//               minWidth: MediaQuery.of(context).size.width / 3,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               color: MyColor.appcolor,
//               onPressed: () async{
//                 if (category1 == null) {
//                   Toast.show("No data", context);
//                 } else {
//                   for (var i = 0; i < category1.length; i++) {
//                     if (_controllers[i].text.isEmpty) {
//                       setState(() {
//                         validationList[i] = true;
//                       });
//                     } else {
//                       setState(() {
//                         validationList[i] = false;
//                       });
//                       if (category1[i].formFieldDatatype == "select") {
//                         z[category1[i].formFieldName] = _controllers[i].text;
//                       } else if (category1[i].formFieldDatatype == "file") {
//                         z1[category1[i].formFieldName] = _controllers[i].text;
//                       } else {
//                         z[category1[i].formFieldName] = _controllers[i].text;
//                       }
//                     }
//                   }

//                   print("hhh");
//                   print(z);
//                   print(z.length);
//                   if (z.length != category1.length) {
//                     print("3444");
        
//         Toast.show("Please fill all fields",context,gravity: Toast.CENTER);
        
        
//                   } else {
//         var connectivityResult = await (Connectivity().checkConnectivity());

//           if (connectivityResult == ConnectivityResult.mobile ||
//               connectivityResult == ConnectivityResult.wifi) {            print("8888");


//                     submitform(z, z1, widget.stageid, widget.id)
//                         .then((response) => {
//                               if (response.staus == "true")
//                                 {
//                                   print(response.newData.serviceId),
//                                   print(response.data.length),
//                                   price = response.newData.price.length > 0
//                                       ? response.newData.price
//                                       : "0",
//                                   if (price == "0")
//                                     {
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => HomePage()),
//                                           (Route<dynamic> route) => false),
//                                       Toast.show("Low Balance", context),
                                    
//                                     }
//                                   else
//                                     {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   ViewPaymentOrder(
//                                                       response
//                                                           .newData.serviceName,
//                                                       response.newData.orderId
//                                                           .toString(),
//                                                       response
//                                                           .newData.transactionId
//                                                           .toString(),
//                                                       response.newData
//                                                           .walletBalance,
//                                                       price,
//                                                       response
//                                                           .newData.country)))
//                                     }
//                                 }
//                             });
//               }
//             else {
//             print("no-conn");

//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text("Please check your Internet Connection"),
//               duration: Duration(seconds: 3),
//              margin: EdgeInsets.all(30),
//               behavior: SnackBarBehavior.floating,
//             ));
//           } 
//                   }
//                 }
//               },

//               //       onPressed: () {
//               //         if (category1 == null) {
//               //           Toast.show("No data", context);
//               //         } else {

//               //           for (var i = 0; i < category1.length; i++) {
//               //             if(_controllers[i].text.isEmpty){
//               //               print(_controllers[i].text);
//               //               setState(() {
//               //         validationList[i] =true;

//               //     });

//               //             }else{
//               //                setState(() {
//               //         validationList[i] =false;

//               //     });
//               //             }
//               //            if (category1[i].formFieldDatatype == "select") {
//               //               z[category1[i].formFieldName] = _controllers[i].text;
//               //             }
//               // else if(category1[i].formFieldDatatype == "file") {
//               //               z1[category1[i].formFieldName] =
//               //                   _controllers1[i].toString();
//               //             }
//               // else{
//               //   z[category1[i].formFieldName] = _controllers[i].text;
//               //           }}
//               //             // if (category1[i].formFieldDatatype == "text") {
//               //             //   z[category1[i].formFieldName] = _controllers[i].text;
//               //             // } else if (category1[i].formFieldDatatype == "select") {
//               //             //   z[category1[i].formFieldName] = _controllers[i].text;
//               //             // }else {
//               //             //   z1[category1[i].formFieldName] =
//               //             //       _controllers1[i].toString();
//               //             // }

//               //           print(z);

//               //           print(z1);

//               //           print("textfield");

//               //           submitform(z, z1, widget.stageid, widget.id)
//               //               .then((response) => {
//               //                     if (response.staus == "true")
//               //                       {
//               //                         print(response.newData.serviceId),
//               //                         print(response.data.length),
//               //                       price=response.newData.price.length>0?response.newData.price:"0",
//               //                         if (price == "0")
//               //                           {
//               //                             Navigator.pushAndRemoveUntil(
//               //                                 context,
//               //                                 MaterialPageRoute(
//               //                                     builder: (context) => HomePage()),
//               //                                 (Route<dynamic> route) => false),
//               //                             Toast.show("Low Balance", context)
//               //                           }
//               //                         else
//               //                           {
//               //                             Navigator.push(
//               //                                 context,
//               //                                 MaterialPageRoute(
//               //                                     builder: (context) =>
//               //                                         ViewPaymentOrder(
//               //                                             response
//               //                                                 .newData.serviceName,
//               //                                             response.newData.orderId
//               //                                                 .toString(),
//               //                                             response
//               //                                                 .newData.transactionId
//               //                                                 .toString(),
//               //                                             response
//               //                                                 .newData.walletBalance,
//               //                                             price,
//               //                                             response.newData.country)))
//               //                           }
//               //                       }
//               //                   });
//               //         }
//               //       },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text("Submit",
//                     style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//             // MaterialButton(
//             //   minWidth: MediaQuery.of(context).size.width / 3,
//             //   shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.circular(15)),
//             //   color: MyColor.appcolor,
//             //   onPressed: () {},
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(8.0),
//             //     child: Text("Save as draft",
//             //         style: TextStyle(color: Colors.white, fontSize: 16)),
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }

//   buildImages(
//       category1, int index, TextEditingController controllertxt, validation) {
//     // print(controllertxt);

//     return GestureDetector(
//       onTap: () {
//       //  FocusScope.of(context).requestFocus(new FocusNode());
//         print(validation);
//         print("ontap");
//         // print(controllertxt);
//         return gallery(controllertxt);
//       },
//       child: Container(
//           margin: EdgeInsets.only(left: 10, right: 10),
//           child: Theme(
//             data: ThemeData(
//                 primaryColor: Colors.black54, hintColor: Colors.black45),
//             child: TextFormField(
//               controller: controllertxt,
//               enabled: false,
//               decoration: InputDecoration(
                  
//                   suffixIcon: Icon(Icons.insert_drive_file_rounded),
//                   errorText:
//                       validation == true ? 'Please fill out this field' : null,
//                   hintText: category1[index].formFieldName),
//             ),
//           )),
//     );
//   }

//   Container buildText(
//       category1, int index, TextEditingController controllertxt, validation) {
//     print("@#@####");

//     return Container(
//         margin: EdgeInsets.only(left: 10, right: 10),
//         child: Theme(
//           data: ThemeData(
//               primaryColor: Colors.black54, hintColor: Colors.black45),
//           child: TextFormField(
//             controller: controllertxt,
//             keyboardType: TextInputType.multiline,
//             maxLines: null,
//             cursorColor: Colors.black,
//             decoration: InputDecoration(
//                 hintMaxLines: 10,
//                 suffixIcon: Icon(Icons.edit_outlined),
//                 errorText:
//                     validation == true ? 'Please fill out this field' : null,
//                 hintText: category1[index].formFieldName),
//           ),

//           // child: TextField(
//           //       decoration: InputDecoration(
//           //           errorText: validation == true ? 'Value cant be empty' : null,

//           //           border: OutlineInputBorder()),
//           //           controller:controllertxt,
//           //   ),
//           // ),
//         ));
//   }

//   Container buildDropdown(
//       category1, int index, TextEditingController controllertxt, validation) {
//     print("@#");
//     print(category1[index].formFieldSubValue.length);
//     return Container(
//       margin: EdgeInsets.only(left: 10, right: 10),
//       child: Material(
//         child: Theme(
//           data:
//               ThemeData(hintColor: Colors.black, primaryColor: Colors.black54),
//           // child:Text(category1[index].formFieldSubValue)
//           //  child: DropdownButton(
//           //                                 isDense: true,
//           //                                 hint: new Text(category1[index].formFieldSubValue[0].optionValue),
//           //                                 value:controllertxt.text,
//           //                                 onChanged: (String newValue) {
//           //                                   setState(() {
//           //                                     controllertxt.text = newValue;
//           //                                   });

//           //                                   print(controllertxt.text);
//           //                                 },
//           //                                  items: category1[index].formFieldSubValue.map<DropdownMenuItem<String>>((value) =>
//           //          new DropdownMenuItem<String>(
//           //           value: value.optionValue,
//           //           child: new Text(value.optionValue),
//           //         )
//           //       ).toList(),
//           // items: category1[index].formFieldSubValue.map<DropdownMenuItem<String>>((map) {
//           //   return new DropdownMenuItem(
//           //     child:Text(map.optionValue)
//           //     // value: map.optionValue,
//           //     // child: new Text(
//           //     //   map.optionValue,
//           //     // ),
//           //   );
//           // }).toList(),
//           // ),
//           child: DropdownButtonFormField(
//             // decoration: InputDecoration(
//             //    errorText: validation == true ? 'Please fill out this field' : null,
//             //   // contentPadding: EdgeInsets.all(13),
//             //   // border: OutlineInputBorder(
//             //   //     borderSide: BorderSide(color: Colors.black),
//             //   //     borderRadius: BorderRadius.circular(10)),
//             // ),
//             hint: Text(category1[index].formFieldSubValue[0].optionValue),
//             // value: Text( controllertxt.text),
//             items: category1[index]
//                 .formFieldSubValue
//                 .map<DropdownMenuItem<String>>((country) {
//               return DropdownMenuItem<String>(
//                 value: country.optionValue,
//                 child: Text(country.optionValue),
//               );
//             }).toList(),

//             onChanged: (value) {
//               setState(() {
//                 controllertxt.text = value;
//               });
//               _controllers.add(controller.text());
//             },
//           ),
//         ),
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
//               future = getform(widget.id, widget.stageid);
//             });
//           },
//         )
//       ],
//     ));
//   }

//   Future gallery(controller) async {
//     print("gggg");
//     print(controller);
//     final pickedFile =
//         await ImagePicker().getImage(source: ImageSource.gallery);
//     print("jhhghgxhs");
//     print(pickedFile.path);
//     final File file = File(pickedFile.path);

//     setState(() {
//       if (pickedFile != null) {
//         image = File(pickedFile.path);
//         _file = file.path.split('/').last;
//         print(_file);
//         controller.value = TextEditingValue(text: _file.toString());

//         print("#####");

//         // _controllers1.add(pickedFile.path);
//         _controllers.add(controller.text);
//       }
//     });
//   }
// }

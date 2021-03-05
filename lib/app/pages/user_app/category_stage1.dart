import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/category_stage_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/domain/entities/user_app_model/category_stage_model.dart' as cs;
import 'category_stage2.dart';

class Categorystage1 extends StatefulWidget {
  static const routeName = '/categoryStage1';
  final String categoryid, categoryname;
  Categorystage1(this.categoryid, this.categoryname);
  @override
  _Categorystage1State createState() => _Categorystage1State();
}

class _Categorystage1State extends State<Categorystage1> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future future;
  @override
  void initState() {
    future = categorystage1(widget.categoryid);
    super.initState();
  }

  Future _refresh() async {
    setState(() {
      future = categorystage1(widget.categoryid);
    });
  }

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
            margin: EdgeInsets.only(left: size * 0.28743961352657 - 60),
            child: Text(widget.categoryname))),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
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
                  } else if (snapshot.data is cs.Categorystagemodel) {
                    if (snapshot.data.data == null) {
                      return retryWiget(message: 'Nodata');
                    }
                    return Stage1(
                        stage1list: snapshot.data.data,
                        categoryname: widget.categoryname);
                  }
                  return retryWiget();
              }
              return retryWiget();
            }),
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
                future = categorystage1(widget.categoryid);
              });
            },
          )
        ],
      ),
    );
  }
}

class Stage1 extends StatefulWidget {
  final List<cs.Datum> stage1list;
  final String categoryname;
  const Stage1(
      {Key key, @required this.stage1list, @required this.categoryname})
      : super(key: key);

  @override
  _Stage1State createState() => _Stage1State();
}

class _Stage1State extends State<Stage1> {
  @override
  Widget build(BuildContext context) {
    List<cs.Datum> stage1list = widget.stage1list;
    print("@@@@");
    print(stage1list);
    return (stage1list.isEmpty)
        ? Center(child: Text("No data in ${widget.categoryname}"))
        : ListView(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    return showSearch(
                        context: context, delegate: SearchStage1(stage1list));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(0xFF53549D)),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Search.....',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            CircleAvatar(
                                radius: 23,
                                backgroundColor: Color(0xFF53549D),
                                child: Icon(Icons.search))
                          ],
                        ))),
                  )),
              ...stage1list
                  .map((st1) => Stage1CategoryList(
                        stage1list: st1,
                      ))
                  .toList(),
              Divider(
                height: 100,
              )
            ],
          );
  }
}

class SearchStage1 extends SearchDelegate {
  SearchStage1(this.stage1);
  List<cs.Datum> stage1;

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
            .map((f) => Stage1CategoryList(
                  stage1list: f,
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
        children: stage1
            .where((st1) => st1.name.toLowerCase().contains(query))
            .map((f) => Stage1CategoryList(
                  stage1list: f,
                ))
            .toList());
  }
}

class Stage1CategoryList extends StatelessWidget {
  Stage1CategoryList({@required this.stage1list});
  final cs.Datum stage1list;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ListTile(
        onTap: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Categorystage2(stage1list.id, stage1list.name)));
          } else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        leading: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              stage1list.image,
            )),
        title: Text(
          stage1list.name,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: MyColor.appcolor,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.black)
      ),
    );
  }
}












// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:zoro_legal/data/datarepositories/category_stage_future.dart';
// import 'package:zoro_legal/data/datarepositories/stage_search_future.dart';
// import 'package:zoro_legal/data/helpers/colors.dart';
// import 'package:zoro_legal/domain/entities/category_stage_model.dart' as cs;
// import 'category_stage2.dart';

// class Categorystage1 extends StatefulWidget {
//   static const routeName = '/categoryStage1';
//   final String categoryid, categoryname;
//   Categorystage1(this.categoryid, this.categoryname);
//   @override
//   _Categorystage1State createState() => _Categorystage1State();
// }

// class _Categorystage1State extends State<Categorystage1> {
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       new GlobalKey<RefreshIndicatorState>();

//   Future future;
//   @override
//   void initState() {
//     future = categorystage1(widget.categoryid);
//     super.initState();
//   }

//   Future _refresh() async {
//     setState(() {
//       future = categorystage1(widget.categoryid);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: IconButton(
//             icon: Icon(
//               Icons.keyboard_arrow_left,
//               size: 40,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Text(widget.categoryname)),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         onRefresh: _refresh,
//         child: FutureBuilder(
//             future: future,
//             builder: (context, snapshot) {
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
//                     return retryWiget(message: snapshot.data);
//                   } else if (snapshot.data is cs.Categorystagemodel) {
//                     if (snapshot.data.data == null) {
//                       return retryWiget(message: 'Nodata');
//                     }
//                     return Stage1(
//                         stage1list: snapshot.data.data,
//                         categoryname: widget.categoryname,
//                         id: widget.categoryid);
//                   }
//                   return retryWiget();
//               }
//               return retryWiget();
//             }),
//       ),
//     );
//   }

//   Widget retryWiget({String message}) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(message ?? 'Something Went Wrong Try Again'),
//           ),
//           CupertinoButton.filled(
//             child: Text(
//               'Retry',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               setState(() {
//                 future = categorystage1(widget.categoryid);
//               });
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

// class Stage1 extends StatefulWidget {
//   final List<cs.Datum> stage1list;
//   final String categoryname;
//   final String id;
//   const Stage1(
//       {Key key,
//       @required this.stage1list,
//       @required this.categoryname,
//       this.id})
//       : super(key: key);

//   @override
//   _Stage1State createState() => _Stage1State();
// }

// class _Stage1State extends State<Stage1> {
//   final TextEditingController _controller = TextEditingController();
//   var searchStage1List;
//   @override
//   Widget build(BuildContext context) {
//     List<cs.Datum> stage1list = widget.stage1list;
//     print("@@@@");
//     print(stage1list);
//     return (stage1list.isEmpty)
//         ? Center(child: Text("No data in ${widget.categoryname}"))
//         : Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Container(
//                   height: 55,
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                             borderSide: BorderSide(color: Colors.white)),
//                         hintText: "Search....",
//                         suffixIcon: CircleAvatar(
//                             radius: 23,
//                             backgroundColor: Color(0xFF53549D),
//                             child: Icon(Icons.search))),
//                     controller: _controller,
//                     onChanged: (String value) {
//                       searchStage1(widget.id, value).then((response) {
//                         print(response.data);
//                         // setState(() {
//                         //   searchStage1List = response.data;
//                         // });
//                       });
//                     },
//                     onFieldSubmitted: (String value) {
//                       searchStage1(widget.id, value).then((response) {
//                         // setState(() {
//                         //   searchStage1List = response.data;
//                         // });
//                       });
//                     },
//                   ),
//                 ),
//               ),

             
//               Expanded(
//                 child: (_controller.text.isEmpty)?ListView.builder(
//                   itemCount: stage1list.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Stage1CategoryList(
//                       stage1list: stage1list[index],
//                     );
//                   },
//                 ) :searchStage1List  == null
//                   ? Text("No Data",style: TextStyle(fontSize: 15),):
//                   ListView.builder(
//                   itemCount: searchStage1List.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Stage1CategoryList(
//                       stage1list: searchStage1List[index],
//                     );
//                   },
//                 )
//               ),
//             ],
//           );
//   }
// }

// class SearchStage1 extends SearchDelegate {
//   SearchStage1(this.stage1);
//   List<cs.Datum> stage1;

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return ListView(
//         children: stage1
//             .where((st1) => st1.name.toLowerCase().contains(query))
//             .map((f) => Stage1CategoryList(
//                   stage1list: f,
//                 ))
//             .toList());
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return ListView(
//         children: stage1
//             .where((st1) => st1.name.toLowerCase().contains(query))
//             .map((f) => Stage1CategoryList(
//                   stage1list: f,
//                 ))
//             .toList());
//   }
// }

// class Stage1CategoryList extends StatelessWidget {
//   Stage1CategoryList({@required this.stage1list});
//   final cs.Datum stage1list;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(6),
//       child: ListTile(
//         onTap: () async {
//           var connectivityResult = await (Connectivity().checkConnectivity());

//           if (connectivityResult == ConnectivityResult.mobile ||
//               connectivityResult == ConnectivityResult.wifi) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         Categorystage2(stage1list.id, stage1list.name)));
//           } else {
//             print("no-conn");

//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text("Please check your Internet Connection"),
//               duration: Duration(seconds: 3),
//               margin: EdgeInsets.all(10),
//               behavior: SnackBarBehavior.floating,
//             ));
//           }
//         },
//         leading: CircleAvatar(
//             radius: 23,
//             backgroundColor: Colors.white,
//             backgroundImage: NetworkImage(
//               stage1list.image,
//             )),
//         title: Text(
//           stage1list.name,
//           style: TextStyle(fontSize: 17, color: Colors.white),
//         ),
//         trailing: Icon(
//           Icons.keyboard_arrow_right,
//           color: Colors.white,
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: MyColor.appcolor,
//         borderRadius: BorderRadius.circular(15),
//         // border: Border.all(color: Colors.black)
//       ),
//     );
//   }
// }

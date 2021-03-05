import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/category_stage_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/domain/entities/user_app_model/category_stage_model.dart' as cs;

import 'category_stage3.dart';
import 'get_form_details.dart';


class Categorystage2 extends StatefulWidget {
  static const routeName = '/categoryStage2';
  final String categoryid, categoryname;
  Categorystage2(this.categoryid, this.categoryname);
  @override
  _Categorystage2State createState() => _Categorystage2State();
}

class _Categorystage2State extends State<Categorystage2> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future future;
  @override
  void initState() {
    future = categorystage2(widget.categoryid);
    super.initState();
  }

  Future _refresh() async {
    setState(() {
      future = categorystage2(widget.categoryid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    print(widget.categoryname);
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
                    return Stage2(
                        stage2list: snapshot.data.data,
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
                future = categorystage2(widget.categoryid);
              });
            },
          )
        ],
      ),
    );
  }
}

class Stage2 extends StatefulWidget {
  final List<cs.Datum> stage2list;
  final String categoryname;
  const Stage2({Key key, @required this.stage2list, this.categoryname})
      : super(key: key);

  @override
  _Stage2State createState() => _Stage2State();
}

class _Stage2State extends State<Stage2> {
  @override
  Widget build(BuildContext context) {
    List<cs.Datum> stage2list = widget.stage2list;
    print("@@@@");
    print(stage2list);
    return (stage2list.isEmpty)
        ? Center(child: Text("No Data in ${widget.categoryname} "))
        : ListView(
            children: <Widget>[
              InkWell(
                  onTap: ()async {
                     var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
                    return showSearch(
                        context: context, delegate: SearchStage2(stage2list));
              }else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
             margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
                }
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
                                backgroundColor:  Color(0xFF53549D),
                                child: Icon(Icons.search))
                          ],
                        ))),
                  )),
              ...stage2list
                  .map((st2) => Stage2CategoryList(
                        stage2list: st2,
                      ))
                  .toList(),
              Divider(
                height: 100,
              )
            ],
          );
  }
}

class SearchStage2 extends SearchDelegate {
  SearchStage2(this.stage2);
  List<cs.Datum> stage2;

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
        children: stage2
            .where((st2) => st2.name.toLowerCase().contains(query))
            .map((f) => Stage2CategoryList(
                  stage2list: f,
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
        children: stage2
            .where((st2) => st2.name.toLowerCase().contains(query))
            .map((f) => Stage2CategoryList(
                  stage2list: f,
                ))
            .toList());
  }
}

class Stage2CategoryList extends StatelessWidget {
  Stage2CategoryList({@required this.stage2list});
  final cs.Datum stage2list;

  @override
  Widget build(BuildContext context) {
    
    return stage2list.fromType == '0'
        ? Container(
            margin: EdgeInsets.all(6),
            child: ListTile(
              onTap: () async{
var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Categorystage3(stage2list.id, stage2list.name)));
              }else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
             margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
          }},
              leading: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    stage2list.image,
                  )),
              title: Text(
                stage2list.name,
                style: TextStyle(fontSize: 18, color: Colors.white),
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
          )
        : Container(
            margin: EdgeInsets.all(6),
            child: ListTile(
              onTap: () async {
                var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                builder: (context) =>GetFormDetails(stage2list
                      .id,stage2list
                      .name,"stage2")));
               }
               else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
             margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
          }},
              leading: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    stage2list.image,
                  )),
              title: Text(
                stage2list.name,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              trailing:Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${stage2list.currency} ',
                                      style: TextStyle(fontSize:10),
                                    ),
                                    TextSpan(
                                      text: stage2list.price==""?"0":'${stage2list.price}',
                                      style: TextStyle(
                                       
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
            ),
            decoration: BoxDecoration(
                color: MyColor.stagecolor,
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(color: Colors.black)
                ),
          );
  }
}

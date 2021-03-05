import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/category_stage_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/domain/entities/user_app_model/category_stage_model.dart'as cs;

import 'get_form_details.dart';



class Categorystage3 extends StatefulWidget {
 
  Categorystage3(this.categoryid, this.categoryname);
   final String categoryid;
   final String categoryname;
   static const routeName = '/categoryStage3';
  @override
  _Categorystage3State createState() => _Categorystage3State();
}

class _Categorystage3State extends State<Categorystage3> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future future;
  @override
  void initState() {
    future = categorystage3(widget.categoryid);
    super.initState();
  }

  Future _refresh() async {
    setState(() {
      future = categorystage3(widget.categoryid);
    });
  }

  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
      backgroundColor:MyColor.appcolor,
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
                    return Stage3(
                        stage3list: snapshot.data.data,
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
                  future = categorystage3(widget.categoryid);
              });
            },
          )
        ],
      ),
    );
  }
}

class Stage3 extends StatefulWidget {
  final List<cs.Datum> stage3list;
  final String categoryname;
  const Stage3({Key key, @required this.stage3list, this.categoryname})
      : super(key: key);

  @override
  _Stage3State createState() => _Stage3State();
}

class _Stage3State extends State<Stage3> {
  @override
  Widget build(BuildContext context) {
    List<cs.Datum> stage3list = widget.stage3list;
    print("@@@@");
    print(stage3list);
    return (stage3list.isEmpty)
        ? Center(child: Text("No Data in ${widget.categoryname}"))
        : ListView(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    return showSearch(
                        context: context, delegate: SearchStage3(stage3list));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Color(0xFF53549D)),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Search....',
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                            CircleAvatar(
                                radius: 23,
                                backgroundColor: Color(0xFF53549D),
                                child: Icon(Icons.search))
                          ],
                        ))),
                  )),
              ...stage3list
                  .map((st3) => Stage3CategoryList(
                        stage3list: st3,
                      ))
                  .toList(),
              Divider(
                height: 100,
              )
            ],
          );
  }
}

class SearchStage3 extends SearchDelegate {
  SearchStage3(this.stage3);
  List<cs.Datum> stage3;

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
        children: stage3
            .where((st3) => st3.name.toLowerCase().contains(query))
            .map((f) => Stage3CategoryList(
                  stage3list: f,
                ))
            .toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
        children: stage3
            .where((st3) => st3.name.toLowerCase().contains(query))
            .map((f) => Stage3CategoryList(
                  stage3list: f,
                ))
            .toList());
  }
}

class Stage3CategoryList extends StatelessWidget {
  Stage3CategoryList({@required this.stage3list});
  final cs.Datum stage3list;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ListTile(
      
        onTap: () async{
      
      var connectivityResult = await (Connectivity().checkConnectivity());

          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetFormDetails(stage3list
                                      .id,stage3list
                      .name,"stage3")));
      } else {
            print("no-conn");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Please check your Internet Connection"),
              duration: Duration(seconds: 3),
             margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
            ));
          } },
        leading: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              stage3list.image,
            )),
        title: Text(
          stage3list.name,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
trailing: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${stage3list.currency} ',
                                      style: TextStyle(fontSize:10),
                                    ),
                                    TextSpan(
                                      text: stage3list.price==""?"0":'${stage3list.price}',
                                      style: TextStyle(
                                          
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),      ),
      decoration: BoxDecoration(
        color: MyColor.stagecolor,
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Colors.black)
      ),
    );
  }
}

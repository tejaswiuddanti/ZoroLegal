import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zoro_legal/data/datarepositories/user_app_future/home_future.dart';
import 'package:zoro_legal/data/helpers/colors.dart';

import 'category_stage1.dart';
import 'drawer.dart';
import 'get_form_details.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future future, future1;
  var category, search;
  var searchList;
  String query = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // future = homeimages();
    // future1 = homecategories();
    future = Future.wait(
        [homeimages(), homecategories(), homeSearch(),]);
    super.initState();
  }

  Future _refresh() async {
    setState(() {
      future = Future.wait([
        homeimages(),
        homecategories(),
        homeSearch(),
      ]);
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
          backgroundColor: MyColor.appcolor,
          centerTitle: true,
          title: Text("ZoroLegal"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(60),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CupertinoButton(
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
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
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                
                    width: MediaQuery.of(context).size.width - 30,
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

                            var images = snapshot.data[0].data;
                            category = snapshot.data[1].category;
                            search =
                                snapshot.data[2].services;
                            print(search[0].stage);
                            print("sddddd");
                            return Column(
                              children: [
                                (images.length == 0)
                                    ? Center(
                                        child: Text(
                                        "No Images",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                    : CarouselSlider.builder(
                                        itemCount: images.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          print("@@@" + images[index]);
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width-20,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    NetworkImage(images[index]),
                                              ),
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                      
                                          viewportFraction: 1.0,
                                          autoPlayCurve: Curves.linearToEaseOut,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                        ),
                                      ),
                                Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(top: 30, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Choose Service",
                                          style: TextStyle(
                                              color: MyColor.appcolor,
                                              fontSize: 20),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            return showSearch(
                                                context: context,
                                                delegate: Search(search));
                                          },
                                        )
                                      ],
                                    )),
                                Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.3,
                                    margin: EdgeInsets.only(top: 20),
                                    child: GridView.builder(
                                      
                                      scrollDirection: Axis.horizontal,
                                      itemCount: category.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            var connectivityResult =
                                                await (Connectivity()
                                                    .checkConnectivity());

                                            if (connectivityResult ==
                                                    ConnectivityResult.mobile ||
                                                connectivityResult ==
                                                    ConnectivityResult.wifi) {
                                              print(category[index].categoryId);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Categorystage1(
                                                              category[index]
                                                                  .categoryId,
                                                              category[index]
                                                                  .categoryName)));
                                            } else {
                                              print("no-conn");

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Please check your Internet Connection"),
                                                duration: Duration(seconds: 3),
                                                margin: EdgeInsets.all(10),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ));
                                            }
                                          },
                                          child: SizedBox(
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: MyColor.appcolor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(5.0, 5.0),
                                                    )
                                                  ]),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Image.network(
                                                    category[index]
                                                        .categoryImage
                                                        .toString(),
                                                    width: 50,
                                                  ),
                                                  Text(
                                                      category[index]
                                                          .categoryName
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: MyColor
                                                              .appcolor)),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0,
                                      ),
                                    )),
                              ],
                            );

                          default:
                            return Text("error");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              future = Future.wait([homeimages(), homecategories()]);
              // future = homeimages();
              // future1 = homecategories();
            });
          },
        )
      ],
    ));
  }
}

class Search extends SearchDelegate {
  Search(this.category);
  List category;
  Future future;
var searchList;


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
    return FutureBuilder(
      future: getlist(query),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return retryWiget();
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            print(snapshot.data);
            if (snapshot.hasError) {
              return retryWiget();
            } else if (snapshot.data is String) {
              return Center(child: Text("${snapshot.data}"));
            } else if (snapshot.data.services.length == 0) {
              return Center(child: Text("No Data"));
            }
            searchList = snapshot.data.services;
            return ListView(
                children: searchList
                    .map<Widget>((f) => CategoryList(
                          servicelist: f,
                        ))
                    .toList());
        }
        return retryWiget();
              },
            );
          }
         
        
          @override
          Widget buildSuggestions(BuildContext context) {
            return ListView(
                children: category
                    .where((st1) => st1.stageName.toLowerCase().contains(query))
                    .map((f) =>
                    CategoryList(
                          servicelist: f,
                        ),)
                    .toList()
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
         
        ],
      ),
    );
  }
}

  


class CategoryList extends StatelessWidget {
  CategoryList({@required this.servicelist});
  final servicelist;
 @override
  Widget build(BuildContext context) {
 
    return
    GestureDetector(
      
        onTap: () async{
         var connectivityResult = await (Connectivity().checkConnectivity());

            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
        
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                       GetFormDetails(servicelist.stageId,servicelist.stageName,servicelist.stage)));
          
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
          
          child: Container(
        margin: EdgeInsets.only(left:10,right:10,top:10,bottom:4),
        child:Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                              child: Text(
                    servicelist.stageName,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
              ),
              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${servicelist.currency} ',
                                      style: TextStyle(fontSize:10),
                                    ),
                                    TextSpan(
                                      text: servicelist.stagePrice==""?"0":'${servicelist.stagePrice}',
                                      style: TextStyle(
                                         
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
            //  (servicelist.stagePrice=="")?Text(servicelist.currency+" "+"0"):Text(servicelist.currency+" "+servicelist.stagePrice,style: TextStyle(fontSize: 15))
            ],
          ),
        ),
      
        decoration: BoxDecoration(
            color:MyColor.stagecolor,
            borderRadius: BorderRadius.circular(15),
           
            ),
      ),
    );
  }
}

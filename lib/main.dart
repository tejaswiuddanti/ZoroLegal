import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'package:zoro_legal/data/helpers/colors.dart';
import 'package:zoro_legal/provider/profile_provider.dart';

import 'package:zoro_legal/services/service_locator.dart';
import 'package:zoro_legal/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await FlutterDownloader.initialize(
      //debug: true // optional: set false to disable printing logs to console
      );
  // await FlutterDownloader.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: MyColor.statusbarcolor));
    return MultiProvider(
        providers: [
          
          ChangeNotifierProvider(
            create: (BuildContext context) => ProfileProvider(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ZoroLegal',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SafeArea(child: Splash())));
  }
}

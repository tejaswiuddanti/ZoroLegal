

import 'package:get_it/get_it.dart';

import 'storage.dart';

GetIt locator = GetIt.I;

Future setupLocator() async {
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);
}

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }
String getFromDisk(String key) {
  var value  = _preferences.get(key);
  print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
  return value;
}

void saveStringToDisk(String key, String content){
  print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
  _preferences.setString(key, content);
}

String getListFromDisk(String key)  {
  var value  = _preferences.get(key);
  print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
  return value;
}

void saveListToDisk(String key, List<String> content){
  print('(TRACE) LocalStorageService:_saveStringToDisk. key: $key value: $content');
  _preferences.setStringList(key, content);
}


}

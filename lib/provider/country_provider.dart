import 'package:flutter/material.dart';

class CountryProvider with ChangeNotifier {
  String _country="India";
  
  get getCountry => _country;                  
  void setCountry(String country){
    _country=country;
    notifyListeners();
  }
}

// class GetformProvider with ChangeNotifier {
//  String _formimage;
//   get getformImage =>_formimage;                  
//   void setformImage(String formimage){
//    _formimage=formimage;
//     notifyListeners();
//   }
// }
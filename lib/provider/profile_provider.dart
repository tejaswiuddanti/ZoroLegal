// import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
 String imagefile ;
 String imageSelect;
  get getImage =>imagefile;                  
  void setImage( String image){
   imagefile=image;
    notifyListeners();
  }

  get getImage1 =>imageSelect;                  
  void setImage1( String image){
   imageSelect=image;
    notifyListeners();
  }
}


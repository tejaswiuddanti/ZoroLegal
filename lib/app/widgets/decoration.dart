import 'package:flutter/material.dart';
InputDecoration buildInputDecoration(String labeltext,String hinttext) {
    return InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.white)),
                              contentPadding: EdgeInsets.all(15),
                              labelText: labeltext,
                              // hintText: hinttext,
                              hintStyle: TextStyle(color: Colors.black12),
                            );
  }